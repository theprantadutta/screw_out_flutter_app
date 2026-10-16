import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:screw_out/presentation/bloc/game/game_cubit.dart';
import 'package:screw_out/screens/gameplay/gameplay_screen.dart';

import '../helpers/harness.dart';

void main() {
  setUpAll(loadAppFonts);

  Future<GameCubit> pump(WidgetTester tester, {int level = 24, void Function(GameCubit c)? setup}) async {
    useDesignFrame(tester);
    final cubit = GameCubit(level: sampleLevel(level), host: FakeHost());
    await tester.pumpWidget(
      appShell(
        child: BlocProvider.value(
          value: cubit,
          child: GameplayScreen(
            coins: 860,
            adAvailable: true,
            callbacks: GameplayCallbacks(
              onExit: () {},
              onNext: (_) {},
              onReplay: () {},
              nextLabel: 'Next sheet — DWG 025',
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    setup?.call(cubit);
    await tester.pumpAndSettle();
    return cubit;
  }

  testWidgets('07 gameplay', (tester) async {
    await pump(tester);
    await expectLater(find.byType(GameplayScreen), matchesGoldenFile('goldens/07-gameplay.png'));
  });

  testWidgets('09 pause', (tester) async {
    await pump(tester, setup: (c) {
      for (final id in ['D-0', 'C-0', 'C-1']) {
        c.tapScrew(id);
      }
      c.pause();
    });
    await expectLater(find.byType(GameplayScreen), matchesGoldenFile('goldens/09-pause.png'));
  });

  testWidgets('10 stuck', (tester) async {
    await pump(tester, setup: (c) {
      for (final id in ['A-1', 'A-2', 'A-3', 'C-0']) {
        c.tapScrew(id);
      }
    });
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
    await expectLater(find.byType(GameplayScreen), matchesGoldenFile('goldens/10-stuck.png'));
  });

  testWidgets('11 level complete', (tester) async {
    final cubit = await pump(tester, setup: (c) {
      for (final id in c.level.solution!) {
        c.tapScrew(id);
      }
    });
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    expect(cubit.state.overlay, GameOverlay.won);
    await expectLater(find.byType(GameplayScreen), matchesGoldenFile('goldens/11-complete.png'));
  });

  testWidgets('13 out of hints', (tester) async {
    await pump(tester, setup: (c) {
      c
        ..requestHint()
        ..requestHint()
        ..requestHint()
        ..requestHint();
    });
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    await expectLater(find.byType(GameplayScreen), matchesGoldenFile('goldens/13-out-of-hints.png'));
  });
}

