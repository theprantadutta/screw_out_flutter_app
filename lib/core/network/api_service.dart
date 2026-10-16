import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/app_log.dart';
import 'api_result.dart';
import 'connectivity_service.dart';
import 'install_identity.dart';

export 'api_result.dart';

/// HTTP gateway to the Screw Out API (docs/API_CONTRACT.md). Ported from
/// snake-classic: typed [ApiResult]s, contract headers on every request,
/// JWT in SharedPreferences, any 401 clears the token and fires
/// [onUnauthorized] so the user service can re-mint it.
class ApiService {
  ApiService(this._connectivity, {http.Client? client}) : _client = client ?? http.Client();

  final ConnectivityService _connectivity;
  final http.Client _client;

  static const _tokenKey = 'jwt_access_token';
  static const _userIdKey = 'backend_user_id';
  static const _prodFallback = 'https://screwout.pranta.dev';
  static const _timeout = Duration(seconds: 15);

  String? _accessToken;
  String? _userId;

  /// Fired after any 401 (token already cleared).
  VoidCallback? onUnauthorized;

  /// Test seam: overrides the base URL.
  @visibleForTesting
  static String? baseUrlOverride;

  static String get baseUrl {
    if (baseUrlOverride != null) return baseUrlOverride!;
    final String backend;
    if (kDebugMode) {
      backend = dotenv.maybeGet('DEV_API_BACKEND_URL') ?? dotenv.maybeGet('PROD_API_BACKEND_URL') ?? _prodFallback;
    } else {
      backend = dotenv.maybeGet('PROD_API_BACKEND_URL') ?? _prodFallback;
    }
    return '${backend.replaceAll(RegExp(r'/+$'), '')}/api/v1';
  }

