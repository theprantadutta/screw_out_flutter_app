import 'package:material_ui/material_ui.dart';

import '../../core/theme/blueprint_tokens.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/bp/bp_buttons.dart';
import '../../widgets/bp/bp_sheet.dart';

/// Confirms a sign-out. Signing out clears this device (so the next person
/// never sees the account), which an accidental tap shouldn't do silently:
/// anything not synced yet would be lost. Resolves to true to sign out.
Future<bool> confirmSignOut(BuildContext context) async =>
    await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: BpColor.transparent,
      barrierColor: BpColor.scrim,
      elevation: 0,
      isScrollControlled: true,
      builder: (context) => const SignOutSheet(),
    ) ??
    false;

class SignOutSheet extends StatelessWidget {
  const SignOutSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(BpSize.sheetInset, 0, BpSize.sheetInset, 14),
        child: BpSheetCard(
          children: [
            Text(l.signOutSheetTitle, style: BpType.stuckTitle.copyWith(color: BpColor.line)),
            Text(l.signOutSheetBody, style: BpType.monoBody.copyWith(color: BpColor.textSecondary, height: 1.5)),
            BpPrimaryButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l.staySignedIn, style: BpType.monoButtonBold.copyWith(color: BpColor.ink)),
            ),
            BpOutlineButton(
              height: 46,
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l.signOutConfirm, style: BpType.monoSmallButton),
            ),
          ],
        ),
      ),
    );
  }
}
