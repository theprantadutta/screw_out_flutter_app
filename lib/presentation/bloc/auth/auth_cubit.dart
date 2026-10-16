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
  Future<void> signOut();
  Future<bool> deleteAccount();

  /// What the sign-in just completed pulled or saved (null when the API
  /// could not be reached). Read once by the screen that started it.
  SyncReport? takeSignInReport();
}

enum AuthProviderKind { guest, google, apple }

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

  Future<void> signOut() => _port.signOut();
  Future<bool> deleteAccount() => _port.deleteAccount();
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
  Future<void> signOut() async {}
  @override
  Future<bool> deleteAccount() async => false;
  @override
  SyncReport? takeSignInReport() => null;
}
