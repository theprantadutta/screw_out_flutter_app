import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:screw_out/l10n/app_localizations.dart';

import 'pseudo_l10n.dart';

/// Stretches every word by 40% (rounded up), keeping digits, symbols,
/// spacing and line breaks: "Settings" -> "SettingsSet", "TRAY" -> "TRAYTR".
/// Words get longer rather than gaining extra words, like real German or
/// Russian, so unbreakable labels are tested too.
String stretch(String s) => s.replaceAllMapped(
  RegExp(r'[A-Za-z]+'),
  (m) {
    final w = m.group(0)!;
    return w + w.substring(0, (w.length * .4).ceil());
  },
);

/// Loads [PseudoLongL10n] for any locale, so the app can be pumped in a
/// right-to-left locale (ar) with stretched English strings.
class PseudoL10nDelegate extends LocalizationsDelegate<AppLocalizations> {
  const PseudoL10nDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<AppLocalizations> load(Locale locale) => SynchronousFuture(PseudoLongL10n(locale.toString()));

  @override
  bool shouldReload(PseudoL10nDelegate old) => false;
}
