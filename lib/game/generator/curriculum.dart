import 'generator.dart';

/// Campaign plan: chapter metadata and the generator spec for every sheet.
///
/// Only `tool/generate_levels.dart` runs this — the app ships the resulting
/// JSON (assets/levels/chNN.json), so editing a spec never silently changes
/// shipped levels. Sheets 1, 12 and 24 are the hand-validated design samples.

final class ChapterInfo {
  const ChapterInfo(this.number, this.name, this.goal, this.newMechanic, this.pitch);
  final int number;
  final String name;

  /// Campaign card caption ("Tap, remove, release").
  final String goal;

  /// Short tag for the map preview ("CIRCLES"); null when none.
  final String? newMechanic;

  /// One line shown on the previous chapter's completion screen.
  final String pitch;
}

const kLevelsPerChapter = 20;
const kBundledChapters = 5;

const kChapters = <ChapterInfo>[
  ChapterInfo(1, 'Workshop Basics', 'Tap, remove, release', null, 'Tap a screw. Drop a plate. That is the whole rule.'),
  ChapterInfo(2, 'Layer by Layer', 'Overlap & reveal order', 'CIRCLES', 'Plates hide plates. Work from the top down.'),
  ChapterInfo(3, 'Make Room', 'Plan around a tight tray', 'TIGHT TRAYS', 'Tighter trays. Plan which screws to pull first.'),
  ChapterInfo(4, 'Interlocking', 'Shared supports', 'SHARED SUPPORTS', 'One plate pins several. Find the key piece.'),
  ChapterInfo(5, 'Master Builder', 'Everything, fairly', 'DEEP STACKS', 'Deep stacks, every idea at once. Take your time.'),
];

/// Info for any chapter, including downloaded ones past the bundled five.
ChapterInfo chapterInfo(int chapter, {String? name, String? goal}) =>
    chapter >= 1 && chapter <= kChapters.length
    ? kChapters[chapter - 1]
    : ChapterInfo(chapter, name ?? 'Drawing Set ${chapter.toString().padLeft(2, '0')}', goal ?? 'Master-level sheets', null, 'More sheets, same fair rules.');

/// Label for a mechanic tag, used for "NEW: …" on the map preview.
const kMechanicLabels = {
  'overlap': 'OVERLAP',
  'tray': 'TRAY',
  'multi_layer': 'LAYERS',
  'circle_panel': 'CIRCLES',
  'trap': 'TRAPS',
  'dependency': 'SUPPORTS',
};

/// Sheets taken verbatim from the design bundle.
const kHandmadeSheets = {1, 12, 24};

final class SheetPlan {
  const SheetPlan(this.spec, {this.mechanics = const [], this.objective});
  final LevelSpec spec;
  final List<String> mechanics;
  final String? objective;
}

/// Plan for sheet [id] (1-based, global).
SheetPlan planFor(int id) {
  final explicit = _chapterOne[id];
  if (explicit != null) return explicit;
  final chapter = (id - 1) ~/ kLevelsPerChapter + 1;
  final k = (id - 1) % kLevelsPerChapter; // 0 … 19
  final ramp = k / (kLevelsPerChapter - 1); // 0 … 1 across the chapter
  final slot = k % 5; // 0 teach · 1–2 practice · 3 breather · 4 challenge
  final objective = _objectives[id];
  return switch (chapter) {
    2 => _layerByLayer(slot, ramp, objective),
    3 => _makeRoom(slot, ramp, objective),
    4 => _interlocking(slot, ramp, objective),
    _ => _masterBuilder(slot, ramp, objective, chapter),
  };
}

const _objectives = <int, String>{
  21: '→ ROUND PLATES COVER LIKE ANY OTHER',
  41: '→ TIGHT TRAY. FREE A PLATE BEFORE IT FILLS',
  61: '→ ONE PLATE CAN HOLD DOWN SEVERAL OTHERS',
  81: '→ EVERYTHING YOU HAVE LEARNED. TAKE YOUR TIME',
};

// Difficulty bands on "chance a random tapper wins" (lower = harder).
(double, double) _band(int slot, double easy, double hard, double ramp) {
  final mid = easy + (hard - easy) * ramp;
  return switch (slot) {
    0 => (mid + 0.15, 1.0), // teach: low pressure
    3 => (0.75, 1.0), // breather
    4 => (0.0, (mid - 0.1).clamp(0.02, 1.0)), // challenge
    _ => ((mid - 0.2).clamp(0.0, 1.0), (mid + 0.2).clamp(0.0, 1.0)),
  };
}

