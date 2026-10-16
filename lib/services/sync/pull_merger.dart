import 'dart:convert';

import 'package:drift/drift.dart';

import '../../data/database/app_database.dart';
import 'sync_payloads.dart';
import 'wire_ids.dart';

/// Applies a `GET /sync/pull` snapshot to Drift without ever losing local
/// progress (API_CONTRACT §3 merge rules, applied client-side):
///
/// * clears: union; best moves/time MIN; mastered sticky; first clear earliest.
/// * coins: server balance + local ledger rows the server has not seen yet
///   (still pending in the outbox), then pending grants are credited.
/// * unlocked items, daily completions: union.
/// * settings, equipped theme: last-write-wins on `updated_at`.
///
/// Everything the merge adds locally that the server lacks is re-enqueued so
/// the next drain makes the server whole.
class PullMerger {
  PullMerger(this._db);

  final AppDatabase _db;

  Future<void> apply(Map<String, dynamic> snapshot) async {
    await _db.transaction(() async {
      await _settings(snapshot['settings']);
      await _progress(snapshot['progress']);
      await _unlocked(snapshot['unlocked_items']);
      await _equipped(snapshot['equipped']);
      await _daily(snapshot['daily']);
      await _coins(snapshot['coins']);
    });
    final coins = snapshot['coins'];
    await CoinGrants(_db).credit(coins is Map ? coins['pending_grants'] as List? : null);
  }

  DateTime? _time(Object? v) => v is String ? DateTime.tryParse(v)?.toUtc() : null;

  Future<void> _settings(Object? s) async {
    if (s is! Map) return;
    final remoteAt = _time(s['updated_at']);
    final local = await (_db.select(_db.gameSettings)..where((t) => t.id.equals(1))).getSingleOrNull();
    if (remoteAt == null || (local != null && local.initialized && !remoteAt.isAfter(local.updatedAt))) {
      await _db.enqueueSyncOutbox(dataType: SyncDataType.settings, entityKey: 'settings');
      return;
    }
    await _db.into(_db.gameSettings).insertOnConflictUpdate(
      GameSettingsCompanion(
        id: const Value(1),
        sound: Value(s['sound_enabled'] as bool? ?? true),
        music: Value(s['music_enabled'] as bool? ?? false),
        haptics: Value(s['haptics_enabled'] as bool? ?? true),
        reducedMotion: Value(s['reduced_motion'] as bool? ?? false),
        localeCode: Value(s['locale_code'] as String?),
        dailyReminder: Value(s['notify_daily_reminder'] as bool? ?? true),
        // Someone with cloud progress has seen the tutorial.
        tutorialDone: const Value(true),
        initialized: const Value(true),
        updatedAt: Value(remoteAt),
      ),
    );
  }

  Future<void> _progress(Object? p) async {
    final local = {for (final c in await _db.select(_db.levelClears).get()) c.levelId: c};
    final remoteIds = <int>{};
    if (p is Map && p['levels'] is List) {
      for (final l in p['levels'] as List) {
        if (l is! Map) continue;
        final id = l['level_id'];
        if (id is! int) continue;
        remoteIds.add(id);
        final moves = l['best_moves'] as int?;
        final time = l['best_time_ms'] as int?;
        final mastered = l['mastered'] == true;
        final first = _time(l['first_cleared_at']) ?? DateTime.now().toUtc();
        final mine = local[id];
        if (mine == null) {
          await _db.into(_db.levelClears).insert(
            LevelClearsCompanion.insert(
              levelId: Value(id),
              bestMoves: moves != null && moves > 0 ? moves : 0,
              bestTimeMs: time != null && time > 0 ? time : 0,
              mastered: Value(mastered),
              firstClearedAt: first,
              lastClearedAt: first,
            ),
          );
          continue;
        }
        int best(int a, int? b) => (b == null || b <= 0) ? a : (a <= 0 ? b : (a < b ? a : b));
        final merged = LevelClearsCompanion(
          bestMoves: Value(best(mine.bestMoves, moves)),
          bestTimeMs: Value(best(mine.bestTimeMs, time)),
          mastered: Value(mine.mastered || mastered),
          firstClearedAt: Value(first.isBefore(mine.firstClearedAt) ? first : mine.firstClearedAt),
        );
        await (_db.update(_db.levelClears)..where((c) => c.levelId.equals(id))).write(merged);
        final improvedLocally = (moves == null || mine.bestMoves < moves) || (mine.mastered && !mastered);
        if (improvedLocally) {
          await _db.enqueueSyncOutbox(dataType: SyncDataType.progress, entityKey: '$id');
        }
      }
    }
    for (final id in local.keys.where((id) => !remoteIds.contains(id))) {
      await _db.enqueueSyncOutbox(dataType: SyncDataType.progress, entityKey: '$id');
    }
  }

