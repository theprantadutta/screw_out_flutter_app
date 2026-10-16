import 'dart:math' as math;

import '../domain/board.dart';
import '../domain/level.dart';
import '../engine/solver.dart';
import '../level/validator.dart';
import 'rng.dart';

/// What a generated level must look like and how hard it may be.
final class LevelSpec {
  const LevelSpec({
    required this.layers,
    required this.panels,
    required this.screwsPerPanel,
    this.totalScrews = (1, 40),
    this.circleChance = 0,
    this.extraTray = 1,
    this.minTray = 3,
    this.maxTray = 5,
    this.randomWin = (0.0, 1.0),
    this.minTraps = 0,
    this.minBlocked = 0,
    this.mirror = 0.5,
  });

  /// Depth levels (min, max).
  final (int, int) layers;

  /// Total panels (min, max).
  final (int, int) panels;
  final (int, int) screwsPerPanel;
  final (int, int) totalScrews;
  final double circleChance;

  /// Tray = minimum solvable capacity + [extraTray], clamped to
  /// [minTray]..[maxTray].
  final int extraTray;
  final int minTray;
  final int maxTray;

  /// Acceptable band for the chance a random tapper wins (lower = harder).
  final (double, double) randomWin;

  /// Minimum number of opening moves that make the level unwinnable.
  final int minTraps;

  /// Minimum screws blocked at the start.
  final int minBlocked;

  /// Chance of a left/right mirrored (symmetric) layout.
  final double mirror;
}

final class GeneratedLevel {
  const GeneratedLevel(this.level, this.analysis, this.attempts);
  final Level level;
  final SolverAnalysis analysis;
  final int attempts;
}

/// Deterministic level generator: same seed + spec → same level, on every
/// platform. Produces only levels that pass [validateLevel].
final class LevelGenerator {
  const LevelGenerator({this.maxAttempts = 4000, this.stateBudget = 250000});

  final int maxAttempts;

  /// Abort analysis of levels whose reachable state space exceeds this.
  final int stateBudget;

  GeneratedLevel? generate({
    required int seed,
    required LevelSpec spec,
    required int id,
    required String code,
    required int chapter,
    required String title,
    List<String> mechanics = const [],
    String? objective,
  }) {
    final root = SeededRng(seed);
    for (var attempt = 1; attempt <= maxAttempts; attempt++) {
      final rng = root.fork(attempt);
      final shape = _layout(rng, spec);
      if (shape == null) continue;
      final (panels, screws) = shape;
      final draft = Level(
        id: id,
        code: code,
        chapter: chapter,
        title: title,
        trayCapacity: spec.maxTray,
        panels: panels,
        screws: screws,
        mechanics: mechanics,
        objective: objective,
      );
      final board = Board(draft);
      final blocked = [
        for (var s = 0; s < board.screwCount; s++)
          if (board.blockers[s].isNotEmpty) s,
      ];
      if (blocked.length < spec.minBlocked) continue;

      // Smallest tray that still solves it.
      int? cMin;
      for (var c = kMinTray; c <= spec.maxTray; c++) {
        if (Solver(board, capacity: c).isSolvable(const [])) {
          cMin = c;
          break;
        }
      }
      if (cMin == null) continue;
      final capacity = math.min(
        spec.maxTray,
        math.max(spec.minTray, cMin + spec.extraTray),
      );
      final solver = Solver(board, capacity: capacity);
      final analysis = _boundedAnalysis(solver);
      if (analysis == null) continue;
      final (lo, hi) = spec.randomWin;
      if (analysis.randomWinProbability < lo ||
          analysis.randomWinProbability > hi) {
        continue;
      }
      if (analysis.trapFirstMoves < spec.minTraps) continue;

      final level = Level(
        id: id,
        code: code,
        chapter: chapter,
        title: title,
        trayCapacity: capacity,
        panels: panels,
        screws: screws,
        mechanics: mechanics,
        objective: objective,
        solution: solver.solve(const []),
        difficulty: rateDifficulty(analysis, screws.length),
      );
      if (validateLevel(level).isNotEmpty) continue;
      return GeneratedLevel(level, analysis, attempt);
    }
    return null;
  }

