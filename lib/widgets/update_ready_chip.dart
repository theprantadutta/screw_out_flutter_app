import 'package:material_ui/material_ui.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../core/di/injection.dart';
import '../core/theme/blueprint_tokens.dart';
import '../l10n/app_localizations.dart';
import '../services/update/in_app_update_service.dart';
import 'bp/bp_buttons.dart';

/// Home's top-row chip, shown only once a Play update has finished
/// downloading in the background: one tap restarts into the new version.
/// Nothing renders in tests or before a download lands.
class UpdateReadyChip extends StatelessWidget {
  const UpdateReadyChip({super.key});

  @override
  Widget build(BuildContext context) {
    if (!getIt.isRegistered<InAppUpdateService>()) return const SizedBox.shrink();
    final updates = getIt<InAppUpdateService>();
    return ValueListenableBuilder<bool>(
      valueListenable: updates.updateReadyToInstall,
      builder: (context, ready, _) {
        if (!ready) return const SizedBox.shrink();
        final l = AppLocalizations.of(context);
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: BpPrimaryButton(
            height: 40,
            shadow: 3,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            semanticLabel: l.updateReadyRestart,
            onPressed: updates.completeUpdate,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Symbols.system_update_alt_sharp, size: 18),
                const SizedBox(width: 6),
                Text(l.updateChip, style: BpType.monoSmallButton.copyWith(color: BpColor.ink)),
              ],
            ),
          ),
        );
      },
    );
  }
}
