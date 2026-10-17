import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../core/theme/blueprint_tokens.dart';
import '../../game/domain/level.dart';
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
import '../../widgets/bp/bp_mini_board.dart';
import '../../widgets/bp/bp_screen.dart';

/// 05 - Chapter map: serpentine path of 20 nodes (3 per row), auto-scrolled
/// to the current sheet, with a preview card for the selected sheet.
class ChapterMapScreen extends StatefulWidget {
  const ChapterMapScreen({super.key, required this.chapter});

  final int chapter;

  @override
  State<ChapterMapScreen> createState() => _ChapterMapScreenState();
}

class _ChapterMapScreenState extends State<ChapterMapScreen> {
  late int _chapter = widget.chapter;
  int? _selected;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final repo = context.read<LevelRepository>();
    final progress = context.watch<ProgressCubit>().state;
    final reduced = context.watch<SettingsCubit>().state.reducedMotion;
    final pack = repo.pack(_chapter);
    String pad2(int n) => n.toString().padLeft(2, '0');
    if (pack == null) return BpScreenScaffold(body: const SizedBox.shrink(), title: '');
    final info = chapterInfo(_chapter, name: pack.name);
    final current = progress.currentLevel;
    final inChapter = current >= pack.firstLevel && current <= pack.lastLevel;
    final selectedId = _selected ?? (inChapter ? current : pack.firstLevel);
    final selected = repo.level(selectedId);
    final theme = Cosmetics.resolve(progress.equippedTheme);

    return BpScreenScaffold(
      caption: l.chapterLabel(pad2(_chapter)),
      title: info.name,
      trailing: Text(
        l.sheetsCount(progress.clearedIn(_chapter), pack.levels.length),
        style: BpType.label.copyWith(letterSpacing: 1.1, color: BpColor.textSecondary, fontFeatures: const [FontFeature.tabularFigures()]),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          SizedBox(
            height: 30,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: BpSpace.screen),
              itemCount: repo.chapterCount,
              separatorBuilder: (_, _) => const SizedBox(width: 6),
              itemBuilder: (context, i) {
                final c = repo.packs[i].chapter;
                final width = (MediaQuery.sizeOf(context).width - 2 * BpSpace.screen - 24) / 5;
                return _ChapterChip(
                  width: math.max(width, 48),
                  label: pad2(c),
                  done: progress.clearedIn(c) == repo.packs[i].levels.length,
                  selected: c == _chapter,
                  locked: c > LevelRepository.chapterOf(current),
                  onTap: () {
                    if (c > LevelRepository.chapterOf(current)) {
                      showBpToast(context, l.finishChapterFirst(pad2(c - 1)));
                      return;
                    }
                    setState(() {
                      _chapter = c;
                      _selected = null;
                    });
                  },
                );
              },
            ),
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: BpMotion.feedback,
              child: _NodeMap(
                key: ValueKey(_chapter),
                levels: pack.levels,
                progress: progress,
                selectedId: selectedId,
                reduced: reduced,
                onSelect: (id) => setState(() => _selected = id),
              ),
            ),
          ),
          if (selected != null)
            Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, bpBottom(context, 30)),
              child: _PreviewCard(
                level: selected,
                theme: theme,
                newMechanic: _newMechanic(repo, selected),
                playable: progress.isUnlocked(selected.id),
              ),
            ),
        ],
      ),
    );
  }

  /// Mechanic tags this sheet is the first to use (campaign order).
  static String? _newMechanic(LevelRepository repo, Level level) {
    final seen = <String>{};
    for (var id = 1; id < level.id; id++) {
      seen.addAll(repo.level(id)?.mechanics ?? const []);
    }
    for (final m in level.mechanics) {
      if (!seen.contains(m) && kMechanicLabels.containsKey(m)) return kMechanicLabels[m];
    }
    return null;
  }
}

class _ChapterChip extends StatelessWidget {
  const _ChapterChip({
    required this.width,
    required this.label,
    required this.done,
    required this.selected,
    required this.locked,
    required this.onTap,
  });

