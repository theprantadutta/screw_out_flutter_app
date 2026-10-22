import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';

import 'app.dart';
import 'core/di/injection.dart';
import 'core/network/connectivity_service.dart';
import 'core/network/install_identity.dart';
import 'core/theme/blueprint_tokens.dart';
import 'data/database/app_database.dart';
import 'firebase_options.dart';
import 'game/generator/daily.dart';
import 'l10n/app_localizations.dart';
import 'presentation/bloc/display/display_cubit.dart';
import 'presentation/bloc/auth/auth_cubit.dart';
import 'presentation/bloc/premium/premium_cubit.dart';
import 'presentation/bloc/progress/progress_cubit.dart';
import 'presentation/bloc/settings/settings_cubit.dart';
import 'router/app_router.dart';
import 'screens/licenses/licenses_screen.dart';
import 'services/audio/audio_service.dart';
import 'services/ads/ad_service.dart';
import 'services/analytics/analytics.dart';
import 'services/analytics/telemetry.dart';
import 'services/app_log.dart';
import 'services/level_pack_service.dart';
import 'services/level_repository.dart';
import 'services/notifications/notification_service.dart';
import 'services/ports.dart';
import 'services/purchases/purchase_service.dart';
import 'services/sync/sync_engine.dart';
import 'services/user_service.dart';
import 'widgets/bp/bp_buttons.dart';
import 'widgets/bp/bp_screen.dart';
import 'widgets/sync_notices.dart';

Future<void> main() async {
  final binding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: binding);
  try {
    final firebase = await _preBoot();
    configureDependencies(firebase: firebase);
    final ready = _bootstrapServices(firebase: firebase);
    final router = createAppRouter(
      ready: ready,
      observers: [AnalyticsRouteObserver(getIt<AnalyticsPort>())],
      packs: getIt<LevelPackService>(),
    );
    _wireRouter(router, ready);
    _AppLifecycle(firebase: firebase).attach();
    runApp(ScrewOutApp(router: router));
  } on Object catch (e, s) {
    AppLog.error('Startup failed', e, s);
    runApp(_StartupFailureApp(error: e));
  } finally {
    binding.addPostFrameCallback((_) {
      FlutterNativeSplash.remove();
      // The refresh-rate plugin needs an attached view.
      if (getIt.isRegistered<DisplayCubit>()) unawaited(getIt<DisplayCubit>().initialize());
    });
  }
}

/// Everything that must exist before the first frame. Returns whether
/// Firebase is available.
Future<bool> _preBoot() async {
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  try {
    await dotenv.load(fileName: '.env');
  } on Object catch (e) {
    AppLog.warn('.env missing - using production defaults: $e');
  }
  var firebase = false;
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    firebase = true;
  } on Object catch (e) {
    AppLog.warn('Firebase unavailable - accounts, push and analytics off: $e');
  }
  registerFontLicenses();
  await InstallIdentity.load();
  return firebase;
}

