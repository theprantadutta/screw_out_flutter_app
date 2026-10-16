import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../core/theme/blueprint_tokens.dart';
import '../../game/generator/curriculum.dart';
import '../../l10n/app_localizations.dart';
import '../../presentation/bloc/progress/progress_cubit.dart';
import '../../router/routes.dart';
import '../../services/level_repository.dart';
import '../../services/progress_service.dart';
import '../../widgets/bp/bp_buttons.dart';
import '../../widgets/bp/bp_grid.dart';
import '../../widgets/bp/bp_screen.dart';

/// Downloads chapter packs past the bundled five. Null = not available yet
/// (the card reads MORE SHEETS SOON).
abstract interface class ChapterPacks {
  /// Chapters the server publishes that aren't installed (or are newer).
  Stream<Set<int>> get availableRemoteChapters;
  Future<void> refresh({bool force});
  Future<bool> downloadChapter(int chapter);
}

/// 04 — Campaign: one card per chapter.
class CampaignScreen extends StatefulWidget {
  const CampaignScreen({super.key, this.packs});

  /// Null (tests/offline builds): the card reads MORE SHEETS SOON.
  final ChapterPacks? packs;

  @override
  State<CampaignScreen> createState() => _CampaignScreenState();
}

class _CampaignScreenState extends State<CampaignScreen> {
  bool _downloading = false;
  Set<int> _remote = const {};
  StreamSubscription<Set<int>>? _sub;

  @override
  void initState() {
    super.initState();
    final packs = widget.packs;
    if (packs != null) {
      _sub = packs.availableRemoteChapters.listen((s) {
        if (mounted) setState(() => _remote = s);
      });
      unawaited(packs.refresh(force: true));
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final repo = context.read<LevelRepository>();
    final progress = context.watch<ProgressCubit>().state;
    final packs = repo.packs;
    final current = LevelRepository.chapterOf(progress.currentLevel);
    final nextChapter = repo.lastChapter + 1;
    String pad2(int n) => n.toString().padLeft(2, '0');

    return BpScreenScaffold(
      caption: l.theCampaign,
      title: packs.length == 5 ? l.fiveChapters : l.chaptersTitle,
      trailing: Text(
        l.sheetsCount(progress.totalCleared, repo.totalLevels),
        style: BpType.label.copyWith(letterSpacing: 1.1, color: BpColor.textSecondary, fontFeatures: const [FontFeature.tabularFigures()]),
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(BpSpace.screen, 20, BpSpace.screen, bpBottom(context, 40)),
        children: [
          for (final pack in packs) ...[
            _ChapterCard(
              number: pad2(pack.chapter),
              name: chapterInfo(pack.chapter, name: pack.name).name,
              goal: chapterInfo(pack.chapter, goal: pack.goal).goal,
              status: progress.clearedIn(pack.chapter) == pack.levels.length
                  ? _Status.done
                  : (pack.chapter == current ? _Status.active : (pack.chapter < current ? _Status.active : _Status.locked)),
              progress: l.chapterProgress(progress.clearedIn(pack.chapter), pack.levels.length),
              onTap: () {
                if (pack.chapter > current) {
                  showBpToast(context, l.finishChapterFirst(pad2(pack.chapter - 1)));
                } else {
                  context.push(AppRoutes.chapterPath(pack.chapter));
                }
              },
            ),
            const SizedBox(height: 12),
          ],
          _MoreSheetsCard(
            number: pad2(nextChapter),
            downloading: _downloading,
            // Only offered once the server actually publishes that chapter.
            onDownload: widget.packs == null || !_remote.contains(nextChapter)
                ? null
                : () async {
                    setState(() => _downloading = true);
                    final ok = await widget.packs!.downloadChapter(nextChapter);
                    if (!mounted) return;
                    setState(() => _downloading = false);
                    if (!ok) showBpToast(this.context, l.somethingWentWrong);
                  },
          ),
          const SizedBox(height: 32),
          Text(l.campaignFooter, style: BpType.monoBody.copyWith(fontSize: 11, height: 1.6, color: BpColor.textMuted)),
        ],
      ),
    );
  }
}

enum _Status { done, active, locked }

class _NumberTile extends StatelessWidget {
  const _NumberTile({required this.number});

