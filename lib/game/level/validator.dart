import '../domain/board.dart';
import '../domain/level.dart';
import '../engine/engine.dart';
import '../engine/solver.dart';
import '../domain/move_result.dart';

/// Radius of the empty hole left on a plate after its screw leaves.
const double kHoleRadius = 8;

/// A blocking overlap must cover at least this much of the screw head
/// (in units) so the player can *see* why it is blocked.
const double kMinVisibleCover = 4;

/// A non-blocking plate edge must clear the screw head by at least this
/// margin, so "touching but free" never happens.
const double kMinClearance = 2;

/// Minimum centre distance between two screws (heads are 26 units wide).
const double kMinScrewSpacing = 30;

/// The PL tag drawn at the top-centre of every plate (level units):
/// ±[kTagHalfWidth] around the centre line, [kTagTop]…[kTagBottom] below the
/// plate's top edge.
const double kTagHalfWidth = 16;
const double kTagTop = 6;
const double kTagBottom = 18;

/// True when a screw head at ([x], [y]) would hide [p]'s PL tag.
bool screwCoversTag(Panel p, double x, double y) {
  final l = p.cx - kTagHalfWidth;
  final r = p.cx + kTagHalfWidth;
  final t = p.y + kTagTop;
  final b = p.y + kTagBottom;
  final nx = x.clamp(l, r);
  final ny = y.clamp(t, b);
  final dx = x - nx;
  final dy = y - ny;
  return dx * dx + dy * dy < kScrewOverlapRadius * kScrewOverlapRadius;
}

const int kMinTray = 2;
const int kMaxTray = 6;

final class ValidationIssue {
  const ValidationIssue(this.levelId, this.code, this.message);
  final int levelId;
  final String code;
  final String message;

  @override
  String toString() => '[level $levelId] $code: $message';
}

/// Enforces the fairness checklist for one level. Returns an empty list when
/// the level may ship.
List<ValidationIssue> validateLevel(Level level) {
  final issues = <ValidationIssue>[];
  void fail(String code, String msg) =>
      issues.add(ValidationIssue(level.id, code, msg));

  // Structure ---------------------------------------------------------------
  final panelIds = <String>{};
  final labels = <String>{};
  for (final p in level.panels) {
    if (!panelIds.add(p.id)) fail('duplicate_panel', 'Panel id ${p.id}');
    if (!labels.add(p.label)) fail('duplicate_label', 'Label ${p.label}');
    if (p.w <= 0 || p.h <= 0) fail('panel_size', '${p.id} has no area');
    if (p.x < 0 ||
        p.y < 0 ||
        p.x + p.w > kBoardUnits ||
        p.y + p.h > kBoardUnits) {
      fail('panel_bounds', '${p.id} leaves the 300×300 play area');
    }
    if (p.depth < 0) fail('panel_depth', '${p.id} has negative depth');
  }
  final screwIds = <String>{};
  for (final s in level.screws) {
    if (!screwIds.add(s.id)) fail('duplicate_screw', 'Screw id ${s.id}');
    if (!panelIds.contains(s.panelId)) {
      fail('screw_panel', '${s.id} references unknown panel ${s.panelId}');
    }
  }
  for (final p in level.panels) {
    if (!level.screws.any((s) => s.panelId == p.id)) {
      fail('empty_panel', '${p.id} has no screws');
    }
  }
  if (level.trayCapacity < kMinTray || level.trayCapacity > kMaxTray) {
    fail('tray_capacity', 'trayCapacity ${level.trayCapacity}');
  }
  if (level.screws.length > Solver.maxScrews ||
      level.panels.length > Solver.maxPanels) {
    fail('too_large', '${level.screws.length} screws');
  }
  if (issues.isNotEmpty) return issues;

  // Geometry & readability --------------------------------------------------
  for (final s in level.screws) {
    final own = level.panelById(s.panelId);
    if (own.visualSignedDistance(s.x, s.y) > -kHoleRadius) {
      fail('screw_off_plate', '${s.id} hole is not fully on ${own.label}');
    }
    // Screws render above every plate at their depth or below, so they
    // must not sit on any of those plates' PL tags.
    for (final p in level.panels) {
      if (p.depth <= own.depth && screwCoversTag(p, s.x, s.y)) {
        fail('tag_covered', '${s.id} hides the ${p.label} tag');
      }
    }
    for (final p in level.panels) {
      if (p.depth == own.depth && p.id != own.id) {
        // Screws render above every plate of their depth: a screw sitting on
        // a sibling plate would look like it belongs to that plate.
        if (p.visualSignedDistance(s.x, s.y) < kScrewOverlapRadius) {
          fail('ambiguous_owner', '${s.id} sits on sibling plate ${p.label}');
        }
        continue;
      }
      if (p.depth <= own.depth) continue;
      final logical = p.distanceTo(s.x, s.y);
      if (logical < kScrewOverlapRadius) {
        final visual = p.visualSignedDistance(s.x, s.y);
        if (visual > kScrewOverlapRadius - kMinVisibleCover) {
          fail(
            'hidden_cover',
            '${s.id} is blocked by ${p.label} but barely looks covered',
          );
        }
      } else if (logical < kScrewOverlapRadius + kMinClearance) {
        fail('near_miss', '${s.id} almost touches ${p.label}');
      }
    }
  }
  for (var i = 0; i < level.screws.length; i++) {
    for (var j = i + 1; j < level.screws.length; j++) {
      final a = level.screws[i];
      final b = level.screws[j];
      final dx = a.x - b.x;
      final dy = a.y - b.y;
      if (dx * dx + dy * dy < kMinScrewSpacing * kMinScrewSpacing) {
        fail('screw_spacing', '${a.id} and ${b.id} overlap');
      }
    }
  }

  // Solvability -------------------------------------------------------------
  final board = Board(level);
  final solver = Solver(board, capacity: level.trayCapacity);
  final solution = solver.solve(const []);
  if (solution == null) {
    fail('unsolvable', 'No solution with tray ${level.trayCapacity}');
  }
  final stated = level.solution;
  if (stated != null) {
    final error = replaySolution(level, stated);
    if (error != null) fail('bad_solution', error);
  }
  return issues;
}

/// Replays [solution] through the real engine; returns an error message or
/// null when it legally wins on its final move.
String? replaySolution(Level level, List<String> solution) {
  final engine = GameEngine(level);
  for (var i = 0; i < solution.length; i++) {
    final result = engine.tap(solution[i]);
    if (result is! ScrewRemoved) {
      return 'Move ${i + 1} (${solution[i]}) rejected: ${result.runtimeType}';
    }
    final last = i == solution.length - 1;
    if ((result.status == GameStatus.won) != last) {
      return 'Won ${last ? 'never' : 'early at move ${i + 1}'}';
    }
  }
  return null;
}
