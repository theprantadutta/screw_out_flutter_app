import '../game/domain/level.dart';
import '../game/generator/curriculum.dart';
import '../services/cosmetics.dart';
import 'app_localizations.dart';

/// Player-visible game content (sheet titles, objectives, chapter text,
/// mechanic tags, theme names) resolved through [AppLocalizations].
///
/// Data files keep their English text and stable ids (level JSON, the
/// curriculum, [Cosmetics]); the UI never shows that text directly but asks
/// this extension, which maps the id to an ARB key:
///
/// * sheet titles: index in [kSheetTitles] -> `sheetTitle001` ... `sheetTitle100`
///   (daily sheets draw from the same list; downloaded packs fall back to
///   their own text),
/// * objectives: sheet id -> `sheetObjectiveNNN`,
/// * chapters 1-5: `chapterNameN`, `chapterGoalN`, `chapterPitchN`,
/// * mechanic tags and theme ids: one key each.
extension ContentL10n on AppLocalizations {
  /// Display title of [level].
  String levelTitle(Level level) => sheetTitle(level.title);

  /// Localised form of an English sheet title from the curriculum, keeping a
  /// roman cycle suffix ("Gasket II"). Unknown titles are returned as is.
  String sheetTitle(String title) {
    final index = kSheetTitles.indexOf(title);
    if (index >= 0) return _sheetTitleAt(index);
    final numbered = RegExp(r'^Sheet (\d+)$').firstMatch(title);
    if (numbered != null) return sheetTitleNumbered(int.parse(numbered.group(1)!));
    final cycle = RegExp(r'^(.+) ([IVX]+)$').firstMatch(title);
    if (cycle != null) {
      final base = kSheetTitles.indexOf(cycle.group(1)!);
      if (base >= 0) return '${_sheetTitleAt(base)} ${cycle.group(2)}';
    }
    return title;
  }

  /// Objective chip text for [level] (without the leading arrow), or null.
  String? levelObjective(Level level) {
    final raw = level.objective;
    if (raw == null) return null;
    return _objectiveFor(level.id) ?? raw.replaceFirst(RegExp(r'^\s*[→←]\s*'), '');
  }

  String chapterName(int chapter, {String? packName}) => switch (chapter) {
    1 => chapterName1,
    2 => chapterName2,
    3 => chapterName3,
    4 => chapterName4,
    5 => chapterName5,
    _ => packName == null || packName == chapterInfo(chapter).name
        ? chapterNameDrawingSet(chapter.toString().padLeft(2, '0'))
        : packName,
  };

  String chapterGoal(int chapter, {String? packGoal}) => switch (chapter) {
    1 => chapterGoal1,
    2 => chapterGoal2,
    3 => chapterGoal3,
    4 => chapterGoal4,
    5 => chapterGoal5,
    _ => packGoal == null || packGoal == chapterInfo(chapter).goal ? chapterGoalDownloaded : packGoal,
  };

  String chapterPitch(int chapter) => switch (chapter) {
    1 => chapterPitch1,
    2 => chapterPitch2,
    3 => chapterPitch3,
    4 => chapterPitch4,
    5 => chapterPitch5,
    _ => chapterPitchDownloaded,
  };

  /// Tag for a mechanic id from [kMechanicLabels], or null if unknown.
  String? mechanicLabel(String mechanic) => switch (mechanic) {
    'overlap' => mechanicOverlap,
    'tray' => mechanicTray,
    'multi_layer' => mechanicLayers,
    'circle_panel' => mechanicCircles,
    'trap' => mechanicTraps,
    'dependency' => mechanicSupports,
    _ => null,
  };

  String themeName(BoardTheme theme) => switch (theme.id) {
    'blueprint' => themeNameBlueprint,
    'walnut' => themeNameWalnut,
    'ocean' => themeNameOcean,
    'copper' => themeNameCopper,
    'midnight' => themeNameMidnight,
    'pastel' => themeNamePastel,
    _ => theme.name,
  };

