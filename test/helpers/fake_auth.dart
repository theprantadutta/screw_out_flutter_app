import 'dart:async';

import 'package:screw_out/presentation/bloc/auth/auth_cubit.dart';
import 'package:screw_out/services/ports.dart';
import 'package:screw_out/services/sync/sync_report.dart';

/// Scriptable [AuthPort]: starts as a guest (or [signedIn]); every sign-in
/// succeeds unless [emailResult] / [googleOk] say otherwise. Records calls.
final class FakeAuth implements AuthPort {
  FakeAuth({bool signedIn = false})
    : _state = signedIn ? _signedIn(AuthProviderKind.google) : const AuthState(status: AuthStatus.guest);

  static AuthState _signedIn(AuthProviderKind p) =>
      AuthState(status: AuthStatus.signedIn, provider: p, displayName: 'Tester', email: 'tester@example.com');

  final _changes = StreamController<AuthState>.broadcast();
  AuthState _state;

  bool googleOk = true;
  EmailAuthResult emailResult = const EmailAuthResult.success();
  final emailCalls = <({String email, String password, bool create})>[];
  final resetCalls = <String>[];

  void _set(AuthState s) {
    _state = s;
    _changes.add(s);
  }

  @override
  Stream<AuthState> get changes => _changes.stream;
  @override
  AuthState get current => _state;
  @override
  Future<void> initialize() async {}
  @override
  Future<bool> signInWithGoogle() async {
    if (googleOk) _set(_signedIn(AuthProviderKind.google));
    return googleOk;
  }

  @override
  Future<bool> signInWithApple() async {
    _set(_signedIn(AuthProviderKind.apple));
    return true;
  }

  @override
  Future<EmailAuthResult> signInWithEmail({required String email, required String password, bool create = false}) async {
    emailCalls.add((email: email, password: password, create: create));
    if (emailResult.ok) _set(_signedIn(AuthProviderKind.email));
    return emailResult;
  }

  @override
  Future<EmailAuthResult> sendPasswordReset(String email) async {
    resetCalls.add(email);
    return const EmailAuthResult.success();
  }

  @override
  Future<void> signOut() async => _set(const AuthState(status: AuthStatus.guest));
  @override
  Future<AccountDeletion> deleteAccount({String? password}) async => AccountDeletion.deleted;
  @override
  SyncReport? takeSignInReport() => null;
}

/// [PurchasesPort] that records what was bought / restored.
final class RecordingPurchases implements PurchasesPort {
  final bought = <String>[];
  int restores = 0;

  @override
  String? priceOf(String productId) => r'$0.99';
  @override
  Future<PurchaseOutcome> buy(String productId) async {
    bought.add(productId);
    return PurchaseOutcome.granted;
  }

  @override
  Future<PurchaseOutcome> restore() async {
    restores++;
    return PurchaseOutcome.granted;
  }
}
