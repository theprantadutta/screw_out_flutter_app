import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/theme/blueprint_tokens.dart';
import '../../../game/generator/rng.dart';
import '../../../l10n/app_localizations.dart';
import '../../../presentation/bloc/game/game_host.dart';
import '../../../widgets/bp/bp_buttons.dart';
import '../../../widgets/bp/bp_grid.dart';
import '../../../widgets/bp/bp_sheet.dart';

/// Confetti + APPROVED stamp over the (now empty) board frame.
/// 18 bits max; none under reduced motion (stamp static).
class CelebrationLayer extends StatefulWidget {
  const CelebrationLayer({super.key, required this.seed, required this.reducedMotion, this.onStamp});

  final int seed;
  final bool reducedMotion;
  final VoidCallback? onStamp;

  @override
  State<CelebrationLayer> createState() => _CelebrationLayerState();
}

class _CelebrationLayerState extends State<CelebrationLayer> with TickerProviderStateMixin {
  late final AnimationController _burst = AnimationController(vsync: this, duration: BpMotion.celebration);
  late final AnimationController _stamp = AnimationController(vsync: this, duration: const Duration(milliseconds: 220));
  late final List<_Bit> _bits = _makeBits(widget.seed);
  Timer? _stampTimer;

  @override
  void initState() {
    super.initState();
    if (widget.reducedMotion) {
      _stamp.value = 1;
    } else {
      _burst.forward();
      // Stamp lands 110 ms after the card starts rising.
      _stampTimer = Timer(const Duration(milliseconds: 110), () {
        _stamp.forward();
        widget.onStamp?.call();
      });
    }
  }

  @override
  void dispose() {
    _stampTimer?.cancel();
    _burst.dispose();
    _stamp.dispose();
    super.dispose();
  }

