import 'package:flutter/material.dart';

import '../../core/theme/blueprint_tokens.dart';
import 'bp_grid.dart';

/// Bottom sheet card: 12 dp side inset, `card` fill, 1.5 dp white inset edge,
/// 20 dp padding, 14 dp gap between children.
class BpSheetCard extends StatelessWidget {
  const BpSheetCard({super.key, required this.children, this.gap = 14});

  final List<Widget> children;
  final double gap;

  @override
  Widget build(BuildContext context) => BpOutlined(
    color: BpColor.line,
    fill: BpColor.card,
    padding: const EdgeInsets.all(BpSize.sheetPad),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0) SizedBox(height: gap),
          children[i],
        ],
      ],
    ),
  );
}

/// Scrim (0 → 50%, 260 ms) + sheet sliding up (100% → 0, 380 ms sheetCurve);
/// dismiss reverses in 240 ms standardIn. Reduced motion: fades, 160 ms.
///
/// Keeps showing the last child while it animates out.
class BpSheetHost extends StatefulWidget {
  const BpSheetHost({
    super.key,
    required this.sheet,
    required this.reducedMotion,
    this.onScrimTap,
    this.above,
    this.bottomInset = 14,
  });

  /// Null hides the sheet.
  final Widget? sheet;
  final bool reducedMotion;
  final VoidCallback? onScrimTap;

  /// Optional widget pinned directly above the sheet (e.g. the lifted tray).
  final Widget? above;
  final double bottomInset;

  @override
  State<BpSheetHost> createState() => _BpSheetHostState();
}

class _BpSheetHostState extends State<BpSheetHost>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: BpMotion.sheet,
    reverseDuration: BpMotion.sheetOut,
  );
  Widget? _shown;
  Widget? _above;

  @override
  void initState() {
    super.initState();
    if (widget.sheet != null) {
      _shown = widget.sheet;
      _above = widget.above;
      _c.forward();
    }
  }

  @override
  void didUpdateWidget(BpSheetHost old) {
    super.didUpdateWidget(old);
    _c.duration = widget.reducedMotion ? BpMotion.reduced : BpMotion.sheet;
    _c.reverseDuration = widget.reducedMotion
        ? BpMotion.reduced
        : BpMotion.sheetOut;
    if (widget.sheet != null) {
      _shown = widget.sheet;
      _above = widget.above;
      if (_c.status != AnimationStatus.completed) _c.forward();
    } else if (_shown != null) {
      _c.reverse().whenComplete(() {
        if (mounted && widget.sheet == null) {
          setState(() {
            _shown = null;
            _above = null;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_shown == null) return const SizedBox.shrink();
    final reduced = widget.reducedMotion;
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        final forward = _c.status != AnimationStatus.reverse;
        final scrimT = reduced
            ? _c.value
            : (forward
                  ? (_c.value *
                            BpMotion.sheet.inMilliseconds /
                            BpMotion.scrim.inMilliseconds)
                        .clamp(0.0, 1.0)
                  : _c.value);
        final slide = reduced
            ? 0.0
            : 1 -
                  (forward ? BpMotion.sheetCurve : BpMotion.standardIn)
                      .transform(_c.value);
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: widget.onScrimTap,
                child: ColoredBox(
                  color: BpColor.scrim.withValues(
                    alpha: BpColor.scrim.a * scrimT,
                  ),
                ),
              ),
            ),
            Positioned(
              left: BpSize.sheetInset,
              right: BpSize.sheetInset,
              bottom: widget.bottomInset,
              child: FractionalTranslation(
                translation: Offset(0, slide * 1.15),
                child: Opacity(
                  opacity: reduced ? _c.value : 1,
                  // Sheets may be hosted outside a screen's Material (e.g. in a
                  // Stack above it); give text its defaults here.
                  child: Material(
                    type: MaterialType.transparency,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [?_above, _shown!],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