  SolverAnalysis? _boundedAnalysis(Solver solver) {
    // Cheap pre-check: count states with a bounded DFS before the full DP.
    final seen = <int>{};
    final stack = <int>[0];
    while (stack.isNotEmpty) {
      final s = stack.removeLast();
      if (!seen.add(s)) continue;
      if (seen.length > stateBudget) return null;
      for (final m in solver.legalMoves(s)) {
        stack.add(s | (1 << m));
      }
    }
    return solver.analyze();
  }

  // ---------------------------------------------------------------- layout

  (List<Panel>, List<Screw>)? _layout(SeededRng rng, LevelSpec spec) {
    final layers = rng.range(spec.layers.$1, spec.layers.$2);
    final panelCount = math.max(layers, rng.range(spec.panels.$1, spec.panels.$2));
    final mirror = rng.chance(spec.mirror);

    // Distribute panels over layers: at least one per layer.
    final perLayer = List.filled(layers, 1);
    for (var i = layers; i < panelCount; i++) {
      perLayer[rng.nextInt(layers)]++;
    }

    final placed = <_P>[];
    for (var depth = 0; depth < layers; depth++) {
      var need = perLayer[depth];
      var guard = 0;
      while (need > 0 && guard++ < 80) {
        final candidates = _proposePanel(rng, spec, depth, layers, mirror);
        if (candidates.isEmpty) continue;
        if (!candidates.every((c) => _fits(c, placed))) continue;
        placed.addAll(candidates);
        need -= candidates.length;
      }
      if (need > 0) return null;
    }
    _centre(placed);

    // Screws, bottom layer first; anchors that break readability are skipped.
    final screwsByPanel = <int, List<(double, double)>>{};
    final all = <(double, double)>[];
    var total = 0;
    final order = List.generate(placed.length, (i) => i);
    for (final i in order) {
      final p = placed[i];
      final anchors = _anchors(p, rng);
      rng.shuffle(anchors);
      final want = rng.range(spec.screwsPerPanel.$1, spec.screwsPerPanel.$2);
      final chosen = <(double, double)>[];
      final twin = p.twin;
      final twinScrews = twin == null ? null : screwsByPanel[placed.indexOf(twin)];
      if (twinScrews != null) {
        // Mirror image of the twin's screws keeps symmetric boards symmetric.
        final mirrored = [for (final t in twinScrews) (kBoardUnits - t.$1, t.$2)];
        if (mirrored.every((a) => _screwOk(a, p, placed, [...all, ...mirrored.where((m) => m != a)]))) {
          chosen.addAll(mirrored);
          all.addAll(mirrored);
        }
      }
      for (final a in anchors) {
        if (chosen.isNotEmpty && twinScrews != null) break;
        if (chosen.length >= want) break;
        if (_screwOk(a, p, placed, all)) {
          chosen.add(a);
          all.add(a);
        }
      }
      if (chosen.isEmpty) return null;
      screwsByPanel[i] = chosen;
      total += chosen.length;
    }
    if (total < spec.totalScrews.$1 || total > spec.totalScrews.$2) return null;
    if (total > Solver.maxScrews) return null;

    // Stable naming: sort by depth (render order), then label PL-01…
    final indices = List.generate(placed.length, (i) => i)
      ..sort((a, b) {
        final d = placed[a].depth.compareTo(placed[b].depth);
        return d != 0 ? d : a.compareTo(b);
      });
    final panels = <Panel>[];
    final screws = <Screw>[];
    for (var n = 0; n < indices.length; n++) {
      final p = placed[indices[n]];
      final id = 'P$n';
      final label = 'PL-${(n + 1).toString().padLeft(2, '0')}';
      final pattern = PlatePattern.values[n % PlatePattern.values.length];
      panels.add(
        p.circle
            ? Panel.circle(
                id: id,
                x: p.x,
                y: p.y,
                d: p.w,
                depth: p.depth,
                pattern: pattern,
                label: label,
              )
            : Panel.rect(
                id: id,
                x: p.x,
                y: p.y,
                w: p.w,
                h: p.h,
                r: p.r,
                depth: p.depth,
                pattern: pattern,
                label: label,
              ),
      );
      final pts = screwsByPanel[indices[n]]!
        ..sort((a, b) => a.$2 != b.$2 ? a.$2.compareTo(b.$2) : a.$1.compareTo(b.$1));
      for (var k = 0; k < pts.length; k++) {
        screws.add(Screw(id: '$id-$k', panelId: id, x: pts[k].$1, y: pts[k].$2));
      }
    }
    return (panels, screws);
  }

