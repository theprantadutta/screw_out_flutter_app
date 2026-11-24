import 'package:material_ui/material_ui.dart';

/// Mirrors [child] horizontally in right-to-left locales. For icons that
/// point along the reading direction (arrows, chevrons, undo): Material
/// Symbols glyphs don't flip on their own.
class BpMirrorRtl extends StatelessWidget {
  const BpMirrorRtl({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) =>
      Directionality.of(context) == TextDirection.rtl ? Transform.flip(flipX: true, child: child) : child;
}
