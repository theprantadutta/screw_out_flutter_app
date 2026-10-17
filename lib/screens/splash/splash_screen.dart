import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/blueprint_tokens.dart';
import '../../l10n/app_localizations.dart';
import '../../presentation/bloc/settings/settings_cubit.dart';
import '../../router/routes.dart';
import '../../widgets/bp/bp_grid.dart';

/// 01 - Splash. ≈ 900 ms: centre lines draw → ring settles → cross turns a
/// quarter in → arc sweeps → wordmark rises → caption. Static 300 ms under
/// reduced motion. Waits for [ready] (bootstrap) before leaving.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.ready, this.autoNavigate = true});

  final Future<void> ready;

  /// Off in golden tests.
  final bool autoNavigate;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
  bool _reduced = false;

  @override
  void initState() {
    super.initState();
    _run();
  }

  Future<void> _run() async {
    await Future<void>.delayed(Duration.zero);
    if (!mounted) return;
    _reduced = (MediaQuery.maybeDisableAnimationsOf(context) ?? false) || context.read<SettingsCubit>().state.reducedMotion;
    final anim = _reduced ? Future<void>.delayed(const Duration(milliseconds: 300)) : _c.forward().orCancel.catchError((_) {});
    if (_reduced) _c.value = 1;
    try {
      await Future.wait([widget.ready, anim]);
    } on Object {
      // Bootstrap failures are surfaced by main; still leave the splash.
    }
    if (!mounted || !widget.autoNavigate) return;
    final settings = context.read<SettingsCubit>().state;
    context.go(settings.tutorialDone ? AppRoutes.home : AppRoutes.playPath(1));
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  /// Progress of [t] (ms) within [from, to].
  double _seg(double ms, double from, double to, [Curve curve = Curves.linear]) =>
      curve.transform(((ms - from) / (to - from)).clamp(0.0, 1.0));

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return BpGridBackground(
      child: LayoutBuilder(
        builder: (context, c) {
          final cx = c.maxWidth / 2;
          final cy = c.maxHeight * .423;
          return AnimatedBuilder(
            animation: _c,
            builder: (context, _) {
              final ms = _c.value * 900;
              final line = _seg(ms, 0, 260, BpMotion.centerLines);
              final ring = _seg(ms, 120, 420, BpMotion.standardOut);
              final cross = _seg(ms, 300, 640, BpMotion.spring);
              final arc = _seg(ms, 380, 800, BpMotion.standardOut);
              final word = _seg(ms, 480, 800, BpMotion.standardOut);
              final cap = _seg(ms, 640, 900);
              return Stack(
                children: [
                  Positioned(
                    left: cx - 150,
                    top: cy - 150,
                    width: 300,
                    height: 300,
                    child: CustomPaint(
                      painter: _MarkPainter(line: line, ring: ring, cross: cross, arc: arc),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    top: cy + 170,
                    child: Opacity(
                      opacity: word,
                      child: Transform.translate(
                        offset: Offset(0, 8 * (1 - word)),
                        child: Column(
                          children: [
                            Text(
                              'Screw Out.',
                              style: BpType.hero.copyWith(fontSize: 58, height: 1, letterSpacing: -2.9, color: BpColor.line),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              l.splashTagline,
                              style: BpType.label.copyWith(
                                fontWeight: FontWeight.w500,
                                fontVariations: BpType.medium,
                                letterSpacing: 2.64,
                                color: BpColor.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 46 + MediaQuery.paddingOf(context).bottom / 2,
                    child: Opacity(
                      opacity: cap,
                      child: Text(
                        l.splashFooter,
                        textAlign: TextAlign.center,
                        style: BpType.caption.copyWith(letterSpacing: 1.4, color: BpColor.lineMuted),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

/// The logomark on drafting centre-lines (300×300 box, centred).
class _MarkPainter extends CustomPainter {
  _MarkPainter({required this.line, required this.ring, required this.cross, required this.arc});

  final double line;
  final double ring;
  final double cross;
  final double arc;

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final dash = Paint()
      ..color = BpColor.lineDefault
      ..strokeWidth = 2;
    // Centre lines: dash 16 / gap 5 / dot 3 / gap 5, growing from the centre.
    void dashed(Offset a, Offset b) {
      final len = (b - a).distance;
      final dir = (b - a) / len;
      const pattern = [16.0, 5.0, 3.0, 5.0];
      var d = 0.0;
      var i = 0;
      while (d < len) {
        final seg = math.min(pattern[i % 4], len - d);
        if (i.isEven) canvas.drawLine(a + dir * d, a + dir * (d + seg), dash);
        d += seg;
        i++;
      }
    }

    final half = 150 * line;
    if (half > 0) {
      dashed(c.translate(-half, 0), c.translate(half, 0));
      dashed(c.translate(0, -half), c.translate(0, half));
    }

    // Yellow arc: 184 dp circle, 12 dp, top quadrant, rotate −70° → 10°.
    if (arc > 0) {
      final rot = (-70 + 80 * arc) * math.pi / 180;
      canvas.drawArc(
        Rect.fromCircle(center: c, radius: 86),
        -3 * math.pi / 4 + rot,
        math.pi / 2,
        false,
        Paint()
          ..color = BpColor.action.withValues(alpha: arc)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 12,
      );
    }

    // Ring: 148 dp, 12 dp stroke, scale .6 → 1.
    if (ring > 0) {
      final s = .6 + .4 * ring;
      canvas.save();
      canvas.translate(c.dx, c.dy);
      canvas.scale(s);
      canvas.drawCircle(Offset.zero, 74, Paint()..color = BpColor.sheet.withValues(alpha: ring));
      canvas.drawCircle(
        Offset.zero,
        68,
        Paint()
          ..color = BpColor.line.withValues(alpha: ring)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 12,
      );
      // Cross: 68 × 16, radius 4, quarter turn in.
      canvas.rotate((-90 + 90 * cross) * math.pi / 180);
      final white = Paint()..color = BpColor.line.withValues(alpha: ring);
      canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset.zero, width: 68, height: 16), const Radius.circular(4)), white);
      canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset.zero, width: 16, height: 68), const Radius.circular(4)), white);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_MarkPainter old) =>
      old.line != line || old.ring != ring || old.cross != cross || old.arc != arc;
}
