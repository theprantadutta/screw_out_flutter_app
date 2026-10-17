import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

import '../../data/database/app_database.dart';
import '../../presentation/bloc/display/display_cubit.dart';
import '../../presentation/bloc/auth/auth_cubit.dart';
import '../../presentation/bloc/premium/premium_cubit.dart';
import '../../presentation/bloc/progress/progress_cubit.dart';
import '../../presentation/bloc/settings/settings_cubit.dart';
import '../../services/audio/audio_service.dart';
import '../../services/leaderboard_service.dart';
import '../../services/ads/ad_service.dart';
import '../../services/analytics/analytics.dart';
import '../../services/analytics/telemetry.dart';
import '../../services/level_pack_service.dart';
import '../../services/level_repository.dart';
import '../../services/notifications/notification_service.dart';
import '../../services/ports.dart';
import '../../services/progress_service.dart';
import '../../services/purchases/purchase_service.dart';
import '../../services/storage_service.dart';
import '../../services/sync/sync_engine.dart';
import '../../services/user_service.dart';
import '../network/api_service.dart';
import '../network/connectivity_service.dart';

final getIt = GetIt.instance;

/// Registers everything (snake-classic order: database → network → domain
/// services → platform services → cubits). Constructor injection only - no
/// `getIt` inside methods. Registration is synchronous; async start-up work
/// lives in `bootstrapServices()` (main.dart).
///
/// [firebase] is false when Firebase could not initialise (desktop, tests,
/// a broken google-services config): Firebase-backed clients are skipped.
void configureDependencies({required bool firebase, AppDatabase? database}) {
  if (getIt.isRegistered<AppDatabase>()) return;

  // Data.
  getIt.registerSingleton<AppDatabase>(database ?? AppDatabase(), dispose: (db) => db.close());

  // Network.
  getIt
    ..registerLazySingleton<ConnectivityService>(ConnectivityService.new)
    ..registerLazySingleton<ApiService>(() => ApiService(getIt<ConnectivityService>()));

  // Domain services.
  getIt
    ..registerLazySingleton<LevelRepository>(() => LevelRepository(getIt<AppDatabase>()))
    ..registerLazySingleton<ProgressService>(() => ProgressService(getIt<AppDatabase>()))
    ..registerLazySingleton<SyncEngine>(
      () => SyncEngine(getIt<AppDatabase>(), getIt<ApiService>(), getIt<ConnectivityService>()),
    )
    ..registerLazySingleton<LevelPackService>(() => LevelPackService(getIt<ApiService>(), getIt<LevelRepository>()))
    ..registerLazySingleton<LeaderboardPort>(() => LeaderboardService(getIt<ApiService>()));

  // Analytics: Firebase in release, console in debug, plus backend telemetry.
  getIt
    ..registerLazySingleton<TelemetryRecorder>(() => TelemetryRecorder(getIt<AppDatabase>()))
    ..registerLazySingleton<TelemetryUploader>(
      () => TelemetryUploader(getIt<AppDatabase>(), getIt<ApiService>(), getIt<TelemetryRecorder>()),
    )
    ..registerLazySingleton<AnalyticsPort>(
      () => AnalyticsFacade([
        if (kDebugMode) DebugAnalyticsClient() else if (firebase) FirebaseAnalyticsClient(),
        getIt<TelemetryRecorder>(),
      ]),
    );

  // Cubits (app-wide singletons).
  getIt
    ..registerLazySingleton<SettingsCubit>(() => SettingsCubit(DriftSettingsStore(getIt<AppDatabase>())))
    ..registerLazySingleton<ProgressCubit>(() => ProgressCubit(getIt<ProgressService>()))
    ..registerLazySingleton<PremiumCubit>(() => PremiumCubit(getIt<AppDatabase>()))
    ..registerLazySingleton<DisplayCubit>(() => DisplayCubit(DriftDisplayPreferenceStore(getIt<AppDatabase>())));

  // Accounts.
  getIt
    ..registerLazySingleton<UserService>(
      () => UserService(api: getIt<ApiService>(), db: getIt<AppDatabase>(), sync: getIt<SyncEngine>()),
    )
    ..registerLazySingleton<AuthCubit>(() => AuthCubit(firebase ? getIt<UserService>() : GuestAuth()));

  // Platform services behind the UI ports.
  getIt
    ..registerLazySingleton<AdService>(
      () => AdService(premium: getIt<PremiumCubit>(), analytics: getIt<AnalyticsPort>()),
    )
    ..registerLazySingleton<AdsPort>(() => getIt<AdService>())
    ..registerLazySingleton<PurchaseService>(
      () => PurchaseService(
        api: getIt<ApiService>(),
        user: getIt<UserService>(),
        premium: getIt<PremiumCubit>(),
        progress: getIt<ProgressService>(),
        db: getIt<AppDatabase>(),
        analytics: getIt<AnalyticsPort>(),
        onPurchaseFlowStarted: () => getIt<AdService>().suppressNextAppOpen(),
      ),
    )
    ..registerLazySingleton<PurchasesPort>(() => getIt<PurchaseService>())
    ..registerLazySingleton<AudioService>(() => AudioService(getIt<SettingsCubit>()))
    ..registerLazySingleton<SoundPort>(() => getIt<AudioService>())
    ..registerLazySingleton<NotificationService>(
      () => NotificationService(api: getIt<ApiService>(), user: getIt<UserService>()),
    );
}

/// Test helper.
@visibleForTesting
Future<void> resetDependencies() => getIt.reset();
