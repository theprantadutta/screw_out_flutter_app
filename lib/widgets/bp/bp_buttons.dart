import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/blueprint_tokens.dart';
import 'bp_grid.dart';

/// Called on every UI press (sound `sfx_tick` + `selectionClick` haptic).
/// Set once at startup by the app; null in tests.
VoidCallback? bpUiTick;

/// Called when a toggle flips (latch click). Set once at startup.
VoidCallback? bpUiToggle;

/// Primary action: drafting-yellow, hard offset ink shadow, no blur.
/// Pressed → translate (+2, +2) and the shadow collapses (90 ms).
class BpPrimaryButton extends StatefulWidget {
  const BpPrimaryButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.height = BpSize.primaryH,
    this.shadow = BpSize.hardShadow,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.semanticLabel,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final double height;
  final double shadow;
  final EdgeInsetsGeometry padding;
  final String? semanticLabel;

  @override
  State<BpPrimaryButton> createState() => _BpPrimaryButtonState();
}

class _BpPrimaryButtonState extends State<BpPrimaryButton> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null;
    final offset = _down ? 2.0 : 0.0;
    final shadow = _down ? 0.0 : widget.shadow;
    return Semantics(
      button: true,
      enabled: enabled,
      label: widget.semanticLabel,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: enabled ? (_) => setState(() => _down = true) : null,
        onTapCancel: () => setState(() => _down = false),
        onTapUp: (_) => setState(() => _down = false),
        onTap: enabled
            ? () {
                bpUiTick?.call();
                widget.onPressed!();
              }
            : null,
        child: Opacity(
          opacity: enabled ? 1 : .45,
          child: Padding(
            padding: EdgeInsets.only(right: widget.shadow, bottom: widget.shadow),
            child: AnimatedContainer(
              duration: BpMotion.tap,
              transform: Matrix4.translationValues(offset, offset, 0),
              height: widget.height,
              padding: widget.padding,
              decoration: BoxDecoration(
                color: BpColor.action,
                boxShadow: [
                  BoxShadow(color: BpColor.ink, offset: Offset(shadow, shadow)),
                ],
              ),
              child: DefaultTextStyle.merge(
                style: BpType.button.copyWith(color: BpColor.ink),
                child: IconTheme.merge(
                  data: const IconThemeData(color: BpColor.ink, size: 24),
                  child: Center(child: widget.child),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Outline button: 1.5 dp white 85% border; pressed → white 15% fill.
class BpOutlineButton extends StatefulWidget {
  const BpOutlineButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.height = 48,
    this.width,
    this.color = BpColor.lineDefault,
    this.textColor = BpColor.line,
    this.fill,
    this.dimmed = false,
    this.padding = EdgeInsets.zero,
    this.semanticLabel,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final double height;
  final double? width;
  final Color color;
  final Color textColor;
  final Color? fill;

  /// 45% opacity look (e.g. Undo with empty history) — still tappable.
  final bool dimmed;
  final EdgeInsetsGeometry padding;
  final String? semanticLabel;

  @override
  State<BpOutlineButton> createState() => _BpOutlineButtonState();
}

class _BpOutlineButtonState extends State<BpOutlineButton> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null;
    return Semantics(
      button: true,
      enabled: enabled,
      label: widget.semanticLabel,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: enabled ? (_) => setState(() => _down = true) : null,
        onTapCancel: () => setState(() => _down = false),
        onTapUp: (_) => setState(() => _down = false),
        onTap: enabled
            ? () {
                bpUiTick?.call();
                widget.onPressed!();
              }
            : null,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: widget.dimmed || !enabled ? .45 : 1,
          child: SizedBox(
            height: widget.height,
            width: widget.width,
            child: BpOutlined(
              color: widget.color,
              fill: _down ? BpColor.pressFill : widget.fill,
              padding: widget.padding,
              child: DefaultTextStyle.merge(
                style: BpType.monoButton.copyWith(color: widget.textColor),
                textAlign: TextAlign.center,
                child: IconTheme.merge(
                  data: IconThemeData(color: widget.textColor, size: 20),
                  child: Center(child: widget.child),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Square 44–48 dp icon button (outline).
class BpIconButton extends StatelessWidget {
  const BpIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.semanticLabel,
    this.size = BpSize.iconButton,
    this.iconSize = 24,
  });

  final Widget icon;
  final VoidCallback? onPressed;
  final String semanticLabel;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) => BpOutlineButton(
    onPressed: onPressed,
    width: size,
    height: size,
    semanticLabel: semanticLabel,
    child: IconTheme.merge(data: IconThemeData(size: iconSize), child: icon),
  );
}

/// Square toggle 46×26: off = white 70% outline + 85% knob at x 3;
/// on = yellow fill/border + ink knob at x 23.
class BpToggle extends StatelessWidget {
  const BpToggle({
    super.key,
    required this.value,
    required this.onChanged,
    required this.semanticLabel,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) => Semantics(
    toggled: value,
    label: semanticLabel,
    child: GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        bpUiToggle != null ? bpUiToggle!() : HapticFeedback.selectionClick();
        onChanged(!value);
      },
      child: Padding(
        // Pads the 46×26 control to a 48 dp tap target.
        padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 1),
        child: AnimatedContainer(
          duration: BpMotion.feedback,
          width: BpSize.toggleW,
          height: BpSize.toggleH,
          decoration: BoxDecoration(
            color: value ? BpColor.action : BpColor.transparent,
            border: Border.all(
              color: value ? BpColor.action : BpColor.lineMuted,
              width: BpSize.stroke,
            ),
          ),
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: BpMotion.toggle,
                curve: BpMotion.toggleCurve,
                left: value ? 23 - BpSize.stroke : 3 - BpSize.stroke,
                top: 3 - BpSize.stroke,
                child: AnimatedContainer(
                  duration: BpMotion.feedback,
                  width: BpSize.toggleKnob,
                  height: BpSize.toggleKnob,
                  color: value ? BpColor.ink : BpColor.lineDefault,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

/// Coin balance chip: yellow ring glyph + tabular number.
class BpCoinChip extends StatelessWidget {
  const BpCoinChip({super.key, required this.coins, this.height = BpSize.chipH, this.onTap});

  final int coins;
  final double height;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: SizedBox(
      height: height,
      child: BpOutlined(
        color: BpColor.lineFaint,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const BpCoinGlyph(),
            const SizedBox(width: 6),
            Text('$coins', style: BpType.coin.copyWith(color: BpColor.line)),
          ],
        ),
      ),
    ),
  );
}

/// The coin: a 2 dp yellow ring.
class BpCoinGlyph extends StatelessWidget {
  const BpCoinGlyph({super.key, this.size = 12, this.stroke = 2});

  final double size;
  final double stroke;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(color: BpColor.action, width: stroke),
    ),
  );
}
