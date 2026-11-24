import 'dart:ui';

import 'app_localizations.dart';

/// One language the player can pick in Settings.
final class AppLanguage {
  const AppLanguage(this.code, this.nativeName);

  /// Stored code ([SettingsState.localeCode]): `es`, `pt`, `zh_Hant` ...
  final String code;

  /// Always written in the language itself, never translated.
  final String nativeName;

  Locale get locale => localeFromCode(code)!;
}

/// Every language the app is built to ship, in picker order. Only the ones
/// with a translation (an app_<code>.arb) are offered; see [pickableLanguages].
const kAppLanguages = <AppLanguage>[
  AppLanguage('en', 'English'),
  AppLanguage('es', 'Español'),
  AppLanguage('pt', 'Português (Brasil)'),
  AppLanguage('fr', 'Français'),
  AppLanguage('de', 'Deutsch'),
  AppLanguage('ru', 'Русский'),
  AppLanguage('tr', 'Türkçe'),
  AppLanguage('id', 'Bahasa Indonesia'),
  AppLanguage('hi', 'हिन्दी'),
  AppLanguage('ar', 'العربية'),
  AppLanguage('bn', 'বাংলা'),
  AppLanguage('ja', '日本語'),
  AppLanguage('ko', '한국어'),
  AppLanguage('zh_Hant', '繁體中文'),
];

/// Languages that have a translation in this build.
List<AppLanguage> get pickableLanguages => [
  for (final lang in kAppLanguages)
    if (AppLocalizations.supportedLocales.contains(lang.locale)) lang,
];

/// Parses a stored code. `zh_Hant` (or `zh-Hant`) keeps its script subtag;
/// a 2-letter second part is a country (`pt_BR`). Null/blank = system.
Locale? localeFromCode(String? code) {
  if (code == null || code.trim().isEmpty) return null;
  final parts = code.trim().split(RegExp('[_-]'));
  final language = parts.first.toLowerCase();
  String? script;
  String? country;
  for (final p in parts.skip(1)) {
    if (p.length == 4) {
      script = p[0].toUpperCase() + p.substring(1).toLowerCase();
    } else if (p.isNotEmpty) {
      country = p.toUpperCase();
    }
  }
  return Locale.fromSubtags(languageCode: language, scriptCode: script, countryCode: country);
}

/// Inverse of [localeFromCode]: `zh_Hant`, `pt_BR`, `es`.
String localeToCode(Locale locale) => [
  locale.languageCode,
  ?locale.scriptCode,
  ?locale.countryCode,
].join('_');

/// The supported locale the app shows for a stored [code] (null = follow
/// the device). Same rules as MaterialApp: exact match, then language plus
/// script, then language, else English.
Locale resolveAppLocale(String? code, {List<Locale>? device}) {
  final supported = AppLocalizations.supportedLocales;
  final wanted = [
    ?localeFromCode(code),
    ...(device ?? PlatformDispatcher.instance.locales),
  ];
  for (final w in wanted) {
    final match = _match(w, supported);
    if (match != null) return match;
  }
  return supported.first;
}

Locale? _match(Locale w, List<Locale> supported) {
  // Traditional Chinese is often reported as zh_TW / zh_HK without a script.
  final script = w.scriptCode ??
      (w.languageCode == 'zh' && const {'TW', 'HK', 'MO'}.contains(w.countryCode) ? 'Hant' : null);
  for (final s in supported) {
    if (s.languageCode == w.languageCode && s.scriptCode == script && s.countryCode == w.countryCode) return s;
  }
  for (final s in supported) {
    if (s.languageCode == w.languageCode && s.scriptCode == script && script != null) return s;
  }
  for (final s in supported) {
    if (s.languageCode == w.languageCode && s.scriptCode == null && s.countryCode == null) return s;
  }
  return null;
}

/// Locale name for package:intl (DateFormat). intl has no `zh_Hant` data,
/// so Traditional Chinese uses Taiwan's.
String intlLocaleName(Locale locale) {
  if (locale.languageCode == 'zh' && locale.scriptCode == 'Hant') return 'zh_TW';
  return localeToCode(locale);
}

/// MaterialApp.localeResolutionCallback that applies [resolveAppLocale]'s
/// rules to the device list (maps zh_TW to Traditional Chinese).
Locale appLocaleResolution(List<Locale>? device, Iterable<Locale> _) =>
    resolveAppLocale(null, device: device ?? const []);
