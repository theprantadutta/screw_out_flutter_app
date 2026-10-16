import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:screw_out/presentation/bloc/game/game_cubit.dart';
import 'package:screw_out/screens/gameplay/gameplay_screen.dart';

import '../helpers/harness.dart';

/// System back must never drop the player out of a level by accident.
void main() {
  testWidgets('back: play → pause → resume; never exits the level', (tester) async {
    useDesignFrame(tester);
    var exited = 0;
    final cubit = GameCubit(level: sampleLevel(24), host: FakeHost());
    await tester.pumpWidget(
      appShell(
        child: BlocProvider.value(
          value: cubit,
          child: GameplayScreen(
            coins: 0,
            callbacks: GameplayCallbacks(onExit: () => exited++, onNext: (_) {}, onReplay: () {}, nextLabel: 'Next'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(cubit.state.overlay, GameOverlay.paused);
    expect(find.byType(GameplayScreen), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(cubit.state.overlay, GameOverlay.none);
    expect(find.byType(GameplayScreen), findsOneWidget);
    expect(exited, 0);
    await cubit.close();
  });

  test('a resumed sheet with moves keeps its objective collapsed', () async {
    final level = sampleLevel(24);
    final first = GameCubit(level: level, host: FakeHost())..tapScrew('D-0');
    final saved = first.engine.save();
    await first.close();
    final resumed = GameCubit(level: level, host: FakeHost(), resume: saved);
    expect(resumed.state.objectiveVisible, isFalse);
    expect(GameCubit(level: level, host: FakeHost()).state.objectiveVisible, isTrue);
    await resumed.close();
  });
}
