import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../core/theme/blueprint_tokens.dart';
import '../../game/domain/level.dart';
import '../../game/generator/curriculum.dart';
import '../../game/generator/daily.dart';
import '../../l10n/app_localizations.dart';
import '../../presentation/bloc/progress/progress_cubit.dart';
import '../../presentation/bloc/settings/settings_cubit.dart';
import '../../router/routes.dart';
import '../../services/cosmetics.dart';
import '../../services/level_repository.dart';
import '../../services/ports.dart';
import '../../widgets/bp/bp_buttons.dart';
import '../../widgets/bp/bp_grid.dart';
import '../../widgets/bp/bp_mini_board.dart';
import '../../widgets/bp/bp_screen.dart';

/// 02 — Home. One primary action (Continue); secondary actions are quiet.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, this.today});

  /// Overridable clock for tests.
  final DateTime? today;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final repo = context.read<LevelRepository>();
    final progress = context.watch<ProgressCubit>().state;
    final reduced = context.watch<SettingsCubit>().state.reducedMotion;
    final banner = context.read<AdsPort>().menuBanner();

    final total = repo.totalLevels;
    final allDone = progress.currentLevel > total;
    final currentId = math.min(progress.currentLevel, total);
    final level = repo.level(currentId);
    final chapter = LevelRepository.chapterOf(currentId);
    final info = chapterInfo(chapter, name: repo.pack(chapter)?.name);
    final dailyKey = DailySheets.dateKey(today ?? DateTime.now());
    final dailyUnplayed = !progress.dailyDone.contains(dailyKey);
    final theme = Cosmetics.resolve(progress.equippedTheme);
    String pad2(int n) => n.toString().padLeft(2, '0');

    return BpGridBackground(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: BpSpace.screen),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: bpHeaderTop(context) - 2),
            // Top row: logomark · coins · settings.
            SizedBox(
              height: 44,
              child: Row(
                children: [
                  Semantics(
                    label: l.appName,
                    child: Image.asset('assets/brand/logomark-512.png', width: 44, height: 44),
                  ),
                  const Spacer(),
                  BpCoinChip(coins: progress.coins, height: 44),
                  const SizedBox(width: 8),
                  BpIconButton(
                    size: 44,
                    iconSize: 22,
                    icon: const Icon(Symbols.settings_sharp),
                    semanticLabel: l.settings,
                    onPressed: () => context.push(AppRoutes.settings),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            // Hero + figure caption.
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text('Screw\nOut.', style: BpType.hero.copyWith(color: BpColor.line)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: SizedBox(
                    width: 110,
                    child: Text(
                      l.homeFigure(level?.panels.length ?? 0, level?.screws.length ?? 0),
                      textAlign: TextAlign.right,
                      style: BpType.caption.copyWith(letterSpacing: 0, height: 1.5, color: BpColor.textMuted),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _DimensionLine(label: l.chapterOf(pad2(chapter), pad2(repo.chapterCount))),
            // Exploded view (fills the remaining height).
            Expanded(
              child: level == null
                  ? const SizedBox.shrink()
                  : _ExplodedView(level: level, theme: theme, reduced: reduced),
            ),
            // Title block.
            _TitleBlock(
              nextCode: allDone ? l.allCleared : codeFor(currentId),
              chapterLabel: l.chapterLabel(pad2(chapter)),
              chapterName: info.name,
              done: progress.totalCleared,
              total: total,
              ticks: [
                for (var i = 0; i < kLevelsPerChapter; i++)
                  () {
                    final id = (chapter - 1) * kLevelsPerChapter + i + 1;
                    if (progress.isCleared(id)) return BpTick.done;
                    if (id == progress.currentLevel) return BpTick.current;
                    return BpTick.empty;
                  }(),
              ],
            ),
            const SizedBox(height: 26),
            BpPrimaryButton(
              height: 60,
              shadow: BpSize.hardShadowLarge,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              onPressed: () => context.go(allDone ? AppRoutes.campaign : AppRoutes.playPath(currentId)),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      allDone ? l.allCleared : l.continueSheet(codeFor(currentId)),
                      style: BpType.button.copyWith(fontSize: 18, color: BpColor.ink),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(Symbols.arrow_forward_sharp, size: 26),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: BpOutlineButton(
                    onPressed: () => context.push(AppRoutes.campaign),
                    child: Text(l.sheets, style: BpType.monoSmallButton),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: BpOutlineButton(
                    onPressed: () => context.push(AppRoutes.daily),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (dailyUnplayed) ...[
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(color: BpColor.action, shape: BoxShape.circle),
                          ),
                          const SizedBox(width: 6),
                        ],
                        Text(l.daily, style: BpType.monoSmallButton),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: BpOutlineButton(
                    onPressed: () => context.push(AppRoutes.themes),
                    child: Text(l.themes, style: BpType.monoSmallButton),
                  ),
                ),
              ],
            ),
            SizedBox(height: banner == null ? bpBottom(context) : 12),
            if (banner != null) ...[
              banner,
              SizedBox(height: MediaQuery.paddingOf(context).bottom),
            ],
          ],
        ),
      ),
    );
  }
}