  static List<_Bit> _makeBits(int seed) {
    final rng = SeededRng(seed);
    const colors = [BpColor.line, BpColor.action, BpColor.confettiBlue];
    return [
      for (var i = 0; i < 18; i++)
        _Bit(
          angle: (i / 18) * 2 * math.pi + rng.nextDouble() * .3,
          radius: 95 + rng.nextDouble() * 60,
          spin: (rng.nextDouble() * 2 - 1) * math.pi,
          circle: i % 3 == 0,
          color: colors[i % 3],
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return IgnorePointer(
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          if (!widget.reducedMotion)
            AnimatedBuilder(
              animation: _burst,
              builder: (context, _) {
                final t = BpMotion.burst.transform(_burst.value);
                final fade = 1 - const Cubic(.8, 0, 1, 1).transform(_burst.value);
                return Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    for (final b in _bits)
                      Transform.translate(
                        offset: Offset(
                          math.cos(b.angle) * b.radius * t,
                          math.sin(b.angle) * b.radius * t - 30 * t,
                        ),
                        child: Transform.rotate(
                          angle: b.spin * t,
                          child: Opacity(
                            opacity: fade.clamp(0.0, 1.0),
                            child: Container(
                              width: b.circle ? 10 : 7,
                              height: b.circle ? 10 : 15,
                              decoration: BoxDecoration(
                                color: b.color,
                                borderRadius: BorderRadius.circular(b.circle ? 5 : 1),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          AnimatedBuilder(
            animation: _stamp,
            builder: (context, child) {
              final t = Curves.easeOutBack.transform(_stamp.value);
              return Opacity(
                opacity: _stamp.value.clamp(0.0, 1.0),
                child: Transform.rotate(
                  angle: (-14 + 6 * t) * math.pi / 180,
                  child: Transform.scale(scale: 1.3 - .3 * t, child: child),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              decoration: BoxDecoration(
                color: BpColor.sheet.withValues(alpha: .85),
                border: Border.all(color: BpColor.action, width: BpSize.stampStroke),
              ),
              child: Text(l.approved, style: BpType.stamp.copyWith(color: BpColor.action)),
            ),
          ),
        ],
      ),
    );
  }
}

class _Bit {
  const _Bit({required this.angle, required this.radius, required this.spin, required this.circle, required this.color});
  final double angle;
  final double radius;
  final double spin;
  final bool circle;
  final Color color;
}

/// 11 - Level complete card.
class ResultCard extends StatefulWidget {
  const ResultCard({
    super.key,
    required this.result,
    required this.reward,
    required this.reducedMotion,
    required this.nextLabel,
    required this.onNext,
    required this.onReplay,
    required this.onSheets,
    this.secondaryLabel,
    this.onCoinsCounted,
  });

  final LevelResult result;

  /// Null while the clear is still being recorded.
  final LevelReward? reward;
  final bool reducedMotion;
  final String nextLabel;
  final VoidCallback onNext;
  final VoidCallback onReplay;
  final VoidCallback onSheets;
  final String? secondaryLabel;

  /// Fired once when the counter finishes (header balance updates then).
  final VoidCallback? onCoinsCounted;

  @override
  State<ResultCard> createState() => _ResultCardState();
}

class _ResultCardState extends State<ResultCard> {
  int _shown = 0;
  Timer? _ticker;
  Timer? _start;
  bool _counted = false;

  @override
  void initState() {
    super.initState();
    _maybeCount();
  }

  @override
  void didUpdateWidget(ResultCard old) {
    super.didUpdateWidget(old);
    _maybeCount();
  }

  /// Ticks 0 → reward in 10 equal steps of 55 ms, starting 480 ms after the
  /// card appears (1130 ms into the sequence).
  void _maybeCount() {
    final reward = widget.reward;
    if (reward == null || _start != null || _counted) return;
    if (widget.reducedMotion || reward.coins == 0) {
      _shown = reward.coins;
      // Runs from initState / didUpdateWidget, i.e. inside the parent's
      // build: the parent reacts with setState, so report after the frame
      // (calling it here threw "setState() called during build" and the
      // card became a red error box on every 0-coin replay).
      _counted = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) widget.onCoinsCounted?.call();
      });
      return;
    }
    _start = Timer(const Duration(milliseconds: 480), () {
      var step = 0;
      _ticker = Timer.periodic(const Duration(milliseconds: 55), (t) {
        step++;
        setState(() => _shown = (reward.coins * step / 10).round());
        if (step >= 10) {
          t.cancel();
          _finish();
        }
      });
    });
  }

  void _finish() {
    if (_counted) return;
    _counted = true;
    widget.onCoinsCounted?.call();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _start?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final r = widget.result;
    final reward = widget.reward;
    final secs = r.elapsed.inSeconds;
    final time = '${secs ~/ 60}:${(secs % 60).toString().padLeft(2, '0')}';
    Widget stat(String label, Widget value) => Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: BpType.caption.copyWith(fontSize: 9, letterSpacing: .9, color: BpColor.textMuted)),
            const SizedBox(height: 6),
            value,
          ],
        ),
      ),
    );
    final valueStyle = BpType.statValue.copyWith(fontSize: 20, color: BpColor.line);
    return BpSheetCard(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.cleared(r.level.code), style: BpType.caption.copyWith(color: BpColor.success)),
            const SizedBox(height: 4),
            Text(l.disassembled, style: BpType.resultTitle.copyWith(fontSize: 32, color: BpColor.line)),
          ],
        ),
        DecoratedBox(
          decoration: BoxDecoration(border: Border.all(color: BpColor.divider)),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                stat(l.statMoves, Text('${r.moves}', style: valueStyle)),
                const VerticalDivider(width: 1, thickness: 1, color: BpColor.divider),
                stat(l.statTime, Text(time, style: valueStyle)),
                const VerticalDivider(width: 1, thickness: 1, color: BpColor.divider),
                stat(
                  l.statMastery,
                  SizedBox(
                    height: 26,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: r.mastered
                          ? const BpDiamond(size: 20)
                          : Text('-', style: valueStyle.copyWith(color: BpColor.textMuted)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Row(
          children: [
            const BpCoinGlyph(size: 24, stroke: 3),
            const SizedBox(width: 12),
            Text('+$_shown', style: BpType.reward.copyWith(fontSize: 24, color: BpColor.action)),
            const Spacer(),
            if (reward != null)
              Text(
                '${reward.balanceBefore} → ${reward.balanceAfter}',
                style: BpType.monoBody.copyWith(fontSize: 11, color: BpColor.textSecondary, fontFeatures: const [FontFeature.tabularFigures()]),
              ),
          ],
        ),
        BpPrimaryButton(
          height: 56,
          onPressed: widget.onNext,
          child: Row(
            children: [
              Expanded(child: Text(widget.nextLabel, style: BpType.button.copyWith(fontSize: 17, color: BpColor.ink))),
              const Icon(Symbols.arrow_forward_sharp, size: 24),
            ],
          ),
        ),
        Row(
          children: [
            Expanded(child: BpOutlineButton(onPressed: widget.onReplay, child: Text(l.replay, style: BpType.monoSmallButton))),
            const SizedBox(width: 8),
            Expanded(child: BpOutlineButton(onPressed: widget.onSheets, child: Text(widget.secondaryLabel ?? l.sheets, style: BpType.monoSmallButton))),
          ],
        ),
      ],
    );
  }
}