  final String number;

  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: 58,
    child: CustomPaint(
      painter: const _HatchPainter(),
      foregroundPainter: const BpBorderPainter(color: BpColor.lineFaint, width: 1),
      child: Center(
        child: Text(number, style: BpType.title.copyWith(fontSize: 22, color: BpColor.line, fontFeatures: const [FontFeature.tabularFigures()])),
      ),
    ),
  );
}

class _ChapterCard extends StatelessWidget {
  const _ChapterCard({
    required this.number,
    required this.name,
    required this.goal,
    required this.status,
    required this.progress,
    required this.onTap,
  });

  final String number;
  final String name;
  final String goal;
  final _Status status;
  final String progress;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final locked = status == _Status.locked;
    final Widget icon = switch (status) {
      _Status.done => const Icon(Symbols.check_sharp, size: 20, weight: 700, color: BpColor.success),
      _Status.active => const Icon(Symbols.play_arrow_sharp, size: 20, fill: 1, color: BpColor.action),
      _Status.locked => const Icon(Symbols.lock_sharp, size: 18, color: BpColor.line),
    };
    return Semantics(
      button: true,
      label: '$number $name, ${locked ? l.lockedChapter : progress}',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          bpUiTick?.call();
          onTap();
        },
        child: Opacity(
          opacity: locked ? .6 : 1,
          child: CustomPaint(
            foregroundPainter: BpBorderPainter(
              color: status == _Status.active ? BpColor.action : BpColor.lineDefault,
              width: status == _Status.active ? BpSize.emphasis : BpSize.stroke,
            ),
            child: Container(
              color: BpColor.card,
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  _NumberTile(number: number),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name, style: BpType.cardTitle.copyWith(color: BpColor.line)),
                        const SizedBox(height: 3),
                        Text(goal, style: BpType.monoBody.copyWith(fontSize: 11, height: 1.3, color: BpColor.textMuted)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      icon,
                      const SizedBox(height: 4),
                      Text(
                        locked ? l.lockedChapter : progress,
                        style: BpType.trayLabel.copyWith(letterSpacing: .6, color: BpColor.lineDefault, fontFeatures: const [FontFeature.tabularFigures()]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Chapter 6+: downloadable drawing sets (or "MORE SHEETS SOON").
class _MoreSheetsCard extends StatelessWidget {
  const _MoreSheetsCard({required this.number, required this.downloading, this.onDownload});

  final String number;
  final bool downloading;
  final VoidCallback? onDownload;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return CustomPaint(
      foregroundPainter: const BpBorderPainter(color: BpColor.lineDashed, dashed: true),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Opacity(opacity: .6, child: _NumberTile(number: number)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l.moreSheetsTitle, style: BpType.cardTitle.copyWith(color: BpColor.textSecondary)),
                  const SizedBox(height: 3),
                  Text(
                    onDownload == null ? l.comingSoon : l.moreSheetsCaption,
                    style: BpType.monoBody.copyWith(fontSize: 11, height: 1.3, color: BpColor.textMuted),
                  ),
                ],
              ),
            ),
            if (onDownload != null) ...[
              const SizedBox(width: 8),
              BpOutlineButton(
                width: 112,
                height: 44,
                onPressed: downloading ? null : onDownload,
                child: Text(downloading ? l.downloading : l.downloadChapter, style: BpType.monoSmallButton.copyWith(fontSize: 10)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// 45° hatch, α .1, 7 dp period (chapter number tiles).
class _HatchPainter extends CustomPainter {
  const _HatchPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Offset.zero & size);
    final paint = Paint()
      ..color = BpColor.gridMajor
      ..strokeWidth = BpSize.stroke;
    const step = 7 * 1.4142;
    for (var c = -size.height; c < size.width + size.height; c += step) {
      canvas.drawLine(Offset(c, size.height), Offset(c + size.height, 0), paint);
    }
  }

  @override
  bool shouldRepaint(_HatchPainter oldDelegate) => false;
}

/// Exposed for the chapter map: which chapters are reachable.
bool chapterUnlocked(ProgressSnapshot p, int chapter) =>
    chapter <= LevelRepository.chapterOf(p.currentLevel);
