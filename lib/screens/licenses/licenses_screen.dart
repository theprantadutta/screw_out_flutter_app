import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../core/theme/blueprint_tokens.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/bp/bp_screen.dart';

/// Registers the bundled OFL font licences (Space Grotesk, JetBrains Mono)
/// with Flutter's licence registry. Call once from main.
void registerFontLicenses() {
  LicenseRegistry.addLicense(() async* {
    for (final (pkg, file) in const [
      ('Space Grotesk', 'assets/legal/OFL-SpaceGrotesk.txt'),
      ('JetBrains Mono', 'assets/legal/OFL-JetBrainsMono.txt'),
    ]) {
      yield LicenseEntryWithLineBreaks([pkg], await rootBundle.loadString(file));
    }
  });
}

/// Licenses & credits, in Blueprint style: one expandable row per package.
class LicensesScreen extends StatefulWidget {
  const LicensesScreen({super.key});

  @override
  State<LicensesScreen> createState() => _LicensesScreenState();
}

class _LicensesScreenState extends State<LicensesScreen> {
  late final Future<Map<String, List<LicenseEntry>>> _entries = _load();
  String? _open;

  static Future<Map<String, List<LicenseEntry>>> _load() async {
    final out = <String, List<LicenseEntry>>{};
    await for (final e in LicenseRegistry.licenses) {
      for (final p in e.packages) {
        (out[p] ??= []).add(e);
      }
    }
    return Map.fromEntries(out.entries.toList()..sort((a, b) => a.key.toLowerCase().compareTo(b.key.toLowerCase())));
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return BpScreenScaffold(
      caption: l.licensesCaption,
      title: l.licensesTitle,
      body: FutureBuilder(
        future: _entries,
        builder: (context, snap) {
          final data = snap.data;
          if (data == null) return const SizedBox.shrink();
          final keys = data.keys.toList();
          return ListView.builder(
            padding: EdgeInsets.fromLTRB(BpSpace.screen, 16, BpSpace.screen, bpBottom(context)),
            itemCount: keys.length,
            itemBuilder: (context, i) {
              final pkg = keys[i];
              final open = _open == pkg;
              return Container(
                decoration: const BoxDecoration(border: Border(top: BorderSide(color: BpColor.divider))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Semantics(
                      button: true,
                      label: pkg,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => setState(() => _open = open ? null : pkg),
                        child: SizedBox(
                          height: 48,
                          child: Row(
                            children: [
                              Expanded(child: Text(pkg, style: BpType.body.copyWith(fontSize: 14, color: BpColor.line))),
                              Text('${data[pkg]!.length}', style: BpType.caption.copyWith(color: BpColor.textMuted)),
                              const SizedBox(width: 6),
                              Icon(open ? Symbols.expand_less_sharp : Symbols.expand_more_sharp, size: 20, color: BpColor.line),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (open)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          [
                            for (final e in data[pkg]!) e.paragraphs.map((p) => p.text).join('\n\n'),
                          ].join('\n\n————\n\n'),
                          style: BpType.monoBody.copyWith(fontSize: 10, color: BpColor.textSecondary),
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
