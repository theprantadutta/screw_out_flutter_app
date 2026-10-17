// ignore_for_file: prefer_initializing_formals
import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../../core/network/api_service.dart';
import '../../core/network/install_identity.dart';
import '../../l10n/app_localizations.dart';
import '../app_log.dart';
import '../user_service.dart';
import 'notification_primer.dart';

/// FCM + local notifications (ported from snake-classic).
///
/// * The FCM token is fetched at startup **without** a permission prompt; the
///   OS prompt only follows the in-app soft-ask (after the 3rd cleared sheet).
/// * `POST /users/register-token` on every launch (it is also the activity
///   heartbeat) and on token refresh - after a backend identity exists.
/// * Deep links come from `data.nav_route` (never `route`), held until the
///   app is ready.
/// * A local 19:00 reminder is the offline fallback for the daily sheet; the
///   server's reminder covers players with a backend session.
class NotificationService {
  NotificationService({required ApiService api, required UserService user}) : _api = api, _user = user;

  final ApiService _api;
  final UserService _user;

  static const channelId = 'screw_out_notifications';
  static const _channelName = 'Screw Out';
  static const _channelDescription = 'Daily sheet reminders and account notices';
  static const _smallIcon = 'ic_notification';
  static const _reminderId = 1901;
  static const _primerAskedKey = 'notif_primer_asked';
  static const _lastTokenKey = 'fcm_last_registered_token';

  final FlutterLocalNotificationsPlugin _local = FlutterLocalNotificationsPlugin();
  bool _initialized = false;
  String? _token;
  String? _pendingRoute;
  bool _appReady = false;

  /// Set by main once the router exists.
  void Function(String route)? navigate;

  static bool get _mobile => !kIsWeb && (defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS);

