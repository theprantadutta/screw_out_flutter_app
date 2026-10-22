// ignore_for_file: prefer_initializing_formals
import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/network/api_service.dart';
import '../data/database/app_database.dart';
import '../presentation/bloc/auth/auth_cubit.dart';
import 'app_log.dart';
import 'sync/sync_engine.dart';
import 'sync/sync_report.dart';

/// Accounts (ported from snake-classic's UnifiedUserService, trimmed to
/// Screw Out's needs). Play-first: everyone starts as an offline guest.
///
/// * Google / Apple / email sign-in go through Firebase Auth; the Firebase
///   ID token is exchanged for the API's own 7-day JWT (`POST /auth/firebase`).
/// * A guest who allows notifications is silently given a Firebase
///   anonymous account so pushes and sync can reach them; signing in later
///   *links* that account (same UID, nothing lost).
/// * There is no refresh token: [ensureBackendSession] re-mints the JWT from
///   a fresh Firebase ID token - single-flight, at most once a minute.
class UserService implements AuthPort {
  UserService({
    required ApiService api,
    required AppDatabase db,
    required SyncEngine sync,
    FirebaseAuth? auth,
    GoogleSignIn? google,
  }) : _api = api,
       _db = db,
       _sync = sync,
       _authOverride = auth,
       _googleOverride = google;

  final ApiService _api;
  final AppDatabase _db;
  final SyncEngine _sync;
  final FirebaseAuth? _authOverride;
  final GoogleSignIn? _googleOverride;

  FirebaseAuth get _auth => _authOverride ?? FirebaseAuth.instance;
  GoogleSignIn get _google => _googleOverride ?? GoogleSignIn.instance;

  static const _profileKey = 'cached_user_profile_v1';

  final _changes = StreamController<AuthState>.broadcast();
  AuthState _state = const AuthState(status: AuthStatus.guest);
  Future<void>? _init;
  Future<bool>? _sessionRefresh;
  DateTime? _lastRefreshAt;
  bool _googleReady = false;
  bool _firebaseAvailable = true;
  bool _interactive = false;
  SyncReport? _signInReport;

  /// Run after every successful API session (purchase reconcile,
  /// entitlement refresh, push registration…). Wired by DI.
  final List<Future<void> Function()> onSession = [];

  /// Run after sign-out / account deletion wiped local account data.
  final List<Future<void> Function()> onSignedOut = [];

  @override
  Stream<AuthState> get changes => _changes.stream;

  @override
  AuthState get current => _state;

  /// Non-anonymous account with a live API session - required to purchase.
  bool get canPurchase => !_state.isGuest && _api.isAuthenticated;

  /// A Firebase user exists (guest-anonymous or real).
  bool get hasBackendIdentity => _firebaseAvailable && _safeCurrentUser != null;

  String? get backendUserId => _api.currentUserId;

  User? get _safeCurrentUser {
    try {
      return _auth.currentUser;
    } on Object {
      _firebaseAvailable = false;
      return null;
    }
  }

  void _emit(AuthState s) {
    _state = s;
    if (!_changes.isClosed) _changes.add(s);
  }

  @override
  Future<void> initialize() => _init ??= _initialize();

  Future<void> _initialize() async {
    await _api.initialize();
    _api.onUnauthorized = () => unawaited(ensureBackendSession());
    final user = _safeCurrentUser;
    if (user == null || user.isAnonymous) {
      _emit(const AuthState(status: AuthStatus.guest));
    } else {
      _emit(await _cachedProfile(user));
    }
    if (user != null) unawaited(ensureBackendSession(force: true));
  }