  Future<void> _unlocked(Object? items) async {
    final local = {
      for (final i in await _db.select(_db.unlockedItems).get()) '${i.itemType}:${i.itemId}': i,
    };
    final remote = <String>{};
    if (items is List) {
      for (final i in items) {
        if (i is! Map) continue;
        final type = i['item_type'];
        final rawId = i['item_id'];
        if (type is! String || rawId is! String) continue;
        final id = type == 'theme' ? WireIds.themeFromServer(rawId) : rawId;
        remote.add('$type:$id');
        await _db.into(_db.unlockedItems).insert(
          UnlockedItemsCompanion.insert(
            itemType: type,
            itemId: id,
            source: switch (i['unlocked_by']) {
              'purchase' => 'purchase',
              'pro' => 'pro',
              'coins' => 'coins',
              'default' => 'default',
              _ => 'chapter',
            },
            unlockedAt: _time(i['unlocked_at']) ?? DateTime.now().toUtc(),
          ),
          mode: InsertMode.insertOrIgnore,
        );
      }
    }
    for (final entry in local.entries.where((e) => !remote.contains(e.key) && e.value.source != 'default')) {
      final i = entry.value;
      await _db.enqueueSyncOutbox(
        dataType: SyncDataType.unlockedItem,
        entityKey: entry.key,
        payload: {
          'item_type': i.itemType,
          'item_id': i.itemId,
          'source': i.source,
          'unlocked_at': WireIds.iso(i.unlockedAt),
        },
      );
    }
  }

  Future<void> _equipped(Object? e) async {
    final profile = await (_db.select(_db.playerProfile)..where((p) => p.id.equals(1))).getSingleOrNull();
    final remoteAt = e is Map ? _time(e['updated_at']) : null;
    if (e is! Map || remoteAt == null || (profile != null && !remoteAt.isAfter(profile.updatedAt))) {
      if (profile != null && profile.equippedTheme != 'blueprint') {
        await _db.enqueueSyncOutbox(dataType: SyncDataType.equipped, entityKey: 'theme');
      }
      return;
    }
    final theme = e['theme_id'] is String ? WireIds.themeFromServer(e['theme_id'] as String) : 'blueprint';
    await (_db.update(_db.playerProfile)..where((p) => p.id.equals(1))).write(
      PlayerProfileCompanion(equippedTheme: Value(theme)),
    );
  }

  Future<void> _daily(Object? d) async {
    final local = {for (final c in await _db.select(_db.dailyCompletions).get()) c.dateKey: c};
    final remote = <int>{};
    if (d is Map && d['completions'] is List) {
      for (final c in d['completions'] as List) {
        if (c is! Map) continue;
        final key = WireIds.keyFromDate(c['date'] as String?);
        final moves = c['moves'];
        if (key == null || moves is! int) continue;
        remote.add(key);
        if (local.containsKey(key)) continue;
        await _db.into(_db.dailyCompletions).insert(
          DailyCompletionsCompanion.insert(
            dateKey: Value(key),
            moves: moves,
            timeMs: c['time_ms'] as int? ?? 0,
            completedAt: _time(c['completed_at']) ?? DateTime.now().toUtc(),
          ),
          mode: InsertMode.insertOrIgnore,
        );
      }
    }
    for (final c in local.values.where((c) => !remote.contains(c.dateKey))) {
      await _db.enqueueSyncOutbox(
        dataType: SyncDataType.daily,
        entityKey: '${c.dateKey}',
        payload: {
          'date': WireIds.dateFromKey(c.dateKey),
          'moves': c.moves,
          'time_ms': c.timeMs,
          'completed_at': WireIds.iso(c.completedAt),
        },
      );
    }
  }

  /// Server balance + local ledger rows not yet pushed.
  Future<void> _coins(Object? c) async {
    if (c is! Map || c['balance'] is! int) {
      await _db.enqueueSyncOutbox(dataType: SyncDataType.coinBalance, entityKey: 'balance');
      return;
    }
    final pending = await (_db.select(_db.syncQueue)
          ..where((q) => q.dataType.equals(SyncDataType.coinTransaction) & q.status.equals(0)))
        .get();
    var unpushed = 0;
    for (final row in pending) {
      final p = row.payload == null ? null : jsonDecode(row.payload!);
      if (p is Map && p['amount'] is int) unpushed += p['amount'] as int;
    }
    final merged = ((c['balance'] as int) + unpushed).clamp(0, 10000000);
    await (_db.update(_db.playerProfile)..where((p) => p.id.equals(1))).write(
      PlayerProfileCompanion(coins: Value(merged), updatedAt: Value(DateTime.now().toUtc())),
    );
    await _db.enqueueSyncOutbox(dataType: SyncDataType.coinBalance, entityKey: 'balance');
  }
}
