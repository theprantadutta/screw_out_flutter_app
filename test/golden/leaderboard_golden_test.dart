import 'package:flutter_test/flutter_test.dart';
import 'package:screw_out/presentation/bloc/auth/auth_cubit.dart';
import 'package:screw_out/screens/leaderboard/leaderboard_screen.dart';
import 'package:screw_out/services/leaderboard_service.dart';
import 'package:screw_out/services/sync/sync_report.dart';

import '../helpers/harness.dart';
import '../helpers/screen_harness.dart';

class _SignedIn implements AuthPort {
  @override
  Stream<AuthState> get changes => const Stream.empty();
  @override
  AuthState get current => const AuthState(
    status: AuthStatus.signedIn,
    provider: AuthProviderKind.google,
    displayName: 'Pranta Dutta',
    username: 'Bright_Flange_2210',
  );
  @override
  Future<void> initialize() async {}
  @override
  Future<bool> signInWithGoogle() async => true;
  @override
  Future<bool> signInWithApple() async => true;
  @override
  Future<void> signOut() async {}
  @override
  Future<AccountDeletion> deleteAccount() async => AccountDeletion.deleted;
  @override
  SyncReport? takeSignInReport() => null;
}

void main() {
  setUpAll(loadAppFonts);

  Future<void> pump(WidgetTester tester, {AuthPort? auth, LeaderboardPort? board, Board initial = Board.sheets}) async {
    useDesignFrame(tester);
    final env = (await tester.runAsync(() => ScreenEnv.create(auth: auth)))!;
    if (board != null) env.leaderboard = board;
    addTearDown(() => tester.runAsync(env.dispose));
    await tester.pumpWidget(env.wrap(LeaderboardScreen(initial: initial, today: DateTime(2026, 10, 16))));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
  }

  testWidgets('leaderboard: signed in, sheets', (tester) async {
    await pump(tester, auth: _SignedIn());
    await expectLater(find.byType(LeaderboardScreen), matchesGoldenFile('goldens/16-leaderboard.png'));
  });

  testWidgets('leaderboard: daily tab', (tester) async {
    await pump(tester, auth: _SignedIn(), initial: Board.daily);
    await expectLater(find.byType(LeaderboardScreen), matchesGoldenFile('goldens/16-leaderboard-daily.png'));
  });

  testWidgets('leaderboard: guest', (tester) async {
    await pump(tester);
    await expectLater(find.byType(LeaderboardScreen), matchesGoldenFile('goldens/16-leaderboard-guest.png'));
  });

  testWidgets('leaderboard: offline shows retry', (tester) async {
    await pump(tester, board: FakeLeaderboard(offline: true));
    expect(find.text('TRY AGAIN'), findsOneWidget);
  });
}
