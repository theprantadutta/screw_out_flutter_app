import 'dart:async';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/network/api_service.dart';
import '../../core/network/connectivity_service.dart';
import '../../data/database/app_database.dart';
import '../app_log.dart';
import 'pull_merger.dart';
import 'sync_payloads.dart';
import 'sync_report.dart';

/// The only thing that pushes local changes to the API (ported from
/// snake-classic). Drains the Drift [SyncQueue] grouped by data type:
///
/// * 3 s debounce after an outbox change, never deferred beyond 10 s;
/// * every 2 minutes, on resume and on pause;
/// * gated on a usable JWT and an OS link (link state is a hint, not proof);
/// * success evicts; transient leaves pending; permanent bumps attempts and
///   dead-letters (status 2) after [maxRetries].
class SyncEngine {
  SyncEngine(this._db, this._api, this._connectivity) : _payloads = SyncPayloads(_db);

  final AppDatabase _db;
  final ApiService _api;
  final ConnectivityService _connectivity;
  final SyncPayloads _payloads;

  static const maxRetries = 5;
  static const _debounce = Duration(seconds: 3);
  static const _maxDefer = Duration(seconds: 10);
  static const _periodic = Duration(minutes: 2);
  static const _lastSyncedUserKey = 'sync_last_synced_user_id';

  Timer? _debounceTimer;
  Timer? _periodicTimer;
  DateTime? _deadline;
  StreamSubscription<List<SyncQueueData>>? _outboxSub;
  StreamSubscription<bool>? _linkSub;
  Future<void>? _inFlight;
  bool _started = false;

  /// Arms the triggers. Safe to call more than once.
  void start() {
    if (_started) return;
    _started = true;
    _outboxSub = (_db.select(_db.syncQueue)..where((q) => q.status.equals(0))).watch().listen((rows) {
      if (rows.isNotEmpty) schedule();
    });
    _linkSub = _connectivity.snapshots.map((s) => s.shouldAttemptNetworkWork).distinct().listen((ok) {
      if (ok) schedule(immediate: true);
    });
    _periodicTimer = Timer.periodic(_periodic, (_) {
      schedule();
      unawaited(refresh());
    });
  }

  void schedule({bool immediate = false}) {
    _debounceTimer?.cancel();
    if (immediate) {
      _deadline = null;
      unawaited(syncNow());
      return;
    }
    final now = DateTime.now();
    _deadline ??= now.add(_maxDefer);
    final remaining = _deadline!.difference(now);
    _debounceTimer = Timer(remaining < _debounce ? (remaining.isNegative ? Duration.zero : remaining) : _debounce, () {
      _deadline = null;
      unawaited(syncNow());
    });
  }

  /// Drains now; concurrent callers share one drain.
  Future<void> syncNow() => _inFlight ??= _drain().whenComplete(() => _inFlight = null);

  Future<void> _drain() async {
    if (!_api.isAuthenticated || !_connectivity.shouldAttemptNetworkWork) return;
    try {
      final rows = await (_db.select(_db.syncQueue)
            ..where((q) => q.status.equals(0))
            ..orderBy([(q) => OrderingTerm.asc(q.id)]))
          .get();
      if (rows.isEmpty) return;
      final groups = <String, List<SyncQueueData>>{};
      for (final r in rows) {
        groups.putIfAbsent(r.dataType, () => []).add(r);
      }
      for (final type in [...SyncPayloads.order, ...groups.keys.where((k) => !SyncPayloads.order.contains(k))]) {
        final group = groups[type];
        if (group == null) continue;
        final stop = await _drainGroup(type, group);
        if (stop) break; // backend down / session gone - try again later
      }
    } on Object catch (e, s) {
      AppLog.error('SyncEngine drain failed', e, s);
    }
  }

  /// Returns true when the drain should stop (transient failure).
  Future<bool> _drainGroup(String type, List<SyncQueueData> rows) async {
    if (!SyncPayloads.order.contains(type)) {
      await _deadLetter(rows, 'unknown data type');
      return false;
    }
    // Batches of ≤ 500 for list endpoints.
    for (var i = 0; i < rows.length; i += 500) {
      final batch = rows.sublist(i, i + 500 > rows.length ? rows.length : i + 500);
      final body = await _payloads.build(type, batch);
      if (body == null) {
        await _evict(batch);
        continue;
      }
      final key = '$type:${batch.first.id}-${batch.last.id}-${batch.length}';
      final outcome = await _api.syncPost(SyncPayloads.pathFor(type), body, idempotencyKey: key);
      switch (outcome.kind) {
        case SyncOutcomeKind.success:
          await _evict(batch);
        case SyncOutcomeKind.transient:
          return true;
        case SyncOutcomeKind.permanent:
          await _bump(batch, 'HTTP ${outcome.statusCode}');
      }
    }
    return false;
  }

  Future<void> _evict(List<SyncQueueData> rows) =>
      (_db.delete(_db.syncQueue)..where((q) => q.id.isIn(rows.map((r) => r.id)))).go();

  Future<void> _bump(List<SyncQueueData> rows, String error) async {
    for (final r in rows) {
      final attempts = r.attempts + 1;
      await (_db.update(_db.syncQueue)..where((q) => q.id.equals(r.id))).write(
        SyncQueueCompanion(
          attempts: Value(attempts),
          lastError: Value(error),
          status: Value(attempts >= maxRetries ? 2 : 0),
        ),
      );
    }
  }

  Future<void> _deadLetter(List<SyncQueueData> rows, String reason) async {
    for (final r in rows) {
      await (_db.update(_db.syncQueue)..where((q) => q.id.equals(r.id))).write(
        SyncQueueCompanion(status: const Value(2), lastError: Value(reason)),
      );
    }
  }

