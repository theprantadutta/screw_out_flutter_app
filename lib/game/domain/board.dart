import 'level.dart';

/// Static, precomputed geometry of a level: index lookups and, for every
/// screw, the panels that can ever cover it. Blocking never changes for a
/// given level, only which of those panels are released — so the engine and
/// solver never redo geometry at runtime.
final class Board {
  Board(this.level)
    : screwIds = [for (final s in level.screws) s.id],
      panelIds = [for (final p in level.panels) p.id] {
    for (var i = 0; i < screwIds.length; i++) {
      screwIndex[screwIds[i]] = i;
    }
    for (var i = 0; i < panelIds.length; i++) {
      panelIndex[panelIds[i]] = i;
    }
    for (var p = 0; p < panelIds.length; p++) {
      panelScrews.add([]);
    }
    for (var s = 0; s < level.screws.length; s++) {
      final screw = level.screws[s];
      final p = panelIndex[screw.panelId];
      if (p == null) {
        throw FormatException(
          'Screw ${screw.id} references unknown panel ${screw.panelId}',
        );
      }
      screwPanel.add(p);
      panelScrews[p].add(s);
    }
    for (var s = 0; s < level.screws.length; s++) {
      final screw = level.screws[s];
      final depth = level.panels[screwPanel[s]].depth;
      final covering = <int>[
        for (var p = 0; p < level.panels.length; p++)
          if (level.panels[p].depth > depth &&
              level.panels[p].coversCircle(
                screw.x,
                screw.y,
                kScrewOverlapRadius,
              ))
            p,
      ];
      // Topmost first: highest depth, then later in the list (drawn later).
      covering.sort((a, b) {
        final d = level.panels[b].depth.compareTo(level.panels[a].depth);
        return d != 0 ? d : b.compareTo(a);
      });
      blockers.add(covering);
    }
  }

  final Level level;
  final List<String> screwIds;
  final List<String> panelIds;
  final Map<String, int> screwIndex = {};
  final Map<String, int> panelIndex = {};

  /// Panel index owning each screw.
  final List<int> screwPanel = [];

  /// Screw indices held by each panel.
  final List<List<int>> panelScrews = [];

  /// For each screw: panel indices that cover it, topmost first.
  final List<List<int>> blockers = [];

  int get screwCount => screwIds.length;
  int get panelCount => panelIds.length;

  String panelOfScrew(String screwId) =>
      panelIds[screwPanel[screwIndex[screwId]!]];

  List<String> screwsOfPanel(String panelId) => [
    for (final s in panelScrews[panelIndex[panelId]!]) screwIds[s],
  ];

  /// Topmost unreleased panel covering [screwId], or null when it is free.
  String? blockerOf(String screwId, Set<String> released) {
    for (final p in blockers[screwIndex[screwId]!]) {
      final id = panelIds[p];
      if (!released.contains(id)) return id;
    }
    return null;
  }
}
