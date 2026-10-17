import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/blueprint_tokens.dart';
import '../../l10n/app_localizations.dart';
import '../../presentation/bloc/auth/auth_cubit.dart';
import '../../presentation/bloc/display/display_cubit.dart';
import '../../presentation/bloc/premium/premium_cubit.dart';
import '../../presentation/bloc/settings/settings_cubit.dart';
import '../../router/routes.dart';
import '../../services/ports.dart';
import '../../widgets/bp/bp_buttons.dart';
import '../../widgets/bp/bp_grid.dart';
import '../../widgets/bp/bp_screen.dart';
import '../../widgets/sync_notices.dart';
import 'delete_account_sheet.dart';

/// Hosted by privacy-project (Projects/screw_out); bundled copies live in
/// assets/legal/.
String legalUrl(String doc) => 'https://legal.pranta.dev/$doc/html?projectName=screw_out';

/// 15 - Settings. Toggles persist immediately (no Save).
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final s = context.watch<SettingsCubit>().state;
    final cubit = context.read<SettingsCubit>();
    final ads = context.read<AdsPort>();

    return BpScreenScaffold(
      title: l.settingsTitle,
      body: ListView(
        padding: EdgeInsets.fromLTRB(BpSpace.screen, 14, BpSpace.screen, bpBottom(context, 30)),
        children: [
          _Section(l.feedbackSection),
          _ToggleRow(label: l.soundEffects, value: s.sound, onChanged: cubit.setSound),
          _ToggleRow(label: l.music, value: s.music, onChanged: cubit.setMusic),
          _ToggleRow(label: l.hapticsRow, value: s.haptics, onChanged: cubit.setHaptics),
          _ToggleRow(label: l.reducedMotionRow, caption: l.reducedMotionCaption, value: s.reducedMotion, onChanged: cubit.setReducedMotion),
          _ToggleRow(label: l.notifications, caption: l.notificationsCaption, value: s.dailyReminder, onChanged: cubit.setDailyReminder, last: true),
          const SizedBox(height: 18),
          _Section(l.generalSection),
          const _RefreshRateRow(),
          _LinkRow(
            label: l.language,
            value: l.languageEnglish,
            icon: Symbols.chevron_right_sharp,
            last: true,
          ),
          const SizedBox(height: 18),
          _Section(l.accountSection),
          const _AccountBlock(),
          const SizedBox(height: 18),
          _Section(l.purchasesSection),
          const _PurchasesBlock(),
          const SizedBox(height: 18),
          _Section(l.aboutSection),
          _LinkRow(
            label: l.privacyPolicy,
            icon: Symbols.open_in_new_sharp,
            onTap: () => launchUrl(Uri.parse(legalUrl('privacy')), mode: LaunchMode.externalApplication),
          ),
          _LinkRow(
            label: l.termsOfUse,
            icon: Symbols.open_in_new_sharp,
            onTap: () => launchUrl(Uri.parse(legalUrl('terms')), mode: LaunchMode.externalApplication),
          ),
          _LinkRow(
            label: l.refundPolicy,
            icon: Symbols.open_in_new_sharp,
            onTap: () => launchUrl(Uri.parse(legalUrl('refund')), mode: LaunchMode.externalApplication),
          ),
          if (ads.privacyOptionsRequired)
            _LinkRow(label: l.privacyChoices, icon: Symbols.chevron_right_sharp, onTap: ads.showPrivacyOptions),
          _LinkRow(
            label: l.licenses,
            icon: Symbols.chevron_right_sharp,
            onTap: () => context.push(AppRoutes.licenses),
            last: true,
          ),
          const SizedBox(height: 40),
          const _VersionFooter(),
        ],
      ),
    );
  }
}

/// High refresh rate (opt-in, device-only). The caption explains what the
/// display can do and when the OS is capping it anyway.
class _RefreshRateRow extends StatelessWidget {
  const _RefreshRateRow();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final d = context.watch<DisplayCubit>().state;
    final unsupported = d.info != null && !d.supported;
    String caption;
    if (unsupported) {
      caption = l.highRefreshRateUnsupported;
    } else if (d.highRefreshRate && d.throttledByBattery) {
      caption = l.highRefreshRateBattery;
    } else if (d.highRefreshRate && d.throttledByHeat) {
      caption = l.highRefreshRateHeat;
    } else if (d.highRefreshRate && d.currentHz != null) {
      caption = '${d.maxHz == null ? l.highRefreshRateOff : l.highRefreshRateOn(d.maxHz!)} · ${l.highRefreshRateNow(d.currentHz!)}';
    } else {
      caption = d.maxHz != null && d.supported ? l.highRefreshRateOn(d.maxHz!) : l.highRefreshRateOff;
    }
    return IgnorePointer(
      ignoring: unsupported,
      child: Opacity(
        opacity: unsupported ? .45 : 1,
        child: _ToggleRow(
          label: l.highRefreshRate,
          caption: caption,
          value: d.highRefreshRate && !unsupported,
          onChanged: context.read<DisplayCubit>().setHighRefreshRate,
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section(this.label);

  final String label;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: BpCaption(label),
  );
}

const _divider = BorderSide(color: BpColor.divider);

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.label,
    required this.value,
    required this.onChanged,
    this.caption,
    this.last = false,
  });

  final String label;
  final String? caption;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool last;

  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(minHeight: 50),
    decoration: BoxDecoration(border: Border(top: _divider, bottom: last ? _divider : BorderSide.none)),
    child: Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: BpType.body.copyWith(color: BpColor.line)),
                if (caption != null) ...[
                  const SizedBox(height: 2),
                  Text(caption!, style: BpType.caption.copyWith(letterSpacing: 0, color: BpColor.textMuted)),
                ],
              ],
            ),
          ),
        ),
        BpToggle(value: value, onChanged: onChanged, semanticLabel: label),
      ],
    ),
  );
}

