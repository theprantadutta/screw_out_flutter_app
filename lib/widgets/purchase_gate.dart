import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/theme/blueprint_tokens.dart';
import '../l10n/app_localizations.dart';
import '../presentation/bloc/auth/auth_cubit.dart';
import '../services/ports.dart';
import 'bp/bp_buttons.dart';
import 'bp/bp_screen.dart';
import 'bp/bp_sheet.dart';
import 'sign_in_buttons.dart';
import 'sync_notices.dart';

/// Offered at most once per app run, so a guest buying several coin packs
/// isn't asked every time.
bool _saveOfferShown = false;

@visibleForTesting
void resetPurchaseSaveOffer() => _saveOfferShown = false;

/// Buys [productId] the way every store button does: the store sheet, then
/// one toast for the outcome (nothing on cancel). No account is needed (App
/// Store Guideline 5.1.1(v)); a guest who just bought is OFFERED a sign-in so
/// the purchase also reaches their other devices, and may decline.
Future<PurchaseOutcome?> buyWithFeedback(BuildContext context, String productId) async {
  final l = AppLocalizations.of(context);
  final outcome = await context.read<PurchasesPort>().buy(productId);
  if (!context.mounted) return outcome;
  final (msg, kind) = switch (outcome) {
    PurchaseOutcome.granted => (l.purchaseThanks, BpToastKind.success),
    PurchaseOutcome.pending => (l.purchasePending, BpToastKind.info),
    PurchaseOutcome.failed => (l.purchaseFailed, BpToastKind.error),
    PurchaseOutcome.needsSignIn => (l.purchaseNeedsConnection, BpToastKind.info),
    PurchaseOutcome.cancelled => (null, BpToastKind.info),
  };
  if (outcome == PurchaseOutcome.granted) context.read<SoundPort>().play(Sfx.purchase);
  if (msg != null) showBpToast(context, msg, kind: kind);
  if (outcome == PurchaseOutcome.granted) await offerSignInAfterPurchase(context);
  return outcome;
}

/// The optional "keep your purchase on every device" sign-in, for guests
/// only. Resolves true when the player signed in.
Future<bool> offerSignInAfterPurchase(BuildContext context) async {
  final cubit = context.read<AuthCubit>();
  if (!cubit.state.isGuest || _saveOfferShown) return false;
  _saveOfferShown = true;
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
  return true;
}

/// "Keep your purchase": Google, Apple (iOS / macOS), email, or not now.
/// Optional, shown after a guest's purchase. Pops true once signed in.
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
              Text(l.purchaseSaveTitle, style: BpType.stuckTitle.copyWith(color: BpColor.line)),
              Text(l.purchaseSaveBody, style: BpType.monoBody.copyWith(color: BpColor.textSecondary, height: 1.5)),
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