  /// Proposes one panel, or a mirrored pair, for [depth].
  List<_P> _proposePanel(
    SeededRng rng,
    LevelSpec spec,
    int depth,
    int layers,
    bool mirror,
  ) {
    // Lower layers are bigger; the top layer is small "keys".
    final t = layers == 1 ? 0.0 : depth / (layers - 1);
    final circle = depth > 0 && rng.chance(spec.circleChance);
    _P p;
    if (circle) {
      final dMax = (176 - 96 * t).round();
      final d = rng.snapped(64, math.max(68, dMax), 4).toDouble();
      final x = rng.snapped(12, (288 - d).round(), 4).toDouble();
      final y = rng.snapped(12, (288 - d).round(), 4).toDouble();
      p = _P(x, y, d, d, d / 2, depth, circle: true);
    } else {
      final wide = rng.chance(0.5);
      final long = rng.snapped((200 - 80 * t).round(), (276 - 60 * t).round(), 4);
      final short = rng.snapped(40, math.max(44, (200 - 130 * t).round()), 4);
      final w = (wide ? long : short).toDouble();
      final h = (wide ? short : long).toDouble();
      final x = rng.snapped(12, (288 - w).round(), 4).toDouble();
      final y = rng.snapped(12, (288 - h).round(), 4).toDouble();
      final r = math.min(math.min(w, h) / 2, depth == 0 ? 28.0 : 18.0);
      p = _P(x, y, w, h, r, depth);
    }
    if (!mirror) return [p];
    final m = p.mirrored();
    // Overlaps its own mirror image: centre it on the axis instead.
    if ((m.x - p.x).abs() < p.w + 8) return [p.centered()];
    m.twin = p;
    return [p, m];
  }

  /// A panel may overlap panels of *other* depths, but never another panel of
  /// its own depth (same-depth overlap makes ownership ambiguous). Upper
  /// panels must sit on something below them.
  bool _fits(_P c, List<_P> placed) {
    var supported = c.depth == 0;
    for (final o in placed) {
      if (o.depth == c.depth) {
        if (_overlap(c, o, gap: 6)) return false;
      } else if (o.depth < c.depth && _overlap(c, o, gap: -12)) {
        supported = true;
      }
    }
    return supported;
  }

  /// Shifts the composition so its bounding box is centred on the sheet
  /// (in 2-unit steps, keeping coordinates whole).
  void _centre(List<_P> placed) {
    var minX = kBoardUnits, minY = kBoardUnits, maxX = 0.0, maxY = 0.0;
    for (final p in placed) {
      minX = math.min(minX, p.x);
      minY = math.min(minY, p.y);
      maxX = math.max(maxX, p.x + p.w);
      maxY = math.max(maxY, p.y + p.h);
    }
    final dx = ((kBoardUnits - maxX - minX) / 4).round() * 2.0;
    final dy = ((kBoardUnits - maxY - minY) / 4).round() * 2.0;
    for (final p in placed) {
      p
        ..x += dx
        ..y += dy;
    }
  }

  bool _overlap(_P a, _P b, {required double gap}) =>
      a.x < b.x + b.w + gap &&
      b.x < a.x + a.w + gap &&
      a.y < b.y + b.h + gap &&
      b.y < a.y + a.h + gap;

