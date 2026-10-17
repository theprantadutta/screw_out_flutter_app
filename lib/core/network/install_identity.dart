import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../services/app_log.dart';

/// Who this install is: the install id plus the build facts every request
/// carries (API_CONTRACT §0 headers). Device-only - lives in
/// SharedPreferences, never synced, never cleared on sign-out.
class InstallIdentity {
  InstallIdentity({
    required this.installId,
    required this.appVersion,
    required this.build,
    required this.platform,
    required this.installedAt,
  });

  static const installIdKey = 'install_id';
  static const installedAtKey = 'install_installed_at';

  /// Set by [load]; read synchronously by the API header builder.
  static InstallIdentity? current;

  final String installId;
  final String appVersion;
  final int build;
  final String platform;
  final DateTime installedAt;

  static String get platformName => switch (defaultTargetPlatform) {
    TargetPlatform.android => 'android',
    TargetPlatform.iOS => 'ios',
    final other => other.name.toLowerCase(),
  };

  /// Reads (or mints, on first launch) the install id. Never throws.
  static Future<InstallIdentity> load({SharedPreferences? prefs, Future<PackageInfo> Function()? packageInfo}) async {
    final existing = current;
    if (existing != null) return existing;

    var installId = const Uuid().v4();
    var installedAt = DateTime.now().toUtc();
    try {
      final store = prefs ?? await SharedPreferences.getInstance();
      final stored = store.getString(installIdKey);
      if (stored != null && Uuid.isValidUUID(fromString: stored)) {
        installId = stored;
      } else {
        await store.setString(installIdKey, installId);
      }
      final at = DateTime.tryParse(store.getString(installedAtKey) ?? '');
      if (at != null) {
        installedAt = at;
      } else {
        await store.setString(installedAtKey, installedAt.toIso8601String());
      }
    } on Object catch (e) {
      AppLog.warn('InstallIdentity: storage unavailable: $e');
    }

    var version = '0.0.0';
    var build = 0;
    try {
      final info = await (packageInfo ?? PackageInfo.fromPlatform)();
      version = info.version;
      build = int.tryParse(info.buildNumber) ?? 0;
    } on Object catch (e) {
      AppLog.warn('InstallIdentity: package info unavailable: $e');
    }
    return current = InstallIdentity(
      installId: installId,
      appVersion: version,
      build: build,
      platform: platformName,
      installedAt: installedAt,
    );
  }

  /// Headers on EVERY request, authenticated or not.
  static Map<String, String> get clientHeaders {
    final id = current;
    return {
      if (id != null) 'X-Install-Id': id.installId,
      if (id != null) 'X-App-Version': id.appVersion,
      if (id != null) 'X-App-Build': '${id.build}',
      'X-Platform': id?.platform ?? platformName,
    };
  }

  @visibleForTesting
  static void resetForTest() => current = null;
}
