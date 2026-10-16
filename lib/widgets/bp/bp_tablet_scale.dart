import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../core/theme/blueprint_tokens.dart';

/// Tablets render the 360×780 design frame scaled up as a whole, instead of
/// stretching a phone layout across a wide screen.
///
/// The child is laid out in a smaller *logical* size (screen ÷ scale) and
/// painted through a transform, so text and strokes stay vector-crisp and
/// hit testing, global keys and overlays stay consistent. Phones (shortest
/// side < [tabletShortestSide]) are untouched.
class BpTabletScale extends StatelessWidget {
  const BpTabletScale({super.key, required this.child});

  final Widget child;

  static const tabletShortestSide = 550.0;
  static const maxScale = 1.7;

  /// Scale for a screen of [size] (1 on phones).
  static double scaleFor(Size size) {
    if (size.shortestSide < tabletShortestSide) return 1;
    final s = math.min(size.width / BpSize.frameW, size.height / BpSize.frameH);
    return s.clamp(1.0, maxScale);
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final s = scaleFor(mq.size);
    if (s == 1) return child;
    final logical = mq.size / s;
    EdgeInsets div(EdgeInsets e) => EdgeInsets.fromLTRB(e.left / s, e.top / s, e.right / s, e.bottom / s);
    return MediaQuery(
      data: mq.copyWith(
        size: logical,
        devicePixelRatio: mq.devicePixelRatio * s,
        padding: div(mq.padding),
        viewPadding: div(mq.viewPadding),
        viewInsets: div(mq.viewInsets),
        systemGestureInsets: div(mq.systemGestureInsets),
      ),
      child: ClipRect(
        child: OverflowBox(
          alignment: Alignment.topLeft,
          minWidth: logical.width,
          maxWidth: logical.width,
          minHeight: logical.height,
          maxHeight: logical.height,
          child: Transform.scale(
            scale: s,
            alignment: Alignment.topLeft,
            child: SizedBox.fromSize(size: logical, child: child),
          ),
        ),
      ),
    );
  }
}
