import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/blueprint_tokens.dart';
import '../../game/domain/level.dart';
import '../../l10n/app_localizations.dart';
import '../../presentation/bloc/game/game_cubit.dart';
import '../../presentation/bloc/premium/premium_cubit.dart';
import '../../presentation/bloc/progress/progress_cubit.dart';
import '../../presentation/bloc/settings/settings_cubit.dart';
import '../../router/routes.dart';
import '../../services/app_game_host.dart';
import '../../services/cosmetics.dart';
import '../../services/level_repository.dart';
import '../../services/ports.dart';
import '../../services/progress_service.dart';
import '../../widgets/bp/bp_grid.dart';
import 'gameplay_screen.dart';
import 'widgets/tutorial_overlay.dart';

/// `/play/:level` and `/daily/play`. Loads the sheet, resumes a saved
/// position, and swaps to the next sheet *in place* (MOTION_SPEC §7: board
/// out 180 ms, new board in) - the page itself never re-transitions.
class GameplayRoute extends StatefulWidget {
  const GameplayRoute({super.key, this.levelId, this.daily = false});

  final int? levelId;
  final bool daily;

  @override
  State<GameplayRoute> createState() => _GameplayRouteState();
}

class _GameplayRouteState extends State<GameplayRoute> {
  Level? _level;
  GameCubit? _cubit;
  int _session = 0;
  bool _visible = true;
  bool _tutorial = false;
  StreamSubscription<GameSessionState>? _tutorialSub;

  @override
  void initState() {
    super.initState();
    _start(widget.levelId, resume: true);
  }

  @override
  void didUpdateWidget(GameplayRoute old) {
    super.didUpdateWidget(old);
    if (old.levelId != widget.levelId || old.daily != widget.daily) {
      unawaited(_transitionTo(widget.levelId));
    }
  }

  Future<void> _transitionTo(int? id) async {
    final reduced = context.read<SettingsCubit>().state.reducedMotion;
    setState(() => _visible = false);
    await Future<void>.delayed(reduced ? BpMotion.reduced : BpMotion.transitionOut);
    if (!mounted) return;
    await _start(id, resume: true);
    if (mounted) setState(() => _visible = true);
  }

  Future<void> _start(int? id, {required bool resume}) async {
    final repo = context.read<LevelRepository>();
    final progressService = context.read<ProgressService>();
    final settings = context.read<SettingsCubit>();
    final analytics = context.read<AnalyticsPort>();
    final host = AppGameHost(
      progress: progressService,
      progressCubit: context.read<ProgressCubit>(),
      premium: context.read<PremiumCubit>(),
      ads: context.read<AdsPort>(),
      analytics: analytics,
    );
    final level = widget.daily ? repo.daily(DateTime.now()) : (id == null ? null : repo.level(id));
    if (level == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.go(AppRoutes.campaign);
      });
      return;
    }
    final saved = resume ? await progressService.savedGame(level.id) : null;
    if (!mounted) return;
    final old = _cubit;
    await _tutorialSub?.cancel();
    final cubit = GameCubit(level: level, host: host, resume: saved, isDaily: widget.daily);
    final showTutorial = level.id == 1 && !widget.daily && !settings.state.tutorialDone && (saved == null || saved.state.moves == 0);
    if (showTutorial) {
      analytics.track('tutorial_started');
      _tutorialSub = cubit.stream.listen((s) {
        if (s.moves > 0 && _tutorial) _endTutorial();
      });
    }
    setState(() {
      _level = level;
      _cubit = cubit;
      _session++;
      _tutorial = showTutorial;
    });
    await old?.close();
  }

  void _endTutorial() {
    context.read<SettingsCubit>().markTutorialDone();
    context.read<AnalyticsPort>().track('tutorial_completed');
    if (mounted) setState(() => _tutorial = false);
  }

  @override
  void dispose() {
    _tutorialSub?.cancel();
    _cubit?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final level = _level;
    final cubit = _cubit;
    if (level == null || cubit == null) return const BpGridBackground();
    final repo = context.read<LevelRepository>();
    final ads = context.read<AdsPort>();
    final next = widget.daily ? null : repo.level(level.id + 1);
    final reduced = context.watch<SettingsCubit>().state.reducedMotion;
    final progress = context.watch<ProgressCubit>().state;

    void afterResult() => unawaited(ads.maybeShowInterstitial(levelId: level.id));

    final callbacks = GameplayCallbacks(
      nextLabel: widget.daily ? l.backHome : (next != null ? l.nextSheet(next.code) : l.sheets),
      onExit: () => context.go(widget.daily ? AppRoutes.home : AppRoutes.chapterPath(level.chapter)),
      onReplay: () {
        afterResult();
        unawaited(_start(level.id, resume: false));
      },
      onNext: (reward) {
        afterResult();
        if (widget.daily) {
          context.go(AppRoutes.home);
        } else if (reward?.chapterCompleted != null) {
          context.go(AppRoutes.chapterCompletePath(reward!.chapterCompleted!));
        } else if (next != null) {
          context.go(AppRoutes.playPath(next.id));
        } else {
          context.go(AppRoutes.campaign);
        }
      },
    );

    return AnimatedOpacity(
      opacity: _visible ? 1 : 0,
      duration: reduced ? BpMotion.reduced : BpMotion.transitionOut,
      curve: BpMotion.standardIn,
      child: BlocProvider<GameCubit>.value(
        key: ValueKey('${level.id}-$_session'),
        value: cubit,
        child: GameplayScreen(
          key: ValueKey('screen-${level.id}-$_session'),
          coins: progress.coins,
          callbacks: callbacks,
          feedback: AppGameFeedback(context.read<SettingsCubit>(), context.read<SoundPort>()),
          adAvailable: ads.rewardedAvailable,
          theme: Cosmetics.resolve(progress.equippedTheme),
          tutorial: _tutorial
              ? (visuals) => TutorialOverlay(
                  visuals: visuals,
                  screwId: level.screws.first.id,
                  reducedMotion: reduced,
                  onSkip: _endTutorial,
                )
              : null,
        ),
      ),
    );
  }
}
