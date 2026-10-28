import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/network/api_service.dart';
import '../app_log.dart';
import 'update_policy.dart';

/// Play Store in-app updates (Android, release builds). Ported from
/// snake-classic: ONE check per process, run once Home is up (never in the
/// bootstrap), flexible by default, blocking only per [UpdatePolicy]. A
/// declined flexible offer is snoozed; a finished download raises
/// [updateReadyToInstall] so Home can offer the restart.
class InAppUpdateService {
  InAppUpdateService(this._api);

  final ApiService _api;

  static const _declinedAtKey = 'in_app_update_declined_ms';

  bool _checked = false;
  StreamSubscription<InstallStatus>? _installSub;

  /// A flexible update finished downloading and only needs a restart.
  final ValueNotifier<bool> updateReadyToInstall = ValueNotifier(false);

  /// Never throws: a failed check is a log line, never a blocked launch.
  Future<void> checkForUpdate() async {
    if (kDebugMode || kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;
    if (_checked) return;
    _checked = true;
    try {
      final info = await InAppUpdate.checkForUpdate().timeout(const Duration(seconds: 5));

      // A download from an earlier session finished while we were away.
      if (info.installStatus == InstallStatus.downloaded) {
        updateReadyToInstall.value = true;
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      final declinedMs = prefs.getInt(_declinedAtKey);
      final flow = UpdatePolicy.decide(
        updateAvailable: info.updateAvailability == UpdateAvailability.updateAvailable,
        priority: info.updatePriority,
        immediateAllowed: info.immediateUpdateAllowed,
        flexibleAllowed: info.flexibleUpdateAllowed,
        sinceDeclined: declinedMs == null
            ? null
            : DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(declinedMs)),
        belowMinimumSupported: await _belowMinimumSupported(),
      );
      AppLog.info('In-app update: ${info.updateAvailability.name}, priority ${info.updatePriority}, flow ${flow.name}');

      switch (flow) {
        case UpdateFlow.none:
          return;
        case UpdateFlow.immediate:
          final result = await InAppUpdate.performImmediateUpdate();
          AppLog.info('Immediate update: ${result.name}');
        case UpdateFlow.flexible:
          await _runFlexible(prefs);
      }
    } on Object catch (e) {
      AppLog.warn('In-app update check failed: $e');
    }
  }

  /// The API's release policy for Android (dashboard: App releases).
  Future<bool> _belowMinimumSupported() async {
    try {
      final policy = await _api.appRelease('android').timeout(const Duration(seconds: 4));
      final p = policy.value;
      if (!policy.isSuccess || p == null || p['enabled'] != true) return false;
      final version = (await PackageInfo.fromPlatform()).version;
      return UpdatePolicy.isBelow(version, p['minimum_supported_version'] as String?);
    } on Object {
      return false; // no policy, no wall
    }
  }

  Future<void> _runFlexible(SharedPreferences prefs) async {
    _installSub ??= InAppUpdate.installUpdateListener.listen(
      (status) {
        if (status == InstallStatus.downloaded) {
          updateReadyToInstall.value = true;
        } else if (status == InstallStatus.installed ||
            status == InstallStatus.failed ||
            status == InstallStatus.canceled) {
          updateReadyToInstall.value = false;
        }
      },
      onError: (Object e) => AppLog.warn('In-app update status failed: $e'),
    );
    final result = await InAppUpdate.startFlexibleUpdate();
    AppLog.info('Flexible update: ${result.name}');
    if (result == AppUpdateResult.userDeniedUpdate) {
      await prefs.setInt(_declinedAtKey, DateTime.now().millisecondsSinceEpoch);
    }
  }

  /// Applies a downloaded flexible update; Play restarts the app.
  Future<void> completeUpdate() async {
    try {
      await InAppUpdate.completeFlexibleUpdate();
    } on Object catch (e) {
      AppLog.warn('Completing the update failed: $e');
      updateReadyToInstall.value = false;
    }
  }
}
