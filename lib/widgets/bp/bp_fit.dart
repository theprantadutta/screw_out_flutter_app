import 'package:flutter/rendering.dart';
import 'package:material_ui/material_ui.dart';

/// Shrinks [child] uniformly when it is wider than the space it gets (a
/// long translation on a button, chip or tab) instead of wrapping or
/// overflowing.
///
/// Unlike `FittedBox(fit: BoxFit.scaleDown)`, a child that fits is laid out
/// and painted exactly as if this widget weren't there, so layouts that fit
/// (every English label) stay pixel-identical.
///
/// The child must not contain flexible children of an unbounded Row
/// (`Expanded` inside a Row): when it is too wide it is laid out at its
/// natural width.
class BpShrinkToFit extends SingleChildRenderObjectWidget {
  const BpShrinkToFit({super.key, required Widget super.child});

  @override
  RenderObject createRenderObject(BuildContext context) => _RenderShrinkToFit();
}

class _RenderShrinkToFit extends RenderProxyBox {
  double _scale = 1;

  @override
  void performLayout() {
    final child = this.child!;
    final natural = child.getMaxIntrinsicWidth(double.infinity);
    if (!constraints.hasBoundedWidth || natural <= constraints.maxWidth) {
      _scale = 1;
      child.layout(constraints, parentUsesSize: true);
      size = child.size;
      return;
    }
    child.layout(BoxConstraints(maxHeight: constraints.maxHeight), parentUsesSize: true);
    _scale = constraints.maxWidth / child.size.width;
    size = constraints.constrain(child.size * _scale);
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final child = this.child!;
    final natural = child.getMaxIntrinsicWidth(double.infinity);
    if (!constraints.hasBoundedWidth || natural <= constraints.maxWidth) return child.getDryLayout(constraints);
    final full = child.getDryLayout(BoxConstraints(maxHeight: constraints.maxHeight));
    return constraints.constrain(full * (constraints.maxWidth / full.width));
  }

  Offset get _childOffset => Offset(
    (size.width - child!.size.width * _scale) / 2,
    (size.height - child!.size.height * _scale) / 2,
  );

  Matrix4 get _transform => Matrix4.translationValues(_childOffset.dx, _childOffset.dy, 0)
    ..scaleByDouble(_scale, _scale, 1, 1);

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child == null) return;
    if (_scale == 1) {
      layer = null;
      context.paintChild(child!, offset);
      return;
    }
    layer = context.pushTransform(needsCompositing, offset, _transform, (c, o) => c.paintChild(child!, o), oldLayer: layer as TransformLayer?);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    if (_scale == 1) return super.hitTestChildren(result, position: position);
    return result.addWithPaintTransform(
      transform: _transform,
      position: position,
      hitTest: (r, p) => child!.hitTest(r, position: p),
    );
  }

  @override
  void applyPaintTransform(RenderBox child, Matrix4 transform) {
    if (_scale != 1) transform.multiply(_transform);
  }
}
