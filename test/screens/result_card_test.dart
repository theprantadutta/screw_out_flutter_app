import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:screw_out/presentation/bloc/game/game_host.dart';
import 'package:screw_out/screens/gameplay/widgets/result_overlay.dart';

import '../helpers/harness.dart';

/// Mirrors the gameplay screen: the parent reacts to "coins counted" with
/// setState (to update the header balance).
class _Parent extends StatefulWidget {
  const _Parent({required this.reward, this.reducedMotion = false});

  final LevelReward reward;
  final bool reducedMotion;

  @override
  State<_Parent> createState() => _ParentState();
}

class _ParentState extends State<_Parent> {
  bool counted = false;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Align(
      alignment: Alignment.bottomCenter,
      child: ResultCard(
        result: LevelResult(
          level: sampleLevel(24),
          moves: 8,
          elapsed: const Duration(seconds: 30),
          mastered: false,
          usedHint: true,
          restarted: false,
          rescued: false,
          isDaily: false,
        ),
        reward: widget.reward,
        reducedMotion: widget.reducedMotion,
        nextLabel: 'Next',
        onNext: () {},
        onReplay: () {},
        onSheets: () {},
        onCoinsCounted: () => setState(() => counted = true),
      ),
    ),
  );
}

void main() {
  // A replay of a cleared sheet pays 0 coins: the card used to report
  // "counted" during the parent's build → "setState() called during build"
  // → a red error box instead of the card.
  testWidgets('0-coin replay shows the card (no setState during build)', (tester) async {
    useDesignFrame(tester);
    await tester.pumpWidget(
      appShell(
        child: const _Parent(
          reward: LevelReward(coins: 0, balanceBefore: 2250, balanceAfter: 2250, firstClear: false),
        ),
      ),
    );
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(find.text('Disassembled.'), findsOneWidget);
    expect(tester.state<_ParentState>(find.byType(_Parent)).counted, isTrue);
  });

  testWidgets('reduced motion: counted at once, no error', (tester) async {
    useDesignFrame(tester);
    await tester.pumpWidget(
      appShell(
        child: const _Parent(
          reward: LevelReward(coins: 25, balanceBefore: 100, balanceAfter: 125, firstClear: true),
          reducedMotion: true,
        ),
      ),
    );
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(find.text('+25'), findsOneWidget);
  });
}
