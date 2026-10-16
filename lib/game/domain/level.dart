/// Pure-Dart level model. No Flutter imports — the engine, solver, validator
/// and level generator all run under plain `dart test` and in `tool/` CLIs.
///
/// Coordinates live in a 300×300 unit play area, origin top-left. Depth 0 is
/// the bottom plate. A screw belongs to exactly one panel and sits at that
/// panel's depth.
library;

import 'dart:math' as math;

/// Width/height of the play area in level units.
const double kBoardUnits = 300;

/// Radius of a screw head used for overlap (blocking) tests, in level units.
const double kScrewOverlapRadius = 13;

enum PanelShape { rect, circle }

/// Plate surface pattern. Plates are told apart by pattern + PL tag, never by
/// colour alone.
enum PlatePattern { solid, hatch45, dots, crosshatch }

final class Panel {
  const Panel.rect({
    required this.id,
    required this.x,
    required this.y,
    required this.w,
    required this.h,
    this.r = 18,
    required this.depth,
    this.pattern = PlatePattern.solid,
    required this.label,
  }) : shape = PanelShape.rect;

  /// A circular plate. [x],[y] is the top-left of its bounding box.
  const Panel.circle({
    required this.id,
    required this.x,
    required this.y,
    required double d,
    required this.depth,
    this.pattern = PlatePattern.solid,
    required this.label,
  }) : shape = PanelShape.circle,
       w = d,
       h = d,
       r = d / 2;

  final String id;
  final PanelShape shape;
  final double x;
  final double y;
  final double w;
  final double h;

  /// Corner radius for rects; radius for circles.
  final double r;
  final int depth;
  final PlatePattern pattern;

  /// Drawing tag, e.g. `PL-03`.
  final String label;

  double get cx => x + w / 2;
  double get cy => y + h / 2;
  bool get isCircle => shape == PanelShape.circle;

  /// Engine rule: does this panel cover a circle of [radius] at ([px],[py])?
  ///
  /// Rect → distance from the point to the nearest point of the (square
  /// cornered) rect < radius. Circle → centre distance < r + radius.
  bool coversCircle(double px, double py, double radius) =>
      distanceTo(px, py) < radius;

  /// Distance from a point to this panel's logical shape (0 when inside).
  /// Rects use their square bounding box, as the rules specify; the level
  /// validator separately rejects screws that sit in a rounded corner where
  /// the visual and logical outlines disagree.
  double distanceTo(double px, double py) {
    if (isCircle) {
      return math.max(0, _hypot(px - cx, py - cy) - r);
    }
    final nx = px.clamp(x, x + w);
    final ny = py.clamp(y, y + h);
    return _hypot(px - nx, py - ny);
  }

  /// Signed distance to the *visual* outline (rounded corners respected):
  /// negative inside (depth of the point inside the shape), positive outside.
  double visualSignedDistance(double px, double py) {
    if (isCircle) return _hypot(px - cx, py - cy) - r;
    final rr = math.min(r, math.min(w, h) / 2);
    final qx = (px - cx).abs() - (w / 2 - rr);
    final qy = (py - cy).abs() - (h / 2 - rr);
    final ox = math.max(qx, 0.0);
    final oy = math.max(qy, 0.0);
    return _hypot(ox, oy) + math.min(math.max(qx, qy), 0.0) - rr;
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'shape': isCircle ? 'circle' : 'rect',
    'x': _num(x),
    'y': _num(y),
    if (isCircle) 'd': _num(w) else ...{'w': _num(w), 'h': _num(h), 'r': _num(r)},
    'depth': depth,
    'pattern': pattern.index,
    'label': label,
  };