/// Async start-up the splash waits on. Local state (levels, settings,
/// progress) always finishes first - routing depends on it - and only the
/// rest gets the 25 s budget (like snake-classic).
Future<void> _bootstrapServices({required bool firebase}) async {
  final db = getIt<AppDatabase>();
  await db.initializeDefaults();
  await getIt<LevelRepository>().load();

  final settings = getIt<SettingsCubit>();
  final osReducedMotion = WidgetsBinding.instance.platformDispatcher.accessibilityFeatures.disableAnimations;
  await settings.load(osReducedMotion: osReducedMotion);
  await getIt<ProgressCubit>().initialize();
  await getIt<PremiumCubit>().initialize();

  Future<void> run() async {
    await getIt<ConnectivityService>().initialize();

    // Music is on by default since the "Workshop" loop exists; installs that
    // saved the old off-by-default once get it switched on, one time only.
    final prefs = await SharedPreferences.getInstance();
    if (!(prefs.getBool('music_default_on_v1') ?? false)) {
      if (!settings.state.music) await settings.setMusic(true);
      await prefs.setBool('music_default_on_v1', true);
    }
    unawaited(getIt<AudioService>().initialize());

    // UI tick: sound + selection haptic on every Blueprint button.
    final sound = getIt<SoundPort>();
    bpUiTick = () {
      if (settings.state.sound) sound.play(Sfx.tick);
      if (settings.state.haptics) HapticFeedback.selectionClick();
    };
    bpUiToggle = () {
      if (settings.state.sound) sound.play(Sfx.toggle);
      if (settings.state.haptics) HapticFeedback.selectionClick();
    };

    final user = getIt<UserService>();
    final purchases = getIt<PurchaseService>();
    final notifications = getIt<NotificationService>();
    final packs = getIt<LevelPackService>();
    user.onSession.addAll([
      purchases.onSession,
      notifications.registerToken,
      () => packs.refresh(force: true),
    ]);
    user.onSignedOut.add(() => getIt<PremiumCubit>().apply(isPro: false, adsRemoved: false));

    getIt<SyncEngine>().start();
    getIt<TelemetryUploader>().start();
    if (firebase) {
      await getIt<AuthCubit>().initialize();
    }
    // Store, ads and push never block the first screen.
    unawaited(purchases.initialize());
    // Size the banner slot first (fast), so Home never shifts when it loads.
    await getIt<AdService>().prepareBanner().timeout(const Duration(seconds: 2), onTimeout: () {});
    unawaited(getIt<AdService>().initialize());
    if (firebase) {
      unawaited(notifications.initialize().then((_) => notifications.registerToken()));
    }
    unawaited(packs.prefetchIfNear(getIt<ProgressCubit>().state.currentLevel));
    unawaited(_scheduleReminder());
  }

  await run().timeout(
    const Duration(seconds: 25),
    onTimeout: () => AppLog.warn('Bootstrap exceeded 25 s - continuing with what is ready'),
  );
}

/// Deep links, the notification soft-ask and reminder rescheduling.
void _wireRouter(GoRouter router, Future<void> ready) {
  final notifications = getIt<NotificationService>()..navigate = router.go;
  unawaited(
    ready.then((_) {
      notifications.markAppReady();
      _PrimerTrigger(router, notifications).attach();
      _AccountNotices().attach();
      getIt<SettingsCubit>().stream.listen((_) => unawaited(_scheduleReminder()));
      getIt<ProgressCubit>().stream
          .map((p) => p.dailyDone.length)
          .distinct()
          .listen((_) => unawaited(_scheduleReminder()));
    }),
  );
}

Future<void> _scheduleReminder() async {
  final settings = getIt<SettingsCubit>().state;
  final done = getIt<ProgressCubit>().state.dailyDone.contains(DailySheets.dateKey(DateTime.now()));
  await getIt<NotificationService>().scheduleDailyReminder(
    enabled: settings.dailyReminder,
    todayDone: done,
    localeCode: settings.localeCode ?? 'en',
  );
}

/// Shows the notification soft-ask once, after the 3rd cleared sheet, the
/// next time the player is on a menu screen (never mid-level).
class _PrimerTrigger {
  _PrimerTrigger(this._router, this._notifications);

  final GoRouter _router;
  final NotificationService _notifications;
  bool _done = false;

  void attach() => _router.routerDelegate.addListener(_check);

  void _check() {
    if (_done) return;
    final cleared = getIt<ProgressCubit>().state.totalCleared;
    if (cleared < 3) return;
    final path = _router.routerDelegate.currentConfiguration.uri.path;
    if (path.startsWith('/play') || path.startsWith('/daily/play') || path == '/') return;
    _done = true;
    Future<void>.delayed(const Duration(milliseconds: 600), () {
      final context = rootNavigatorKey.currentContext;
      if (context != null && context.mounted) {
        unawaited(_notifications.maybeShowPrimer(context, clearedSheets: cleared));
      }
    });
  }
}