SheetPlan _layerByLayer(int slot, double ramp, String? objective) => SheetPlan(
  LevelSpec(
    layers: slot == 3 ? (2, 3) : (3, 4),
    panels: slot == 3 ? (3, 4) : (4, 5),
    screwsPerPanel: (1, 3),
    totalScrews: (6, 14),
    circleChance: 0.45,
    extraTray: slot == 3 ? 1 : 0,
    minTray: 3,
    maxTray: 4,
    randomWin: _band(slot, 0.6, 0.25, ramp),
    minBlocked: 3,
    minTraps: slot == 4 ? 1 : 0,
  ),
  mechanics: ['overlap', 'multi_layer', 'circle_panel'],
  objective: objective,
);

SheetPlan _makeRoom(int slot, double ramp, String? objective) => SheetPlan(
  LevelSpec(
    layers: (2, 3),
    panels: slot == 3 ? (3, 4) : (4, 6),
    screwsPerPanel: (2, 3),
    totalScrews: (8, 16),
    circleChance: 0.3,
    extraTray: slot == 3 ? 1 : 0,
    minTray: 3,
    maxTray: 4,
    randomWin: _band(slot, 0.4, 0.12, ramp),
    minBlocked: 2,
    minTraps: slot == 4 ? 2 : (slot == 0 || slot == 3 ? 0 : 1),
  ),
  mechanics: ['tray', 'overlap'],
  objective: objective,
);

SheetPlan _interlocking(int slot, double ramp, String? objective) => SheetPlan(
  LevelSpec(
    layers: slot == 3 ? (2, 3) : (3, 4),
    panels: slot == 3 ? (4, 5) : (5, 7),
    screwsPerPanel: (1, 3),
    totalScrews: (10, 18),
    circleChance: 0.4,
    extraTray: slot == 3 ? 1 : 0,
    minTray: 3,
    maxTray: 4,
    randomWin: _band(slot, 0.35, 0.08, ramp),
    minBlocked: 5,
    minTraps: slot == 4 ? 1 : 0,
    mirror: 0.35,
  ),
  mechanics: ['dependency', 'overlap', 'tray'],
  objective: objective,
);

/// Chapter 5 and every downloaded chapter after it.
SheetPlan _masterBuilder(
  int slot,
  double ramp,
  String? objective,
  int chapter,
) {
  // Later chapters keep the master-builder shape but lean harder.
  final extra = ((chapter - 5) * 0.03).clamp(0.0, 0.1);
  return SheetPlan(
    LevelSpec(
      layers: slot == 3 ? (3, 3) : (4, 5),
      panels: slot == 3 ? (4, 5) : (6, 8),
      screwsPerPanel: (2, 3),
      totalScrews: (12, 22),
      circleChance: 0.4,
      extraTray: slot == 3 ? 1 : 0,
      minTray: 3,
      maxTray: 5,
      randomWin: _band(slot, 0.25 - extra, 0.04, ramp),
      minBlocked: 6,
      minTraps: slot == 4 ? 2 : (slot == 0 || slot == 3 ? 0 : 1),
      mirror: 0.4,
    ),
    mechanics: ['multi_layer', 'dependency', 'tray', 'circle_panel'],
    objective: objective,
  );
}

