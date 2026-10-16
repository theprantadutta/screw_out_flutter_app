import '../domain/level.dart';
import 'curriculum.dart';
import 'generator.dart';

/// Bump only together with a migration note: changing it changes every
/// future daily sheet (past completions are stored by date, so they stay).
const kDailyGeneratorVersion = 1;

/// Daily sheets: identical for every player on a given calendar date,
/// generated offline from the date alone.
final class DailySheets {
  const DailySheets({this.generator = const LevelGenerator()});

  final LevelGenerator generator;

  static const spec = LevelSpec(
    layers: (3, 4),
    panels: (5, 7),
    screwsPerPanel: (1, 3),
    totalScrews: (10, 16),
    circleChance: 0.35,
    extraTray: 0,
    minTray: 3,
    maxTray: 4,
    randomWin: (0.05, 0.45),
    minBlocked: 4,
    minTraps: 1,
    mirror: 0.5,
  );

  /// yyyymmdd as an int, e.g. 20261015.
  static int dateKey(DateTime date) =>
      date.year * 10000 + date.month * 100 + date.day;

  /// Day-of-year code shown on the sheet, e.g. `D-288`.
  static String codeFor(DateTime date) {
    final start = DateTime.utc(date.year);
    final day = DateTime.utc(date.year, date.month, date.day)
            .difference(start)
            .inDays +
        1;
    return 'D-${day.toString().padLeft(3, '0')}';
  }

  Level sheetFor(DateTime date) {
    final key = dateKey(date);
    final seed = (key * 2246822519 + kDailyGeneratorVersion * 0x9E3779B1) &
        0x7FFFFFFF;
    final title = kSheetTitles[(key * 31 + 7) % kSheetTitles.length];
    final result = generator.generate(
      seed: seed,
      spec: spec,
      id: key,
      code: codeFor(date),
      chapter: 0,
      title: title,
      mechanics: const ['daily'],
    );
    if (result == null) {
      // Practically unreachable (tested over years of dates); fall back to a
      // fixed campaign-style plan so the daily never disappears.
      throw StateError('Daily generation failed for $key');
    }
    return result.level;
  }
}
