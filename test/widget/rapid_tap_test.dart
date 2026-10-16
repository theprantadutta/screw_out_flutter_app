import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:screw_out/game/presentation/tray_view.dart';
import 'package:screw_out/presentation/bloc/game/game_cubit.dart';
import 'package:screw_out/screens/gameplay/gameplay_screen.dart';

import '../helpers/harness.dart';

/// MOTION_SPEC principle 1 / Phase 3 DoD: tapping as fast as possible never
/// desyncs visuals from state.
void main() {
  for (final levelId in [12, 24]) {
    testWidgets('50 random taps @30 ms → rendered tray == engine tray (DWG $levelId)', (tester) async {
      useDesignFrame(tester);
      final level = sampleLevel(levelId);
      final host = FakeHost();
      final cubit = GameCubit(level: level, host: host);
      await tester.pumpWidget(
        appShell(
          child: BlocProvider.value(
            value: cubit,
            child: GameplayScreen(
              coins: 0,
              callbacks: GameplayCallbacks(onExit: () {}, onNext: (_) {}, onReplay: () {}, nextLabel: 'Next'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final rng = Random(levelId);
      for (var i = 0; i < 50; i++) {
        if (cubit.state.overlay != GameOverlay.none) {
          // Stuck sheet: undo and keep hammering.
          cubit.dismissOverlay();
          cubit.undo();
        }
        final screw = level.screws[rng.nextInt(level.screws.length)];
        final finder = find.byKey(ValueKey('screw-${screw.id}'));
        if (finder.evaluate().isNotEmpty) {
          await tester.tapAt(tester.getCenter(finder));
        }
        await tester.pump(const Duration(milliseconds: 30));
      }
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      final rendered = tester
          .widgetList<Text>(find.descendant(of: find.byType(TrayView), matching: find.byType(Text)))
          .map((t) => t.data!)
          .where((s) => s.startsWith('PL-'))
          .toList();
      final engine = [
        for (final id in cubit.state.board.tray.whereType<String>())
          level.panelById(cubit.engine.board.panelOfScrew(id)).label,
      ];
      expect(rendered, engine);
      // Every removed screw is gone from the board; every other one is there.
      for (final s in level.screws) {
        final shown = tester.widgetList(
          find.descendant(of: find.byKey(ValueKey('screw-${s.id}')), matching: find.byType(CustomPaint)),
        ).isNotEmpty;
        expect(shown, !cubit.state.board.removed.contains(s.id), reason: s.id);
      }
      expect(host.saved.length + host.completed.length, greaterThan(5), reason: 'taps must land');
      await cubit.close();
    });
  }
}
