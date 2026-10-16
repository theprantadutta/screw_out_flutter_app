import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart' as material_ui;

import 'core/di/injection.dart';
import 'core/theme/app_theme.dart';
import 'l10n/app_localizations.dart';
import 'presentation/bloc/auth/auth_cubit.dart';
import 'presentation/bloc/display/display_cubit.dart';
import 'presentation/bloc/premium/premium_cubit.dart';
import 'presentation/bloc/progress/progress_cubit.dart';
import 'presentation/bloc/settings/settings_cubit.dart';
import 'services/leaderboard_service.dart';
import 'services/level_repository.dart';
import 'services/ports.dart';
import 'services/progress_service.dart';
import 'widgets/bp/bp_tablet_scale.dart';

/// Root widget. Provider contract for every screen:
///
/// * Blocs: [SettingsCubit], [ProgressCubit], [PremiumCubit], [AuthCubit],
///   [DisplayCubit].
/// * Repositories: [LevelRepository], [ProgressService], [AdsPort],
///   [AnalyticsPort], [PurchasesPort], [SoundPort].
class ScrewOutApp extends StatelessWidget {
  const ScrewOutApp({super.key, required this.router});

  final GoRouter router;

  @override
  Widget build(BuildContext context) => MultiRepositoryProvider(
    providers: [
      RepositoryProvider<LevelRepository>.value(value: getIt<LevelRepository>()),
      RepositoryProvider<ProgressService>.value(value: getIt<ProgressService>()),
      RepositoryProvider<AdsPort>.value(value: getIt<AdsPort>()),
      RepositoryProvider<AnalyticsPort>.value(value: getIt<AnalyticsPort>()),
      RepositoryProvider<PurchasesPort>.value(value: getIt<PurchasesPort>()),
      RepositoryProvider<SoundPort>.value(value: getIt<SoundPort>()),
      RepositoryProvider<LeaderboardPort>.value(value: getIt<LeaderboardPort>()),
    ],
    child: MultiBlocProvider(
      providers: [
        BlocProvider<SettingsCubit>.value(value: getIt<SettingsCubit>()),
        BlocProvider<ProgressCubit>.value(value: getIt<ProgressCubit>()),
        BlocProvider<PremiumCubit>.value(value: getIt<PremiumCubit>()),
        BlocProvider<AuthCubit>.value(value: getIt<AuthCubit>()),
        BlocProvider<DisplayCubit>.value(value: getIt<DisplayCubit>()),
      ],
      child: BlocBuilder<SettingsCubit, SettingsState>(
        buildWhen: (a, b) => a.localeCode != b.localeCode,
        builder: (context, settings) => MaterialApp.router(
          title: 'Screw Out',
          debugShowCheckedModeBanner: false,
          theme: buildAppTheme(),
          routerConfig: router,
          locale: settings.localeCode == null ? null : Locale(settings.localeCode!),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            ...material_ui.GlobalMaterialLocalizations.delegates,
          ],
          builder: (context, child) {
            // Text scale: honour the OS within a range the layout survives.
            final mq = MediaQuery.of(context);
            final scale = mq.textScaler.scale(1).clamp(0.9, 1.3);
            return MediaQuery(
              data: mq.copyWith(textScaler: TextScaler.linear(scale)),
              child: BpTabletScale(child: child!),
            );
          },
        ),
      ),
    ),
  );
}
