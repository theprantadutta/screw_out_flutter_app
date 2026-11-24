import 'package:material_ui/material_ui.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../core/theme/blueprint_tokens.dart';
import '../../l10n/app_locales.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/bp/bp_buttons.dart';
import '../../widgets/bp/bp_sheet.dart';

/// Result of [pickLanguage]: [code] null = follow the device.
typedef LanguageChoice = ({String? code});

/// Language picker sheet. Resolves to the chosen language, or null when
/// dismissed without a choice.
Future<LanguageChoice?> pickLanguage(BuildContext context, {required String? current}) =>
    showModalBottomSheet<LanguageChoice>(
      context: context,
      backgroundColor: BpColor.transparent,
      barrierColor: BpColor.scrim,
      elevation: 0,
      isScrollControlled: true,
      builder: (context) => LanguageSheet(current: current),
    );

/// Native name of the stored language [code], or null for "system default"
/// (and for codes this build doesn't know).
String? languageNativeName(String? code) {
  final locale = localeFromCode(code);
  if (locale == null) return null;
  for (final lang in kAppLanguages) {
    if (lang.locale == locale) return lang.nativeName;
  }
  return null;
}

class LanguageSheet extends StatelessWidget {
  const LanguageSheet({super.key, required this.current});

  /// Stored code of the current choice; null = system default.
  final String? current;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final currentLocale = localeFromCode(current);
    final options = <(String?, String)>[
      (null, l.languageSystemDefault),
      for (final lang in pickableLanguages) (lang.code, lang.nativeName),
    ];
    final maxListHeight = MediaQuery.sizeOf(context).height * .6;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(BpSize.sheetInset, 0, BpSize.sheetInset, 14),
        child: BpSheetCard(
          children: [
            Text(l.language, style: BpType.stuckTitle.copyWith(color: BpColor.line)),
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: maxListHeight),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var i = 0; i < options.length; i++)
                      _LanguageRow(
                        label: options[i].$2,
                        selected: options[i].$1 == null ? currentLocale == null : localeFromCode(options[i].$1) == currentLocale,
                        last: i == options.length - 1,
                        onTap: () => Navigator.of(context).pop((code: options[i].$1)),
                      ),
                  ],
                ),
              ),
            ),
            BpOutlineButton(
              height: 46,
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l.close, style: BpType.monoSmallButton),
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageRow extends StatelessWidget {
  const _LanguageRow({required this.label, required this.selected, required this.onTap, this.last = false});

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool last;

  static const _divider = BorderSide(color: BpColor.divider);

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    selected: selected,
    child: GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        bpUiTick?.call();
        onTap();
      },
      child: Container(
        constraints: const BoxConstraints(minHeight: 48),
        decoration: BoxDecoration(border: Border(top: _divider, bottom: last ? _divider : BorderSide.none)),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: BpType.body.copyWith(color: selected ? BpColor.action : BpColor.line),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (selected) const Icon(Symbols.check_sharp, size: 20, weight: 700, color: BpColor.action),
          ],
        ),
      ),
    ),
  );
}
