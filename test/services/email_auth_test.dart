import 'dart:convert';

import 'package:drift/native.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:screw_out/core/network/api_service.dart';
import 'package:screw_out/core/network/connectivity_service.dart';
import 'package:screw_out/data/database/app_database.dart';
import 'package:screw_out/presentation/bloc/auth/auth_cubit.dart';
import 'package:screw_out/presentation/bloc/premium/premium_cubit.dart';
import 'package:screw_out/services/ports.dart';
import 'package:screw_out/services/progress_service.dart';
import 'package:screw_out/services/purchases/purchase_service.dart';
import 'package:screw_out/services/sync/sync_engine.dart';
import 'package:screw_out/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Minimal Firebase Auth stand-ins: only what the email paths touch.
class _Info extends Fake implements UserInfo {
  _Info(this.providerId);
  @override
  final String providerId;
}

class _Cred extends Fake implements UserCredential {}

class _User extends Fake implements User {
  _User(this._auth, {required this.isAnonymous, this.email, this.providers = const []});

  final _FakeAuth _auth;
  @override
  bool isAnonymous;
  @override
  String? email;
  List<String> providers;
  final linked = <EmailAuthCredential>[];
  final reauthenticated = <EmailAuthCredential>[];

  @override
  String get uid => 'uid-guest';
  @override
  String? get displayName => null;
  @override
  List<UserInfo> get providerData => [for (final p in providers) _Info(p)];
  @override
  Future<String?> getIdToken([bool forceRefresh = false]) async => 'firebase-id-token';

  @override
  Future<UserCredential> linkWithCredential(AuthCredential credential) async {
    final c = credential as EmailAuthCredential;
    linked.add(c);
    if (_auth.accounts.containsKey(c.email)) throw FirebaseAuthException(code: 'email-already-in-use');
    _auth.accounts[c.email] = c.password!;
    isAnonymous = false;
    email = c.email;
    providers = ['password'];
    return _Cred();
  }

  @override
  Future<UserCredential> reauthenticateWithCredential(AuthCredential credential) async {
    final c = credential as EmailAuthCredential;
    reauthenticated.add(c);
    if (_auth.accounts[c.email] != c.password) throw FirebaseAuthException(code: 'invalid-credential');
    return _Cred();
  }
}

class _FakeAuth extends Fake implements FirebaseAuth {
  /// Existing email accounts: address → password.
  final accounts = <String, String>{};
  _User? user;
  final signIns = <String>[];
  final created = <String>[];
  final resets = <String>[];

  @override
  User? get currentUser => user;

  @override
  Future<UserCredential> signInWithCredential(AuthCredential credential) async {
    final c = credential as EmailAuthCredential;
    signIns.add(c.email);
    if (accounts[c.email] != c.password) throw FirebaseAuthException(code: 'invalid-credential');
    user = _User(this, isAnonymous: false, email: c.email, providers: ['password']);
    return _Cred();
  }

  @override
  Future<UserCredential> createUserWithEmailAndPassword({required String email, required String password}) async {
    if (accounts.containsKey(email)) throw FirebaseAuthException(code: 'email-already-in-use');
    created.add(email);
    accounts[email] = password;
    user = _User(this, isAnonymous: false, email: email, providers: ['password']);
    return _Cred();
  }

  @override
  Future<void> sendPasswordResetEmail({required String email, ActionCodeSettings? actionCodeSettings}) async {
    resets.add(email);
  }
}

String _jwt() {
  String b64(Object o) => base64Url.encode(utf8.encode(jsonEncode(o))).replaceAll('=', '');
  return '${b64({'alg': 'HS256'})}.${b64({'exp': 4102444800, 'sub': 'u1'})}.sig';
}