class _LinkRow extends StatelessWidget {
  const _LinkRow({required this.label, required this.icon, this.value, this.onTap, this.last = false});

  final String label;
  final String? value;
  final IconData icon;
  final VoidCallback? onTap;
  final bool last;

  @override
  Widget build(BuildContext context) => Semantics(
    button: onTap != null,
    label: label,
    child: GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap == null
          ? null
          : () {
              bpUiTick?.call();
              onTap!();
            },
      child: Container(
        constraints: const BoxConstraints(minHeight: 48),
        decoration: BoxDecoration(border: Border(top: _divider, bottom: last ? _divider : BorderSide.none)),
        child: Row(
          children: [
            Expanded(child: Text(label, style: BpType.body.copyWith(color: BpColor.line))),
            if (value != null) Text(value!, style: BpType.monoBody.copyWith(color: BpColor.lineDefault)),
            const SizedBox(width: 4),
            Icon(icon, size: 20, color: BpColor.line),
          ],
        ),
      ),
    ),
  );
}

/// Guest: caption + Sign in with Google / Apple. Signed in: name + sign out
/// / delete account (tap twice to confirm).
class _AccountBlock extends StatelessWidget {
  const _AccountBlock();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final auth = context.watch<AuthCubit>().state;
    final cubit = context.read<AuthCubit>();
    final busy = auth.status == AuthStatus.loading;
    final apple = defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.macOS;

    Future<void> signIn(Future<bool> Function() f) async {
      final ok = await f();
      if (context.mounted) showSignInResult(context, cubit, ok);
    }

