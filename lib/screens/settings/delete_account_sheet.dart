import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/blueprint_tokens.dart';
import '../../l10n/app_localizations.dart';
import '../../presentation/bloc/auth/auth_cubit.dart';
import '../../widgets/bp/bp_buttons.dart';
import '../../widgets/bp/bp_sheet.dart';

bool get _apple => defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.macOS;

/// Where the player cancels Pro (deleting the account never does).
String subscriptionStoreName() => _apple ? 'the App Store' : 'Google Play';

Uri _manageSubscriptionsUri() => _apple
    ? Uri.parse('https://apps.apple.com/account/subscriptions')
    : Uri.parse('https://play.google.com/store/account/subscriptions?package=com.pranta.screwout');

/// The in-app account deletion (Play + App Store requirement): what is
/// deleted, a Pro billing warning, then the deletion itself with progress.
/// Resolves to the outcome, or null when the player kept the account.
Future<AccountDeletion?> showDeleteAccountSheet(
  BuildContext context, {
  required bool isPro,
  required Future<AccountDeletion> Function() delete,
}) => showModalBottomSheet<AccountDeletion>(
  context: context,
  backgroundColor: BpColor.transparent,
  barrierColor: BpColor.scrim,
  elevation: 0,
  isScrollControlled: true,
  builder: (context) => DeleteAccountSheet(isPro: isPro, delete: delete),
);

class DeleteAccountSheet extends StatefulWidget {
  const DeleteAccountSheet({super.key, required this.isPro, required this.delete});

  final bool isPro;
  final Future<AccountDeletion> Function() delete;

  @override
  State<DeleteAccountSheet> createState() => _DeleteAccountSheetState();
}

class _DeleteAccountSheetState extends State<DeleteAccountSheet> {
  bool _busy = false;

  Future<void> _confirm() async {
    setState(() => _busy = true);
    final outcome = await widget.delete();
    if (!mounted) return;
    if (outcome == AccountDeletion.cancelled) {
      setState(() => _busy = false);
      return;
    }
    Navigator.of(context).pop(outcome);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return PopScope(
      canPop: !_busy,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(BpSize.sheetInset, 0, BpSize.sheetInset, 14),
          child: BpSheetCard(
            children: [
              Text(l.deleteSheetTitle, style: BpType.stuckTitle.copyWith(color: BpColor.line)),
              Text(l.deleteSheetBody, style: BpType.monoBody.copyWith(color: BpColor.textSecondary, height: 1.5)),
              if (widget.isPro) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: BpColor.action, width: BpSize.stroke),
                  ),
                  child: Text(
                    l.deleteSheetPro(subscriptionStoreName()),
                    style: BpType.monoBody.copyWith(color: BpColor.line, height: 1.5),
                  ),
                ),
                BpOutlineButton(
                  height: 46,
                  onPressed: _busy
                      ? null
                      : () => launchUrl(_manageSubscriptionsUri(), mode: LaunchMode.externalApplication),
                  child: Text(l.manageSubscription, style: BpType.monoSmallButton),
                ),
              ],
              BpPrimaryButton(
                onPressed: _busy ? null : () => Navigator.of(context).pop(),
                child: Text(l.keepAccount, style: BpType.monoButtonBold.copyWith(color: BpColor.ink)),
              ),
              BpOutlineButton(
                height: 46,
                color: BpColor.blocked,
                textColor: BpColor.blocked,
                onPressed: _busy ? null : _confirm,
                semanticLabel: l.deleteForever,
                child: Text(_busy ? l.deleting : l.deleteForever, style: BpType.monoSmallButton),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