/// |—— CHAPTER 02/05 ——| dimension line.
class _DimensionLine extends StatelessWidget {
  const _DimensionLine({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 12,
    child: Stack(
      alignment: Alignment.center,
      children: [
        const Positioned(left: 0, right: 0, top: 6, child: Divider(height: 1, thickness: 1, color: BpColor.lineMuted)),
        const Positioned(left: 0, top: 0, bottom: 0, child: VerticalDivider(width: 1, thickness: 1, color: BpColor.lineMuted)),
        const Positioned(right: 0, top: 0, bottom: 0, child: VerticalDivider(width: 1, thickness: 1, color: BpColor.lineMuted)),
        Container(
          color: BpColor.sheet,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(label, style: BpType.caption.copyWith(letterSpacing: 0, color: BpColor.textSecondary)),
        ),
      ],
    ),
  );
}

/// Floating mini board (scale .62) with leader-line callouts for the two
/// topmost plates.
class _ExplodedView extends StatefulWidget {
  const _ExplodedView({required this.level, required this.theme, required this.reduced});

  final Level level;
  final BoardTheme theme;
  final bool reduced;

  @override
  State<_ExplodedView> createState() => _ExplodedViewState();
}

class _ExplodedViewState extends State<_ExplodedView> with SingleTickerProviderStateMixin {
  late final AnimationController _float = AnimationController(vsync: this, duration: const Duration(milliseconds: 1100));

  @override
  void initState() {
    super.initState();
    _sync();
  }

  @override
  void didUpdateWidget(_ExplodedView old) {
    super.didUpdateWidget(old);
    _sync();
  }

  void _sync() {
    if (widget.reduced) {
      _float
        ..stop()
        ..value = .5;
    } else if (!_float.isAnimating) {
      _float.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _float.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final level = widget.level;
    // Two topmost plates (highest depth first, later in list wins ties).
    final order = [...level.panels]
      ..sort((a, b) => b.depth != a.depth ? b.depth.compareTo(a.depth) : level.panels.indexOf(b).compareTo(level.panels.indexOf(a)));
    final callouts = order.take(2).toList();

    return LayoutBuilder(
      builder: (context, c) {
        final frame = math.min(201.0, c.maxHeight - 32);
        if (frame < 80) return const SizedBox.shrink();
        final scale = frame / BpSize.boardFrame;
        final play = BpSize.boardPlay * scale;
        final inset = BpSize.boardInset * scale;
        final top = (c.maxHeight - frame) / 2;
        const labelLeft = 234.0;
        final labelX = math.min(labelLeft, c.maxWidth - 102);

        var lastY = -100.0;
        final anchors = <(Panel, Offset)>[];
        for (final p in callouts) {
          final ax = p.isCircle ? p.cx + p.w / 2 : p.x + p.w;
          var ay = (p.isCircle ? p.cy : p.y + math.min(p.h / 2, 24)) * scale + inset;
          ay = math.max(ay, lastY + 70);
          lastY = ay;
          anchors.add((p, Offset(inset + ax * scale, ay)));
        }
        anchors.sort((a, b) => a.$2.dy.compareTo(b.$2.dy));

        return AnimatedBuilder(
          animation: _float,
          builder: (context, child) {
            final t = Curves.easeInOut.transform(_float.value);
            final dy = widget.reduced ? 0.0 : 3 - 9 * t;
            return Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  left: 0,
                  top: top + dy,
                  width: frame,
                  height: frame,
                  child: Padding(
                    padding: EdgeInsets.all(inset),
                    child: BpMiniBoard(level: level, size: play, theme: widget.theme),
                  ),
                ),
                for (var i = 0; i < anchors.length; i++) ...[
                  Positioned(
                    left: anchors[i].$2.dx,
                    top: top + dy + anchors[i].$2.dy,
                    width: math.max(0, labelX - 4 - anchors[i].$2.dx),
                    height: 1,
                    child: const ColoredBox(color: BpColor.lineMuted),
                  ),
                  Positioned(
                    left: anchors[i].$2.dx - 3.5,
                    top: top + dy + anchors[i].$2.dy - 3,
                    width: 7,
                    height: 7,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: i == 0 ? BpColor.action : BpColor.line,
                      ),
                    ),
                  ),
                  Positioned(
                    left: labelX,
                    top: top + dy + anchors[i].$2.dy - 10,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(anchors[i].$1.label, style: BpType.trayLabel.copyWith(letterSpacing: 0, height: 1.4, color: BpColor.line)),
                        Text(
                          l.fastenerCount(level.screws.where((s) => s.panelId == anchors[i].$1.id).length),
                          style: BpType.caption.copyWith(letterSpacing: 0, height: 1.4, color: BpColor.lineMuted),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            );
          },
        );
      },
    );
  }
}

class _TitleBlock extends StatelessWidget {
  const _TitleBlock({
    required this.nextCode,
    required this.chapterLabel,
    required this.chapterName,
    required this.done,
    required this.total,
    required this.ticks,
  });

  final String nextCode;
  final String chapterLabel;
  final String chapterName;
  final int done;
  final int total;
  final List<BpTick> ticks;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final small = BpType.caption.copyWith(fontSize: 9, letterSpacing: .9, color: BpColor.textMuted);
    const line = BorderSide(color: BpColor.lineDefault, width: BpSize.stroke);
    return BpOutlined(
      fill: BpColor.sheet,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(border: Border(right: line, bottom: line)),
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l.nextSheetLabel, style: small),
                        const SizedBox(height: 4),
                        Text(nextCode, style: BpType.title.copyWith(fontSize: 20, color: BpColor.line), maxLines: 1, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(border: Border(bottom: line)),
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(chapterLabel, style: small),
                        const SizedBox(height: 4),
                        Text(chapterName, style: BpType.button.copyWith(height: 1.25, color: BpColor.line)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(l.campaign, style: small),
                    const Spacer(),
                    Text(l.campaignProgress(done, total), style: small.copyWith(fontFeatures: const [FontFeature.tabularFigures()])),
                  ],
                ),
                const SizedBox(height: 8),
                BpTickStrip(states: ticks),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
