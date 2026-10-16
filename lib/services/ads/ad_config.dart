import 'package:flutter/foundation.dart';

/// AdMob unit ids.
///
/// * Debug builds always use Google's official TEST units.
/// * Release builds read [_release], whose keys are exactly the names in
///   `ADMOB_IDS_TEMPLATE.txt` (project root). Paste each value from the
///   filled template here. An **empty value means that format is skipped**
///   in release (no request is ever made for it).
///
/// The AdMob *app* ids (ANDROID_APP_ID / IOS_APP_ID) go in
/// `android/app/src/main/AndroidManifest.xml` (APPLICATION_ID meta-data) and
/// `ios/Runner/Info.plist` (GADApplicationIdentifier).
abstract final class AdConfig {
  static bool get _ios => defaultTargetPlatform == TargetPlatform.iOS;

  // From ADMOB_IDS_TEMPLATE.txt.
  static const _release = <String, String>{
    'ANDROID_REWARDED': 'ca-app-pub-9242904787767394/1367243862',
    'ANDROID_INTERSTITIAL': 'ca-app-pub-9242904787767394/4696114785',
    'ANDROID_BANNER': 'ca-app-pub-9242904787767394/8639229227',
    'ANDROID_APP_OPEN': 'ca-app-pub-9242904787767394/7264322393',
    'IOS_REWARDED': 'ca-app-pub-9242904787767394/3957748187',
    'IOS_INTERSTITIAL': 'ca-app-pub-9242904787767394/7741080520',
    'IOS_BANNER': 'ca-app-pub-9242904787767394/2488753843',
    'IOS_APP_OPEN': 'ca-app-pub-9242904787767394/8577404061',
  };

  // Google's official test ad units.
  static const _test = <String, String>{
    'ANDROID_REWARDED': 'ca-app-pub-3940256099942544/5224354917',
    'ANDROID_INTERSTITIAL': 'ca-app-pub-3940256099942544/1033173712',
    'ANDROID_BANNER': 'ca-app-pub-3940256099942544/9214589741',
    'ANDROID_APP_OPEN': 'ca-app-pub-3940256099942544/9257395921',
    'IOS_REWARDED': 'ca-app-pub-3940256099942544/1712485313',
    'IOS_INTERSTITIAL': 'ca-app-pub-3940256099942544/4411468910',
    'IOS_BANNER': 'ca-app-pub-3940256099942544/2435281174',
    'IOS_APP_OPEN': 'ca-app-pub-3940256099942544/5575463023',
  };

  /// Null = this format is disabled (release build, empty template value).
  static String? _id(String format) {
    final key = '${_ios ? 'IOS' : 'ANDROID'}_$format';
    if (kDebugMode) return _test[key];
    final real = _release[key] ?? '';
    return real.isEmpty ? null : real;
  }

  static String? get rewardedUnitId => _id('REWARDED');
  static String? get interstitialUnitId => _id('INTERSTITIAL');
  static String? get bannerUnitId => _id('BANNER');
  static String? get appOpenUnitId => _id('APP_OPEN');
}
