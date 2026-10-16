// ignore_for_file: prefer_initializing_formals
import 'dart:async';
import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../presentation/bloc/premium/premium_cubit.dart';
import '../app_log.dart';
import '../ports.dart';
import 'ad_config.dart';
import 'ad_gate.dart';

/// google_mobile_ads + UMP consent + iOS ATT (ported from snake-classic).
///
/// * Rewarded is always an *optional* choice (hints, rescue) — never forced.
/// * Interstitial only at natural breaks (after a result card), capped by
///   [AdGate]; never during a level, never on the first sheets.
/// * Banner only on menu screens; app-open only after ≥ 30 min away.
/// * Pro / Remove-ads turn off interstitial, banner and app-open.
/// * Consent: UMP; ad requests only when `canRequestAds()` allows.
class AdService implements AdsPort {
  AdService({required PremiumCubit premium, required AnalyticsPort analytics})
    : _premium = premium,
      _analytics = analytics;

  final PremiumCubit _premium;
  final AnalyticsPort _analytics;

  static bool get _mobile => !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  bool _sdkReady = false;
  bool _canRequestAds = false;
  bool _privacyOptionsRequired = false;
  bool _initialized = false;
  SharedPreferences? _prefs;
  StreamSubscription<PremiumState>? _premiumSub;

  RewardedAd? _rewarded;
  bool _rewardedLoading = false;
  InterstitialAd? _interstitial;
  bool _interstitialLoading = false;
  AppOpenAd? _appOpen;
  DateTime? _appOpenLoadedAt;
  bool _appOpenLoading = false;
  bool _fullScreenShowing = false;
  bool _coldStart = true;
  bool _suppressAppOpen = false;
  DateTime? _backgroundedAt;
  final Map<String, int> _retryAttempt = {};
  final _rewardedReady = ValueNotifier<bool>(false);

  static const _kCompletions = 'ads_completions_since_interstitial';
  static const _kLastInterstitial = 'ads_last_interstitial_ms';
  static const _kLastFullScreen = 'ads_last_full_screen_ms';
  static const _kLastAppOpen = 'ads_last_app_open_ms';
  static const _kClears = 'ads_clears_this_install';
  static const _retryDelays = [2, 10, 45, 180, 600];

  bool get _noAds => _premium.state.noAds;
  bool get adsEnabled => _mobile && _sdkReady && _canRequestAds;

  Future<void> initialize() async {
    if (_initialized || !_mobile) return;
    _initialized = true;
    try {
      _prefs = await SharedPreferences.getInstance();
      _premiumSub = _premium.stream.listen((_) => _onPremiumChanged());
      await MobileAds.instance.updateRequestConfiguration(
        RequestConfiguration(maxAdContentRating: MaxAdContentRating.pg),
      );
      final sdk = MobileAds.instance.initialize();
      await _gatherConsent();
      await _refreshCanRequestAds();
      await sdk;
      _sdkReady = true;
      if (adsEnabled) {
        _loadRewarded();
        if (!_noAds) {
          _loadInterstitial();
          _loadAppOpen();
        }
      }
    } on Object catch (e) {
      AppLog.warn('AdService init failed: $e');
    }
  }

  // --------------------------------------------------------------- consent

