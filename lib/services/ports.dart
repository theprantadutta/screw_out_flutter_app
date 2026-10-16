import 'package:flutter/widgets.dart';

/// Integration ports between the UI and platform/back-end services.
/// Screens depend on these interfaces only; `core/di/injection.dart` binds
/// the real implementations (ads, analytics, purchases, auth…).

/// Ads (google_mobile_ads + UMP consent). Every method is a safe no-op when
/// ads are disabled (Pro / Remove ads / no consent / unsupported platform),
/// except rewarded ads, which stay available as an *optional* choice.
abstract interface class AdsPort {
  bool get rewardedAvailable;

  /// Resolves true only when the reward was earned.
  Future<bool> showRewarded({required String placement});

  /// Natural break after a level-complete card is dismissed. Frequency
  /// capped inside; never during a level, never on the first sheets.
  Future<void> maybeShowInterstitial({required int levelId});

  /// Banner for menu screens only (never gameplay). Null = nothing to show.
  Widget? menuBanner();

  /// Settings → "Privacy choices" (UMP), when required in the region.
  bool get privacyOptionsRequired;
  Future<void> showPrivacyOptions();
}

/// Product analytics (Firebase in release, logger in debug) + backend
/// telemetry for level analytics. Never collects personal data.
abstract interface class AnalyticsPort {
  void track(String event, [Map<String, Object?> params = const {}]);
  void screen(String name);
}

/// Store purchases (flutter_inapp_purchase) verified by the API.
abstract interface class PurchasesPort {
  /// Localised price string ("$2.99") or null before products load.
  String? priceOf(String productId);
  Future<PurchaseOutcome> buy(String productId);
  Future<PurchaseOutcome> restore();
}

enum PurchaseOutcome { granted, pending, cancelled, failed, needsSignIn }

/// Store product ids (without the `com.pranta.screwout.` prefix).
abstract final class Products {
  static const prefix = 'com.pranta.screwout.';
  static const removeAds = 'remove_ads';
  static const coinsSmall = 'coins_small';
  static const coinsMedium = 'coins_medium';
  static const coinsLarge = 'coins_large';
  static const themePackWorkshop = 'theme_pack_workshop';
  static const themePackOcean = 'theme_pack_ocean';
  static const themePackMidnight = 'theme_pack_midnight';
  static const themesBundle = 'themes_bundle';
  static const proMonthly = 'pro_monthly';
  static const proYearly = 'pro_yearly';

  static const coinPackAmounts = {coinsSmall: 500, coinsMedium: 1500, coinsLarge: 4000};
  static const proMonthlyCoins = 1000;
}

/// Haptics + sound effects. Audio assets are not sourced yet (TODO): the
/// sound implementation is a silent no-op that keeps the call sites ready.
abstract interface class SoundPort {
  void play(Sfx sfx);
}

/// MOTION_SPEC §12 sound map. TODO(audio): add `assets/sfx/NAME.ogg` files.
enum Sfx { tick, unscrew, clink, panelSlide, slotFree, thunk, undo, hint, success, coin }

final class NoAds implements AdsPort {
  const NoAds();
  @override
  bool get rewardedAvailable => false;
  @override
  Future<bool> showRewarded({required String placement}) async => false;
  @override
  Future<void> maybeShowInterstitial({required int levelId}) async {}
  @override
  Widget? menuBanner() => null;
  @override
  bool get privacyOptionsRequired => false;
  @override
  Future<void> showPrivacyOptions() async {}
}

final class NoAnalytics implements AnalyticsPort {
  const NoAnalytics();
  @override
  void track(String event, [Map<String, Object?> params = const {}]) {}
  @override
  void screen(String name) {}
}

final class NoPurchases implements PurchasesPort {
  const NoPurchases();
  @override
  String? priceOf(String productId) => null;
  @override
  Future<PurchaseOutcome> buy(String productId) async => PurchaseOutcome.failed;
  @override
  Future<PurchaseOutcome> restore() async => PurchaseOutcome.failed;
}

final class SilentSound implements SoundPort {
  const SilentSound();
  @override
  void play(Sfx sfx) {}
}
