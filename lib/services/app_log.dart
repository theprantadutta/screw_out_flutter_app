import 'package:flutter/foundation.dart';

/// Debug-only logging. Never logs request/response bodies (player data).
abstract final class AppLog {
  static void info(String message) {
    if (kDebugMode) debugPrint('[screw_out] $message');
  }

  static void warn(String message) {
    if (kDebugMode) debugPrint('[screw_out] WARN $message');
  }

  /// Release builds: where handled errors are reported (Crashlytics, set at
  /// start-up). Null in debug builds and tests.
  static void Function(String message, Object? error, StackTrace? stack)? onError;

  static void error(String message, [Object? error, StackTrace? stack]) {
    onError?.call(message, error, stack);
    if (kDebugMode) {
      debugPrint('[screw_out] ERROR $message${error == null ? '' : ': $error'}');
      if (stack != null) debugPrint('$stack');
    }
  }
}
