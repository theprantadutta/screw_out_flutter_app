import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../core/theme/blueprint_tokens.dart';
import '../presentation/bloc/progress/progress_cubit.dart';
import '../screens/campaign/campaign_screen.dart';
import '../screens/chapter_complete/chapter_complete_screen.dart';
import '../screens/chapter_map/chapter_map_screen.dart';
import '../screens/daily/daily_screen.dart';
import '../screens/gameplay/gameplay_route.dart';
import '../screens/home/home_screen.dart';
import '../screens/licenses/licenses_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/themes/themes_screen.dart';
import '../services/level_repository.dart';
import 'routes.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

/// Flat route table (snake pattern). Every route has a `name` for
/// analytics/screen views.
///
/// * [ready] — bootstrap future the splash waits for.
/// * [downloadChapter] — downloads chapter packs past the bundled five;
///   null until the API integration provides it (campaign shows
///   MORE SHEETS SOON).
GoRouter createAppRouter({
  required Future<void> ready,
  List<NavigatorObserver> observers = const [],
  ChapterDownloader? downloadChapter,
  String initialLocation = AppRoutes.splash,
}) => GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: initialLocation,
  observers: observers,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      name: 'splash',
      pageBuilder: (context, state) => NoTransitionPage(key: state.pageKey, name: 'splash', child: SplashScreen(ready: ready)),
    ),
    GoRoute(
      path: AppRoutes.home,
      name: 'home',
      pageBuilder: (context, state) => _fade(state, const HomeScreen()),
    ),
    GoRoute(
      path: AppRoutes.campaign,
      name: 'campaign',
      pageBuilder: (context, state) => _slide(state, CampaignScreen(downloadChapter: downloadChapter)),
    ),
    GoRoute(
      path: AppRoutes.chapter,
      name: 'chapter',
      pageBuilder: (context, state) =>
          _slide(state, ChapterMapScreen(chapter: int.tryParse(state.pathParameters['chapter'] ?? '') ?? 1)),
    ),
    GoRoute(
      path: AppRoutes.play,
      name: 'play',
      redirect: (context, state) {
        final id = int.tryParse(state.pathParameters['level'] ?? '');
        final progress = context.read<ProgressCubit>().state;
        final repo = context.read<LevelRepository>();
        if (id == null) return AppRoutes.home;
        if (id > repo.totalLevels) return AppRoutes.campaign;
        // Locked sheets redirect to the current one.
        if (!progress.isUnlocked(id)) return AppRoutes.playPath(progress.currentLevel);
        return null;
      },
      // One stable page key: moving to the next sheet updates in place.
      pageBuilder: (context, state) => _slide(
        state,
        GameplayRoute(levelId: int.tryParse(state.pathParameters['level'] ?? '')),
        key: const ValueKey('play'),
      ),
    ),
    GoRoute(
      path: AppRoutes.daily,
      name: 'daily',
      pageBuilder: (context, state) => _slide(state, const DailyScreen()),
    ),
    GoRoute(
      path: AppRoutes.dailyPlay,
      name: 'daily_play',
      pageBuilder: (context, state) => _slide(state, const GameplayRoute(daily: true)),
    ),
    GoRoute(
      path: AppRoutes.chapterComplete,
      name: 'chapter_complete',
      pageBuilder: (context, state) =>
          _fade(state, ChapterCompleteScreen(chapter: int.tryParse(state.pathParameters['chapter'] ?? '') ?? 1)),
    ),
    GoRoute(
      path: AppRoutes.themes,
      name: 'themes',
      pageBuilder: (context, state) => _slide(state, const ThemesScreen()),
    ),
    GoRoute(
      path: AppRoutes.settings,
      name: 'settings',
      pageBuilder: (context, state) => _slide(state, const SettingsScreen()),
    ),
    GoRoute(
      path: AppRoutes.licenses,
      name: 'licenses',
      pageBuilder: (context, state) => _slide(state, const LicensesScreen()),
    ),
  ],
);

/// Push: slide 24 px from the right + fade, 240 ms standardOut; pop reverses.
CustomTransitionPage<void> _slide(GoRouterState state, Widget child, {LocalKey? key}) => CustomTransitionPage<void>(
  key: key ?? state.pageKey,
  name: state.name,
  child: child,
  transitionDuration: BpMotion.navigation,
  reverseTransitionDuration: BpMotion.navigation,
  transitionsBuilder: (context, animation, secondary, child) {
    if (MediaQuery.disableAnimationsOf(context)) {
      return FadeTransition(opacity: animation, child: child);
    }
    final curved = CurvedAnimation(parent: animation, curve: BpMotion.standardOut, reverseCurve: BpMotion.standardIn);
    return AnimatedBuilder(
      animation: curved,
      builder: (context, c) => Opacity(
        opacity: curved.value.clamp(0.0, 1.0),
        child: Transform.translate(offset: Offset(24 * (1 - curved.value), 0), child: c),
      ),
      child: child,
    );
  },
);

/// Cross-fade (splash → home, 200 ms; chapter complete).
CustomTransitionPage<void> _fade(GoRouterState state, Widget child) => CustomTransitionPage<void>(
  key: state.pageKey,
  name: state.name,
  child: child,
  transitionDuration: const Duration(milliseconds: 200),
  reverseTransitionDuration: const Duration(milliseconds: 200),
  transitionsBuilder: (context, animation, secondary, child) => FadeTransition(opacity: animation, child: child),
);
