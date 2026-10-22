import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/blueprint_tokens.dart';
import '../../l10n/app_localizations.dart';
import '../../presentation/bloc/auth/auth_cubit.dart';
import '../../widgets/bp/bp_buttons.dart';
import '../../widgets/bp/bp_sheet.dart';
import '../../widgets/bp/bp_text_field.dart';

bool get _apple => defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.macOS;

/// Where the player cancels Pro (deleting the account never does).
String subscriptionStoreName() => _apple ? 'the App Store' : 'Google Play';

Uri _manageSubscriptionsUri() => _apple
    ? Uri.parse('https://apps.apple.com/account/subscriptions')
    : Uri.parse('https://play.google.com/store/account/subscriptions?package=com.pranta.screwout');

/// The in-app account deletion (Play + App Store requirement): what is
/// deleted, a Pro billing warning, then the deletion itself with progress.
/// Resolves to the outcome, or null when the player kept the account.
/// [needsPassword]: an email account re-confirms with its password, which
/// is handed to [delete].
Future<AccountDeletion?> showDeleteAccountSheet(
  BuildContext context, {
  required bool isPro,
  required Future<AccountDeletion> Function(String? password) delete,
  bool needsPassword = false,
}) => showModalBottomSheet<AccountDeletion>(
  context: context,
  backgroundColor: BpColor.transparent,
  barrierColor: BpColor.scrim,
  elevation: 0,
  isScrollControlled: true,
  builder: (context) => DeleteAccountSheet(isPro: isPro, delete: delete, needsPassword: needsPassword),
);

class DeleteAccountSheet extends StatefulWidget {
  const DeleteAccountSheet({super.key, required this.isPro, required this.delete, this.needsPassword = false});

  final bool isPro;
  final Future<AccountDeletion> Function(String? password) delete;
  final bool needsPassword;

  @override
  State<DeleteAccountSheet> createState() => _DeleteAccountSheetState();
}

class _DeleteAccountSheetState extends State<DeleteAccountSheet> {
  bool _busy = false;
  String? _passwordError;
  final _password = TextEditingController();

  @override
  void dispose() {
    _password.dispose();
    super.dispose();
  }

  Future<void> _confirm() async {
    final l = AppLocalizations.of(context);
    if (widget.needsPassword && _password.text.isEmpty) {
      setState(() => _passwordError = l.passwordRequired);
      return;
    }
    setState(() {
      _busy = true;
      _passwordError = null;
    });
    final outcome = await widget.delete(widget.needsPassword ? _password.text : null);
    if (!mounted) return;
    if (outcome == AccountDeletion.cancelled || outcome == AccountDeletion.wrongPassword) {
      setState(() {
        _busy = false;
        _passwordError = outcome == AccountDeletion.wrongPassword ? l.deleteWrongPassword : null;
      });
      return;
    }
    Navigator.of(context).pop(outcome);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return PopScope(
      canPop: !_busy,
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
        child: SafeArea(
          child: SingleChildScrollView(
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
                    child: Text(l.deleteSheetPro(subscriptionStoreName()), style: BpType.monoBody.copyWith(color: BpColor.line, height: 1.5)),
                  ),
                  BpOutlineButton(
                    height: 46,
                    onPressed: _busy ? null : () => launchUrl(_manageSubscriptionsUri(), mode: LaunchMode.externalApplication),
                    child: Text(l.manageSubscription, style: BpType.monoSmallButton),
                  ),
                ],
                if (widget.needsPassword) ...[
                  Text(l.deletePasswordBody, style: BpType.monoBody.copyWith(color: BpColor.textSecondary, height: 1.5)),
                  BpTextField(
                    controller: _password,
                    label: l.passwordLabel,
                    enabled: !_busy,
                    obscureText: true,
                    autofillHints: const [AutofillHints.password],
                    textInputAction: TextInputAction.done,
                  ),
                  if (_passwordError != null) Text(_passwordError!, style: BpType.monoBody.copyWith(color: BpColor.blocked, height: 1.4)),
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
      ),
    );
  }
}
