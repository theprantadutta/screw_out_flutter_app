import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/widgets.dart';

import '../app_log.dart';
import '../ports.dart';

/// One analytics destination.
abstract interface class AnalyticsClient {
  void track(String event, Map<String, Object?> params);
  void screen(String name);
}

/// Fan-out to every client (snake-classic's AnalyticsFacade). A failing
/// client never breaks the others or the caller.
class AnalyticsFacade implements AnalyticsPort {
  AnalyticsFacade(this._clients);

  final List<AnalyticsClient> _clients;

  @override
  void track(String event, [Map<String, Object?> params = const {}]) {
    for (final c in _clients) {
      try {
        c.track(event, params);
      } on Object catch (e) {
        AppLog.warn('analytics client failed on $event: $e');
      }
    }
  }

  @override
  void screen(String name) {
    for (final c in _clients) {
      try {
        c.screen(name);
      } on Object {
        // ignore
      }
    }
  }
}

/// Firebase Analytics (release builds). Params are coerced to the types
/// GA4 accepts; nothing personal is ever sent.
class FirebaseAnalyticsClient implements AnalyticsClient {
  FirebaseAnalyticsClient([FirebaseAnalytics? analytics]) : _fa = analytics ?? FirebaseAnalytics.instance;

  final FirebaseAnalytics _fa;

  @override
  void track(String event, Map<String, Object?> params) {
    final clean = <String, Object>{};
    params.forEach((k, v) {
      if (v is num || v is String) {
        clean[k] = v!;
      } else if (v is bool) {
        clean[k] = v ? 1 : 0;
      }
    });
    _fa.logEvent(name: event, parameters: clean);
  }

  @override
  void screen(String name) => _fa.logScreenView(screenName: name);
}

/// Debug builds: log to the console instead.
class DebugAnalyticsClient implements AnalyticsClient {
  @override
  void track(String event, Map<String, Object?> params) => AppLog.info('analytics: $event $params');

  @override
  void screen(String name) => AppLog.info('analytics: screen $name');
}

/// Screen views from route names (every GoRoute carries a `name`).
class AnalyticsRouteObserver extends NavigatorObserver {
  AnalyticsRouteObserver(this._analytics);

  final AnalyticsPort _analytics;

  void _report(Route<dynamic>? route) {
    final name = route?.settings.name;
    if (name != null && name.isNotEmpty) _analytics.screen(name);
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) => _report(route);

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) => _report(newRoute);

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) => _report(previousRoute);
}
