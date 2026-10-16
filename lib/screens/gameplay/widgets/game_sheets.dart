import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/theme/blueprint_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/bp/bp_buttons.dart';
import '../../../widgets/bp/bp_grid.dart';
import '../../../widgets/bp/bp_sheet.dart';

/// 09 — Pause.
class PauseSheet extends StatelessWidget {
  const PauseSheet({
    super.key,
    required this.code,
    required this.moves,
    required this.sound,
    required this.haptics,
    required this.reducedMotion,
    required this.onResume,
    required this.onSound,
    required this.onHaptics,
    required this.onReducedMotion,
    required this.onRestart,
    required this.onExit,
  });

  final String code;
  final int moves;
  final bool sound;
  final bool haptics;
  final bool reducedMotion;
  final VoidCallback onResume;
  final ValueChanged<bool> onSound;
  final ValueChanged<bool> onHaptics;
  final ValueChanged<bool> onReducedMotion;
  final VoidCallback onRestart;
  final VoidCallback onExit;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    Widget row(String label, bool value, ValueChanged<bool> onChanged) => Container(
      height: 48,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: BpColor.divider)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: BpType.label.copyWith(fontSize: 12, letterSpacing: .72, color: BpColor.line),
            ),
          ),
          BpToggle(value: value, onChanged: onChanged, semanticLabel: label),
        ],
      ),
    );
    return BpSheetCard(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Expanded(child: Text(l.paused, style: BpType.sheetTitle.copyWith(color: BpColor.line))),
            Text(l.pausedMeta(code, moves), style: BpType.caption.copyWith(color: BpColor.textMuted)),
          ],
        ),
        BpPrimaryButton(onPressed: onResume, child: Text(l.resume)),
        DecoratedBox(
          decoration: const BoxDecoration(border: Border(top: BorderSide(color: BpColor.divider))),
          child: Column(
            children: [
              row(l.sound, sound, onSound),
              row(l.haptics, haptics, onHaptics),
              row(l.reducedMotion, reducedMotion, onReducedMotion),
            ],
          ),
        ),
        Row(
          children: [
            Expanded(child: BpOutlineButton(onPressed: onRestart, color: BpColor.line, child: Text(l.restart, style: BpType.monoSmallButton))),
            const SizedBox(width: 8),
            Expanded(child: BpOutlineButton(onPressed: onExit, color: BpColor.line, child: Text(l.exitToSheets, style: BpType.monoSmallButton))),
          ],
        ),
      ],
    );
  }
}

/// 10 — Stuck (tray full). The lifted tray is drawn by the gameplay screen.
class StuckSheet extends StatelessWidget {
  const StuckSheet({
    super.key,
    required this.reason,
    required this.hintLabel,
    required this.canUndo,
    required this.onUndo,
    required this.onRestart,
    required this.onHint,
    this.rescue,
  });

  final String reason;
  final String hintLabel;
  final bool canUndo;
  final VoidCallback onUndo;
  final VoidCallback onRestart;
  final VoidCallback onHint;

  /// Extra-slot rescue row; null when unavailable.
  final Widget? rescue;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return BpSheetCard(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.stuckTitle, style: BpType.stuckTitle.copyWith(fontSize: 24, height: 1.1, color: BpColor.line)),
            const SizedBox(height: 6),
            Text(reason, style: BpType.monoBody.copyWith(color: BpColor.textSecondary)),
          ],
        ),
        BpPrimaryButton(
          onPressed: canUndo ? onUndo : null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Symbols.undo_sharp, size: 22),
              const SizedBox(width: 8),
              Text(l.undoLastMove),
            ],
          ),
        ),
        Row(
          children: [
            Expanded(
              child: BpOutlineButton(
                onPressed: onRestart,
                color: BpColor.line,
                child: Text(l.restart, style: BpType.monoSmallButton),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: BpOutlineButton(
                onPressed: onHint,
                color: BpColor.line,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Symbols.lightbulb_sharp, size: 18),
                    const SizedBox(width: 6),
                    Text(hintLabel, style: BpType.monoSmallButton),
                  ],
                ),
              ),
            ),
          ],
        ),
        ?rescue,
      ],
    );
  }
}

/// Extra-slot rescue: one button for Pro, coins | video otherwise.
class RescueRow extends StatelessWidget {
  const RescueRow({
    super.key,
    required this.isPro,
    required this.cost,
    required this.adAvailable,
    required this.onCoins,
    required this.onAd,
    required this.onPro,
  });