  Future<void> _gatherConsent() async {
    try {
      final done = Completer<void>();
      ConsentInformation.instance.requestConsentInfoUpdate(
        ConsentRequestParameters(),
        () async {
          try {
            await ConsentForm.loadAndShowConsentFormIfRequired((_) {});
          } on Object {
            // Form errors leave the cached status in place.
          }
          if (!done.isCompleted) done.complete();
        },
        (FormError error) {
          AppLog.warn('UMP update failed: ${error.message}');
          if (!done.isCompleted) done.complete();
        },
      );
      await done.future.timeout(const Duration(seconds: 10), onTimeout: () {});
      try {
        _privacyOptionsRequired =
            await ConsentInformation.instance.getPrivacyOptionsRequirementStatus() ==
            PrivacyOptionsRequirementStatus.required;
      } on Object {
        _privacyOptionsRequired = false;
      }
    } on Object catch (e) {
      AppLog.warn('Consent gathering errored: $e');
    }
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      try {
        if (await AppTrackingTransparency.trackingAuthorizationStatus == TrackingStatus.notDetermined) {
          await AppTrackingTransparency.requestTrackingAuthorization();
        }
      } on Object {
        // ATT optional.
      }
    }
  }

  /// Requests only when UMP allows (fail-closed on platform error).
  Future<void> _refreshCanRequestAds() async {
    try {
      _canRequestAds = await ConsentInformation.instance.canRequestAds();
    } on Object {
      _canRequestAds = false;
    }
  }

  @override
  bool get privacyOptionsRequired => _privacyOptionsRequired;

  @override
  Future<void> showPrivacyOptions() async {
    final done = Completer<void>();
    try {
      await ConsentForm.showPrivacyOptionsForm((_) {
        if (!done.isCompleted) done.complete();
      });
      await done.future;
    } on Object catch (e) {
      AppLog.warn('Privacy options form failed: $e');
    }
    await _refreshCanRequestAds();
    if (adsEnabled) _loadRewarded();
  }

  void _onPremiumChanged() {
    if (_noAds) {
      _interstitial?.dispose();
      _interstitial = null;
      _appOpen?.dispose();
      _appOpen = null;
    } else if (adsEnabled) {
      _loadInterstitial();
      _loadAppOpen();
    }
  }

  void _retry(String key, VoidCallback load) {
    final attempt = _retryAttempt[key] ?? 0;
    if (attempt >= _retryDelays.length) return;
    _retryAttempt[key] = attempt + 1;
    Timer(Duration(seconds: _retryDelays[attempt]), load);
  }

  // -------------------------------------------------------------- rewarded

  void _loadRewarded() {
    final unit = AdConfig.rewardedUnitId;
    if (unit == null || !adsEnabled || _rewarded != null || _rewardedLoading) return;
    _rewardedLoading = true;
    RewardedAd.load(
      adUnitId: unit,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedLoading = false;
          _rewarded = ad;
          _retryAttempt.remove('rewarded');
          _rewardedReady.value = true;
        },
        onAdFailedToLoad: (error) {
          _rewardedLoading = false;
          AppLog.warn('Rewarded failed to load: ${error.message}');
          _retry('rewarded', _loadRewarded);
        },
      ),
    );
  }

  @override
  bool get rewardedAvailable => adsEnabled && AdConfig.rewardedUnitId != null;

  /// Shows a rewarded video, waiting up to 4 s for a load. Resolves after
  /// the ad is dismissed with whether the reward was earned (handles the
  /// earn-after-dismiss race).
  @override
  Future<bool> showRewarded({required String placement}) async {
    if (!adsEnabled) return false;
    if (_rewarded == null) {
      _loadRewarded();
      if (!_rewardedReady.value) {
        final ready = Completer<void>();
        void check() {
          if (_rewardedReady.value && !ready.isCompleted) ready.complete();
        }

        _rewardedReady.addListener(check);
        await ready.future.timeout(const Duration(seconds: 4), onTimeout: () {});
        _rewardedReady.removeListener(check);
      }
    }
    final ad = _rewarded;
    if (ad == null) return false;
    _rewarded = null;
    _rewardedReady.value = false;
    var earned = false;
    var dismissed = false;
    final done = Completer<bool>();
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        dismissed = true;
        _fullScreenEnded();
        ad.dispose();
        _loadRewarded();
        if (earned) {
          if (!done.isCompleted) done.complete(true);
        } else {
          Future<void>.delayed(const Duration(milliseconds: 800), () {
            if (!done.isCompleted) done.complete(earned);
          });
        }
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        _fullScreenEnded();
        ad.dispose();
        _loadRewarded();
        if (!done.isCompleted) done.complete(false);
      },
    );
    _fullScreenShowing = true;
    _analytics.track('ad_impression', {'format': 'rewarded', 'placement': placement});
    await ad.show(
      onUserEarnedReward: (_, _) {
        earned = true;
        if (dismissed && !done.isCompleted) done.complete(true);
      },
    );
    final ok = await done.future;
    if (!ok) _analytics.track('rewarded_ad_abandoned', {'placement': placement});
    return ok;
  }

  // ---------------------------------------------------------- interstitial

  void _loadInterstitial() {
    final unit = AdConfig.interstitialUnitId;
    if (unit == null || !adsEnabled || _noAds || _interstitial != null || _interstitialLoading) return;
    _interstitialLoading = true;
    InterstitialAd.load(
      adUnitId: unit,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialLoading = false;
          _interstitial = ad;
          _retryAttempt.remove('interstitial');
        },
        onAdFailedToLoad: (error) {
          _interstitialLoading = false;
          _retry('interstitial', _loadInterstitial);
        },
      ),
    );
  }

  int _msSince(String key) {
    final last = _prefs?.getInt(key) ?? 0;
    return DateTime.now().millisecondsSinceEpoch - last;
  }

  @override
  Future<void> maybeShowInterstitial({required int levelId}) async {
    final prefs = _prefs;
    if (prefs == null) return;
    final isDaily = levelId > 19000000;
    final clears = (prefs.getInt(_kClears) ?? 0) + 1;
    await prefs.setInt(_kClears, clears);
    final since = prefs.getInt(_kCompletions) ?? 0;
    final show = AdGate.interstitial(
      noAds: _noAds,
      adsEnabled: adsEnabled,
      loaded: _interstitial != null,
      isDaily: isDaily,
      levelId: levelId,
      clearsThisInstall: clears,
      completionsSinceLastAd: since,
      msSinceLastInterstitial: _msSince(_kLastInterstitial),
      msSinceAnyFullScreenAd: _msSince(_kLastFullScreen),
    );
    if (!show) {
      await prefs.setInt(_kCompletions, since + 1);
      if (_interstitial == null) _loadInterstitial();
      return;
    }
    final ad = _interstitial!;
    _interstitial = null;
    final done = Completer<void>();
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        _fullScreenEnded();
        ad.dispose();
        _loadInterstitial();
        if (!done.isCompleted) done.complete();
      },
      onAdFailedToShowFullScreenContent: (ad, _) {
        _fullScreenEnded();
        ad.dispose();
        _loadInterstitial();
        if (!done.isCompleted) done.complete();
      },
    );
    _fullScreenShowing = true;
    await prefs.setInt(_kCompletions, 0);
    await prefs.setInt(_kLastInterstitial, DateTime.now().millisecondsSinceEpoch);
    _analytics.track('ad_impression', {'format': 'interstitial', 'level_id': levelId});
    await ad.show();
    await done.future.timeout(const Duration(minutes: 2), onTimeout: () {});
  }

  void _fullScreenEnded() {
    _fullScreenShowing = false;
    _prefs?.setInt(_kLastFullScreen, DateTime.now().millisecondsSinceEpoch);
  }

  // -------------------------------------------------------------- app open

  void _loadAppOpen() {
    final unit = AdConfig.appOpenUnitId;
    if (unit == null || !adsEnabled || _noAds || _appOpen != null || _appOpenLoading) return;
    _appOpenLoading = true;
    AppOpenAd.load(
      adUnitId: unit,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenLoading = false;
          _appOpen = ad;
          _appOpenLoadedAt = DateTime.now();
        },
        onAdFailedToLoad: (_) {
          _appOpenLoading = false;
          _retry('app_open', _loadAppOpen);
        },
      ),
    );
  }

  /// The billing sheet backgrounds the app; skip the app-open ad on return.
  void suppressNextAppOpen() => _suppressAppOpen = true;

  void onBackgrounded() {
    _backgroundedAt = DateTime.now();
    _coldStart = false;
  }

  Future<void> onResumed() async {
    final away = _backgroundedAt == null ? 0 : DateTime.now().difference(_backgroundedAt!).inMilliseconds;
    final suppressed = _suppressAppOpen || _fullScreenShowing;
    _suppressAppOpen = false;
    // App-open ads expire after 4 h.
    if (_appOpenLoadedAt != null && DateTime.now().difference(_appOpenLoadedAt!) > const Duration(hours: 4)) {
      _appOpen?.dispose();
      _appOpen = null;
    }
    final show = AdGate.appOpen(
      noAds: _noAds,
      adsEnabled: adsEnabled,
      loaded: _appOpen != null,
      coldStart: _coldStart,
      suppressed: suppressed,
      msAway: away,
      msSinceLastAppOpen: _msSince(_kLastAppOpen),
      msSinceAnyFullScreenAd: _msSince(_kLastFullScreen),
    );
    if (!show) {
      _loadAppOpen();
      return;
    }
    final ad = _appOpen!;
    _appOpen = null;
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        _fullScreenEnded();
        ad.dispose();
        _loadAppOpen();
      },
      onAdFailedToShowFullScreenContent: (ad, _) {
        _fullScreenEnded();
        ad.dispose();
        _loadAppOpen();
      },
    );
    _fullScreenShowing = true;
    await _prefs?.setInt(_kLastAppOpen, DateTime.now().millisecondsSinceEpoch);
    _analytics.track('ad_impression', {'format': 'app_open'});
    await ad.show();
  }

  // ---------------------------------------------------------------- banner

  @override
  Widget? menuBanner() =>
      (adsEnabled && !_noAds && AdConfig.bannerUnitId != null) ? _MenuBanner(analytics: _analytics) : null;

  void dispose() {
    _premiumSub?.cancel();
    _rewarded?.dispose();
    _interstitial?.dispose();
    _appOpen?.dispose();
  }
}

