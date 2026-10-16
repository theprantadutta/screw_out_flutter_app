import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/blueprint_tokens.dart';
import 'gameplay_visuals.dart';
import 'plate_painter.dart';

/// Screws in flight, painted above board and tray so they are never clipped.
/// X and Y run on separate curves (arcX / arcY) — arcY's negative control
/// point lifts the screw ~30 px before it drops into the slot.
class FlyerLayer extends StatelessWidget {
  const FlyerLayer({super.key, required this.visuals});

  final GameplayVisuals visuals;

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: ListenableBuilder(
      listenable: visuals,
      builder: (context, _) {
        final box = context.findRenderObject() as RenderBox?;
        if (visuals.flights.isEmpty || box == null || !box.hasSize) {
          return const SizedBox.expand();
        }
        return Stack(
          clipBehavior: Clip.none,
          children: [
            for (final f in visuals.flights)
              _Flyer(
                key: ObjectKey(f),
                fill: visuals.theme.screwFill,
                line: visuals.theme.screwLine,
                flight: f,
                from: box.globalToLocal(f.from),
                to: box.globalToLocal(f.to),
              ),
          ],
        );
      },
    ),
  );
}

class _Flyer extends StatelessWidget {
  const _Flyer({super.key, required this.flight, required this.from, required this.to, required this.fill, required this.line});

  final Flight flight;
  final Color fill;
  final Color line;
  final Offset from;
  final Offset to;

  @override
  Widget build(BuildContext context) {
    final d = BpSize.screwHead * flight.unit;
    return AnimatedBuilder(
      animation: flight.controller,
      builder: (context, child) {
        final t = flight.controller.value;
        double x;
        double y;
        double angle;
        double scale;
        if (flight.reverse) {
          // Screwing back in: standardOut, rotate −420° → 0.
          final e = BpMotion.standardOut.transform(t);
          x = from.dx + (to.dx - from.dx) * e;
          y = from.dy + (to.dy - from.dy) * e;
          angle = -420 * (1 - e);
          scale = .86 + (1 - .86) * e;
        } else {
          x = from.dx + (to.dx - from.dx) * BpMotion.arcX.transform(t);
          y = from.dy + (to.dy - from.dy) * BpMotion.arcY.transform(t);
          angle = -420 * t;
          scale = 1.12 + (.86 - 1.12) * t;
        }
        return Positioned(
          left: x - d / 2,
          top: y - d / 2,
          width: d,
          height: d,
          child: Transform.rotate(
            angle: angle * math.pi / 180,
            child: Transform.scale(scale: scale, child: child),
          ),
        );
      },
      child: CustomPaint(painter: ScrewHeadPainter(unit: flight.unit, lifted: true, fill: fill, line: line)),
    );
  }
}