  final bool isPro;
  final int cost;
  final bool adAvailable;
  final VoidCallback onCoins;
  final VoidCallback onAd;
  final VoidCallback onPro;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final style = BpType.monoSmallButton;
    if (isPro) {
      return BpOutlineButton(
        onPressed: onPro,
        color: BpColor.action,
        textColor: BpColor.action,
        child: Text(l.rescueSlotPro, style: style),
      );
    }
    return Row(
      children: [
        Expanded(
          child: BpOutlineButton(
            onPressed: onCoins,
            color: BpColor.lineDefault,
            child: Text(l.rescueSlotCoins(cost), style: style),
          ),
        ),
        if (adAvailable) ...[
          const SizedBox(width: 8),
          Expanded(
            child: BpOutlineButton(
              onPressed: onAd,
              color: BpColor.lineDefault,
              child: Text(l.rescueSlotAd, style: style),
            ),
          ),
        ],
      ],
    );
  }
}

/// 13 — Out of hints. "Keep thinking" is the default; ad and coins are
/// equal-weight outlines; the video row is hidden when no ad is available.
class OutOfHintsSheet extends StatelessWidget {
  const OutOfHintsSheet({
    super.key,
    required this.balance,
    required this.cost,
    required this.adAvailable,
    required this.onWatch,
    required this.onCoins,
    required this.onKeepThinking,
  });

  final int balance;
  final int cost;
  final bool adAvailable;
  final VoidCallback onWatch;
  final VoidCallback onCoins;
  final VoidCallback onKeepThinking;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    Widget option({required Widget leading, required String title, required String meta, required VoidCallback? onTap}) =>
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Opacity(
            opacity: onTap == null ? .45 : 1,
            child: BpOutlined(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  leading,
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: BpType.body.copyWith(fontWeight: FontWeight.w700, fontVariations: const [FontVariation('wght', 700)], color: BpColor.line)),
                        const SizedBox(height: 3),
                        Text(meta, style: BpType.caption.copyWith(letterSpacing: .6, color: BpColor.textMuted)),
                      ],
                    ),
                  ),
                  const Icon(Symbols.chevron_right_sharp, size: 22, color: BpColor.line),
                ],
              ),
            ),
          ),
        );
    return BpSheetCard(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.hintsLeftZero, style: BpType.trayLabel.copyWith(color: BpColor.textMuted)),
            const SizedBox(height: 6),
            Text(l.outOfHintsTitle, style: BpType.stuckTitle.copyWith(fontSize: 24, height: 1.1, color: BpColor.line)),
            const SizedBox(height: 6),
            Text(l.outOfHintsBody, style: BpType.monoBody.copyWith(color: BpColor.textSecondary)),
          ],
        ),
        if (adAvailable)
          option(
            leading: const Icon(Symbols.smart_display_sharp, size: 26, color: BpColor.line),
            title: l.watchVideo,
            meta: l.watchVideoMeta,
            onTap: onWatch,
          ),
        option(
          leading: const BpCoinGlyph(size: 26, stroke: 3),
          title: l.useCoins(cost),
          meta: l.useCoinsMeta(balance),
          onTap: balance >= cost ? onCoins : null,
        ),
        BpPrimaryButton(height: 52, onPressed: onKeepThinking, child: Text(l.keepThinking)),
      ],
    );
  }
}

/// Small confirmation before restarting a sheet with ≥ 6 moves.
class RestartConfirmSheet extends StatelessWidget {
  const RestartConfirmSheet({super.key, required this.moves, required this.onConfirm, required this.onCancel});

  final int moves;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return BpSheetCard(
      children: [
        Text(l.restartConfirmTitle, style: BpType.stuckTitle.copyWith(color: BpColor.line)),
        Text(l.restartConfirmBody(moves), style: BpType.monoBody.copyWith(color: BpColor.textSecondary)),
        Row(
          children: [
            Expanded(child: BpOutlineButton(onPressed: onCancel, color: BpColor.line, child: Text(l.cancel, style: BpType.monoSmallButton))),
            const SizedBox(width: 8),
            Expanded(child: BpPrimaryButton(height: 48, onPressed: onConfirm, child: Text(l.restart, style: BpType.monoButtonBold.copyWith(color: BpColor.ink)))),
          ],
        ),
      ],
    );
  }
}
