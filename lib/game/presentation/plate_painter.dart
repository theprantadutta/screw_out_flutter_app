import 'dart:math' as math;

import 'package:flutter/rendering.dart';

import '../../core/theme/blueprint_tokens.dart';
import '../domain/level.dart';

/// Plate rendering in local plate coordinates (0,0 = plate top-left), already
/// scaled to dp. Draws: soft drop shadow, fill, pattern, 1.5 dp inner white
/// edge, empty holes for every screw (they remain after the screw leaves) and
/// the PL tag.
class PlatePainter extends CustomPainter {
  PlatePainter({
    required this.panel,
    required this.holes,
    required this.scale,
    this.shadowLift = 0,
    this.outline,
    this.outlineOpacity = 0,
    super.repaint,
  });

  final Panel panel;

  /// Hole centres in plate-local dp.
  final List<Offset> holes;
  final double scale;

  /// 0 = resting shadow (0, 8, blur 16); 1 = lifted (0, 20, blur 28).
  final double shadowLift;

  /// Highlight ring 5 dp outside the plate (blocked coral / hint yellow).
  final Color? outline;
  final double outlineOpacity;

  RRect _shape(Size size) => panel.isCircle
      ? RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(size.width / 2))
      : RRect.fromRectAndRadius(
          Offset.zero & size,
          Radius.circular(math.min(panel.r * scale, size.shortestSide / 2)),
        );

  @override
  void paint(Canvas canvas, Size size) {
    final shape = _shape(size);

    // Shadow: CSS `0 8px 16px -8px` → spread −8, blur σ 8.
    final dy = (8 + 12 * shadowLift) * scale;
    final blur = (16 + 12 * shadowLift) * scale;
    canvas.drawRRect(
      shape.deflate(8 * scale).shift(Offset(0, dy)),
      Paint()
        ..color = BpColor.plateShadow
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, blur / 2),
    );

    final pattern = panel.pattern;
    canvas.drawRRect(shape, Paint()..color = BpColor.plates[pattern.index]);

    if (pattern != PlatePattern.solid) {
      canvas.save();
      canvas.clipRRect(shape);
      _paintPattern(canvas, size, pattern);
      canvas.restore();
    }

    // Holes (16 dp, `hole` fill, 1 dp dashed white α .7).
    final holeR = 8 * scale;
    final holeFill = Paint()..color = BpColor.hole;
    final holeEdge = Paint()
      ..color = BpColor.holeEdge
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1 * scale;
    for (final h in holes) {
      canvas.drawCircle(h, holeR, holeFill);
      _dashedCircle(canvas, h, holeR - 0.5 * scale, holeEdge, 10);
    }

    // Inner edge 1.5 dp, α .92.
    final edge = Paint()
      ..color = BpColor.plateEdge
      ..style = PaintingStyle.stroke
      ..strokeWidth = BpSize.stroke * scale;
    canvas.drawRRect(shape.deflate(BpSize.stroke * scale / 2), edge);

    // PL tag, top-centre at 7 dp.
    final tag = TextPainter(
      text: TextSpan(
        text: panel.label,
        style: BpType.plateTag.copyWith(
          color: BpColor.plateTag,
          fontSize: BpType.plateTag.fontSize! * scale,
          letterSpacing: BpType.plateTag.letterSpacing! * scale,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tag.paint(canvas, Offset((size.width - tag.width) / 2, 7 * scale));

    if (outline != null && outlineOpacity > 0) {
      canvas.drawRRect(
        shape.inflate(5 * scale),
        Paint()
          ..color = outline!.withValues(alpha: outline!.a * outlineOpacity)
          ..style = PaintingStyle.stroke
          ..strokeWidth = BpSize.emphasis * scale,
      );
    }
  }

  void _paintPattern(Canvas canvas, Size size, PlatePattern pattern) {
    switch (pattern) {
      case PlatePattern.hatch45:
        _hatch(canvas, size, 8 * scale, 1, BpColor.hatch);
      case PlatePattern.crosshatch:
        _hatch(canvas, size, 6 * scale, 1, BpColor.crosshatch);
        _hatch(canvas, size, 6 * scale, -1, BpColor.crosshatch);
      case PlatePattern.dots:
        final paint = Paint()..color = BpColor.dots;
        final step = 9 * scale;
        final r = 1.2 * scale;
        for (var y = step / 2; y < size.height; y += step) {
          for (var x = step / 2; x < size.width; x += step) {
            canvas.drawCircle(Offset(x, y), r, paint);
          }
        }
      case PlatePattern.solid:
        break;
    }
  }

  /// Parallel 45° lines; [period] measured perpendicular to the lines.
  void _hatch(Canvas canvas, Size size, double period, int dir, Color color) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = BpSize.stroke * scale;
    final step = period * math.sqrt2; // horizontal distance between lines
    final span = size.width + size.height;
    for (var c = -size.height; c < span; c += step) {
      if (dir > 0) {
        canvas.drawLine(Offset(c, size.height), Offset(c + size.height, 0), paint);
      } else {
        canvas.drawLine(Offset(c, 0), Offset(c + size.height, size.height), paint);
      }
    }
  }

  void _dashedCircle(Canvas canvas, Offset c, double r, Paint paint, int dashes) {
    final sweep = 2 * math.pi / dashes;
    final rect = Rect.fromCircle(center: c, radius: r);
    for (var i = 0; i < dashes; i++) {
      canvas.drawArc(rect, i * sweep, sweep * 0.55, false, paint);
    }
  }

  /// Plates absorb taps inside their visible shape only, so a covered
  /// screw's hit area never steals a tap from the plate above it.
  @override
  bool hitTest(Offset position) {
    final size = Size(panel.w * scale, panel.h * scale);
    return _shape(size).contains(position);
  }

  @override
  bool shouldRepaint(PlatePainter old) =>
      old.panel != panel ||
      old.scale != scale ||
      old.shadowLift != shadowLift ||
      old.outline != outline ||
      old.outlineOpacity != outlineOpacity ||
      old.holes.length != holes.length;
}

/// Screw head: sheet-blue disc, 2 dp inner white ring, phillips cross, soft
/// shadow. Board heads are 26 dp with a 12×2 cross; tray heads 22 dp, 10×2.
class ScrewHeadPainter extends CustomPainter {
  const ScrewHeadPainter({
    this.unit = 1,
    this.crossLength = 12,
    this.shadow = true,
    this.lifted = false,
  });

  /// dp per design pixel (the board scale).
  final double unit;
  final double crossLength;
  final bool shadow;

  /// Flyer: deeper shadow (0, 6, blur 10).
  final bool lifted;

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.shortestSide / 2;
    if (shadow) {
      canvas.drawCircle(
        c.translate(0, (lifted ? 6 : 3) * unit),
        r,
        Paint()
          ..color = BpColor.screwShadow
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, (lifted ? 5 : 3) * unit),
      );
    }
    canvas.drawCircle(c, r, Paint()..color = BpColor.sheet);
    canvas.drawCircle(
      c,
      r - unit,
      Paint()
        ..color = BpColor.line
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2 * unit,
    );
    final white = Paint()..color = BpColor.line;
    final len = crossLength * unit;
    final w = 2 * unit;
    canvas.drawRect(Rect.fromCenter(center: c, width: len, height: w), white);
    canvas.drawRect(Rect.fromCenter(center: c, width: w, height: len), white);
  }

  @override
  bool shouldRepaint(ScrewHeadPainter old) =>
      old.unit != unit ||
      old.crossLength != crossLength ||
      old.shadow != shadow ||
      old.lifted != lifted;
}
