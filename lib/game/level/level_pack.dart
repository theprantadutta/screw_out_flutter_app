import '../domain/level.dart';

/// One chapter's worth of sheets — the unit bundled in assets and served by
/// the API for chapters beyond the bundled five.
final class LevelPack {
  const LevelPack({
    required this.chapter,
    required this.name,
    required this.goal,
    required this.levels,
    this.newMechanic,
    this.version = 1,
  });

  final int chapter;
  final String name;
  final String goal;
  final String? newMechanic;
  final int version;
  final List<Level> levels;

  int get firstLevel => levels.first.id;
  int get lastLevel => levels.last.id;

  Map<String, Object?> toJson() => {
    'chapter': chapter,
    'name': name,
    'goal': goal,
    if (newMechanic != null) 'newMechanic': newMechanic,
    'version': version,
    'levels': [for (final l in levels) l.toJson()],
  };

  factory LevelPack.fromJson(Map<String, Object?> j) => LevelPack(
    chapter: (j['chapter']! as num).toInt(),
    name: j['name']! as String,
    goal: j['goal']! as String,
    newMechanic: j['newMechanic'] as String?,
    version: (j['version'] as num? ?? 1).toInt(),
    levels: [
      for (final l in j['levels']! as List) Level.fromJson((l as Map).cast()),
    ],
  );
}
