import 'package:flutter/material.dart';

import '../../core/theme/blueprint_tokens.dart';

/// The blueprint sheet: solid `sheet` blue with a 20 dp minor / 100 dp major
/// white grid. Painted once, isolated in a RepaintBoundary.
class BpGridBackground extends StatelessWidget {
  const BpGridBackground({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) => Material(
    color: BpColor.sheet,
    child: Stack(
      fit: StackFit.expand,
      children: [
        const RepaintBoundary(child: CustomPaint(painter: _GridPainter())),
        ?child,
      ],
    ),
  );
}

class _GridPainter extends CustomPainter {
  const _GridPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final minor = Paint()
      ..color = BpColor.gridMinor
      ..strokeWidth = 1;
    final major = Paint()
      ..color = BpColor.gridMajor
      ..strokeWidth = 1;
    for (var x = 0.0; x <= size.width; x += 20) {
      canvas.drawLine(Offset(x + .5, 0), Offset(x + .5, size.height), minor);
    }
    for (var y = 0.0; y <= size.height; y += 20) {
      canvas.drawLine(Offset(0, y + .5), Offset(size.width, y + .5), minor);
    }
    for (var x = 0.0; x <= size.width; x += 100) {
      canvas.drawLine(Offset(x + .5, 0), Offset(x + .5, size.height), major);
    }
    for (var y = 0.0; y <= size.height; y += 100) {
      canvas.drawLine(Offset(0, y + .5), Offset(size.width, y + .5), major);
    }
  }

  @override
  bool shouldRepaint(_GridPainter oldDelegate) => false;
}

/// Rectangular border, solid or dashed (square corners - UI is never rounded).
class BpBorderPainter extends CustomPainter {
  const BpBorderPainter({
    required this.color,
    this.width = BpSize.stroke,
    this.dashed = false,
    this.dash = 4,
    this.gap = 3,
    this.circle = false,
  });

  final Color color;
  final double width;
  final bool dashed;
  final double dash;
  final double gap;
  final bool circle;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    final rect = (Offset.zero & size).deflate(width / 2);
    final path = circle ? (Path()..addOval(rect)) : (Path()..addRect(rect));
    if (!dashed) {
      canvas.drawPath(path, paint);
      return;
    }
    for (final metric in path.computeMetrics()) {
      for (var d = 0.0; d < metric.length; d += dash + gap) {
        canvas.drawPath(metric.extractPath(d, d + dash), paint);
      }
    }
  }

  @override
  bool shouldRepaint(BpBorderPainter old) =>
      old.color != color ||
      old.width != width ||
      old.dashed != dashed ||
      old.circle != circle;
}

/// Box with a 1.5 dp border painted *inside* its bounds (CSS inset shadow).
class BpOutlined extends StatelessWidget {
  const BpOutlined({
    super.key,
    required this.child,
    this.color = BpColor.lineDefault,
    this.width = BpSize.stroke,
    this.dashed = false,
    this.fill,
    this.padding,
  });

  final Widget child;
  final Color color;
  final double width;
  final bool dashed;
  final Color? fill;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) => CustomPaint(
    foregroundPainter: BpBorderPainter(color: color, width: width, dashed: dashed),
    child: Container(color: fill, padding: padding, child: child),
  );
}

/// Mastery mark ◆ - drawn, not a glyph (Space Grotesk has no U+25C6).
class BpDiamond extends StatelessWidget {
  const BpDiamond({super.key, this.size = 14, this.color = BpColor.action, this.filled = true});

  final double size;
  final Color color;
  final bool filled;

  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: size,
    child: Center(
      child: Transform.rotate(
        angle: 0.7853981633974483,
        child: Container(
          width: size * .7,
          height: size * .7,
          decoration: BoxDecoration(
            color: filled ? color : null,
            border: filled ? null : Border.all(color: color, width: 1.5),
          ),
        ),
      ),
    ),
  );
}