    if (auth.isGuest) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: const BoxDecoration(border: Border(top: _divider)),
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(l.guestCaption, style: BpType.caption.copyWith(letterSpacing: .6, height: 1.5, color: BpColor.textMuted)),
          ),
          BpOutlineButton(
            height: 50,
            onPressed: busy ? null : () => signIn(cubit.signInWithGoogle),
            child: Text(l.signInGoogle, style: BpType.body.copyWith(fontSize: 14, color: BpColor.line)),
          ),
          if (apple) ...[
            const SizedBox(height: 8),
            BpOutlineButton(
              height: 50,
              onPressed: busy ? null : () => signIn(cubit.signInWithApple),
              child: Text(l.signInApple, style: BpType.body.copyWith(fontSize: 14, color: BpColor.line)),
            ),
          ],
        ],
      );
    }
    final name = auth.username ?? auth.displayName ?? auth.email ?? '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          constraints: const BoxConstraints(minHeight: 50),
          decoration: const BoxDecoration(border: Border(top: _divider)),
          alignment: Alignment.centerLeft,
          child: Text(l.signedInAs(name), style: BpType.body.copyWith(color: BpColor.line)),
        ),
        Row(
          children: [
            Expanded(
              child: BpOutlineButton(
                onPressed: () async {
                  await cubit.signOut();
                  if (context.mounted) showBpToast(context, l.signedOutToast);
                },
                child: Text(l.signOut, style: BpType.monoSmallButton),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: BpOutlineButton(
                color: BpColor.blocked,
                textColor: BpColor.blocked,
                onPressed: () async {
                  final outcome = await showDeleteAccountSheet(
                    context,
                    isPro: context.read<PremiumCubit>().state.isPro,
                    delete: cubit.deleteAccount,
                  );
                  if (outcome == null || !context.mounted) return;
                  final (msg, kind) = switch (outcome) {
                    AccountDeletion.deleted => (l.accountDeletedToast, BpToastKind.success),
                    AccountDeletion.deletedProStillBilled => (
                      l.accountDeletedProToast(subscriptionStoreName()),
                      BpToastKind.info,
                    ),
                    AccountDeletion.offline => (l.deleteOffline, BpToastKind.error),
                    AccountDeletion.failed || AccountDeletion.cancelled => (l.deleteFailed, BpToastKind.error),
                  };
                  showBpToast(context, msg, kind: kind, queue: true);
                },
                child: Text(l.deleteAccount, style: BpType.monoSmallButton),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PurchasesBlock extends StatelessWidget {
  const _PurchasesBlock();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final premium = context.watch<PremiumCubit>().state;
    final store = context.read<PurchasesPort>();

    Future<void> buy(String id) async {
      final outcome = await store.buy(id);
      if (!context.mounted) return;
      final (msg, kind) = switch (outcome) {
        PurchaseOutcome.granted => (l.purchaseThanks, BpToastKind.success),
        PurchaseOutcome.pending => (l.purchasePending, BpToastKind.info),
        PurchaseOutcome.failed => (l.purchaseFailed, BpToastKind.error),
        PurchaseOutcome.needsSignIn => (l.signInToPurchase, BpToastKind.info),
        PurchaseOutcome.cancelled => (null, BpToastKind.info),
      };
      if (outcome == PurchaseOutcome.granted) context.read<SoundPort>().play(Sfx.purchase);
      if (msg != null) showBpToast(context, msg, kind: kind);
    }

    final mono = BpType.monoSmallButton;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Pro.
        if (premium.isPro)
          BpOutlined(
            color: BpColor.action,
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Expanded(child: Text(l.proTitle, style: BpType.button.copyWith(fontSize: 15, color: BpColor.action))),
                Text(l.proActive, style: BpType.label.copyWith(color: BpColor.action)),
              ],
            ),
          )
        else
          BpOutlined(
            color: BpColor.action,
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l.proTitle, style: BpType.button.copyWith(fontSize: 16, color: BpColor.action)),
                const SizedBox(height: 4),
                Text(l.proPerks(Products.proMonthlyCoins), style: BpType.caption.copyWith(letterSpacing: .4, height: 1.5, color: BpColor.textSecondary)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: BpOutlineButton(
                        height: 52,
                        onPressed: () => buy(Products.proMonthly),
                        child: _PriceLabel(top: l.proMonthly, bottom: store.priceOf(Products.proMonthly)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: BpPrimaryButton(
                        height: 52,
                        shadow: 0,
                        onPressed: () => buy(Products.proYearly),
                        child: _PriceLabel(top: l.proYearly, bottom: store.priceOf(Products.proYearly), ink: true),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              flex: 14,
              child: premium.noAds
                  ? BpOutlineButton(
                      height: 50,
                      onPressed: null,
                      child: Text(l.adsRemoved, style: mono),
                    )
                  : BpOutlineButton(
                      height: 50,
                      color: BpColor.action,
                      textColor: BpColor.action,
                      onPressed: () => buy(Products.removeAds),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Row(
                        children: [
                          Expanded(child: Text(l.removeAds, style: BpType.button.copyWith(fontSize: 14, color: BpColor.action))),
                          Text(store.priceOf(Products.removeAds) ?? '', style: BpType.label.copyWith(fontSize: 12, letterSpacing: 0, color: BpColor.action)),
                        ],
                      ),
                    ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 10,
              child: BpOutlineButton(
                height: 50,
                onPressed: () async {
                  final o = await store.restore();
                  if (!context.mounted) return;
                  final (msg, kind) = switch (o) {
                    PurchaseOutcome.granted => (l.restored, BpToastKind.success),
                    PurchaseOutcome.needsSignIn => (l.signInToPurchase, BpToastKind.info),
                    PurchaseOutcome.cancelled => (null, BpToastKind.info),
                    _ => (l.restoreNothing, BpToastKind.info),
                  };
                  if (msg != null) showBpToast(context, msg, kind: kind);
                },
                child: Text(l.restore, style: mono),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        BpCaption(l.coinPacks),
        const SizedBox(height: 6),
        Row(
          children: [
            for (final (i, id) in Products.coinPackAmounts.keys.indexed) ...[
              if (i > 0) const SizedBox(width: 8),
              Expanded(
                child: BpOutlineButton(
                  height: 52,
                  onPressed: () => buy(id),
                  child: _PriceLabel(top: l.coinPackAmount(Products.coinPackAmounts[id]!), bottom: store.priceOf(id)),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _PriceLabel extends StatelessWidget {
  const _PriceLabel({required this.top, this.bottom, this.ink = false});

  final String top;
  final String? bottom;
  final bool ink;

  @override
  Widget build(BuildContext context) {
    final c = ink ? BpColor.ink : BpColor.line;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(top, style: BpType.monoSmallButton.copyWith(color: c)),
        if (bottom != null) Text(bottom!, style: BpType.caption.copyWith(letterSpacing: .4, color: ink ? BpColor.ink : BpColor.textMuted)),
      ],
    );
  }
}

class _VersionFooter extends StatelessWidget {
  const _VersionFooter();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snap) {
        final info = snap.data;
        final text = Text(
          info == null ? ' ' : l.versionFooter(info.version, info.buildNumber),
          textAlign: TextAlign.center,
          style: BpType.caption.copyWith(color: BpColor.lineMuted),
        );
        // Debug builds: long-press opens the QA panel.
        if (!kDebugMode) return text;
        return GestureDetector(onLongPress: () => context.push(AppRoutes.debug), child: text);
      },
    );
  }
}
