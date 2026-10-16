import 'package:drift/drift.dart' hide isNotNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:screw_out/data/database/app_database.dart';
import 'package:screw_out/l10n/app_localizations.dart';
import 'package:refresh_rate/refresh_rate.dart' show DisplayInfo;
import 'package:screw_out/presentation/bloc/auth/auth_cubit.dart';
import 'package:screw_out/presentation/bloc/display/display_cubit.dart';
import 'package:screw_out/presentation/bloc/premium/premium_cubit.dart';
import 'package:screw_out/presentation/bloc/progress/progress_cubit.dart';
import 'package:screw_out/presentation/bloc/settings/settings_cubit.dart';
import 'package:screw_out/services/level_repository.dart';
import 'package:screw_out/services/ports.dart';
import 'package:screw_out/services/progress_service.dart';

/// Everything a screen needs, backed by an in-memory database.
class ScreenEnv {
  ScreenEnv._(this.db, this.repo, this.progress, this.progressCubit, this.premium, this.settings, this.auth);

  final AppDatabase db;
  final LevelRepository repo;
  final ProgressService progress;
  final ProgressCubit progressCubit;
  final PremiumCubit premium;
  final SettingsCubit settings;
  final AuthCubit auth;
  late final DisplayCubit display = DisplayCubit(DriftDisplayPreferenceStore(db), backend: const NoRefreshRate());
  AdsPort ads = const NoAds();
  PurchasesPort purchases = const FakePurchases();

  /// Creates the env. Must run inside `tester.runAsync`.
  static Future<ScreenEnv> create({
    int cleared = 23,
    int mastered = 14,
    int coins = 860,
    bool tutorialDone = true,
    Set<int> dailyDone = const {},
    Set<String> themes = const {'walnut'},
    bool pro = false,
    AuthPort? auth,
  }) async {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    await db.initializeDefaults();
    final now = DateTime.utc(2026, 10, 1);
    for (var id = 1; id <= cleared; id++) {
      await db.into(db.levelClears).insert(
        LevelClearsCompanion.insert(
          levelId: Value(id),
          bestMoves: 9,
          bestTimeMs: 48000,
          mastered: Value(id % 20 < mastered % 20 || id <= mastered),
          firstClearedAt: now,
          lastClearedAt: now,
        ),
      );
    }
    await db.customUpdate('UPDATE player_profile SET coins = ?', variables: [Variable.withInt(coins)]);
    for (final t in themes) {
      await db.into(db.unlockedItems).insert(
        UnlockedItemsCompanion.insert(itemType: 'theme', itemId: t, source: 'chapter', unlockedAt: now),
        mode: InsertMode.insertOrIgnore,
      );
    }
    for (final d in dailyDone) {
      await db.into(db.dailyCompletions).insert(
        DailyCompletionsCompanion.insert(dateKey: Value(d), moves: 10, timeMs: 60000, completedAt: now),
      );
    }
    final repo = LevelRepository(db);
    await repo.load();
    final service = ProgressService(db);
    final progressCubit = ProgressCubit(service);
    await progressCubit.initialize();
    final premium = PremiumCubit(db);
    await premium.initialize();
    if (pro) await premium.apply(isPro: true, proExpiresAt: DateTime.utc(2099), proPlan: 'yearly', adsRemoved: false);
    final store = MemorySettingsStore()..value = SettingsState(tutorialDone: tutorialDone);
    final settings = SettingsCubit(store);
    await settings.load(osReducedMotion: false);
    return ScreenEnv._(db, repo, service, progressCubit, premium, settings, AuthCubit(auth ?? GuestAuth()));
  }

  Widget wrap(Widget child, {GoRouter? router}) => MultiRepositoryProvider(
    providers: [
      RepositoryProvider<LevelRepository>.value(value: repo),
      RepositoryProvider<ProgressService>.value(value: progress),
      RepositoryProvider<AdsPort>.value(value: ads),
      RepositoryProvider<AnalyticsPort>.value(value: const NoAnalytics()),
      RepositoryProvider<PurchasesPort>.value(value: purchases),
      RepositoryProvider<SoundPort>.value(value: const SilentSound()),
    ],
    child: MultiBlocProvider(
      providers: [
        BlocProvider<SettingsCubit>.value(value: settings),
        BlocProvider<ProgressCubit>.value(value: progressCubit),
        BlocProvider<PremiumCubit>.value(value: premium),
        BlocProvider<AuthCubit>.value(value: auth),
        BlocProvider<DisplayCubit>.value(value: display),
      ],
      child: router != null
          ? MaterialApp.router(
              debugShowCheckedModeBanner: false,
              localizationsDelegates: _delegates,
              supportedLocales: AppLocalizations.supportedLocales,
              routerConfig: router,
            )
          : MaterialApp(
              debugShowCheckedModeBanner: false,
              localizationsDelegates: _delegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: child,
            ),
    ),
  );

  Future<void> dispose() async {
    await progressCubit.close();
    await db.close();
  }
}

const _delegates = [
  AppLocalizations.delegate,
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
];

final class FakePurchases implements PurchasesPort {
  const FakePurchases();
  @override
  String? priceOf(String productId) => switch (productId) {
    Products.removeAds => r'$2.99',
    Products.proMonthly => r'$3.99',
    Products.proYearly => r'$24.99',
    Products.coinsSmall => r'$0.99',
    Products.coinsMedium => r'$2.99',
    Products.coinsLarge => r'$6.99',
    _ => null,
  };
  @override
  Future<PurchaseOutcome> buy(String productId) async => PurchaseOutcome.granted;
  @override
  Future<PurchaseOutcome> restore() async => PurchaseOutcome.granted;
}

/// Golden helper: settle frames with real async (drift streams) then compare.
Future<void> settle(WidgetTester tester) async {
  await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 50)));
  await tester.pump(const Duration(milliseconds: 1500));
  await tester.pump(const Duration(milliseconds: 100));
}

/// Refresh-rate backend for tests: no platform channel, no display info.
class NoRefreshRate implements RefreshRateBackend {
  const NoRefreshRate();
  @override
  Future<void> preferMax() async {}
  @override
  Future<void> preferDefault() async {}
  @override
  Future<DisplayInfo?> read() async => null;
  @override
  Stream<DisplayInfo> get changes => const Stream.empty();
}
