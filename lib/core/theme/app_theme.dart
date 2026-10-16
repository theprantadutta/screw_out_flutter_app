import 'package:flutter/material.dart';

import 'blueprint_tokens.dart';

/// Material theme shell. Screens are built from Blueprint widgets; this only
/// sets defaults so stray Material widgets match (square, no splash).
ThemeData buildAppTheme() => ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: BpColor.sheet,
  canvasColor: BpColor.sheet,
  colorScheme: const ColorScheme.dark(
    primary: BpColor.action,
    onPrimary: BpColor.ink,
    secondary: BpColor.action,
    surface: BpColor.card,
    onSurface: BpColor.line,
    error: BpColor.blocked,
  ),
  fontFamily: BpType.display,
  splashFactory: NoSplash.splashFactory,
  highlightColor: BpColor.transparent,
  splashColor: BpColor.transparent,
  textSelectionTheme: const TextSelectionThemeData(cursorColor: BpColor.action),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: BpColor.card,
    contentTextStyle: BpType.monoBody.copyWith(color: BpColor.line),
    shape: const RoundedRectangleBorder(side: BorderSide(color: BpColor.lineDefault, width: BpSize.stroke)),
    behavior: SnackBarBehavior.floating,
  ),
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: {
      TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
      TargetPlatform.iOS: FadeForwardsPageTransitionsBuilder(),
    },
  ),
);
