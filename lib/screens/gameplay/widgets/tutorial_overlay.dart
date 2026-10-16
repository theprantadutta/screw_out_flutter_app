import 'dart:async';

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/theme/blueprint_tokens.dart';
import '../../../game/presentation/gameplay_visuals.dart';
import '../../../l10n/app_localizations.dart';

/// 03 — First-run coach mark on DWG 001: a 68 dp spotlight in a 72% scrim
/// around the screw, pulsing yellow ring, leader line to the STEP 1 callout,
/// a nudging finger, "↓ IT LANDS IN THE TRAY" and SKIP TUTORIAL.
/// Only the spotlight lets taps through to the board.
class TutorialOverlay extends StatefulWidget {
  const TutorialOverlay({
    super.key,
    required this.visuals,
    required this.screwId,
    required this.onSkip,
    required this.reducedMotion,
  });

  final GameplayVisuals visuals;
  final String screwId;
  final VoidCallback onSkip;
  final bool reducedMotion;

  @override
  State<TutorialOverlay> createState() => _TutorialOverlayState();
}

class _TutorialOverlayState extends State<TutorialOverlay> with TickerProviderStateMixin {
  static const _hole = 68.0;
  late final AnimationController _pulse = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
  late final AnimationController _finger = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
  Timer? _pulseTimer;
  Offset? _center;
  double? _trayTop;

  @override
  void initState() {
    super.initState();
    if (!widget.reducedMotion) {
      _pulse.forward();
      _pulseTimer = Timer.periodic(const Duration(milliseconds: 1100), (_) => _pulse.forward(from: 0));
      _finger.repeat(reverse: true);
    }
    WidgetsBinding.instance.addPostFrameCallback(_measure);
  }

  void _measure(Duration _) {
    if (!mounted) return;
    final box = context.findRenderObject() as RenderBox?;
    final hole = widget.visuals.holeGlobal(widget.screwId);
    final slot = widget.visuals.slotGlobal(0);
    if (box == null || !box.hasSize || hole == null) {
      WidgetsBinding.instance.addPostFrameCallback(_measure);
      return;
    }
    final c = box.globalToLocal(hole);
    final t = slot == null ? null : box.globalToLocal(slot).dy - 21 - 30;
    if (c != _center || t != _trayTop) {
      setState(() {
        _center = c;
        _trayTop = t;
      });
    }
    // Board entry animates scale; re-measure until it settles.
    if (widget.visuals.boardIn.isAnimating) WidgetsBinding.instance.addPostFrameCallback(_measure);
  }

  @override
  void dispose() {
    _pulseTimer?.cancel();
    _pulse.dispose();
    _finger.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final c = _center;
    final callout = BpType.monoButtonBold.copyWith(fontSize: 12, letterSpacing: .96, color: BpColor.ink);
    return Stack(
      children: [
        Positioned.fill(child: _Spotlight(center: c, radius: _hole / 2)),
        if (c != null) ...[
          // Pulse ring.
          Positioned(
            left: c.dx - _hole / 2,
            top: c.dy - _hole / 2,
            width: _hole,
            height: _hole,
            child: IgnorePointer(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Positioned.fill(child: _Ring()),
                  if (!widget.reducedMotion)
                    Positioned.fill(
                      child: AnimatedBuilder(
                        animation: _pulse,
                        builder: (context, child) {
                          final t = Curves.easeOut.transform(_pulse.value);
                          return Opacity(
                            opacity: (.9 * (1 - t)).clamp(0.0, 1.0),
                            child: Transform.scale(scale: 1 + .35 * t, child: child),
                          );
                        },
                        child: const _Ring(),
                      ),
                    ),
                ],
              ),
            ),
          ),
          // Leader line + callout.
          Positioned(
            left: c.dx - 1,
            top: c.dy - _hole / 2 - 70,
            width: 2,
            height: 70,
            child: const IgnorePointer(child: ColoredBox(color: BpColor.action)),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: c.dy - _hole / 2 - 70 - 46,
            child: IgnorePointer(
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: const BoxDecoration(
                    color: BpColor.action,
                    boxShadow: [BoxShadow(color: BpColor.ink, offset: Offset(3, 3))],
                  ),
                  child: Text(l.tutorialStep1, style: callout),
                ),
              ),
            ),
          ),
          // Finger nudge.
          Positioned(
            left: c.dx + 16,
            top: c.dy + 12,
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _finger,
                builder: (context, child) {
                  final t = Curves.easeInOut.transform(_finger.value);
                  return Transform.translate(offset: Offset(6 * t, 8 * t), child: child);
                },
                child: const Icon(Symbols.touch_app_sharp, size: 54, fill: 1, color: BpColor.line),
              ),
            ),
          ),
        ],
        if (_trayTop != null)
          Positioned(
            left: 0,
            right: 0,
            top: _trayTop! - 8,
            child: IgnorePointer(
              child: Text(
                l.tutorialLands,
                textAlign: TextAlign.center,
                style: BpType.label.copyWith(letterSpacing: 1.1, color: BpColor.line.withValues(alpha: .9)),
              ),
            ),
          ),
        Positioned(
          left: 0,
          right: 0,
          bottom: MediaQuery.paddingOf(context).bottom + 20,
          child: Center(
            child: Semantics(
              button: true,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: widget.onSkip,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Text(l.skipTutorial, style: BpType.label.copyWith(letterSpacing: 1.32, color: BpColor.lineMuted)),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Ring extends StatelessWidget {
  const _Ring();

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(color: BpColor.action, width: 2),
    ),
  );
}

/// 72% scrim with a circular hole. Absorbs every tap except inside the hole.
class _Spotlight extends LeafRenderObjectWidget {
  const _Spotlight({required this.center, required this.radius});

  final Offset? center;
  final double radius;

  @override
  RenderObject createRenderObject(BuildContext context) => _RenderSpotlight(center, radius);

  @override
  void updateRenderObject(BuildContext context, _RenderSpotlight r) {
    r
      ..center = center
      ..radius = radius;
  }
}

class _RenderSpotlight extends RenderBox {
  _RenderSpotlight(this._center, this._radius);

  Offset? _center;
  double _radius;

  set center(Offset? v) {
    if (v == _center) return;
    _center = v;
    markNeedsPaint();
  }

  set radius(double v) {
    if (v == _radius) return;
    _radius = v;
    markNeedsPaint();
  }

  @override
  bool get sizedByParent => true;

  @override
  Size computeDryLayout(BoxConstraints constraints) => constraints.biggest;

  @override
  bool hitTestSelf(Offset position) {
    final c = _center;
    if (c == null) return true;
    return (position - c).distance > _radius;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final rect = offset & size;
    final path = Path()..addRect(rect);
    final c = _center;
    if (c != null) {
      path
        ..addOval(Rect.fromCircle(center: offset + c, radius: _radius))
        ..fillType = PathFillType.evenOdd;
    }
    context.canvas.drawPath(path, Paint()..color = BpColor.spotlight);
  }
}
