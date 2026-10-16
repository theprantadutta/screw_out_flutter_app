import 'package:flutter/material.dart';

import '../../core/theme/blueprint_tokens.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/bp/bp_buttons.dart';
import '../../widgets/bp/bp_sheet.dart';

/// The notification soft-ask (shown once, after the 3rd cleared sheet).
/// Returns true when the player said yes.
Future<bool?> showNotificationPrimer(BuildContext context) => showModalBottomSheet<bool>(
  context: context,
  backgroundColor: BpColor.transparent,
  barrierColor: BpColor.scrim,
  elevation: 0,
  builder: (context) => const NotificationPrimerSheet(),
);

class NotificationPrimerSheet extends StatelessWidget {
  const NotificationPrimerSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(BpSize.sheetInset, 0, BpSize.sheetInset, 14),
        child: BpSheetCard(
          children: [
            Text(l.notificationPrimerTitle, style: BpType.stuckTitle.copyWith(color: BpColor.line)),
            Text(l.notificationPrimerBody, style: BpType.monoBody.copyWith(color: BpColor.textSecondary)),
            BpPrimaryButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l.allow, style: BpType.monoButtonBold.copyWith(color: BpColor.ink)),
            ),
            BpOutlineButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l.notNow, style: BpType.monoSmallButton),
            ),
          ],
        ),
      ),
    );
  }
}