  List<(double, double)> _anchors(_P p, SeededRng rng) {
    final out = <(double, double)>[];
    if (p.circle) {
      final cx = p.x + p.w / 2;
      final cy = p.y + p.w / 2;
      out.add((cx, cy));
      final ring = p.w / 2 - 20;
      if (ring >= 26) {
        for (var k = 0; k < 8; k++) {
          final a = k * math.pi / 4;
          out.add(
            (
              (cx + ring * math.cos(a)).roundToDouble(),
              (cy + ring * math.sin(a)).roundToDouble(),
            ),
          );
        }
      }
      return out;
    }
    final inset = math.min(24.0, math.min(p.w, p.h) / 2);
    final xs = <double>{p.x + inset, p.x + p.w - inset, p.x + p.w / 2};
    final ys = <double>{p.y + inset, p.y + p.h - inset, p.y + p.h / 2};
    if (p.w >= 160) {
      xs.addAll([p.x + p.w / 3, p.x + 2 * p.w / 3]);
    }
    if (p.h >= 160) {
      ys.addAll([p.y + p.h / 3, p.y + 2 * p.h / 3]);
    }
    for (final x in xs) {
      for (final y in ys) {
        out.add((x.roundToDouble(), y.roundToDouble()));
      }
    }
    return out;
  }

  bool _screwOk(
    (double, double) a,
    _P own,
    List<_P> placed,
    List<(double, double)> existing,
  ) {
    final (x, y) = a;
    final ownPanel = own.toPanel();
    if (ownPanel.visualSignedDistance(x, y) > -(kHoleRadius + 2)) return false;
    for (final e in existing) {
      final dx = e.$1 - x;
      final dy = e.$2 - y;
      if (dx * dx + dy * dy < (kMinScrewSpacing + 2) * (kMinScrewSpacing + 2)) {
        return false;
      }
    }
    for (final o in placed) {
      if (identical(o, own)) continue;
      final panel = o.toPanel();
      if (o.depth == own.depth) {
        if (panel.visualSignedDistance(x, y) < kScrewOverlapRadius + 2) {
          return false;
        }
        continue;
      }
      if (o.depth < own.depth) continue;
      final logical = panel.distanceTo(x, y);
      if (logical < kScrewOverlapRadius) {
        if (panel.visualSignedDistance(x, y) >
            kScrewOverlapRadius - kMinVisibleCover - 1) {
          return false;
        }
      } else if (logical < kScrewOverlapRadius + kMinClearance + 2) {
        return false;
      }
    }
    return true;
  }
}

/// 1 … 10, from size and how punishing random play is.
int rateDifficulty(SolverAnalysis a, int screws) {
  final risk = 1 - a.randomWinProbability; // 0 … 1
  final size = ((screws - 1) / 23).clamp(0.0, 1.0);
  final traps = a.firstMoves == 0 ? 0.0 : a.trapFirstMoves / a.firstMoves;
  final score = 0.5 * risk + 0.3 * size + 0.2 * traps;
  return (1 + (score * 9).round()).clamp(1, 10);
}

final class _P {
  _P(this.x, this.y, this.w, this.h, this.r, this.depth, {this.circle = false});

  double x;
  double y;
  final double w;
  final double h;
  final double r;
  final int depth;
  final bool circle;

  /// The panel this one mirrors (set on the right-hand copy).
  _P? twin;

  _P mirrored() =>
      _P(kBoardUnits - x - w, y, w, h, r, depth, circle: circle);

  _P centered() =>
      _P(((kBoardUnits - w) / 2).roundToDouble(), y, w, h, r, depth, circle: circle);

  Panel toPanel() => circle
      ? Panel.circle(id: '', x: x, y: y, d: w, depth: depth, label: '')
      : Panel.rect(id: '', x: x, y: y, w: w, h: h, r: r, depth: depth, label: '');
}
