import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:screw_out/game/domain/game_state.dart';
import 'package:screw_out/game/presentation/game_feedback.dart';
import 'package:screw_out/game/presentation/gameplay_visuals.dart';
import 'package:screw_out/screens/gameplay/widgets/tutorial_overlay.dart';
import 'package:screw_out/services/ads/tap_guard.dart';

import '../helpers/harness.dart';

void main() {
  group('interstitial tap guard', () {
    testWidgets('swallows taps for 0.7 s, then lets them through again', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        appShell(
          child: Scaffold(
            body: Center(
              child: TextButton(onPressed: () => taps++, child: const Text('NEXT')),
            ),
          ),
        ),
      );
      final overlay = tester.state<OverlayState>(find.byType(Overlay).first);

      final guard = TapGuard.absorb(overlay);
      await tester.pump();
      expect(find.byKey(const ValueKey('ad-tap-guard')), findsOneWidget);
      await tester.tap(find.text('NEXT'), warnIfMissed: false);
      await tester.pump(const Duration(milliseconds: 400));
      await tester.tap(find.text('NEXT'), warnIfMissed: false);
      expect(taps, 0);

      await tester.pump(const Duration(milliseconds: 400));
      await guard;
      await tester.pump();
      expect(find.byKey(const ValueKey('ad-tap-guard')), findsNothing);
      await tester.tap(find.text('NEXT'));
      expect(taps, 1);
    });

    testWidgets('without an overlay it only waits', (tester) async {
      var done = false;
      TapGuard.absorb(null).then((_) => done = true);
      await tester.pump(const Duration(milliseconds: 600));
      expect(done, isFalse);
      await tester.pump(const Duration(milliseconds: 200));
      expect(done, isTrue);
    });
  });

  group('tutorial safety net', () {
    late GameplayVisuals visuals;

    Future<void> pumpOverlay(WidgetTester tester, {required VoidCallback onSkip, VoidCallback? onUnavailable}) async {
      final level = sampleLevel(1);
      visuals = GameplayVisuals(
        vsync: tester,
        level: level,
        initial: GameState.initial(level.trayCapacity),
        feedback: const NoFeedback(),
        reducedMotion: true,
      );
      // No board is mounted, so the screw's hole can never be measured.
      await tester.pumpWidget(
        appShell(
          child: Scaffold(
            body: TutorialOverlay(
              visuals: visuals,
              screwId: level.screws.first.id,
              reducedMotion: true,
              onSkip: onSkip,
              onUnavailable: onUnavailable,
            ),
          ),
        ),
      );
    }

    testWidgets('ends the coach mark when the spotlight cannot be placed', (tester) async {
      var skipped = 0;
      var unavailable = 0;
      await pumpOverlay(tester, onSkip: () => skipped++, onUnavailable: () => unavailable++);
      await tester.pump(const Duration(milliseconds: 1000));
      expect(unavailable, 0);
      await tester.pump(TutorialOverlay.measureTimeout);
      expect(unavailable, 1);
      expect(skipped, 0);
      // Gives up once, not every frame.
      await tester.pump(const Duration(seconds: 2));
      expect(unavailable, 1);
      await tester.pumpWidget(const SizedBox());
      visuals.dispose();
    });

    testWidgets('falls back to skip when no handler is given', (tester) async {
      var skipped = 0;
      await pumpOverlay(tester, onSkip: () => skipped++);
      await tester.pump(TutorialOverlay.measureTimeout + const Duration(milliseconds: 100));
      expect(skipped, 1);
      await tester.pumpWidget(const SizedBox());
      visuals.dispose();
    });
  });
}
