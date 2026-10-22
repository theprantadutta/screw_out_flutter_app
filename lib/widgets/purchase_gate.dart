import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/theme/blueprint_tokens.dart';
import '../l10n/app_localizations.dart';
import '../presentation/bloc/auth/auth_cubit.dart';
import 'bp/bp_buttons.dart';
import 'bp/bp_sheet.dart';
import 'sign_in_buttons.dart';
import 'sync_notices.dart';

/// Real-money purchases (and restores) need an account: the API refuses
/// guest receipts. Signed-in players pass straight through; a guest gets a
/// sign-in sheet first. Resolves true when the purchase may go ahead (the
/// sign-in toast is queued so the purchase result follows it), false when
/// the guest backed out.
Future<bool> ensureAccountForPurchase(BuildContext context) async {
  final cubit = context.read<AuthCubit>();
  if (!cubit.state.isGuest) return true;
  final ok = await showModalBottomSheet<bool>(
    context: context,
    backgroundColor: BpColor.transparent,
    barrierColor: BpColor.scrim,
    elevation: 0,
    isScrollControlled: true,
    builder: (_) => const PurchaseSignInSheet(),
  );
  if (ok != true || !context.mounted) return false;
  showSignInResult(context, cubit, true);
  return !cubit.state.isGuest;
}

/// "Sign in to buy": Google, Apple (iOS / macOS), email, or not now.
/// Pops true once signed in.
class PurchaseSignInSheet extends StatelessWidget {
  const PurchaseSignInSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cubit = context.read<AuthCubit>();
    final busy = context.select<AuthCubit, bool>((c) => c.state.status == AuthStatus.loading);
    return PopScope(
      canPop: !busy,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(BpSize.sheetInset, 0, BpSize.sheetInset, 14),
          child: BpSheetCard(
            children: [
              Text(l.purchaseGateTitle, style: BpType.stuckTitle.copyWith(color: BpColor.line)),
              Text(l.purchaseGateBody, style: BpType.monoBody.copyWith(color: BpColor.textSecondary, height: 1.5)),
              SignInButtons(
                primaryGoogle: true,
                onResult: (ok) {
                  if (ok) {
                    if (context.mounted) Navigator.of(context).pop(true);
                  } else if (context.mounted) {
                    showSignInResult(context, cubit, false);
                  }
                },
              ),
              BpOutlineButton(
                height: 46,
                onPressed: busy ? null : () => Navigator.of(context).pop(false),
                child: Text(l.notNow, style: BpType.monoSmallButton),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