  factory Panel.fromJson(Map<String, Object?> j) {
    final shape = j['shape'] as String? ?? 'rect';
    final pattern = PlatePattern.values[(j['pattern'] as num? ?? 0).toInt()];
    if (shape == 'circle') {
      return Panel.circle(
        id: j['id']! as String,
        x: (j['x']! as num).toDouble(),
        y: (j['y']! as num).toDouble(),
        d: (j['d']! as num).toDouble(),
        depth: (j['depth']! as num).toInt(),
        pattern: pattern,
        label: j['label']! as String,
      );
    }
    if (shape != 'rect') throw FormatException('Unknown panel shape "$shape"');
    return Panel.rect(
      id: j['id']! as String,
      x: (j['x']! as num).toDouble(),
      y: (j['y']! as num).toDouble(),
      w: (j['w']! as num).toDouble(),
      h: (j['h']! as num).toDouble(),
      r: (j['r'] as num? ?? 18).toDouble(),
      depth: (j['depth']! as num).toInt(),
      pattern: pattern,
      label: j['label']! as String,
    );
  }
}

final class Screw {
  const Screw({
    required this.id,
    required this.panelId,
    required this.x,
    required this.y,
  });

  final String id;
  final String panelId;
  final double x;
  final double y;

  Map<String, Object?> toJson() => {
    'id': id,
    'panel': panelId,
    'x': _num(x),
    'y': _num(y),
  };

  factory Screw.fromJson(Map<String, Object?> j) => Screw(
    id: j['id']! as String,
    panelId: j['panel']! as String,
    x: (j['x']! as num).toDouble(),
    y: (j['y']! as num).toDouble(),
  );
}

final class Level {
  const Level({
    required this.id,
    required this.code,
    required this.chapter,
    required this.title,
    required this.trayCapacity,
    required this.panels,
    required this.screws,
    this.mechanics = const [],
    this.tutorial,
    this.objective,
    this.solution,
    this.trap,
    this.difficulty,
  });

  /// Global sheet number (1-based). Daily sheets use 900000 + yyyymmdd-ish ids.
  final int id;

  /// Display code, e.g. `DWG 024`.
  final String code;
  final int chapter;
  final String title;
  final int trayCapacity;
  final List<Panel> panels;
  final List<Screw> screws;
  final List<String> mechanics;

  /// First-run tutorial callout (DWG 001 only).
  final String? tutorial;

  /// One-line objective chip shown until the first valid move.
  final String? objective;

  /// A validated solution (screw ids in order). Every solution removes every
  /// screw, so its length is always `screws.length`.
  final List<String>? solution;
  final String? trap;

  /// 1 (trivial) … 10 (hardest), measured by the generator.
  final int? difficulty;

  Panel panelById(String id) => panels.firstWhere((p) => p.id == id);

  Map<String, Object?> toJson() => {
    'id': id,
    'code': code,
    'chapter': chapter,
    'title': title,
    'trayCapacity': trayCapacity,
    'mechanics': mechanics,
    if (tutorial != null) 'tutorial': tutorial,
    if (objective != null) 'objective': objective,
    if (difficulty != null) 'difficulty': difficulty,
    'panels': [for (final p in panels) p.toJson()],
    'screws': [for (final s in screws) s.toJson()],
    if (solution != null) 'solution': solution,
    if (trap != null) 'trap': trap,
  };

  factory Level.fromJson(Map<String, Object?> j) => Level(
    id: (j['id']! as num).toInt(),
    code: j['code']! as String,
    chapter: (j['chapter']! as num).toInt(),
    title: j['title']! as String,
    trayCapacity: (j['trayCapacity']! as num).toInt(),
    mechanics: [for (final m in (j['mechanics'] as List? ?? const [])) m as String],
    tutorial: j['tutorial'] as String?,
    objective: j['objective'] as String?,
    difficulty: (j['difficulty'] as num?)?.toInt(),
    panels: [
      for (final p in j['panels']! as List) Panel.fromJson((p as Map).cast()),
    ],
    screws: [
      for (final s in j['screws']! as List) Screw.fromJson((s as Map).cast()),
    ],
    solution: (j['solution'] as List?)?.cast<String>(),
    trap: j['trap'] as String?,
  );
}

double _hypot(double a, double b) => math.sqrt(a * a + b * b);

/// Keep JSON tidy: whole numbers serialise as ints.
num _num(double v) => v == v.roundToDouble() ? v.toInt() : v;