  Future<void> initialize() async {
    if (_initialized || !_mobile) return;
    _initialized = true;
    try {
      tzdata.initializeTimeZones();
      await _local.initialize(
        settings: const InitializationSettings(
          android: AndroidInitializationSettings(_smallIcon),
          iOS: DarwinInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false,
          ),
        ),
        onDidReceiveNotificationResponse: (r) => _routeFromPayload(r.payload),
      );
      await _local
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(
            const AndroidNotificationChannel(
              channelId,
              _channelName,
              description: _channelDescription,
              importance: Importance.high,
            ),
          );

      final fm = FirebaseMessaging.instance;
      FirebaseMessaging.onMessage.listen(_onForegroundMessage);
      FirebaseMessaging.onMessageOpenedApp.listen((m) => _route(m.data));
      fm.onTokenRefresh.listen((t) {
        _token = t;
        unawaited(registerToken());
      });
      final initial = await fm.getInitialMessage();
      if (initial != null) _route(initial.data);
      _token = await fm.getToken().timeout(const Duration(seconds: 10), onTimeout: () => null);
      final launch = await _local.getNotificationAppLaunchDetails();
      if (launch?.didNotificationLaunchApp == true) _routeFromPayload(launch?.notificationResponse?.payload);
    } on Object catch (e) {
      AppLog.warn('Notifications init failed: $e');
    }
  }

  /// The router is ready - deliver any held deep link.
  void markAppReady() {
    _appReady = true;
    final r = _pendingRoute;
    _pendingRoute = null;
    if (r != null) navigate?.call(r);
  }

  void _route(Map<String, dynamic> data) {
    final route = data['nav_route'];
    if (route is! String || !route.startsWith('/')) return;
    // `/store` has no screen of its own: settings holds purchases.
    final target = route == '/store' ? '/settings' : route;
    if (_appReady && navigate != null) {
      navigate!(target);
    } else {
      _pendingRoute = target;
    }
  }

  void _routeFromPayload(String? payload) {
    if (payload == null) return;
    try {
      _route((jsonDecode(payload) as Map).cast());
    } on Object {
      // ignore malformed payload
    }
  }

  Future<void> _onForegroundMessage(RemoteMessage m) async {
    final n = m.notification;
    if (n == null) return;
    await _local.show(
      id: m.hashCode & 0x7FFFFFFF,
      title: n.title,
      body: n.body,
      notificationDetails: _details,
      payload: jsonEncode(m.data),
    );
  }

  static const _details = NotificationDetails(
    android: AndroidNotificationDetails(
      channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.high,
      priority: Priority.high,
      icon: _smallIcon,
    ),
    iOS: DarwinNotificationDetails(),
  );

  // ------------------------------------------------------- registration

  Future<bool> areNotificationsEnabled() async {
    if (!_mobile) return false;
    try {
      final settings = await FirebaseMessaging.instance.getNotificationSettings();
      return settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional;
    } on Object {
      return false;
    }
  }

  /// Registers the FCM token with the API. Guests who allowed notifications
  /// get a silent anonymous backend identity first.
  Future<void> registerToken() async {
    final token = _token;
    if (token == null) return;
    if (!_api.isAuthenticated) {
      if (!await areNotificationsEnabled()) return;
      if (!await _user.ensureBackendIdentityForPush()) return;
    }
    final r = await _api.registerToken(token, InstallIdentity.platformName);
    if (r.isSuccess) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_lastTokenKey, token);
    }
  }

  /// OS permission prompt (after the soft-ask said yes).
  Future<bool> requestPermission() async {
    if (!_mobile) return false;
    try {
      final settings = await FirebaseMessaging.instance.requestPermission();
      final ok = settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional;
      if (defaultTargetPlatform == TargetPlatform.android) {
        await _local.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
      }
      if (ok) unawaited(registerToken());
      return ok;
    } on Object catch (e) {
      AppLog.warn('Permission request failed: $e');
      return false;
    }
  }

  // ------------------------------------------------------------ primer

  /// Shows the soft-ask once, when [clearedSheets] ≥ 3 and the OS has not
  /// already granted permission.
  Future<void> maybeShowPrimer(BuildContext context, {required int clearedSheets}) async {
    if (!_mobile || clearedSheets < 3) return;
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_primerAskedKey) == true) return;
    if (await areNotificationsEnabled()) {
      await prefs.setBool(_primerAskedKey, true);
      return;
    }
    await prefs.setBool(_primerAskedKey, true);
    if (!context.mounted) return;
    final yes = await showNotificationPrimer(context);
    if (yes == true) await requestPermission();
  }

  // ------------------------------------------------- local daily reminder

  /// Schedules (or cancels) the offline 19:00 reminder for today's sheet.
  Future<void> scheduleDailyReminder({required bool enabled, required bool todayDone, String localeCode = 'en'}) async {
    if (!_initialized) return;
    try {
      await _local.cancel(id: _reminderId);
      // Signed-in players get the server's push at their local 19:00.
      if (!enabled || _api.isAuthenticated) return;
      final now = DateTime.now();
      var fire = DateTime(now.year, now.month, now.day, 19);
      if (todayDone || !fire.isAfter(now)) fire = fire.add(const Duration(days: 1));
      final l = lookupAppLocalizations(Locale(localeCode));
      await _local.zonedSchedule(
        id: _reminderId,
        title: l.reminderTitle,
        body: l.reminderBody,
        scheduledDate: tz.TZDateTime.from(fire, tz.UTC),
        notificationDetails: _details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: jsonEncode({'type': 'daily_reminder', 'nav_route': '/daily'}),
      );
    } on Object catch (e) {
      AppLog.warn('Scheduling reminder failed: $e');
    }
  }

  /// Opens this app's system notification settings (Android).
  Future<void> openSystemSettings() async {
    try {
      await const MethodChannel('screw_out/notification_settings').invokeMethod<bool>('open');
    } on Object {
      // Not available on this platform.
    }
  }
}

/// FCM background messages: the notification block is shown by FCM itself.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {}

