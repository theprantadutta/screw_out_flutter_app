import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'app_log.dart';

/// Tells whether the app runs on one of Google's automated test devices
/// (Firebase Test Lab, which also powers the Play Console pre-launch
/// report). Those robots install, tap around and uninstall: they must not
/// count as players in Analytics or Crashlytics, and must never request or
/// click ads (an AdMob invalid-traffic risk).
///
/// Android: the documented signal is the system setting
/// `Settings.System "firebase.test.lab" == "true"`, read natively in
/// MainActivity. Every other platform (and any channel error) answers
/// false, so a real player is never treated as a robot by mistake.
class TestLabDetector {
  TestLabDetector({this.channel = defaultChannel, bool? isAndroid})
    : _isAndroid = isAndroid ?? (!kIsWeb && defaultTargetPlatform == TargetPlatform.android);

  static const defaultChannel = MethodChannel('screw_out/test_lab');

  final MethodChannel channel;
  final bool _isAndroid;
  Future<bool>? _result;

  /// Asked once per launch; later calls reuse the first answer.
  Future<bool> isTestLab() => _result ??= _query();

  Future<bool> _query() async {
    if (!_isAndroid) return false;
    try {
      final testLab = await channel.invokeMethod<bool>('isTestLab') ?? false;
      if (testLab) AppLog.info('Firebase Test Lab device: analytics, crash reports and ads off');
      return testLab;
    } on Object catch (e) {
      AppLog.warn('Test Lab check failed, assuming a real device: $e');
      return false;
    }
  }
}