void main() {
  late AppDatabase db;
  late _FakeAuth auth;
  late UserService service;
  late ApiService api;
  var deletes = 0;

  setUp(() async {
    // A live API session (for deletion); /auth/firebase itself is offline,
    // so sign-ins finish as "signed in, syncs later".
    deletes = 0;
    SharedPreferences.setMockInitialValues({'jwt_access_token': _jwt(), 'backend_user_id': 'u1'});
    ApiService.baseUrlOverride = 'http://test/api/v1';
    db = AppDatabase.forTesting(NativeDatabase.memory());
    api = ApiService(
      ConnectivityService(),
      client: MockClient((r) async {
        if (r.method == 'DELETE' && r.url.path.endsWith('/users/me')) {
          deletes++;
          return http.Response('{"subscription_was_active":false}', 200);
        }
        return http.Response('{}', 503);
      }),
    );
    await api.initialize();
    auth = _FakeAuth();
    service = UserService(api: api, db: db, sync: SyncEngine(db, api, ConnectivityService()), auth: auth);
  });

  tearDown(() => db.close());

  group('email sign-in', () {
    test('creating an account links the anonymous guest (same UID, progress kept)', () async {
      final guest = auth.user = _User(auth, isAnonymous: true);
      final r = await service.signInWithEmail(email: ' new@example.com ', password: 'longenough', create: true);
      expect(r.ok, isTrue);
      expect(guest.linked.single.email, 'new@example.com', reason: 'trimmed and linked');
      expect(auth.user, same(guest));
      expect(auth.created, isEmpty);
      expect(service.current.status, AuthStatus.signedIn);
      expect(service.current.provider, AuthProviderKind.email);
    });

    test('creating with an address that has an account signs into it with the right password', () async {
      auth.accounts['taken@example.com'] = 'secret123';
      auth.user = _User(auth, isAnonymous: true);
      final r = await service.signInWithEmail(email: 'taken@example.com', password: 'secret123', create: true);
      expect(r.ok, isTrue);
      expect(auth.signIns, ['taken@example.com']);
      expect(service.current.provider, AuthProviderKind.email);
    });

    test('creating with a taken address and the wrong password says the email is in use', () async {
      auth.accounts['taken@example.com'] = 'secret123';
      auth.user = _User(auth, isAnonymous: true);
      final r = await service.signInWithEmail(email: 'taken@example.com', password: 'other-pass', create: true);
      expect(r, const EmailAuthResult.failure('email-already-in-use'));
      expect(auth.user!.isAnonymous, isTrue, reason: 'the guest is untouched');
    });

    test('creating without any Firebase identity makes a new account', () async {
      final r = await service.signInWithEmail(email: 'fresh@example.com', password: 'longenough', create: true);
      expect(r.ok, isTrue);
      expect(auth.created, ['fresh@example.com']);
    });

    test('signing in never links (a typo must not create an account)', () async {
      final guest = auth.user = _User(auth, isAnonymous: true);
      final r = await service.signInWithEmail(email: 'typo@example.com', password: 'whatever');
      expect(r, const EmailAuthResult.failure('invalid-credential'));
      expect(guest.linked, isEmpty);
      expect(auth.accounts, isEmpty);
      expect(service.current.isGuest, isTrue);
    });

    test('signing in to an existing account', () async {
      auth.accounts['player@example.com'] = 'hunter22';
      auth.user = _User(auth, isAnonymous: true);
      final r = await service.signInWithEmail(email: 'player@example.com', password: 'hunter22');
      expect(r.ok, isTrue);
      expect(service.current.status, AuthStatus.signedIn);
      expect(service.current.email, 'player@example.com');
    });

    test('password reset goes to the trimmed address', () async {
      final r = await service.sendPasswordReset('  me@example.com ');
      expect(r.ok, isTrue);
      expect(auth.resets, ['me@example.com']);
    });
  });

  group('deleting an email account', () {
    setUp(() {
      auth.accounts['player@example.com'] = 'hunter22';
      auth.user = _User(auth, isAnonymous: false, email: 'player@example.com', providers: ['password']);
    });

    test('a wrong or missing password stops before anything is deleted', () async {
      expect(await service.deleteAccount(), AccountDeletion.wrongPassword);
      expect(await service.deleteAccount(password: 'nope'), AccountDeletion.wrongPassword);
      expect(auth.user!.reauthenticated.single.password, 'nope');
      expect(deletes, 0);
    });

    test('the right password re-authenticates, then the API delete runs', () async {
      final user = auth.user!;
      expect(await service.deleteAccount(password: 'hunter22'), AccountDeletion.deleted);
      expect(user.reauthenticated.single.password, 'hunter22');
      expect(deletes, 1);
      expect(service.current.isGuest, isTrue);
    });
  });

  group('purchases need an account', () {
    test('a guest (even with an anonymous API session) never reaches the store', () async {
      auth.user = _User(auth, isAnonymous: true);
      final store = PurchaseService(
        api: api,
        user: service,
        premium: PremiumCubit(db),
        progress: ProgressService(db),
        db: db,
        analytics: const NoAnalytics(),
      );
      expect(api.isAuthenticated, isTrue);
      expect(await store.buy(Products.removeAds), PurchaseOutcome.needsSignIn);
      expect(await store.buy(Products.proYearly), PurchaseOutcome.needsSignIn);
      expect(await store.restore(), PurchaseOutcome.needsSignIn);
    });
  });
}