  String? _objectiveFor(int id) => switch (id) {
    4 => sheetObjective004,
    6 => sheetObjective006,
    11 => sheetObjective011,
    12 => sheetObjective012,
    17 => sheetObjective017,
    21 => sheetObjective021,
    24 => sheetObjective024,
    41 => sheetObjective041,
    61 => sheetObjective061,
    81 => sheetObjective081,
    _ => null,
  };

  String _sheetTitleAt(int index) => switch (index) {
    0 => sheetTitle001,
    1 => sheetTitle002,
    2 => sheetTitle003,
    3 => sheetTitle004,
    4 => sheetTitle005,
    5 => sheetTitle006,
    6 => sheetTitle007,
    7 => sheetTitle008,
    8 => sheetTitle009,
    9 => sheetTitle010,
    10 => sheetTitle011,
    11 => sheetTitle012,
    12 => sheetTitle013,
    13 => sheetTitle014,
    14 => sheetTitle015,
    15 => sheetTitle016,
    16 => sheetTitle017,
    17 => sheetTitle018,
    18 => sheetTitle019,
    19 => sheetTitle020,
    20 => sheetTitle021,
    21 => sheetTitle022,
    22 => sheetTitle023,
    23 => sheetTitle024,
    24 => sheetTitle025,
    25 => sheetTitle026,
    26 => sheetTitle027,
    27 => sheetTitle028,
    28 => sheetTitle029,
    29 => sheetTitle030,
    30 => sheetTitle031,
    31 => sheetTitle032,
    32 => sheetTitle033,
    33 => sheetTitle034,
    34 => sheetTitle035,
    35 => sheetTitle036,
    36 => sheetTitle037,
    37 => sheetTitle038,
    38 => sheetTitle039,
    39 => sheetTitle040,
    40 => sheetTitle041,
    41 => sheetTitle042,
    42 => sheetTitle043,
    43 => sheetTitle044,
    44 => sheetTitle045,
    45 => sheetTitle046,
    46 => sheetTitle047,
    47 => sheetTitle048,
    48 => sheetTitle049,
    49 => sheetTitle050,
    50 => sheetTitle051,
    51 => sheetTitle052,
    52 => sheetTitle053,
    53 => sheetTitle054,
    54 => sheetTitle055,
    55 => sheetTitle056,
    56 => sheetTitle057,
    57 => sheetTitle058,
    58 => sheetTitle059,
    59 => sheetTitle060,
    60 => sheetTitle061,
    61 => sheetTitle062,
    62 => sheetTitle063,
    63 => sheetTitle064,
    64 => sheetTitle065,
    65 => sheetTitle066,
    66 => sheetTitle067,
    67 => sheetTitle068,
    68 => sheetTitle069,
    69 => sheetTitle070,
    70 => sheetTitle071,
    71 => sheetTitle072,
    72 => sheetTitle073,
    73 => sheetTitle074,
    74 => sheetTitle075,
    75 => sheetTitle076,
    76 => sheetTitle077,
    77 => sheetTitle078,
    78 => sheetTitle079,
    79 => sheetTitle080,
    80 => sheetTitle081,
    81 => sheetTitle082,
    82 => sheetTitle083,
    83 => sheetTitle084,
    84 => sheetTitle085,
    85 => sheetTitle086,
    86 => sheetTitle087,
    87 => sheetTitle088,
    88 => sheetTitle089,
    89 => sheetTitle090,
    90 => sheetTitle091,
    91 => sheetTitle092,
    92 => sheetTitle093,
    93 => sheetTitle094,
    94 => sheetTitle095,
    95 => sheetTitle096,
    96 => sheetTitle097,
    97 => sheetTitle098,
    98 => sheetTitle099,
    99 => sheetTitle100,
    _ => kSheetTitles[index],
  };
}