/// App-wide account notices nobody tapped for: another device's progress
/// arriving, a delayed restore, Pro switching on. Queued so a sign-in
/// toast and the Pro toast both get read.
class _AccountNotices {
  bool? _wasPro;

  void attach() {
    getIt<SyncEngine>().reports.listen((report) {
      final target = _target();
      if (target == null) return;
      final auth = getIt<AuthCubit>().state;
      final (msg, kind) = syncNotice(target.$2, report, name: auth.displayName ?? auth.username ?? '');
      showBpToastOn(target.$1, msg, kind: kind, queue: true);
    });
    final premium = getIt<PremiumCubit>();
    _wasPro = premium.state.isPro;
    premium.stream.listen((s) {
      final was = _wasPro;
      _wasPro = s.isPro;
      // Only a real switch-on (sign-in, grant, purchase restore) - never the
      // cached state loading at launch.
      if (was != false || !s.isPro) return;
      final target = _target();
      if (target == null) return;
      showBpToastOn(target.$1, target.$2.proActivated, kind: BpToastKind.success, queue: true);
    });
  }

  /// The root navigator's overlay (the navigator's own context sits above
  /// it, so a context lookup would find nothing) and the app's strings.
  (OverlayState, AppLocalizations)? _target() {
    final nav = rootNavigatorKey.currentState;
    final context = rootNavigatorKey.currentContext;
    final overlay = nav?.overlay;
    if (overlay == null || context == null || !context.mounted) return null;
    final l = Localizations.of<AppLocalizations>(context, AppLocalizations);
    return l == null ? null : (overlay, l);
  }
}

/// Resume / pause wiring (snake-classic's lifecycle observer).
class _AppLifecycle with WidgetsBindingObserver {
  _AppLifecycle({required this.firebase});

  final bool firebase;

  void attach() => WidgetsBinding.instance.addObserver(this);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        unawaited(_onResume());
      case AppLifecycleState.paused:
        unawaited(_onPause());
      default:
        break;
    }
  }

  Future<void> _onResume() async {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    // Android drops the window's preferred display mode in the background.
    unawaited(getIt<DisplayCubit>().apply());
    getIt<TelemetryRecorder>().onForeground();
    // Pull what the account's other devices did while this one was away.
    if (firebase) {
      unawaited(getIt<UserService>().ensureBackendSession().then((_) => getIt<SyncEngine>().refresh()));
    }
    getIt<SyncEngine>().schedule(immediate: true);
    unawaited(getIt<PurchaseService>().onResume());
    unawaited(getIt<AdService>().onResumed());
    unawaited(getIt<LevelPackService>().prefetchIfNear(getIt<ProgressCubit>().state.currentLevel));
  }

  Future<void> _onPause() async {
    getIt<TelemetryRecorder>().onBackground();
    getIt<AdService>().onBackgrounded();
    unawaited(getIt<SyncEngine>().syncNow());
    unawaited(getIt<TelemetryUploader>().upload());
    unawaited(_scheduleReminder());
  }
}

/// Dependency-free recovery screen when start-up itself fails.
class _StartupFailureApp extends StatelessWidget {
  const _StartupFailureApp({required this.error});

  final Object error;

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      backgroundColor: BpColor.sheet,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(BpSpace.screen),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Screw Out.', style: BpType.screenTitle.copyWith(color: BpColor.line)),
              const SizedBox(height: BpSpace.s4),
              Text(
                'SOMETHING WENT WRONG WHILE STARTING.\nCLOSE THE APP AND OPEN IT AGAIN.',
                style: BpType.label.copyWith(color: BpColor.textSecondary),
              ),
              if (kDebugMode) ...[
                const SizedBox(height: BpSpace.s4),
                Text('$error', style: BpType.caption.copyWith(color: BpColor.blocked)),
              ],
            ],
          ),
        ),
      ),
    ),
  );
}
