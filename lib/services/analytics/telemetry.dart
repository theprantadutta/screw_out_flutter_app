import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../../core/network/api_service.dart';
import '../../core/network/install_identity.dart';
import '../../data/database/app_database.dart';
import '../app_log.dart';
import '../sync/wire_ids.dart';
import 'analytics.dart';

/// Design-metrics telemetry (API_CONTRACT §9): level events and session
/// counters are queued in Drift `TelemetryEvents` and uploaded in batches.
/// Anonymous, device-scoped (X-Install-Id), idempotent on the server.
class TelemetryRecorder implements AnalyticsClient {
  TelemetryRecorder(this._db, {DateTime Function()? clock}) : _clock = clock ?? DateTime.now;

  final AppDatabase _db;
  final DateTime Function() _clock;
  static const _uuid = Uuid();

  /// Contract level event types and the analytics names they come from.
  static const levelEvents = {
    'level_started',
    'level_completed',
    'level_restarted',
    'hint_used',
    'undo_used',
    'blocked_tap',
    'stuck',
    'rescue_used',
  };

  final Map<int, String> _attempts = {};
  late _Session _session = _Session.start(_clock());

  String get sessionId => _session.id;

  @override
  void screen(String name) {
    if (name.contains('store') || name.contains('settings')) _session.counters['store_views'] = (_session.counters['store_views'] ?? 0) + 1;
  }

  @override
  void track(String event, Map<String, Object?> params) {
    _count(event, params);
    if (!levelEvents.contains(event)) return;
    final levelId = (params['level_id'] as num?)?.toInt();
    if (levelId == null) return;
    final daily = params['daily'] == true || levelId > 19000000;
    if (event == 'level_started' && params['resumed'] != true) _attempts.remove(levelId);
    final attempt = _attempts.putIfAbsent(levelId, () => _uuid.v4());
    final row = {
      'kind': 'level',
      'event_id': _uuid.v4(),
      'event_type': event,
      if (daily) 'daily_date': WireIds.dateFromKey(levelId) else 'level_id': levelId,
      'attempt_id': attempt,
      if (params['moves'] is num) 'moves': (params['moves'] as num).toInt(),
      if (params['time_ms'] is num) 'time_ms': (params['time_ms'] as num).toInt(),
      'occurred_at': WireIds.iso(_clock()),
    };
    if (event == 'level_completed' || event == 'level_restarted') _attempts.remove(levelId);
    unawaited(_db.into(_db.telemetryEvents).insert(TelemetryEventsCompanion.insert(json: jsonEncode(row))));
  }

  void _count(String event, Map<String, Object?> params) {
    final daily = params['daily'] == true;
    String? key = switch (event) {
      'level_started' => daily ? 'daily_started' : 'levels_started',
      'level_completed' => daily ? 'daily_completed' : 'levels_completed',
      'level_restarted' => 'levels_restarted',
      'hint_used' => 'hints_used',
      'undo_used' => 'undos_used',
      'rescue_used' => 'rescues_used',
      'rewarded_ad_completed' => 'rewarded_completed',
      'rewarded_ad_abandoned' => 'rewarded_abandoned',
      'purchase_started' => 'purchases_started',
      'purchase_completed' || 'remove_ads_purchase' => 'purchases_completed',
      _ => null,
    };
    if (event == 'ad_impression') {
      final format = params['format'];
      if (format is String) key = 'ad_impressions_$format';
    }
    if (key != null) _session.counters[key] = (_session.counters[key] ?? 0) + 1;
    if (event == 'level_completed' && params['time_ms'] is num) {
      _session.counters['play_ms'] = (_session.counters['play_ms'] ?? 0) + (params['time_ms'] as num).toInt();
    }
  }

  void onForeground() {
    if (_session.endedAt != null) {
      // New foreground session after > 30 min away; otherwise continue.
      if (_clock().difference(_session.endedAt!) > const Duration(minutes: 30)) {
        _session = _Session.start(_clock());
      } else {
        _session.resumedAt = _clock();
        _session.endedAt = null;
      }
    }
  }

  void onBackground() {
    final now = _clock();
    _session.foregroundMs += now.difference(_session.resumedAt).inMilliseconds;
    _session.resumedAt = now;
    _session.endedAt = now;
  }

  /// Current session as a contract session object.
  Map<String, dynamic> sessionJson() {
    final id = InstallIdentity.current;
    final fg = _session.foregroundMs +
        (_session.endedAt == null ? _clock().difference(_session.resumedAt).inMilliseconds : 0);
    final local = _session.startedAt.toLocal();
    return {
      'session_id': _session.id,
      if (id != null) 'app_version': id.appVersion,
      if (id != null) 'build': id.build,
      'started_at': WireIds.iso(_session.startedAt),
      if (_session.endedAt != null) 'ended_at': WireIds.iso(_session.endedAt!),
      'local_day': WireIds.dateFromKey(local.year * 10000 + local.month * 100 + local.day),
      'foreground_ms': fg,
      ..._session.counters,
      'abnormal_end': false,
    };
  }
}

class _Session {
  _Session(this.id, this.startedAt) : resumedAt = startedAt;

  factory _Session.start(DateTime now) => _Session(const Uuid().v4(), now.toUtc());

  final String id;
  final DateTime startedAt;
  DateTime resumedAt;
  DateTime? endedAt;
  int foregroundMs = 0;
  final Map<String, int> counters = {};
}

/// Uploads queued telemetry (≤ 500 level events per batch). Runs on
/// background and every few minutes; failures just wait for the next try.
class TelemetryUploader {
  TelemetryUploader(this._db, this._api, this._recorder);

  final AppDatabase _db;
  final ApiService _api;
  final TelemetryRecorder _recorder;
  Future<void>? _inFlight;
  Timer? _timer;

  void start() => _timer ??= Timer.periodic(const Duration(minutes: 5), (_) => unawaited(upload()));

  Future<void> upload() => _inFlight ??= _upload().whenComplete(() => _inFlight = null);

  Future<void> _upload() async {
    final id = InstallIdentity.current;
    if (id == null) return;
    try {
      final rows = await (_db.select(_db.telemetryEvents)
            ..orderBy([(t) => OrderingTerm.asc(t.id)])
            ..limit(500))
          .get();
      final events = <Map<String, dynamic>>[];
      for (final r in rows) {
        final j = (jsonDecode(r.json) as Map).cast<String, dynamic>()..remove('kind');
        events.add(j);
      }
      final result = await _api.telemetryBatch({
        'install_id': id.installId,
        'app_version': id.appVersion,
        'build': id.build,
        'platform': id.platform,
        'locale': PlatformDispatcher.instance.locale.languageCode,
        'installed_at': WireIds.iso(id.installedAt),
        'sessions': [_recorder.sessionJson()],
        'level_events': events,
      });
      if (result.isSuccess || result.failure == ApiFailure.validation) {
        // Accepted, or permanently refused (never retry unchanged).
        if (rows.isNotEmpty) {
          await (_db.delete(_db.telemetryEvents)..where((t) => t.id.isSmallerOrEqualValue(rows.last.id))).go();
        }
      }
    } on Object catch (e) {
      AppLog.warn('Telemetry upload failed: $e');
    }
  }

  void dispose() => _timer?.cancel();
}