  // --------------------------------------------------------- first sign-in

  /// Called after every successful `/auth/firebase`.
  ///
  /// * First time this device meets an account that has cloud data: pull and
  ///   merge (additive - local progress is never lost) → [SyncReportKind.restored].
  /// * A brand-new account: push everything the guest built → [SyncReportKind.savedNew].
  /// * Already linked: a routine [refresh] in the background → null.
  ///
  /// A failed first pull leaves the device unlinked, so the next session or
  /// resume retries it ([SyncReportKind.restoreFailed] is returned once).
  Future<SyncReport?> onSignedIn({required String userId, required bool isNewUser}) async {
    final prefs = await SharedPreferences.getInstance();
    final last = prefs.getString(_lastSyncedUserKey);
    SyncReport? report;
    if (!isNewUser && last != userId) {
      final pulled = await _api.pull();
      if (pulled.isSuccess && pulled.value != null) {
        final stats = await PullMerger(_db).apply(pulled.value!);
        await prefs.setString(_lastSyncedUserKey, userId);
        _lastPullAt = DateTime.now();
        report = await _report(SyncReportKind.restored, stats);
      } else {
        AppLog.warn('First sign-in pull failed (${pulled.failure}); retried on the next session');
        report = _restoreFailedShown ? null : await _report(SyncReportKind.restoreFailed, const MergeStats());
        _restoreFailedShown = true;
      }
    } else if (isNewUser) {
      await _enqueueEverything();
      await prefs.setString(_lastSyncedUserKey, userId);
      report = await _report(SyncReportKind.savedNew, const MergeStats());
    } else {
      unawaited(refresh(force: true));
    }
    if (report?.kind != SyncReportKind.restoreFailed) _restoreFailedShown = false;
    schedule(immediate: true);
    return report;
  }

  Future<SyncReport> _report(SyncReportKind kind, MergeStats stats) async {
    final clears = (await _db.select(_db.levelClears).get()).length;
    final profile = await (_db.select(_db.playerProfile)..where((p) => p.id.equals(1))).getSingleOrNull();
    final r = SyncReport(kind, stats: stats, totalClears: clears, coins: profile?.coins ?? 0);
    AppLog.info('Sync: $r');
    return r;
  }

  /// Forget the account binding (sign-out / deletion).
  Future<void> forgetAccount() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_lastSyncedUserKey);
    _lastPullAt = null;
  }

  // -------------------------------------------------------------- refresh

  final _reports = StreamController<SyncReport>.broadcast();
  DateTime? _lastPullAt;
  Future<void>? _refreshing;
  bool _restoreFailedShown = false;
  static const _pullEvery = Duration(seconds: 45);

  /// Notices for the player that no screen asked for (another device's
  /// progress arriving, a delayed restore). The app turns them into toasts.
  Stream<SyncReport> get reports => _reports.stream;

  /// Publishes a report on [reports].
  void announce(SyncReport report) {
    if (!_reports.isClosed) _reports.add(report);
  }

  /// Keeps a linked device in step with the account's other devices: push
  /// what this device has, then pull and merge (newest coin balance wins).
  /// Runs on session start, resume and every few minutes; throttled.
  Future<void> refresh({bool force = false}) => _refreshing ??= _refresh(force).whenComplete(() => _refreshing = null);

  Future<void> _refresh(bool force) async {
    if (!_api.isAuthenticated || !_connectivity.shouldAttemptNetworkWork) return;
    final last = _lastPullAt;
    if (!force && last != null && DateTime.now().difference(last) < _pullEvery) return;
    final prefs = await SharedPreferences.getInstance();
    final linked = prefs.getString(_lastSyncedUserKey);
    final me = _api.currentUserId;
    if (me == null) return;
    if (linked != me) {
      // The first pull never landed (offline at sign-in): do it now.
      final report = await onSignedIn(userId: me, isNewUser: false);
      if (report != null && report.kind != SyncReportKind.restoreFailed) announce(report);
      return;
    }
    try {
      await syncNow(); // the server sees this device's changes first
      final pulled = await _api.pull();
      final snapshot = pulled.value;
      if (!pulled.isSuccess || snapshot == null) return;
      _lastPullAt = DateTime.now();
      final stats = await PullMerger(_db).apply(snapshot, coins: CoinMerge.newestWins);
      if (stats.clearsAdded > 0 || stats.dailyAdded > 0 || stats.themesAdded > 0) {
        announce(await _report(SyncReportKind.fromOtherDevice, stats));
      }
      schedule();
    } on Object catch (e, s) {
      AppLog.error('Sync refresh failed', e, s);
    }
  }

  /// A new account receives the whole local state.
  Future<void> _enqueueEverything() => _db.transaction(() async {
    await _db.enqueueSyncOutbox(dataType: SyncDataType.settings, entityKey: 'settings');
    for (final c in await _db.select(_db.levelClears).get()) {
      await _db.enqueueSyncOutbox(dataType: SyncDataType.progress, entityKey: '${c.levelId}');
    }
    await _db.enqueueSyncOutbox(dataType: SyncDataType.coinBalance, entityKey: 'balance');
    await _db.enqueueSyncOutbox(dataType: SyncDataType.equipped, entityKey: 'theme');
  });

  /// Rows that will never upload (for diagnostics).
  Future<int> deadLetterCount() async =>
      (await (_db.select(_db.syncQueue)..where((q) => q.status.equals(2))).get()).length;

  @visibleForTesting
  Future<void> drainForTesting() => _drain();

  void dispose() {
    _debounceTimer?.cancel();
    _periodicTimer?.cancel();
    _outboxSub?.cancel();
    _linkSub?.cancel();
  }
}
