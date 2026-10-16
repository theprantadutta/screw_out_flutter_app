import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../core/theme/blueprint_tokens.dart';
import '../domain/game_state.dart';
import '../domain/level.dart';
import 'gameplay_visuals.dart';
import 'plate_painter.dart';

/// The drawing frame (corner marks) and the 300×300-unit play area.
///
/// Children are stacked by z: plates at `depth*10+1`, screws at
/// `depth*10+5` — a screw is above its own plate and below every higher
/// plate. Plates absorb taps inside their shape, so the topmost visible
/// thing under a finger always wins.
class BoardView extends StatelessWidget {
  const BoardView({
    super.key,
    required this.visuals,
    required this.state,
    required this.size,
    required this.onTapScrew,
    this.onPressScrew,
    this.interactive = true,
  });

  final GameplayVisuals visuals;

  /// Authoritative state — decides hit-testability.
  final GameState state;

  /// Frame size in dp (324 on the design frame).
  final double size;
  final ValueChanged<String> onTapScrew;
  final VoidCallback? onPressScrew;
  final bool interactive;

  @override
  Widget build(BuildContext context) {
    final scale = size / BpSize.boardFrame;
    final inset = BpSize.boardInset * scale;
    final play = BpSize.boardPlay * scale;
    visuals.scale = scale;
    final level = visuals.level;

    final pieces = <(int, int, Widget)>[];
    for (var i = 0; i < level.panels.length; i++) {
      final p = level.panels[i];
      pieces.add((
        p.depth * 10 + 1,
        i,
        _PlateWidget(
          key: ValueKey('plate-${p.id}'),
          panel: p,
          holes: [
            for (final s in level.screws)
              if (s.panelId == p.id)
                Offset((s.x - p.x) * scale, (s.y - p.y) * scale),
          ],
          scale: scale,
          visuals: visuals,
          released: state.released.contains(p.id),
        ),
      ));
    }
    for (var i = 0; i < level.screws.length; i++) {
      final s = level.screws[i];
      final depth = level.panelById(s.panelId).depth;
      pieces.add((
        depth * 10 + 5,
        i,
        _ScrewWidget(
          key: ValueKey('screw-${s.id}'),
          screw: s,
          scale: scale,
          visuals: visuals,
          removed: state.removed.contains(s.id),
          onTap: onTapScrew,
          onPress: onPressScrew,
          semanticLabel: _semantics(level, s),
        ),
      ));
    }
    pieces.sort((a, b) => a.$1 != b.$1 ? a.$1.compareTo(b.$1) : a.$2.compareTo(b.$2));

    return AnimatedBuilder(
      animation: visuals.boardIn,
      builder: (context, child) {
        final t = BpMotion.standardOut.transform(visuals.boardIn.value);
        return Opacity(
          opacity: visuals.reducedMotion ? visuals.boardIn.value : t,
          child: Transform.scale(
            scale: visuals.reducedMotion ? 1 : .94 + .06 * t,
            child: child,
          ),
        );
      },
      child: SizedBox.square(
        dimension: size,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            const Positioned.fill(child: IgnorePointer(child: CustomPaint(painter: _CornerMarks()))),
            Positioned(
              left: inset,
              top: inset,
              width: play,
              height: play,
              child: IgnorePointer(
                ignoring: !interactive,
                child: Stack(
                  key: visuals.boardKey,
                  clipBehavior: Clip.none,
                  children: [for (final p in pieces) p.$3],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _semantics(Level level, Screw s) {
    final panel = level.panelById(s.panelId);
    final blocker = visuals.board.blockerOf(s.id, state.released);
    final by = blocker == null ? '' : ', blocked by ${level.panelById(blocker).label}';
    return 'Screw, plate ${panel.label}$by';
  }
}

class _CornerMarks extends CustomPainter {
  const _CornerMarks();

  @override
  void paint(Canvas canvas, Size size) {
    const m = BpSize.cornerMark;
    final paint = Paint()
      ..color = BpColor.line
      ..strokeWidth = BpSize.emphasis
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;
    const h = BpSize.emphasis / 2;
    final w = size.width - h;
    final b = size.height - h;
    canvas
      ..drawPath(Path()..moveTo(h, m)..lineTo(h, h)..lineTo(m, h), paint)
      ..drawPath(Path()..moveTo(w - m + h, h)..lineTo(w, h)..lineTo(w, m), paint)
      ..drawPath(Path()..moveTo(h, b - m + h)..lineTo(h, b)..lineTo(m, b), paint)
      ..drawPath(Path()..moveTo(w - m + h, b)..lineTo(w, b)..lineTo(w, b - m + h), paint);
  }

  @override
  bool shouldRepaint(_CornerMarks oldDelegate) => false;
}

class _PlateWidget extends StatelessWidget {
  const _PlateWidget({
    super.key,
    required this.panel,
    required this.holes,
    required this.scale,
    required this.visuals,
    required this.released,
  });

  final Panel panel;
  final List<Offset> holes;
  final double scale;
  final GameplayVisuals visuals;
  final bool released;

  @override
  Widget build(BuildContext context) {
    final out = visuals.panelOut[panel.id]!;
    final dir = panel.cx < 150 ? -1.0 : 1.0;
    return Positioned(
      left: panel.x * scale,
      top: panel.y * scale,
      width: panel.w * scale,
      height: panel.h * scale,
      child: IgnorePointer(
        ignoring: released,
        child: RepaintBoundary(
          child: AnimatedBuilder(
            animation: Listenable.merge([out, visuals.blocker, visuals.hint, visuals]),
            builder: (context, _) {
              final t = out.value;
              if (t >= 1) return const SizedBox.shrink();
              final mode = visuals.panelMode[panel.id]!;
              var opacity = 1.0;
              var offset = Offset.zero;
              var angle = 0.0;
              var lift = 0.0;
              if (visuals.reducedMotion) {
                opacity = 1 - t;
              } else if (mode == PanelMotion.drop) {
                final ms = t * BpMotion.panelRelease.inMilliseconds;
                final d = BpMotion.drop.transform(t);
                offset = Offset(dir * 28 * d, 420 * d);
                angle = dir * 5 * math.pi / 180 * d;
                opacity = ms < 260 ? 1 : (1 - (ms - 260) / 200).clamp(0.0, 1.0);
                lift = (ms / 120).clamp(0.0, 1.0);
              } else {
                opacity = 1 - t;
                offset = Offset(0, 24 * t);
              }

              Color? outline;
              var outlineOpacity = 0.0;
              if (visuals.blockerPanel == panel.id && visuals.blocker.value > 0) {
                outline = BpColor.blocked;
                outlineOpacity = _blockerOpacity(visuals.blocker.value);
              } else if (visuals.hintPanel == panel.id && visuals.hint.value > 0) {
                outline = BpColor.action;
                outlineOpacity = .5 * hintRingOpacity(visuals.hint.value);
              }
              return Opacity(
                opacity: opacity,
                child: Transform.translate(
                  offset: offset,
                  child: Transform.rotate(
                    angle: angle,
                    child: CustomPaint(
                      size: Size(panel.w * scale, panel.h * scale),
                      painter: PlatePainter(
                        panel: panel,
                        holes: holes,
                        scale: scale,
                        shadowLift: lift,
                        outline: outline,
                        outlineOpacity: outlineOpacity,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  /// Fade in 120 ms, hold, fade out 160 ms ending at 650 ms.
  static double _blockerOpacity(double v) {
    final ms = v * BpMotion.blockerHold.inMilliseconds;
    if (ms < 120) return ms / 120;
    if (ms < 490) return 1;
    return (1 - (ms - 490) / 160).clamp(0.0, 1.0);
  }
}

/// Hint ring opacity over its 1.6 s life (MOTION_SPEC §6).
double hintRingOpacity(double v) {
  final ms = v * BpMotion.hintTotal.inMilliseconds;
  if (ms < 420) return BpMotion.standardOut.transform(ms / 420);
  if (ms < 480) return 1;
  if (ms < 720) return 1 - (ms - 480) / 240;
  if (ms < 960) return (ms - 720) / 240;
  if (ms < 1200) return 1;
  if (ms < 1440) return 1 - (ms - 1200) / 240;
  return 0;
}

class _ScrewWidget extends StatefulWidget {
  const _ScrewWidget({
    super.key,
    required this.screw,
    required this.scale,
    required this.visuals,
    required this.removed,
    required this.onTap,
    required this.semanticLabel,
    this.onPress,
  });

  final Screw screw;
  final double scale;
  final GameplayVisuals visuals;
  final bool removed;
  final ValueChanged<String> onTap;
  final VoidCallback? onPress;
  final String semanticLabel;

  @override
  State<_ScrewWidget> createState() => _ScrewWidgetState();
}

class _ScrewWidgetState extends State<_ScrewWidget> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    final scale = widget.scale;
    final hit = scale > 1 ? BpSize.screwHitLarge : BpSize.screwHit;
    final head = BpSize.screwHead * scale;
    final v = widget.visuals;
    final out = v.screwOut[widget.screw.id]!;
    final shake = v.shake[widget.screw.id]!;
    final ringBox = math.max(hit, BpSize.screwHit * scale);

    return Positioned(
      left: widget.screw.x * scale - ringBox / 2,
      top: widget.screw.y * scale - ringBox / 2,
      width: ringBox,
      height: ringBox,
      child: RepaintBoundary(
        child: AnimatedBuilder(
          animation: Listenable.merge([out, shake, v.hint, v]),
          builder: (context, _) {
            final t = out.value;
            if (t >= 1) return const SizedBox.shrink();
            final ms = t * BpMotion.unscrew.inMilliseconds;
            final reduced = v.reducedMotion;
            final spring = BpMotion.spring.transform(t);
            final opacity = reduced ? 1 - t : (1 - ms / 110).clamp(0.0, 1.0);
            final headScale = reduced ? 1.0 : 1 - .6 * spring;
            final angle = reduced ? 0.0 : -140 * math.pi / 180 * spring;
            final dx = _shakeOffset(shake.value) * scale;
            final showHint = v.hintScrew == widget.screw.id && v.hint.value > 0;

            return Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                if (showHint)
                  IgnorePointer(
                    child: _HintRing(progress: v.hint.value, size: BpSize.screwHit * scale),
                  ),
                IgnorePointer(
                  ignoring: widget.removed,
                  child: Semantics(
                    button: true,
                    label: widget.semanticLabel,
                    child: _CircleHit(
                      diameter: hit,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTapDown: (_) {
                          widget.onPress?.call();
                          setState(() => _down = true);
                        },
                        onTapCancel: () => setState(() => _down = false),
                        onTapUp: (_) => setState(() => _down = false),
                        onTap: () => widget.onTap(widget.screw.id),
                        child: SizedBox.square(
                          dimension: hit,
                          child: Center(
                            child: Opacity(
                              opacity: opacity,
                              child: Transform.translate(
                                offset: Offset(dx, 0),
                                child: Transform.rotate(
                                  angle: angle,
                                  child: AnimatedScale(
                                    scale: _down ? .96 : 1,
                                    duration: BpMotion.tap,
                                    curve: BpMotion.standardOut,
                                    child: Transform.scale(
                                      scale: headScale,
                                      child: CustomPaint(
                                        size: Size.square(head),
                                        painter: ScrewHeadPainter(unit: scale),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// +6, −5, +3, 0 px — 40 ms per step, linear.
  static double _shakeOffset(double v) {
    if (v <= 0 || v >= 1) return 0;
    const keys = [0.0, 6.0, -5.0, 3.0, 0.0];
    final x = v * 4;
    final i = x.floor().clamp(0, 3);
    final f = x - i;
    return keys[i] + (keys[i + 1] - keys[i]) * f;
  }
}

class _HintRing extends StatelessWidget {
  const _HintRing({required this.progress, required this.size});

  final double progress;
  final double size;

  @override
  Widget build(BuildContext context) {
    final ms = progress * BpMotion.hintTotal.inMilliseconds;
    final s = ms < 420 ? 1.7 - .7 * BpMotion.standardOut.transform(ms / 420) : 1.0;
    return Opacity(
      opacity: hintRingOpacity(progress),
      child: Transform.scale(
        scale: s,
        child: CustomPaint(size: Size.square(size), painter: const _HintRingPainter()),
      ),
    );
  }
}

class _HintRingPainter extends CustomPainter {
  const _HintRingPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final unit = size.width / BpSize.screwHit;
    final solid = Paint()
      ..color = BpColor.action
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * unit;
    canvas.drawCircle(c, size.width / 2 - unit, solid);
    final r = size.width / 2 + 6 * unit;
    final dashed = Paint()
      ..color = BpColor.action
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1 * unit;
    const n = 24;
    final rect = Rect.fromCircle(center: c, radius: r);
    for (var i = 0; i < n; i++) {
      canvas.drawArc(rect, i * 2 * math.pi / n, math.pi / n, false, dashed);
    }
  }

  @override
  bool shouldRepaint(_HintRingPainter oldDelegate) => false;
}

/// Accepts pointer hits only inside a centred circle.
class _CircleHit extends SingleChildRenderObjectWidget {
  const _CircleHit({required this.diameter, super.child});

  final double diameter;

  @override
  RenderObject createRenderObject(BuildContext context) => _RenderCircleHit(diameter);

  @override
  void updateRenderObject(BuildContext context, _RenderCircleHit renderObject) {
    renderObject.diameter = diameter;
  }
}

class _RenderCircleHit extends RenderProxyBox {
  _RenderCircleHit(this.diameter);

  double diameter;

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    final c = size.center(Offset.zero);
    if ((position - c).distance > diameter / 2) return false;
    return super.hitTest(result, position: position);
  }
}
