import 'package:material_ui/material_ui.dart';

/// Mirrors [child] horizontally in right-to-left locales. For icons that
/// point along the reading direction (arrows, chevrons, undo). An [Icon]
/// whose glyph already has `matchTextDirection` (e.g. Material Symbols
/// arrows) flips on its own, so it is left alone to avoid a double flip.
class BpMirrorRtl extends StatelessWidget {
  const BpMirrorRtl({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final c = child;
    final selfFlips = c is Icon && (c.icon?.matchTextDirection ?? false);
    if (selfFlips || Directionality.of(context) != TextDirection.rtl) return child;
    return Transform.flip(flipX: true, child: child);
  }
}