  Future<void> initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _accessToken = prefs.getString(_tokenKey);
      _userId = prefs.getString(_userIdKey);
      if (_accessToken != null && isTokenExpiredOrExpiring) await clearToken();
    } on Object catch (e) {
      AppLog.error('ApiService: loading stored token failed', e);
    }
  }

  /// A usable (unexpired) JWT is in memory.
  bool get isAuthenticated => _accessToken != null && !isTokenExpiredOrExpiring;
  String? get currentUserId => _userId;

  /// JWT `exp` within 5 minutes (or unreadable).
  bool get isTokenExpiredOrExpiring {
    final token = _accessToken;
    if (token == null) return true;
    try {
      final parts = token.split('.');
      if (parts.length != 3) return true;
      final claims = jsonDecode(utf8.decode(base64Url.decode(base64Url.normalize(parts[1])))) as Map<String, dynamic>;
      final exp = claims['exp'] as int?;
      if (exp == null) return true;
      final expiry = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      return DateTime.now().isAfter(expiry.subtract(const Duration(minutes: 5)));
    } on Object {
      return true;
    }
  }

  Future<void> _storeToken(String token, String userId) async {
    _accessToken = token;
    _userId = userId;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, token);
      await prefs.setString(_userIdKey, userId);
    } on Object catch (e) {
      AppLog.error('ApiService: storing token failed', e);
    }
  }

  Future<void> clearToken() async {
    _accessToken = null;
    _userId = null;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
      await prefs.remove(_userIdKey);
    } on Object catch (e) {
      AppLog.error('ApiService: clearing token failed', e);
    }
  }

  void _observe(ApiResult<Object?> result) {
    if (result.indicatesBackendUnreachable) {
      _connectivity.recordBackendFailure();
    } else if (result.indicatesBackendReachable) {
      _connectivity.recordBackendSuccess();
    }
  }

  /// One request with the contract headers; returns a typed result.
  Future<ApiResult<Map<String, dynamic>>> sendJson({
    required String method,
    required String path,
    Object? body,
    Map<String, String>? headers,
    Duration? timeout,
    bool authenticated = true,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    final requestHeaders = <String, String>{
      'Content-Type': 'application/json',
      ...InstallIdentity.clientHeaders,
      if (authenticated && _accessToken != null) 'Authorization': 'Bearer $_accessToken',
      ...?headers,
    };
    final encoded = body == null ? null : jsonEncode(body);
    try {
      final future = switch (method) {
        'POST' => _client.post(uri, headers: requestHeaders, body: encoded),
        'PUT' => _client.put(uri, headers: requestHeaders, body: encoded),
        'DELETE' => _client.delete(uri, headers: requestHeaders, body: encoded),
        _ => _client.get(uri, headers: requestHeaders),
      };
      final response = await future.timeout(timeout ?? _timeout);
      final result = ApiFailureClassifier.decodeObject(response);
      _observe(result);
      if (result.failure == ApiFailure.unauthorized && authenticated) {
        AppLog.warn('API 401 on $path — re-auth');
        await clearToken();
        onUnauthorized?.call();
      } else if (!result.isSuccess) {
        AppLog.warn('API $method $path → $result');
      }
      return result;
    } on Object catch (e) {
      final result = ApiResult<Map<String, dynamic>>.failed(ApiFailureClassifier.forError(e));
      _observe(result);
      AppLog.warn('API $method $path failed: ${result.failure!.name}');
      return result;
    }
  }

  // ------------------------------------------------------------------ auth

  /// POST /auth/firebase → stores the JWT. Returns the AuthResponse.
  Future<ApiResult<Map<String, dynamic>>> authenticateWithFirebase(String firebaseIdToken) async {
    final result = await sendJson(
      method: 'POST',
      path: '/auth/firebase',
      authenticated: false,
      body: {
        'firebase_token': firebaseIdToken,
        'time_zone_offset_minutes': DateTime.now().timeZoneOffset.inMinutes,
      },
    );
    final data = result.value;
    if (result.isSuccess && data != null) {
      final token = data['access_token'] as String?;
      final userId = data['user_id'] as String?;
      if (token == null || userId == null) return ApiResult.failed(ApiFailure.badResponse, statusCode: result.statusCode);
      await _storeToken(token, userId);
    }
    return result;
  }

  Future<ApiResult<Map<String, dynamic>>> me() => sendJson(method: 'GET', path: '/auth/me');

  Future<void> logout() async {
    if (_accessToken != null) await sendJson(method: 'POST', path: '/auth/logout');
    await clearToken();
  }

  /// DELETE /users/me. True only when the server confirmed.
  Future<bool> deleteAccount() async {
    final r = await sendJson(method: 'DELETE', path: '/users/me');
    if (r.isSuccess) await clearToken();
    return r.isSuccess;
  }

  Future<ApiResult<Map<String, dynamic>>> registerToken(String token, String platform) => sendJson(
    method: 'POST',
    path: '/users/register-token',
    body: {
      'fcm_token': token,
      'platform': platform,
      'time_zone_offset_minutes': DateTime.now().timeZoneOffset.inMinutes,
    },
  );

  // ------------------------------------------------------------------ sync

  Future<SyncOutcome> syncPost(String path, Object body, {String? idempotencyKey}) async {
    final r = await sendJson(
      method: 'POST',
      path: path,
      body: body,
      headers: idempotencyKey == null ? null : {'Idempotency-Key': idempotencyKey},
    );
    return SyncOutcome.fromResult(r);
  }

  Future<ApiResult<Map<String, dynamic>>> pull() =>
      sendJson(method: 'GET', path: '/sync/pull', timeout: const Duration(seconds: 30));

  // ------------------------------------------------------------- purchases

  Future<ApiResult<Map<String, dynamic>>> verifyPurchase(Map<String, dynamic> body) =>
      sendJson(method: 'POST', path: '/purchases/verify', body: body, timeout: const Duration(seconds: 30));

  Future<ApiResult<Map<String, dynamic>>> verifyPurchaseBatch(List<Map<String, dynamic>> purchases) => sendJson(
    method: 'POST',
    path: '/purchases/verify-batch',
    body: {'purchases': purchases},
    timeout: const Duration(seconds: 30),
  );

  Future<ApiResult<Map<String, dynamic>>> restorePurchases(String platform) =>
      sendJson(method: 'POST', path: '/purchases/restore', body: {'platform': platform});

  Future<ApiResult<Map<String, dynamic>>> entitlements() => sendJson(method: 'GET', path: '/purchases/entitlements');

  // ----------------------------------------------------------- level packs

  Future<ApiResult<Map<String, dynamic>>> levelPacks() =>
      sendJson(method: 'GET', path: '/levels/packs', authenticated: false);

  Future<ApiResult<Map<String, dynamic>>> levelPack(int chapter) => sendJson(
    method: 'GET',
    path: '/levels/packs/$chapter',
    authenticated: false,
    timeout: const Duration(seconds: 30),
  );

  // ------------------------------------------------------------ telemetry

  Future<ApiResult<Map<String, dynamic>>> telemetryBatch(Map<String, dynamic> body) =>
      sendJson(method: 'POST', path: '/telemetry/batch', body: body, authenticated: _accessToken != null);

  // ---------------------------------------------------------------- misc

  Future<ApiResult<Map<String, dynamic>>> appRelease(String platform) =>
      sendJson(method: 'GET', path: '/app-release/$platform', authenticated: false);

  Future<ApiResult<Map<String, dynamic>>> dailyStatus() => sendJson(
    method: 'GET',
    path: '/daily/status?tz_offset_minutes=${DateTime.now().timeZoneOffset.inMinutes}',
  );

  /// GET /leaderboard/{board} (levels | daily | streak).
  Future<ApiResult<Map<String, dynamic>>> leaderboard(String board, {String? date, int offset = 0, int limit = 50}) {
    final q = <String>['offset=$offset', 'limit=$limit', if (date != null) 'date=$date'].join('&');
    return sendJson(method: 'GET', path: '/leaderboard/$board?$q', authenticated: _accessToken != null);
  }

  Future<ApiResult<Map<String, dynamic>>> myRank(String board, {String? date}) =>
      sendJson(method: 'GET', path: '/leaderboard/me?board=$board${date == null ? '' : '&date=$date'}');
}
