import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../services/sync/sync_report.dart';

/// Account backend (Firebase Auth → API JWT). Implemented by the user
/// service; the UI only sees [AuthCubit].
abstract interface class AuthPort {
  Stream<AuthState> get changes;
  AuthState get current;
  Future<void> initialize();
  Future<bool> signInWithGoogle();
  Future<bool> signInWithApple();

  /// Email/password: signs in, or with [create] makes the account. A guest's
  /// anonymous identity is linked so its progress is kept.
  Future<EmailAuthResult> signInWithEmail({required String email, required String password, bool create = false});

  /// Sends Firebase's password reset email.
  Future<EmailAuthResult> sendPasswordReset(String email);

  Future<void> signOut();

  /// [password] re-confirms an email/password account before deletion.
  Future<AccountDeletion> deleteAccount({String? password});

  /// What the sign-in just completed pulled or saved (null when the API
  /// could not be reached). Read once by the screen that started it.
  SyncReport? takeSignInReport();
}

/// How an account deletion ended (the Settings sheet words the result).
enum AccountDeletion {
  /// Account and data are gone; this device is signed out and cleared.
  deleted,

  /// Deleted, but Pro was still live: store billing continues until the
  /// player cancels it in Google Play / the App Store.
  deletedProStillBilled,

  /// The player backed out (e.g. dismissed the Apple re-confirmation).
  cancelled,

  /// No connection or no session: nothing was deleted.
  offline,

  /// The server refused or failed: nothing was deleted.
  failed,

  /// Email account: the password did not match, nothing was deleted.
  wrongPassword,
}

/// How an email/password request ended. [code] is the
/// FirebaseAuthException code on failure (the sheet words it).
final class EmailAuthResult extends Equatable {
  const EmailAuthResult.success() : ok = true, code = null;
  const EmailAuthResult.failure([this.code]) : ok = false;

  final bool ok;
  final String? code;

  @override
  List<Object?> get props => [ok, code];
}

/// `email` = Firebase's `password` provider.
enum AuthProviderKind { guest, google, apple, email }

enum AuthStatus { initial, loading, guest, signedIn, error }

final class AuthState extends Equatable {
  const AuthState({
    this.status = AuthStatus.initial,
    this.provider = AuthProviderKind.guest,
    this.displayName,
    this.email,
    this.username,
    this.error,
  });

  final AuthStatus status;
  final AuthProviderKind provider;
  final String? displayName;
  final String? email;
  final String? username;
  final String? error;

  /// Guest (offline or Firebase-anonymous): no credential to restore from.
  bool get isGuest => status != AuthStatus.signedIn;

  AuthState copyWith({AuthStatus? status, String? error}) => AuthState(
    status: status ?? this.status,
    provider: provider,
    displayName: displayName,
    email: email,
    username: username,
    error: error,
  );

  @override
  List<Object?> get props => [status, provider, displayName, email, username, error];
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._port) : super(_port.current) {
    _port.changes.listen((s) {
      if (!isClosed) emit(s);
    });
  }

  final AuthPort _port;

  Future<void> initialize() => _port.initialize();

  Future<bool> signInWithGoogle() async {
    emit(state.copyWith(status: AuthStatus.loading));
    final ok = await _port.signInWithGoogle();
    if (!ok && !isClosed) emit(_port.current);
    return ok;
  }

  Future<bool> signInWithApple() async {
    emit(state.copyWith(status: AuthStatus.loading));
    final ok = await _port.signInWithApple();
    if (!ok && !isClosed) emit(_port.current);
    return ok;
  }

  Future<EmailAuthResult> signInWithEmail({required String email, required String password, bool create = false}) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final r = await _port.signInWithEmail(email: email, password: password, create: create);
    if (!r.ok && !isClosed) emit(_port.current);
    return r;
  }

  Future<EmailAuthResult> sendPasswordReset(String email) => _port.sendPasswordReset(email);

  Future<void> signOut() => _port.signOut();
  Future<AccountDeletion> deleteAccount({String? password}) => _port.deleteAccount(password: password);
  SyncReport? takeSignInReport() => _port.takeSignInReport();
}

/// Guest-only stub for tests/previews.
final class GuestAuth implements AuthPort {
  @override
  Stream<AuthState> get changes => const Stream.empty();
  @override
  AuthState get current => const AuthState(status: AuthStatus.guest);
  @override
  Future<void> initialize() async {}
  @override
  Future<bool> signInWithGoogle() async => false;
  @override
  Future<bool> signInWithApple() async => false;
  @override
  Future<EmailAuthResult> signInWithEmail({required String email, required String password, bool create = false}) async =>
      const EmailAuthResult.failure();
  @override
  Future<EmailAuthResult> sendPasswordReset(String email) async => const EmailAuthResult.failure();
  @override
  Future<void> signOut() async {}
  @override
  Future<AccountDeletion> deleteAccount({String? password}) async => AccountDeletion.failed;
  @override
  SyncReport? takeSignInReport() => null;
}
