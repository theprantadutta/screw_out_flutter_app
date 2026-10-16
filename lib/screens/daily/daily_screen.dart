import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../core/theme/blueprint_tokens.dart';
import '../../game/domain/level.dart';
import '../../game/generator/daily.dart';
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

/// 06 — Daily sheet. Same sheet for everyone (date seed), works offline.
class DailyScreen extends StatelessWidget {
  const DailyScreen({super.key, this.now});

  /// Overridable clock for tests.
  final DateTime? now;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final today = now ?? DateTime.now();
    final repo = context.read<LevelRepository>();
    final progress = context.watch<ProgressCubit>().state;
    final reduced = context.watch<SettingsCubit>().state.reducedMotion;
    final level = repo.daily(today);
    final key = DailySheets.dateKey(today);
    final done = progress.dailyDone.contains(key);
    final streak = dailyStreak(progress.dailyDone, today);
    final theme = Cosmetics.resolve(progress.equippedTheme);

    return BpScreenScaffold(
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l.dailySheet, style: BpType.label.copyWith(letterSpacing: 1.1, color: BpColor.textSecondary)),
          const SizedBox(width: 12),
          BpIconButton(
            size: 44,
            iconSize: 22,
            icon: const Icon(Symbols.leaderboard_sharp),
            semanticLabel: l.todaysBoard,
            onPressed: () => context.push('${AppRoutes.leaderboard}?board=daily'),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, c) => SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(BpSpace.screen, 14, BpSpace.screen, bpBottom(context)),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: c.maxHeight - 14 - bpBottom(context)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BpCaption(
                            '${DateFormat('EEEE', locale).format(today).toUpperCase()} · ${today.year}',
                            size: 11,
                            spacing: .12,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            DateFormat('d MMM', locale).format(today),
                            style: BpType.hero.copyWith(fontSize: 52, letterSpacing: -2.08, color: BpColor.line, fontFeatures: const [FontFeature.tabularFigures()]),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(DailySheets.codeFor(today), style: BpType.label.copyWith(letterSpacing: .88, color: BpColor.action)),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                _WeekStrip(today: today, done: progress.dailyDone, locale: locale),
                const SizedBox(height: 20),
                _Framed(level: level, theme: theme, reduced: reduced),
                const SizedBox(height: 18),
                Text(l.dailyBody(streak), style: BpType.monoBody.copyWith(fontSize: 11, height: 1.6, color: BpColor.textSecondary)),
                const SizedBox(height: 28),
                if (done) ...[
                  Text(l.dailyCompleted, textAlign: TextAlign.center, style: BpType.label.copyWith(color: BpColor.success)),
                  const SizedBox(height: 12),
                ],
                BpPrimaryButton(
                  height: 60,
                  shadow: BpSize.hardShadowLarge,
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  onPressed: () => context.push(AppRoutes.dailyPlay),
                  child: Row(
                    children: [
                      Expanded(child: Text(done ? l.replayDaily : l.startDaily, style: BpType.button.copyWith(fontSize: 18, color: BpColor.ink))),
                      const Icon(Symbols.arrow_forward_sharp, size: 26),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WeekStrip extends StatelessWidget {
  const _WeekStrip({required this.today, required this.done, required this.locale});

  final DateTime today;
  final Set<int> done;
  final String locale;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final day = DateTime(today.year, today.month, today.day);
    final monday = day.subtract(Duration(days: day.weekday - 1));
    return Row(
      children: [
        for (var i = 0; i < 7; i++) ...[
          if (i > 0) const SizedBox(width: 6),
          Expanded(
            child: Builder(
              builder: (context) {
                final d = monday.add(Duration(days: i));
                final isDone = done.contains(DailySheets.dateKey(d));
                final isToday = d == day;
                final future = d.isAfter(day);
                Widget box;
                if (isDone) {
                  box = Container(
                    color: BpColor.line,
                    alignment: Alignment.center,
                    child: const Icon(Symbols.check_sharp, size: 20, weight: 700, color: BpColor.sheet),
                  );
                } else if (isToday) {
                  box = Container(
                    color: BpColor.action,
                    alignment: Alignment.center,
                    child: Text('${d.day}', style: BpType.button.copyWith(fontSize: 14, color: BpColor.ink, fontFeatures: const [FontFeature.tabularFigures()])),
                  );
                } else {
                  box = CustomPaint(
                    foregroundPainter: BpBorderPainter(color: future ? BpColor.lineFaint : BpColor.divider, dashed: future),
                  );
                }
                return Semantics(
                  label: '${DateFormat('EEEE d', locale).format(d)}${isDone ? ', ${l.dailyWeekDone}' : ''}',
                  child: Column(
                    children: [
                      Text(DateFormat('EEEEE', locale).format(d), style: BpType.caption.copyWith(letterSpacing: 0, color: BpColor.textMuted)),
                      const SizedBox(height: 6),
                      SizedBox(width: 36, height: 36, child: box),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}

/// Framed board preview (floating) + TITLE / PLATES / REWARD title block.
class _Framed extends StatefulWidget {
  const _Framed({required this.level, required this.theme, required this.reduced});

  final Level level;
  final BoardTheme theme;
  final bool reduced;

  @override
  State<_Framed> createState() => _FramedState();
}

class _FramedState extends State<_Framed> with SingleTickerProviderStateMixin {
  late final AnimationController _float = AnimationController(vsync: this, duration: const Duration(milliseconds: 1100));

  @override
  void initState() {
    super.initState();
    if (!widget.reduced) _float.repeat(reverse: true);
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
    final small = BpType.caption.copyWith(fontSize: 9, letterSpacing: .9, color: BpColor.textMuted);
    final value = BpType.button.copyWith(fontSize: 14, color: BpColor.line, fontFeatures: const [FontFeature.tabularFigures()]);
    const line = BorderSide(color: BpColor.lineDefault, width: BpSize.stroke);
    Widget cell(String label, String v, {Color? color, bool right = true}) => Container(
      decoration: BoxDecoration(border: right ? const Border(right: line) : null),
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: small),
          const SizedBox(height: 2),
          Text(v, style: value.copyWith(color: color), maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
    return BpOutlined(
      fill: BpColor.sheet,
      child: Column(
        children: [
          SizedBox(
            height: 244,
            child: AnimatedBuilder(
              animation: _float,
              builder: (context, child) => Transform.translate(
                offset: Offset(0, widget.reduced ? 0 : 3 - 9 * Curves.easeInOut.transform(_float.value)),
                child: child,
              ),
              child: Center(
                child: BpMiniBoard(level: level, size: 300 * .69, theme: widget.theme),
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(border: Border(top: line)),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(flex: 14, child: cell(l.dailyTitle, level.title)),
                  Expanded(flex: 10, child: cell(l.dailyPlates, l.platesScrews(level.panels.length, level.screws.length))),
                  Expanded(flex: 10, child: cell(l.dailyReward, '+${Rewards.daily}\u00a0¢', color: BpColor.action, right: false)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
