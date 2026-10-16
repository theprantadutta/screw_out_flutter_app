import 'package:flutter/material.dart';

import '../../core/theme/blueprint_tokens.dart';
import '../../widgets/bp/bp_grid.dart';
import '../domain/game_state.dart';
import 'gameplay_visuals.dart';
import 'plate_painter.dart';

/// The screw tray card: "TRAY n/N" header and fixed slots that never compact.
///
/// The last empty slot turns solid amber (dashed → solid is the non-colour
/// cue). When [stuck], the whole card gets a 2 dp amber outline and the
/// header reads TRAY FULL.
class TrayView extends StatelessWidget {
  const TrayView({
    super.key,
    required this.visuals,
    required this.state,
    required this.trayLabel,
    required this.trayFullLabel,
    this.stuck = false,
  });

  final GameplayVisuals visuals;
  final GameState state;
  final String trayLabel;
  final String trayFullLabel;
  final bool stuck;

  @override
  Widget build(BuildContext context) {
    final n = state.tray.length;
    final filled = state.filledSlots;
    final lastFree = state.emptySlots == 1 ? state.firstEmptySlot : -1;
    final headerColor = stuck ? BpColor.caution : BpColor.textSecondary;
    final header = BpType.trayLabel.copyWith(color: headerColor);
    return Semantics(
      label: '$trayLabel $filled of $n',
      child: CustomPaint(
        foregroundPainter: BpBorderPainter(
          color: stuck ? BpColor.caution : BpColor.lineDefault,
          width: stuck ? BpSize.emphasis : BpSize.stroke,
        ),
        child: Container(
          color: BpColor.card,
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(stuck ? trayFullLabel : trayLabel, style: header),
                  Text(
                    '$filled/$n',
                    style: header.copyWith(
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  for (var i = 0; i < n; i++) ...[
                    if (i > 0) const SizedBox(width: 8),
                    Expanded(
                      child: _Slot(
                        key: visuals.slotKeys.length > i ? visuals.slotKeys[i] : null,
                        visual: visuals.slots[i],
                        visuals: visuals,
                        index: i,
                        lastFree: i == lastFree,
                        stuck: stuck,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Slot extends StatelessWidget {
  const _Slot({
    super.key,
    required this.visual,
    required this.visuals,
    required this.index,
    required this.lastFree,
    required this.stuck,
  });

  final SlotVisual visual;
  final GameplayVisuals visuals;
  final int index;
  final bool lastFree;
  final bool stuck;

  @override
  Widget build(BuildContext context) {
    final borderColor = lastFree
        ? BpColor.caution
        : (stuck ? BpColor.lineDefault : BpColor.lineDashed);
    return AnimatedBuilder(
      animation: Listenable.merge([visual, visuals.risk]),
      builder: (context, _) {
        final pulse = lastFree && visuals.riskSlot == index && visuals.risk.isAnimating
            ? 1 + .04 * (1 - (2 * visuals.risk.value - 1).abs())
            : 1.0;
        return Transform.scale(
          scale: pulse,
          child: SizedBox(
            height: BpSize.traySlotH,
            child: CustomPaint(
              foregroundPainter: BpBorderPainter(
                color: borderColor,
                dashed: !lastFree && !stuck,
              ),
              child: _content(),
            ),
          ),
        );
      },
    );
  }

  Widget _content() {
    final id = visual.screwId;
    if (id == null) return const SizedBox.expand();
    final p = visual.popIn.value;
    final shrink = visual.shrinkOut.value;
    double scale;
    double dy;
    double opacity;
    if (visual.reducedPop || visuals.reducedMotion) {
      scale = 1;
      dy = 0;
      opacity = p;
    } else {
      final ms = p * BpMotion.slotPop.inMilliseconds;
      final c = BpMotion.pop.transform(p);
      scale = c;
      dy = -10 * (1 - c);
      opacity = (ms / 80).clamp(0.0, 1.0);
    }
    if (shrink > 0) {
      scale *= visuals.reducedMotion ? 1 : 1 - BpMotion.standardIn.transform(shrink);
      if (visuals.reducedMotion) opacity *= 1 - shrink;
    }
    final label = visuals.level.panelById(visuals.board.panelOfScrew(id)).label;
    return Stack(
      children: [
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          bottom: 14,
          child: Center(
            child: Opacity(
              opacity: opacity,
              child: Transform.translate(
                offset: Offset(0, dy),
                child: Transform.scale(
                  scale: scale.clamp(0.0, 2.0),
                  child: const CustomPaint(
                    size: Size.square(BpSize.trayScrew),
                    painter: ScrewHeadPainter(crossLength: 10, shadow: false),
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 4,
          child: Opacity(
            opacity: opacity * (1 - shrink),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: BpType.slotTag.copyWith(color: BpColor.textSecondary),
            ),
          ),
        ),
      ],
    );
  }
}
