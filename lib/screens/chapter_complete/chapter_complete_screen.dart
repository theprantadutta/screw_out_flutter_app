import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../services/ports.dart';
import '../../core/theme/blueprint_tokens.dart';
import '../../game/generator/curriculum.dart';
import '../../l10n/app_localizations.dart';
import '../../presentation/bloc/progress/progress_cubit.dart';
import '../../presentation/bloc/settings/settings_cubit.dart';
import '../../router/routes.dart';
import '../../services/cosmetics.dart';
import '../../services/level_repository.dart';
import '../../services/progress_service.dart';
import '../../widgets/bp/bp_buttons.dart';
import '../../widgets/bp/bp_grid.dart';
import '../../widgets/bp/bp_screen.dart';

/// 12 — Chapter complete. Full screen, once per chapter. Ticks fill left →
/// right at a 30 ms stagger, then the bonus counts up once.
class ChapterCompleteScreen extends StatefulWidget {
  const ChapterCompleteScreen({super.key, required this.chapter});

  final int chapter;

  @override
  State<ChapterCompleteScreen> createState() => _ChapterCompleteScreenState();
}

class _ChapterCompleteScreenState extends State<ChapterCompleteScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _ticks = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 30 * kLevelsPerChapter + 200),
  );
  int _bonus = 0;
  Timer? _counter;

  @override
  void initState() {
    super.initState();
    // The fanfare: the motif, harmonised.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<SoundPort>().play(Sfx.chapter);
    });
    final reduced = context.read<SettingsCubit>().state.reducedMotion;
    if (reduced) {
      _ticks.value = 1;
      _bonus = Rewards.chapterBonus;
    } else {
      _ticks.forward().whenComplete(() {
        var step = 0;
        _counter = Timer.periodic(const Duration(milliseconds: 55), (t) {
          step++;
          if (!mounted) return t.cancel();
          setState(() => _bonus = (Rewards.chapterBonus * step / 10).round());
          if (step >= 10) t.cancel();
        });
      });
    }
  }

  @override
  void dispose() {
    _counter?.cancel();
    _ticks.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final repo = context.read<LevelRepository>();
    final progress = context.watch<ProgressCubit>().state;
    final chapter = widget.chapter;
    String pad2(int n) => n.toString().padLeft(2, '0');
    final info = chapterInfo(chapter, name: repo.pack(chapter)?.name);
    final next = chapter + 1;
    final hasNext = repo.hasChapter(next);
    final nextInfo = chapterInfo(next, name: repo.pack(next)?.name);
    final themeId = Cosmetics.chapterReward(chapter);
    final theme = themeId == null ? null : Cosmetics.byId(themeId);
    final total = repo.pack(chapter)?.levels.length ?? kLevelsPerChapter;
    final small = BpType.caption.copyWith(fontSize: 9, letterSpacing: 1.08, color: BpColor.textMuted);

    return BpGridBackground(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(BpSpace.screen, bpHeaderTop(context) + 18, BpSpace.screen, bpBottom(context)),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: MediaQuery.sizeOf(context).height - bpHeaderTop(context) - 18 - bpBottom(context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l.chapterComplete(pad2(chapter)), style: BpType.label.copyWith(letterSpacing: 1.54, color: BpColor.success)),
              const SizedBox(height: 10),
              Text('${info.name}.', style: BpType.hero.copyWith(fontSize: 54, letterSpacing: -2.43, color: BpColor.line)),
              const SizedBox(height: 22),
              AnimatedBuilder(
                animation: _ticks,
                builder: (context, _) {
                  final ms = _ticks.value * _ticks.duration!.inMilliseconds;
                  return BpTickStrip(
                    height: 14,
                    states: [
                      for (var i = 0; i < total; i++)
                        ms >= i * 30 && progress.isCleared((chapter - 1) * kLevelsPerChapter + i + 1)
                            ? BpTick.done
                            : BpTick.empty,
                    ],
                  );
                },
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(l.sheetsCount(progress.clearedIn(chapter), total), style: BpType.caption.copyWith(letterSpacing: .8, color: BpColor.textMuted)),
                  const Spacer(),
                  Text(l.masteredCount(progress.masteredIn(chapter)), style: BpType.caption.copyWith(letterSpacing: .8, color: BpColor.textMuted)),
                  const SizedBox(width: 6),
                  const BpDiamond(size: 10, color: BpColor.textMuted),
                ],
              ),
              const SizedBox(height: 34),
              BpOutlined(
                fill: BpColor.card,
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: const BoxDecoration(border: Border(right: BorderSide(color: BpColor.lineDefault, width: BpSize.stroke))),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(l.chapterBonus, style: small),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const BpCoinGlyph(size: 22, stroke: 3),
                                  const SizedBox(width: 8),
                                  Text('+$_bonus', style: BpType.reward.copyWith(fontSize: 28, color: BpColor.action)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(l.themeUnlocked, style: small),
                              const SizedBox(height: 8),
                              if (theme != null)
                                Row(
                                  children: [
                                    ThemeSwatch(theme: theme, size: 40),
                                    const SizedBox(width: 10),
                                    Expanded(child: Text(theme.name, style: BpType.body.copyWith(fontWeight: FontWeight.w700, fontVariations: const [FontVariation('wght', 700)], height: 1.2, color: BpColor.line))),
                                  ],
                                )
                              else
                                Text('—', style: BpType.body.copyWith(color: BpColor.textMuted)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),
              if (hasNext || next <= kBundledChapters)
                BpOutlined(
                  color: BpColor.lineDashed,
                  dashed: true,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l.nextChapter(pad2(next)), style: small),
                      const SizedBox(height: 6),
                      Text(nextInfo.name, style: BpType.stuckTitle.copyWith(color: BpColor.line)),
                      const SizedBox(height: 6),
                      Text(nextInfo.pitch, style: BpType.monoBody.copyWith(fontSize: 11, color: BpColor.textSecondary)),
                    ],
                  ),
                ),
              const SizedBox(height: 40),
              BpPrimaryButton(
                height: 60,
                shadow: BpSize.hardShadowLarge,
                padding: const EdgeInsets.symmetric(horizontal: 18),
                onPressed: () => context.go(hasNext ? AppRoutes.playPath((next - 1) * kLevelsPerChapter + 1) : AppRoutes.campaign),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        hasNext ? l.startChapter(pad2(next)) : l.sheets,
                        style: BpType.button.copyWith(fontSize: 17, color: BpColor.ink),
                      ),
                    ),
                    const Icon(Symbols.arrow_forward_sharp, size: 26),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              if (theme != null && progress.equippedTheme != theme.id)
                Center(
                  child: TextButtonLike(
                    label: l.equipTheme(theme.name.toUpperCase()),
                    onTap: () async {
                      await context.read<ProgressCubit>().equipTheme(theme.id);
                      if (context.mounted) showBpToast(context, l.themeEquippedToast(theme.name), kind: BpToastKind.success);
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Two-plate + screw theme swatch (cards on 12 and 14).
class ThemeSwatch extends StatelessWidget {
  const ThemeSwatch({super.key, required this.theme, required this.size, this.height});

  final BoardTheme theme;
  final double size;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final h = height ?? size;
    // Geometry from the 156 × 96 card swatch; small swatches use 40 × 40.
    final big = size >= 80;
    final sx = size / (big ? 156 : 40);
    final sy = h / (big ? 96 : 40);
    final p1 = big ? const Rect.fromLTWH(18, 16, 84, 44) : const Rect.fromLTWH(5, 6, 24, 16);
    final p2 = big ? const Rect.fromLTWH(46, 40, 84, 40) : const Rect.fromLTWH(12, 18, 24, 16);
    Rect sc(Rect r) => Rect.fromLTWH(r.left * sx, r.top * sy, r.width * sx, r.height * sy);
    return ClipRect(
      child: Container(
        width: size,
        height: h,
        color: theme.swatchBackground,
        child: Stack(
          children: [
            Positioned.fromRect(rect: sc(p1), child: _Plate(color: theme.plates.first, radius: big ? 10 : 4)),
            Positioned.fromRect(rect: sc(p2), child: _Plate(color: theme.plates.last, radius: big ? 10 : 4)),
            if (big) Positioned(left: 96 * sx, top: 46 * sy, width: 22, height: 22, child: _MiniScrew(theme: theme)),
          ],
        ),
      ),
    );
  }
}

class _Plate extends StatelessWidget {
  const _Plate({required this.color, required this.radius});

  final Color color;
  final double radius;

  @override
  Widget build(BuildContext context) =>
      DecoratedBox(decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(radius)));
}

class _MiniScrew extends StatelessWidget {
  const _MiniScrew({required this.theme});

  final BoardTheme theme;

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: theme.screwFill,
      border: Border.all(color: theme.screwLine, width: 2),
    ),
    child: Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(width: 12, height: 2, color: theme.screwLine),
          Container(width: 2, height: 12, color: theme.screwLine),
        ],
      ),
    ),
  );
}

/// Mono text action with a 48 dp tap target.
class TextButtonLike extends StatelessWidget {
  const TextButtonLike({super.key, required this.label, required this.onTap, this.color = BpColor.textSecondary});

  final String label;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    child: GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        bpUiTick?.call();
        onTap();
      },
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 48),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Text(label, style: BpType.label.copyWith(letterSpacing: 1.1, color: color)),
        ),
      ),
    ),
  );
}
