import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

/// What happened to an API call (ported from snake-classic).
///
/// Interactive callers need to tell offline, an expired session, a refusal on
/// the merits, rate limiting and a backend 5xx apart. The sync outbox keeps
/// its own [SyncOutcome] ("retry later" vs "never retry").
enum ApiFailure {
  /// Never reached the server — DNS, TLS, refused, no route.
  offlineOrTransport,

  /// Reached the network but nothing answered in time.
  timeout,

  /// 401. The session is gone; re-authenticate.
  unauthorized,

  /// 403.
  forbidden,

  /// 400/404/409/422 — refused on its merits; retrying unchanged fails again.
  validation,

  /// 429. Back off.
  rateLimited,

  /// 5xx. Worth retrying later.
  serverUnavailable,

  /// 2xx that could not be parsed — the contract drifted.
  badResponse,
}

/// A value, or a reason. Failures carry the API's `code` (match on it, never
/// on the `error` text — API_CONTRACT §0).
class ApiResult<T> {
  const ApiResult._({this.value, this.failure, this.statusCode, this.retryAfter, this.errorCode});

  factory ApiResult.success(T value, {int? statusCode}) => ApiResult._(value: value, statusCode: statusCode);

  factory ApiResult.failed(ApiFailure failure, {int? statusCode, Duration? retryAfter, String? errorCode}) =>
      ApiResult._(failure: failure, statusCode: statusCode, retryAfter: retryAfter, errorCode: errorCode);

  final T? value;
  final ApiFailure? failure;

  /// HTTP status, when there was one. Bodies are never logged.
  final int? statusCode;
  final Duration? retryAfter;

  /// The contract's machine-readable `code` (e.g. `PURCHASE_PENDING`).
  final String? errorCode;

  bool get isSuccess => failure == null;

  /// Transport failure, timeout or 5xx — says the backend may be down.
  bool get indicatesBackendUnreachable =>
      failure == ApiFailure.offlineOrTransport || failure == ApiFailure.timeout || failure == ApiFailure.serverUnavailable;

  /// Any HTTP response at all — including a refusal — proves reachability.
  bool get indicatesBackendReachable => isSuccess || statusCode != null;

  ApiResult<R> map<R>(R Function(T value) f) => isSuccess
      ? ApiResult.success(f(value as T), statusCode: statusCode)
      : ApiResult.failed(failure!, statusCode: statusCode, retryAfter: retryAfter, errorCode: errorCode);

  @override
  String toString() => isSuccess
      ? 'ApiResult.success(status: $statusCode)'
      : 'ApiResult.failed(${failure!.name}, status: $statusCode, code: $errorCode)';
}

/// Maps HTTP responses / exceptions to [ApiFailure]; kept apart from the
/// client so it is testable without a socket.
abstract final class ApiFailureClassifier {
  static ApiFailure? forStatus(int statusCode) {
    if (statusCode >= 200 && statusCode < 300) return null;
    return switch (statusCode) {
      401 => ApiFailure.unauthorized,
      403 => ApiFailure.forbidden,
      429 => ApiFailure.rateLimited,
      >= 500 => ApiFailure.serverUnavailable,
      >= 400 => ApiFailure.validation,
      _ => ApiFailure.badResponse,
    };
  }

  static ApiFailure forError(Object error) {
    if (error is TimeoutException) return ApiFailure.timeout;
    if (error is SocketException) return ApiFailure.offlineOrTransport;
    if (error is http.ClientException) return ApiFailure.offlineOrTransport;
    if (error is HandshakeException) return ApiFailure.offlineOrTransport;
    if (error is FormatException) return ApiFailure.badResponse;
    return ApiFailure.offlineOrTransport;
  }

  /// `Retry-After`, as seconds or an HTTP date.
  static Duration? retryAfterFrom(Map<String, String> headers, {DateTime? now}) {
    final raw = headers['retry-after'] ?? headers['Retry-After'];
    if (raw == null || raw.isEmpty) return null;
    final seconds = int.tryParse(raw.trim());
    if (seconds != null) return Duration(seconds: seconds.clamp(0, 86400));
    try {
      final delta = HttpDate.parse(raw).difference(now ?? DateTime.now());
      return delta.isNegative ? Duration.zero : delta;
    } on Object {
      return null;
    }
  }

  /// The `code` field of an error body, if any.
  static String? errorCodeFrom(String body) {
    if (body.isEmpty) return null;
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map && decoded['code'] is String) return decoded['code'] as String;
    } on Object {
      // Non-JSON error body (proxy page): no code.
    }
    return null;
  }

  /// Decode a JSON object body, or classify the failure.
  static ApiResult<Map<String, dynamic>> decodeObject(http.Response response) {
    final failure = forStatus(response.statusCode);
    if (failure != null) {
      return ApiResult.failed(
        failure,
        statusCode: response.statusCode,
        retryAfter: retryAfterFrom(response.headers),
        errorCode: errorCodeFrom(response.body),
      );
    }
    if (response.body.isEmpty) return ApiResult.success(const <String, dynamic>{}, statusCode: response.statusCode);
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map) return ApiResult.success(Map<String, dynamic>.from(decoded), statusCode: response.statusCode);
      return ApiResult.success(<String, dynamic>{'data': decoded}, statusCode: response.statusCode);
    } on Object {
      return ApiResult.failed(ApiFailure.badResponse, statusCode: response.statusCode);
    }
  }
}

/// Outcome of a `/sync/*` push, for outbox routing: success evicts the rows,
/// transient leaves them pending (no retry bump), permanent bumps retry and
/// eventually dead-letters them.
enum SyncOutcomeKind { success, transient, permanent }

class SyncOutcome {
  const SyncOutcome._(this.kind, this.body, this.statusCode);

  factory SyncOutcome.success([Map<String, dynamic>? body]) => SyncOutcome._(SyncOutcomeKind.success, body, null);
  factory SyncOutcome.transient({int? statusCode}) => SyncOutcome._(SyncOutcomeKind.transient, null, statusCode);
  factory SyncOutcome.permanent({int? statusCode}) => SyncOutcome._(SyncOutcomeKind.permanent, null, statusCode);

  /// 2xx → success; 401, 429, 5xx, transport → transient; other 4xx → permanent.
  factory SyncOutcome.fromResult(ApiResult<Map<String, dynamic>> r) {
    if (r.isSuccess) return SyncOutcome.success(r.value);
    return switch (r.failure!) {
      ApiFailure.validation || ApiFailure.forbidden || ApiFailure.badResponse => SyncOutcome.permanent(statusCode: r.statusCode),
      _ => SyncOutcome.transient(statusCode: r.statusCode),
    };
  }

  final SyncOutcomeKind kind;
  final Map<String, dynamic>? body;
  final int? statusCode;

  bool get isSuccess => kind == SyncOutcomeKind.success;
}
