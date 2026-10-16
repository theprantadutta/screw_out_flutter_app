import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/blueprint_tokens.dart';
import '../../l10n/app_localizations.dart';
import '../../presentation/bloc/premium/premium_cubit.dart';
import '../../presentation/bloc/progress/progress_cubit.dart';
import '../../services/cosmetics.dart';
import '../../services/level_repository.dart';
import '../../widgets/bp/bp_buttons.dart';
import '../../widgets/bp/bp_grid.dart';
import '../../widgets/bp/bp_mini_board.dart';
import '../../widgets/bp/bp_screen.dart';
import '../../widgets/bp/bp_sheet.dart';
import '../chapter_complete/chapter_complete_screen.dart';

/// 14 — Themes. Cosmetic only; tap a card → preview sheet → Equip / Buy.
class ThemesScreen extends StatefulWidget {
  const ThemesScreen({super.key});

  @override
  State<ThemesScreen> createState() => _ThemesScreenState();
}

class _ThemesScreenState extends State<ThemesScreen> {
  BoardTheme? _preview;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final progress = context.watch<ProgressCubit>().state;
    final isPro = context.watch<PremiumCubit>().state.isPro;
    bool owned(BoardTheme t) => isPro || progress.unlocked.contains(t.id);

    return Stack(
      children: [
        BpScreenScaffold(
          caption: l.themesCaption,
          title: l.themesTitle,
          trailing: BpCoinChip(coins: progress.coins, height: 40),
          body: GridView.builder(
            padding: EdgeInsets.fromLTRB(BpSpace.screen, 16, BpSpace.screen, bpBottom(context)),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              mainAxisExtent: 96 + 78 * math.max(1.0, MediaQuery.textScalerOf(context).scale(1)),
            ),
            itemCount: Cosmetics.themes.length,
            itemBuilder: (context, i) {
              final t = Cosmetics.themes[i];
              final equipped = progress.equippedTheme == t.id;
              final String status;
              final Color statusColor;
              if (equipped) {
                status = l.equipped;
                statusColor = BpColor.action;
              } else if (progress.unlocked.contains(t.id)) {
                status = l.owned;
                statusColor = BpColor.textSecondary;
              } else if (isPro) {
                status = l.proIncluded;
                statusColor = BpColor.textSecondary;
              } else {
                status = t.price == null ? '—' : l.priceCoins(t.price!);
                statusColor = BpColor.textSecondary;
              }
              return _ThemeCard(
                theme: t,
                equipped: equipped,
                status: status,
                statusColor: statusColor,
                onTap: () => setState(() => _preview = t),
              );
            },
          ),
        ),
        Positioned.fill(
          child: BpSheetHost(
            reducedMotion: MediaQuery.disableAnimationsOf(context),
            onScrimTap: () => setState(() => _preview = null),
            sheet: _preview == null
                ? null
                : _PreviewSheet(
                    theme: _preview!,
                    owned: owned(_preview!),
                    equipped: progress.equippedTheme == _preview!.id,
                    coins: progress.coins,
                    onClose: () => setState(() => _preview = null),
                  ),
          ),
        ),
      ],
    );
  }
}

class _ThemeCard extends StatefulWidget {
  const _ThemeCard({
    required this.theme,
    required this.equipped,
    required this.status,
    required this.statusColor,
    required this.onTap,
  });

  final BoardTheme theme;
  final bool equipped;
  final String status;
  final Color statusColor;
  final VoidCallback onTap;

  @override
  State<_ThemeCard> createState() => _ThemeCardState();
}

class _ThemeCardState extends State<_ThemeCard> {
  bool _down = false;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: '${widget.theme.name}, ${widget.status}',
    child: GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => setState(() => _down = true),
      onTapCancel: () => setState(() => _down = false),
      onTapUp: (_) => setState(() => _down = false),
      onTap: () {
        bpUiTick?.call();
        widget.onTap();
      },
      child: AnimatedScale(
        scale: _down ? .98 : 1,
        duration: BpMotion.tap,
        child: CustomPaint(
          foregroundPainter: widget.equipped
              ? const _OuterRing()
              : const BpBorderPainter(color: BpColor.lineMuted),
          child: Container(
            color: BpColor.card,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                LayoutBuilder(
                  builder: (context, c) => ThemeSwatch(theme: widget.theme, size: c.maxWidth, height: 96),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.theme.name, style: BpType.button.copyWith(fontSize: 14, color: BpColor.line), maxLines: 2),
                      const SizedBox(height: 3),
                      Text(widget.status, style: BpType.trayLabel.copyWith(letterSpacing: .8, color: widget.statusColor)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

/// Equipped: 2.5 dp yellow ring outside the card.
class _OuterRing extends CustomPainter {
  const _OuterRing();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      (Offset.zero & size).inflate(1.25),
      Paint()
        ..color = BpColor.action
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );
  }

  @override
  bool shouldRepaint(_OuterRing oldDelegate) => false;
}

class _PreviewSheet extends StatelessWidget {
  const _PreviewSheet({
    required this.theme,
    required this.owned,
    required this.equipped,
    required this.coins,
    required this.onClose,
  });

  final BoardTheme theme;
  final bool owned;
  final bool equipped;
  final int coins;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final repo = context.read<LevelRepository>();
    final progress = context.read<ProgressCubit>();
    final level = repo.level(math.min(progress.state.currentLevel, repo.totalLevels)) ?? repo.level(1)!;
    final price = theme.price;
    return BpSheetCard(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Expanded(child: Text(theme.name, style: BpType.sheetTitle.copyWith(color: BpColor.line))),
            Text(l.previewOnly, style: BpType.caption.copyWith(color: BpColor.textMuted)),
          ],
        ),
        Center(child: BpMiniBoard(level: level, size: 200, theme: theme)),
        Text(l.themesCaption, textAlign: TextAlign.center, style: BpType.caption.copyWith(color: BpColor.textMuted)),
        Row(
          children: [
            Expanded(
              child: BpOutlineButton(onPressed: onClose, child: Text(l.close, style: BpType.monoSmallButton)),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: owned
                  ? BpPrimaryButton(
                      height: 48,
                      onPressed: equipped
                          ? null
                          : () async {
                              await progress.equipTheme(theme.id);
                              onClose();
                            },
                      child: Text(equipped ? l.equipped : l.equip, style: BpType.monoButtonBold.copyWith(color: BpColor.ink)),
                    )
                  : BpPrimaryButton(
                      height: 48,
                      onPressed: price == null
                          ? null
                          : () async {
                              if (coins < price) {
                                showBpToast(context, l.notEnoughCoins);
                                return;
                              }
                              final ok = await progress.buyTheme(theme.id);
                              if (!context.mounted) return;
                              if (ok) {
                                await progress.equipTheme(theme.id);
                                if (context.mounted) showBpToast(context, l.themePurchased);
                                onClose();
                              } else {
                                showBpToast(context, l.notEnoughCoins);
                              }
                            },
                      child: Text(price == null ? '—' : l.buyFor(price), style: BpType.monoButtonBold.copyWith(color: BpColor.ink)),
                    ),
            ),
          ],
        ),
      ],
    );
  }
}