/// Onboarding blueprint (design system §8, first 20 levels).
final _chapterOne = <int, SheetPlan>{
  // 1: handmade "First Turn".
  2: const SheetPlan(
    LevelSpec(layers: (1, 1), panels: (1, 1), screwsPerPanel: (2, 2), minTray: 3, extraTray: 1, mirror: 1),
    mechanics: ['basic_removal'],
  ),
  3: const SheetPlan(
    LevelSpec(layers: (1, 1), panels: (2, 2), screwsPerPanel: (1, 2), minTray: 3, extraTray: 1, mirror: 1),
    mechanics: ['basic_removal'],
  ),
  4: const SheetPlan(
    LevelSpec(layers: (2, 2), panels: (2, 2), screwsPerPanel: (1, 2), minTray: 3, extraTray: 1, minBlocked: 1, randomWin: (1, 1), mirror: 0),
    mechanics: ['overlap'],
    objective: '→ LIFT THE TOP PLATE TO REACH THE SCREW BELOW',
  ),
  5: const SheetPlan(
    LevelSpec(layers: (2, 2), panels: (2, 3), screwsPerPanel: (1, 2), minTray: 3, extraTray: 1, minBlocked: 2, randomWin: (1, 1)),
    mechanics: ['overlap'],
  ),
  6: const SheetPlan(
    LevelSpec(layers: (1, 2), panels: (2, 3), screwsPerPanel: (2, 3), totalScrews: (5, 7), minTray: 3, maxTray: 3, extraTray: 0, randomWin: (0.7, 1)),
    mechanics: ['tray'],
    objective: '→ THE TRAY HOLDS 3. A RELEASED PLATE FREES ITS SLOTS',
  ),
  7: const SheetPlan(
    LevelSpec(layers: (2, 2), panels: (2, 3), screwsPerPanel: (1, 3), totalScrews: (4, 6), minTray: 3, maxTray: 3, extraTray: 0, minBlocked: 1, randomWin: (0.4, 0.85)),
    mechanics: ['tray', 'overlap'],
  ),
  8: const SheetPlan(
    LevelSpec(layers: (2, 2), panels: (3, 3), screwsPerPanel: (1, 3), totalScrews: (6, 8), minTray: 3, maxTray: 3, extraTray: 0, minBlocked: 1, randomWin: (0.35, 0.8)),
    mechanics: ['tray', 'overlap'],
  ),
  9: const SheetPlan(
    LevelSpec(layers: (2, 2), panels: (2, 3), screwsPerPanel: (1, 3), totalScrews: (5, 8), circleChance: 0.6, minTray: 3, maxTray: 4, extraTray: 1, minBlocked: 1, randomWin: (0.6, 1)),
    mechanics: ['overlap'],
  ),
  10: const SheetPlan(
    LevelSpec(layers: (2, 2), panels: (3, 4), screwsPerPanel: (1, 3), totalScrews: (7, 9), minTray: 3, maxTray: 4, extraTray: 0, minBlocked: 2, randomWin: (0.35, 0.8)),
    mechanics: ['overlap', 'tray'],
  ),
  11: const SheetPlan(
    LevelSpec(layers: (3, 3), panels: (3, 3), screwsPerPanel: (1, 2), minTray: 3, maxTray: 4, extraTray: 1, minBlocked: 2, randomWin: (0.7, 1)),
    mechanics: ['multi_layer'],
    objective: '→ THREE LAYERS. WORK FROM THE TOP DOWN',
  ),
  // 12: handmade "Cross Brace".
  13: const SheetPlan(
    LevelSpec(layers: (2, 2), panels: (3, 4), screwsPerPanel: (2, 3), totalScrews: (7, 10), minTray: 3, maxTray: 3, extraTray: 0, minBlocked: 2, randomWin: (0.3, 0.7)),
    mechanics: ['tray'],
  ),
  14: const SheetPlan(
    LevelSpec(layers: (2, 3), panels: (3, 4), screwsPerPanel: (1, 3), totalScrews: (7, 10), minTray: 3, maxTray: 4, extraTray: 0, minBlocked: 2, randomWin: (0.3, 0.7)),
    mechanics: ['overlap', 'tray'],
  ),
  15: const SheetPlan(
    LevelSpec(layers: (2, 2), panels: (3, 4), screwsPerPanel: (1, 3), totalScrews: (6, 9), minTray: 3, maxTray: 4, extraTray: 1, minBlocked: 1, randomWin: (0.8, 1)),
    mechanics: ['overlap'],
  ),
  16: const SheetPlan(
    LevelSpec(layers: (2, 2), panels: (4, 5), screwsPerPanel: (2, 3), totalScrews: (9, 13), minTray: 3, maxTray: 4, extraTray: 1, minBlocked: 2, randomWin: (0.5, 0.9)),
    mechanics: ['overlap', 'tray'],
  ),
  17: const SheetPlan(
    LevelSpec(layers: (2, 3), panels: (3, 4), screwsPerPanel: (1, 3), totalScrews: (7, 11), minTray: 3, maxTray: 4, extraTray: 0, minBlocked: 2, minTraps: 1, randomWin: (0.2, 0.6)),
    mechanics: ['tray', 'trap'],
    objective: '→ ONE TEMPTING MOVE FILLS THE TRAY',
  ),
  18: const SheetPlan(
    LevelSpec(layers: (3, 3), panels: (3, 4), screwsPerPanel: (1, 3), totalScrews: (7, 11), minTray: 3, maxTray: 4, extraTray: 0, minBlocked: 3, randomWin: (0.3, 0.7)),
    mechanics: ['multi_layer'],
  ),
  19: const SheetPlan(
    LevelSpec(layers: (2, 3), panels: (4, 4), screwsPerPanel: (1, 3), totalScrews: (8, 12), minTray: 3, maxTray: 4, extraTray: 0, minBlocked: 2, randomWin: (0.25, 0.6)),
    mechanics: ['overlap', 'tray'],
  ),
  20: const SheetPlan(
    LevelSpec(layers: (3, 3), panels: (5, 6), screwsPerPanel: (1, 3), totalScrews: (10, 14), minTray: 3, maxTray: 4, extraTray: 0, minBlocked: 3, minTraps: 1, randomWin: (0.1, 0.45)),
    mechanics: ['multi_layer', 'tray'],
  ),
};