  final double width;
  final String label;
  final bool done;
  final bool selected;
  final bool locked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final text = BpType.label.copyWith(
      letterSpacing: 0,
      color: selected ? BpColor.sheet : (locked ? BpColor.lineDashed : BpColor.textSecondary),
      fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
    );
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: SizedBox(
          width: width,
          child: CustomPaint(
            foregroundPainter: selected
                ? null
                : BpBorderPainter(color: locked ? BpColor.divider : BpColor.lineFaint, dashed: locked),
            child: Container(
              color: selected ? BpColor.line : null,
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(label, style: text),
                  if (done && !selected) ...[
                    const SizedBox(width: 4),
                    Icon(Symbols.check_sharp, size: 14, weight: 700, color: text.color),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Serpentine nodes: rows of 3 (118 dp pitch, 92 dp rows), alternate rows
/// run right → left. Links solid up to the current node, dashed after.
class _NodeMap extends StatefulWidget {
  const _NodeMap({
    super.key,
    required this.levels,
    required this.progress,
    required this.selectedId,
    required this.reduced,
    required this.onSelect,
  });

  final List<Level> levels;
  final ProgressSnapshot progress;
  final int selectedId;
  final bool reduced;
  final ValueChanged<int> onSelect;

  @override
  State<_NodeMap> createState() => _NodeMapState();
}

class _NodeMapState extends State<_NodeMap> with SingleTickerProviderStateMixin {
  static const _pitch = 118.0;
  static const _row = 92.0;
  static const _node = 56.0;
  static const _top = 24.0;
  final _scroll = ScrollController();
  late final AnimationController _pulse = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
  Timer? _pulseTimer;

  @override
  void initState() {
    super.initState();
    if (!widget.reduced) {
      _pulse.forward();
      _pulseTimer = Timer.periodic(const Duration(milliseconds: 2200), (_) => _pulse.forward(from: 0));
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToCurrent());
  }

  void _scrollToCurrent() {
    if (!_scroll.hasClients) return;
    final idx = widget.levels.indexWhere((l) => l.id == widget.progress.currentLevel);
    if (idx < 0) return;
    final y = _top + (idx ~/ 3) * _row - _scroll.position.viewportDimension / 2 + _node / 2;
    _scroll.jumpTo(y.clamp(0.0, _scroll.position.maxScrollExtent));
  }

  @override
  void dispose() {
    _pulseTimer?.cancel();
    _pulse.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Offset _center(int i, double width) {
    final row = i ~/ 3;
    var col = i % 3;
    if (row.isOdd) col = 2 - col;
    return Offset(width / 2 + (col - 1) * _pitch, _top + row * _row + _node / 2);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final levels = widget.levels;
    final current = widget.progress.currentLevel;
    final rows = (levels.length + 2) ~/ 3;
    return LayoutBuilder(
      builder: (context, c) {
        final w = c.maxWidth;
        final centers = [for (var i = 0; i < levels.length; i++) _center(i, w)];
        return SingleChildScrollView(
          controller: _scroll,
          child: SizedBox(
            height: _top * 2 + (rows - 1) * _row + _node,
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: _LinksPainter(
                      centers: centers,
                      solidUntil: levels.indexWhere((x) => x.id >= current),
                      allDone: levels.every((x) => widget.progress.isCleared(x.id)),
                    ),
                  ),
                ),
                for (var i = 0; i < levels.length; i++)
                  Positioned(
                    left: centers[i].dx - _node / 2,
                    top: centers[i].dy - _node / 2,
                    width: _node,
                    height: _node,
                    child: _Node(
                      number: levels[i].id,
                      done: widget.progress.isCleared(levels[i].id),
                      mastered: widget.progress.isMastered(levels[i].id),
                      current: levels[i].id == current,
                      selected: levels[i].id == widget.selectedId,
                      pulse: _pulse,
                      reduced: widget.reduced,
                      lockedLabel: l.lockedLevel(levels[i].id),
                      onTap: widget.progress.isUnlocked(levels[i].id) ? () => widget.onSelect(levels[i].id) : null,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _LinksPainter extends CustomPainter {
  _LinksPainter({required this.centers, required this.solidUntil, required this.allDone});

  final List<Offset> centers;

  /// Index of the current node; links before it are solid.
  final int solidUntil;
  final bool allDone;

  @override
  void paint(Canvas canvas, Size size) {
    final solid = Paint()
      ..color = BpColor.line
      ..strokeWidth = 2;
    final dashed = Paint()
      ..color = BpColor.lineFaint
      ..strokeWidth = 2;
    for (var i = 0; i + 1 < centers.length; i++) {
      final a = centers[i];
      final b = centers[i + 1];
      if (allDone || (solidUntil >= 0 && i < solidUntil)) {
        canvas.drawLine(a, b, solid);
      } else {
        final len = (b - a).distance;
        final dir = (b - a) / len;
        for (var d = 0.0; d < len; d += 12) {
          canvas.drawLine(a + dir * d, a + dir * math.min(d + 6, len), dashed);
        }
      }
    }
  }

  @override
  bool shouldRepaint(_LinksPainter old) => old.solidUntil != solidUntil || old.centers != centers;
}

class _Node extends StatelessWidget {
  const _Node({
    required this.number,
    required this.done,
    required this.mastered,
    required this.current,
    required this.selected,
    required this.pulse,
    required this.reduced,
    required this.lockedLabel,
    this.onTap,
  });

  final int number;
  final bool done;
  final bool mastered;
  final bool current;
  final bool selected;
  final Animation<double> pulse;
  final bool reduced;
  final String lockedLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (current) {
      child = Stack(
        clipBehavior: Clip.none,
        children: [
          if (!reduced)
            Positioned.fill(
              child: AnimatedBuilder(
                animation: pulse,
                builder: (context, _) => Transform.scale(
                  scale: 1 + .35 * Curves.easeOut.transform(pulse.value),
                  child: Opacity(
                    opacity: (.9 * (1 - Curves.easeOut.transform(pulse.value))).clamp(0.0, 1.0),
                    child: const CustomPaint(painter: BpBorderPainter(color: BpColor.action, width: 2, circle: true)),
                  ),
                ),
              ),
            ),
          Container(
            decoration: const BoxDecoration(color: BpColor.action, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Text('$number', style: BpType.title.copyWith(fontSize: 20, color: BpColor.ink, fontFeatures: const [FontFeature.tabularFigures()])),
          ),
        ],
      );
    } else if (done) {
      child = Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
              color: BpColor.line,
              shape: BoxShape.circle,
              border: selected ? Border.all(color: BpColor.action, width: 2) : null,
            ),
            alignment: Alignment.center,
            child: Text('$number', style: BpType.title.copyWith(fontSize: 18, color: BpColor.sheet, fontFeatures: const [FontFeature.tabularFigures()])),
          ),
          Positioned(
            right: -2,
            bottom: -2,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: BpColor.sheet,
                shape: BoxShape.circle,
                border: Border.all(color: BpColor.line, width: BpSize.stroke),
              ),
              child: const Icon(Symbols.check_sharp, size: 14, weight: 700, color: BpColor.line),
            ),
          ),
          if (mastered) const Positioned(top: -6, right: 0, child: BpDiamond(size: 14)),
        ],
      );
    } else {
      child = CustomPaint(
        foregroundPainter: const BpBorderPainter(color: BpColor.lineDashed, dashed: true, circle: true),
        child: Container(
          decoration: const BoxDecoration(color: BpColor.sheet, shape: BoxShape.circle),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Symbols.lock_sharp, size: 14, color: BpColor.lineMuted),
              Text('$number', style: BpType.label.copyWith(fontSize: 12, letterSpacing: 0, color: BpColor.lineMuted)),
            ],
          ),
        ),
      );
    }
    return Semantics(
      button: onTap != null,
      label: onTap == null ? lockedLabel : codeFor(number),
      child: GestureDetector(behavior: HitTestBehavior.opaque, onTap: onTap, child: child),
    );
  }
}

class _PreviewCard extends StatelessWidget {
  const _PreviewCard({
    required this.level,
    required this.theme,
    required this.newMechanic,
    required this.playable,
  });

  final Level level;
  final BoardTheme theme;
  final String? newMechanic;
  final bool playable;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final head = newMechanic == null ? level.code : '${level.code} · ${l.newMechanic(newMechanic!)}';
    return BpOutlined(
      fill: BpColor.card,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          SizedBox.square(
            dimension: 64,
            child: BpOutlined(
              color: BpColor.lineFaint,
              width: 1,
              child: Center(child: BpMiniBoard(level: level, size: 56, theme: theme, screws: false)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(head, style: BpType.caption.copyWith(letterSpacing: 1, color: BpColor.action)),
                const SizedBox(height: 4),
                Text(level.title, style: BpType.title.copyWith(fontSize: 18, color: BpColor.line), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text(
                  l.sheetMeta(level.panels.length, layerCount(level), level.trayCapacity),
                  style: BpType.monoBody.copyWith(fontSize: 11, height: 1.4, color: BpColor.textMuted),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          SizedBox.square(
            dimension: 52,
            child: BpPrimaryButton(
              height: 52,
              shadow: 0,
              padding: EdgeInsets.zero,
              semanticLabel: l.playLevel(level.code),
              onPressed: playable ? () => context.push(AppRoutes.playPath(level.id)) : null,
              child: const Icon(Symbols.play_arrow_sharp, size: 30, fill: 1),
            ),
          ),
        ],
      ),
    );
  }
}