  Future<AuthState> _cachedProfile(User user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_profileKey);
      if (raw != null) {
        final m = jsonDecode(raw) as Map<String, dynamic>;
        if (m['uid'] == user.uid) {
          return AuthState(
            status: AuthStatus.signedIn,
            provider: _providerOf(user),
            displayName: m['display_name'] as String? ?? user.displayName,
            email: m['email'] as String? ?? user.email,
            username: m['username'] as String?,
          );
        }
      }
    } on Object {
      // Fall through to Firebase's own fields.
    }
    return AuthState(
      status: AuthStatus.signedIn,
      provider: _providerOf(user),
      displayName: user.displayName,
      email: user.email,
    );
  }

  /// Google / Apple win over a password also linked to the same account
  /// (their deletion handling covers it).
  AuthProviderKind _providerOf(User user) {
    final ids = {for (final p in user.providerData) p.providerId};
    if (ids.contains('google.com')) return AuthProviderKind.google;
    if (ids.contains('apple.com')) return AuthProviderKind.apple;
    if (ids.contains('password')) return AuthProviderKind.email;
    return AuthProviderKind.guest;
  }

  // --------------------------------------------------------------- session

  /// Ensures a usable API JWT for the current Firebase user.
  Future<bool> ensureBackendSession({bool force = false}) async {
    if (_api.isAuthenticated && !force) return true;
    if (_safeCurrentUser == null) return false;
    final inFlight = _sessionRefresh;
    if (inFlight != null) return inFlight;
    final last = _lastRefreshAt;
    if (!force && last != null && DateTime.now().difference(last) < const Duration(minutes: 1)) return false;
    _lastRefreshAt = DateTime.now();
    final future = _exchange();
    _sessionRefresh = future;
    try {
      return await future;
    } finally {
      _sessionRefresh = null;
    }
  }

  /// Firebase ID token → API JWT, then first-sign-in sync + session hooks.
  Future<bool> _exchange() async {
    final user = _safeCurrentUser;
    if (user == null) return false;
    try {
      final idToken = await user.getIdToken();
      if (idToken == null) return false;
      var result = await _api.authenticateWithFirebase(idToken);
      if (result.errorCode == 'ACCOUNT_SETUP_IN_PROGRESS') {
        await Future<void>.delayed(const Duration(seconds: 1));
        result = await _api.authenticateWithFirebase(idToken);
      }
      final data = result.value;
      if (!result.isSuccess || data == null) return false;

      if (!user.isAnonymous) {
        final next = AuthState(
          status: AuthStatus.signedIn,
          provider: _providerOf(user),
          displayName: data['display_name'] as String? ?? user.displayName,
          email: data['email'] as String? ?? user.email,
          username: data['username'] as String?,
        );
        _emit(next);
        await _cacheProfile(user.uid, data);
      }
      final report = await _sync.onSignedIn(userId: data['user_id'] as String, isNewUser: data['is_new_user'] == true);
      if (report != null) {
        // A sign-in the player just tapped reports through Settings (one
        // combined toast); anything else becomes an app-wide notice.
        if (_interactive) {
          _signInReport = report;
        } else {
          _sync.announce(report);
        }
      }
      for (final hook in onSession) {
        unawaited(hook().catchError((Object e) => AppLog.warn('session hook failed: $e')));
      }
      return true;
    } on Object catch (e) {
      AppLog.warn('Backend session exchange failed: $e');
      return false;
    }
  }

  Future<void> _cacheProfile(String uid, Map<String, dynamic> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _profileKey,
        jsonEncode({
          'uid': uid,
          'display_name': data['display_name'],
          'email': data['email'],
          'username': data['username'],
        }),
      );
    } on Object {
      // Cache only.
    }
  }

  /// Gives a guest a Firebase anonymous identity so pushes and sync reach
  /// them (called when notifications are allowed). No-op when one exists.
  Future<bool> ensureBackendIdentityForPush() async {
    if (!_firebaseAvailable) return false;
    if (_safeCurrentUser != null) return ensureBackendSession();
    try {
      await _auth.signInAnonymously();
      return await ensureBackendSession(force: true);
    } on Object catch (e) {
      AppLog.warn('Anonymous sign-in failed: $e');
      return false;
    }
  }

  // --------------------------------------------------------------- sign in

  Future<void> _prepareGoogle() async {
    if (_googleReady) return;
    await _google.initialize(serverClientId: dotenv.maybeGet('GOOGLE_WEB_CLIENT_ID'));
    _googleReady = true;
  }

  @override
  Future<bool> signInWithGoogle() async {
    try {
      await _prepareGoogle();
      if (!_google.supportsAuthenticate()) return false;
      final account = await _google.authenticate();
      final idToken = account.authentication.idToken;
      if (idToken == null) return false;
      final credential = GoogleAuthProvider.credential(idToken: idToken);
      await _signInOrLink(credential: credential);
      return await _finishSignIn();
    } on GoogleSignInException catch (e) {
      if (e.code != GoogleSignInExceptionCode.canceled) AppLog.warn('Google sign-in failed: ${e.code}');
      return false;
    } on Object catch (e) {
      AppLog.warn('Google sign-in failed: $e');
      _emit(_state.copyWith(status: AuthStatus.guest, error: 'google'));
      return false;
    }
  }

  @override
  Future<bool> signInWithApple() async {
    try {
      final provider = AppleAuthProvider()
        ..addScope('email')
        ..addScope('name');
      await _signInOrLink(provider: provider);
      return await _finishSignIn();
    } on FirebaseAuthException catch (e) {
      if (e.code != 'canceled' && e.code != 'user-cancelled' && e.code != 'web-context-canceled') {
        AppLog.warn('Apple sign-in failed: ${e.code}');
      }
      return false;
    } on Object catch (e) {
      AppLog.warn('Apple sign-in failed: $e');
      return false;
    }
  }

  /// Firebase codes for "that email already has an account".
  static const _emailTaken = {'email-already-in-use', 'credential-already-in-use', 'provider-already-linked'};

  /// Firebase codes for a wrong email / password pair.
  static const wrongCredentialCodes = {
    'wrong-password',
    'invalid-credential',
    'user-not-found',
    'invalid-login-credentials',
    'INVALID_LOGIN_CREDENTIALS',
  };

  /// Email/password. Creating an account links a guest's anonymous identity
  /// (same UID, nothing lost), like Google / Apple. If the address already
  /// has an account, the right password signs into it instead (the
  /// credential-already-in-use path of [_signInOrLink]); a wrong one reports
  /// `email-already-in-use`. Signing in never links: a mistyped address must
  /// not quietly become a new account, and an existing account wins anyway,
  /// with the pull merging this device's progress into it.
  @override
  Future<EmailAuthResult> signInWithEmail({required String email, required String password, bool create = false}) async {
    final address = email.trim();
    try {
      final credential = EmailAuthProvider.credential(email: address, password: password);
      if (create) {
        try {
          final user = _safeCurrentUser;
          if (user != null && user.isAnonymous) {
            await user.linkWithCredential(credential);
          } else {
            await _auth.createUserWithEmailAndPassword(email: address, password: password);
          }
        } on FirebaseAuthException catch (e) {
          if (!_emailTaken.contains(e.code)) rethrow;
          try {
            await _auth.signInWithCredential(credential);
          } on FirebaseAuthException catch (e2) {
            if (wrongCredentialCodes.contains(e2.code)) return const EmailAuthResult.failure('email-already-in-use');
            rethrow;
          }
        }
      } else {
        await _auth.signInWithCredential(credential);
      }
      return await _finishSignIn() ? const EmailAuthResult.success() : const EmailAuthResult.failure();
    } on FirebaseAuthException catch (e) {
      AppLog.warn('Email sign-in failed: ${e.code}');
      return EmailAuthResult.failure(e.code);
    } on Object catch (e) {
      AppLog.warn('Email sign-in failed: $e');
      return const EmailAuthResult.failure();
    }
  }

  @override
  Future<EmailAuthResult> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      return const EmailAuthResult.success();
    } on FirebaseAuthException catch (e) {
      // Same answer whether or not the address has an account.
      if (e.code == 'user-not-found') return const EmailAuthResult.success();
      AppLog.warn('Password reset failed: ${e.code}');
      return EmailAuthResult.failure(e.code);
    } on Object catch (e) {
      AppLog.warn('Password reset failed: $e');
      return const EmailAuthResult.failure();
    }
  }

  /// Links an anonymous guest (keeps the UID and its synced data) or signs
  /// in. If the credential already belongs to another account, that account
  /// wins and the pull merges this device's progress into it.
  Future<void> _signInOrLink({AuthCredential? credential, AuthProvider? provider}) async {
    final user = _safeCurrentUser;
    if (user != null && user.isAnonymous) {
      try {
        if (credential != null) {
          await user.linkWithCredential(credential);
        } else {
          await user.linkWithProvider(provider!);
        }
        return;
      } on FirebaseAuthException catch (e) {
        if (e.code != 'credential-already-in-use' && e.code != 'provider-already-linked') rethrow;
        final existing = e.credential ?? credential;
        if (existing != null) {
          await _auth.signInWithCredential(existing);
          return;
        }
      }
    }
    if (credential != null) {
      await _auth.signInWithCredential(credential);
    } else {
      await _auth.signInWithProvider(provider!);
    }
  }

  @override
  SyncReport? takeSignInReport() {
    final r = _signInReport;
    _signInReport = null;
    return r;
  }

  Future<bool> _finishSignIn() async {
    _lastRefreshAt = null;
    _signInReport = null;
    _interactive = true;
    final bool ok;
    try {
      ok = await ensureBackendSession(force: true);
    } finally {
      _interactive = false;
    }
    if (!ok) {
      // Firebase succeeded but the API did not (offline): still a signed-in
      // player locally; the session is minted on the next resume.
      final user = _safeCurrentUser;
      if (user != null && !user.isAnonymous) _emit(await _cachedProfile(user));
    }
    return _safeCurrentUser != null && !_safeCurrentUser!.isAnonymous;
  }

  // -------------------------------------------------------------- sign out

  @override
  Future<void> signOut() async {
    try {
      await _sync.syncNow().timeout(const Duration(seconds: 5));
    } on Object {
      // Best effort: whatever did not upload is lost with the account data.
    }
    try {
      await _api.logout();
    } on Object catch (e) {
      AppLog.warn('API logout failed (continuing): $e');
    }
    await _teardown();
  }

  /// Permanently deletes the account (store rule: reachable in-app).
  ///
  /// 1. Needs a live API session; without one nothing is touched.
  /// 2. Email accounts re-confirm with their [password] (a wrong one stops
  ///    here with [AccountDeletion.wrongPassword]).
  ///    Sign in with Apple: Apple requires the app to revoke its token on
  ///    deletion, which needs a fresh authorization code, so the player
  ///    re-confirms with Apple first (dismissing it cancels the deletion).
  /// 3. `DELETE /users/me` removes the account, its data and the Firebase
  ///    identity server-side.
  /// 4. Google access is disconnected (best effort), then this device is
  ///    signed out and wiped.
  @override
  Future<AccountDeletion> deleteAccount({String? password}) async {
    final user = _safeCurrentUser;
    if (user == null || user.isAnonymous) return AccountDeletion.failed;
    if (!await ensureBackendSession()) return AccountDeletion.offline;

    final provider = _providerOf(user);
    if (provider == AuthProviderKind.email) {
      final address = user.email;
      if (address == null || password == null || password.isEmpty) return AccountDeletion.wrongPassword;
      try {
        await user.reauthenticateWithCredential(EmailAuthProvider.credential(email: address, password: password));
      } on FirebaseAuthException catch (e) {
        if (wrongCredentialCodes.contains(e.code)) return AccountDeletion.wrongPassword;
        if (e.code == 'network-request-failed') return AccountDeletion.offline;
        AppLog.warn('Email re-authentication failed: ${e.code}');
        return AccountDeletion.failed;
      } on Object catch (e) {
        AppLog.warn('Email re-authentication failed: $e');
        return AccountDeletion.failed;
      }
    }
    if (provider == AuthProviderKind.apple) {
      try {
        final cred = await user.reauthenticateWithProvider(AppleAuthProvider());
        final code = cred.additionalUserInfo?.authorizationCode;
        if (code != null) await _auth.revokeTokenWithAuthorizationCode(code);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'canceled' || e.code == 'user-cancelled' || e.code == 'web-context-canceled') {
          return AccountDeletion.cancelled;
        }
        // Revocation is best effort; the account itself is still deleted.
        AppLog.warn('Apple token revocation failed (continuing): ${e.code}');
      } on Object catch (e) {
        AppLog.warn('Apple token revocation failed (continuing): $e');
      }
    }

    final result = await _api.deleteAccount();
    if (!result.isSuccess) {
      return switch (result.failure) {
        ApiFailure.offlineOrTransport || ApiFailure.timeout => AccountDeletion.offline,
        _ => AccountDeletion.failed,
      };
    }
    final stillBilled = result.value?['subscription_was_active'] == true;

    if (provider == AuthProviderKind.google) {
      try {
        await _prepareGoogle();
        await _google.disconnect(); // revokes this app's Google grant
      } on Object catch (e) {
        AppLog.warn('Google disconnect failed (continuing): $e');
      }
    }
    await _teardown();
    return stillBilled ? AccountDeletion.deletedProStillBilled : AccountDeletion.deleted;
  }

  Future<void> _teardown() async {
    try {
      await _db.clearAccountData();
      await _sync.forgetAccount();
    } on Object catch (e) {
      AppLog.warn('Local account wipe failed (continuing): $e');
    }
    try {
      if (_googleReady) await _google.signOut();
      await _auth.signOut();
    } on Object catch (e) {
      AppLog.warn('Firebase sign-out failed (continuing): $e');
    }
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_profileKey);
    } on Object {
      // ignore
    }
    for (final hook in onSignedOut) {
      try {
        await hook();
      } on Object catch (e) {
        AppLog.warn('sign-out hook failed: $e');
      }
    }
    _emit(const AuthState(status: AuthStatus.guest));
  }

  @visibleForTesting
  void emitForTesting(AuthState s) => _emit(s);
}