/// Sheet titles — drafting vocabulary. Index = sheet id − 1; downloaded
/// chapters reuse the list with a roman suffix.
const kSheetTitles = <String>[
  'First Turn', 'Two Point', 'Side by Side', 'Cover Plate', 'Reveal', //
  'Tray Day', 'Small Plan', 'Tight Fit', 'Round Stock', 'Checkpoint',
  'Third Layer', 'Cross Brace', 'Free a Slot', 'Two Ahead', 'Painted Steel',
  'Workbench', 'Tempting', 'Cascade', 'Shop Mix', 'Assembly',
  'Washer Stack', 'Gasket', 'Lens Cap', 'Hidden Bracket', 'Shim Set',
  'Bezel', 'Grommet', 'Breather', 'Flange Ring', 'Porthole',
  'Spacer', 'Collar', 'End Cap', 'Quiet Shift', 'Bulkhead',
  'Inspection Port', 'Faceplate', 'Light Duty', 'Rosette', 'Layer Cake',
  'Make Room', 'Bin Space', 'Overflow', 'Cubby', 'Parts Bin',
  'Short Stock', 'Pigeonhole', 'Easy Out', 'Slot Machine', 'Full House',
  'Backlog', 'Spare Slot', 'Clearance', 'Loose Fit', 'Inventory',
  'Allowance', 'Tolerance', 'Day Off', 'Head Room', 'Storage',
  'Interlock', 'Gusset', 'Keystone', 'Lap Joint', 'Splice Plate',
  'Dovetail', 'Lintel', 'Off Cut', 'Strut', 'Truss',
  'Clevis', 'Yoke', 'Saddle', 'Footing', 'Bracket Pair',
  'Clamp Bar', 'Tie Plate', 'Plain Panel', 'Cantilever', 'Moment Frame',
  'Master Plan', 'Subassembly', 'Exploded View', 'Fit Check', 'Torque Spec',
  'Jig', 'Fixture', 'Calm Bench', 'Gearbox', 'Housing',
  'Chassis', 'Panel Bay', 'Cover Set', 'Easy Torque', 'Engine Mount',
  'Switchgear', 'Control Box', 'Drafting Table', 'Final Inspection', 'Sign Off',
];

String titleFor(int id) {
  final base = kSheetTitles[(id - 1) % kSheetTitles.length];
  final cycle = (id - 1) ~/ kSheetTitles.length;
  return cycle == 0 ? base : '$base ${_roman(cycle + 1)}';
}

String codeFor(int id) => 'DWG ${id.toString().padLeft(3, '0')}';

String _roman(int n) {
  const values = [10, 9, 5, 4, 1];
  const symbols = ['X', 'IX', 'V', 'IV', 'I'];
  var out = '';
  var rest = n;
  for (var i = 0; i < values.length; i++) {
    while (rest >= values[i]) {
      out += symbols[i];
      rest -= values[i];
    }
  }
  return out;
}

/// Deterministic per-sheet seed.
int seedFor(int id) => (id * 2654435761 + 0x5C3E) & 0x7FFFFFFF;
