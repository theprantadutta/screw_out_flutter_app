import 'dart:ui';

import '../core/theme/blueprint_tokens.dart';

/// Cosmetic board themes. Purely visual - never changes rules, never makes
/// screws harder to see. Blueprint is the only fully-specced theme; the
/// others recolour plates and screws on the same blueprint sheet.
final class BoardTheme {
  const BoardTheme({
    required this.id,
    required this.name,
    required this.swatchBackground,
    required this.plates,
    required this.screwFill,
    required this.screwLine,
    this.price,
    this.chapter,
    this.storeProductId,
  });

  final String id;
  final String name;

  /// Theme card swatch background (screen 14).
  final Color swatchBackground;

  /// Four plate fills, PL-01 … PL-04 (pattern + tag still distinguish them).
  final List<Color> plates;
  final Color screwFill;
  final Color screwLine;

  /// Coin price; null = not sold for coins.
  final int? price;

  /// Unlocked for free by completing this chapter.
  final int? chapter;

  /// Store product that unlocks it (theme packs).
  final String? storeProductId;
}

abstract final class Cosmetics {
  static const defaultTheme = 'blueprint';

  static const themes = <BoardTheme>[
    BoardTheme(
      id: 'blueprint',
      name: 'Clean Blueprint',
      swatchBackground: BpThemePalette.blueprintBg,
      plates: BpThemePalette.blueprintPlates,
      screwFill: BpThemePalette.blueprintScrew,
      screwLine: BpThemePalette.blueprintLine,
    ),
    BoardTheme(
      id: 'walnut',
      name: 'Walnut Workshop',
      swatchBackground: BpThemePalette.walnutBg,
      plates: BpThemePalette.walnutPlates,
      screwFill: BpThemePalette.walnutScrew,
      screwLine: BpThemePalette.walnutLine,
      price: 300,
      chapter: 1,
      storeProductId: 'theme_pack_workshop',
    ),
    BoardTheme(
      id: 'ocean',
      name: 'Ocean Teal',
      swatchBackground: BpThemePalette.oceanBg,
      plates: BpThemePalette.oceanPlates,
      screwFill: BpThemePalette.oceanScrew,
      screwLine: BpThemePalette.oceanLine,
      price: 400,
      chapter: 2,
      storeProductId: 'theme_pack_ocean',
    ),
    BoardTheme(
      id: 'copper',
      name: 'Warm Copper',
      swatchBackground: BpThemePalette.copperBg,
      plates: BpThemePalette.copperPlates,
      screwFill: BpThemePalette.copperScrew,
      screwLine: BpThemePalette.copperLine,
      price: 600,
      chapter: 3,
    ),
    BoardTheme(
      id: 'midnight',
      name: 'Midnight Workshop',
      swatchBackground: BpThemePalette.midnightBg,
      plates: BpThemePalette.midnightPlates,
      screwFill: BpThemePalette.midnightScrew,
      screwLine: BpThemePalette.midnightLine,
      price: 800,
      chapter: 4,
      storeProductId: 'theme_pack_midnight',
    ),
    BoardTheme(
      id: 'pastel',
      name: 'Pastel Studio',
      swatchBackground: BpThemePalette.pastelBg,
      plates: BpThemePalette.pastelPlates,
      screwFill: BpThemePalette.pastelScrew,
      screwLine: BpThemePalette.pastelLine,
      price: 600,
      chapter: 5,
    ),
  ];

  static BoardTheme? byId(String id) {
    for (final t in themes) {
      if (t.id == id) return t;
    }
    return null;
  }

  static BoardTheme get blueprint => themes.first;

  static BoardTheme resolve(String id) => byId(id) ?? themes.first;

  static String? chapterReward(int chapter) {
    for (final t in themes) {
      if (t.chapter == chapter) return t.id;
    }
    return null;
  }

  /// Themes a store product unlocks (`themes_bundle` = every paid theme).
  static List<String> themesForProduct(String productId) {
    if (productId == 'themes_bundle') {
      return [for (final t in themes) if (t.id != defaultTheme) t.id];
    }
    return [for (final t in themes) if (t.storeProductId == productId) t.id];
  }
}