/// Anchored adaptive banner for menu screens. Collapses to nothing until it
/// fills, so it never pushes buttons around mid-tap.
class _MenuBanner extends StatefulWidget {
  const _MenuBanner({required this.analytics});

  final AnalyticsPort analytics;

  @override
  State<_MenuBanner> createState() => _MenuBannerState();
}

class _MenuBannerState extends State<_MenuBanner> {
  BannerAd? _ad;
  bool _loaded = false;
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    unawaited(_load());
  }

  Future<void> _load() async {
    final width = MediaQuery.sizeOf(context).width.truncate();
    final size = await AdSize.getLargeAnchoredAdaptiveBannerAdSize(width);
    if (!mounted || size == null) return;
    final unit = AdConfig.bannerUnitId;
    if (unit == null) return;
    final ad = BannerAd(
      adUnitId: unit,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          if (mounted) setState(() => _loaded = true);
          widget.analytics.track('ad_impression', {'format': 'banner'});
        },
        onAdFailedToLoad: (ad, _) => ad.dispose(),
      ),
    );
    _ad = ad;
    await ad.load();
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ad = _ad;
    if (!_loaded || ad == null) return const SizedBox.shrink();
    return SizedBox(width: ad.size.width.toDouble(), height: ad.size.height.toDouble(), child: AdWidget(ad: ad));
  }
}
