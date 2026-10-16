import 'dart:convert';

import 'package:drift/drift.dart';

import '../../data/database/app_database.dart';
import '../../game/generator/curriculum.dart';
import 'wire_ids.dart';

/// Builds `/sync/*` request bodies from Drift (API_CONTRACT §3). Snapshot
/// types read the latest rows; event types use the payload frozen in the
/// outbox row. Pure functions of the database — unit-tested in memory.
class SyncPayloads {
  SyncPayloads(this._db);

  final AppDatabase _db;

  /// Endpoint for an outbox data type.
  static String pathFor(String dataType) => switch (dataType) {
    SyncDataType.settings => '/sync/settings',
    SyncDataType.progress => '/sync/progress',
    SyncDataType.coinBalance => '/sync/coins/balance',
    SyncDataType.coinTransaction => '/sync/coins/transactions',
    SyncDataType.unlockedItem => '/sync/unlocked-items',
    SyncDataType.equipped => '/sync/equipped',
    SyncDataType.daily => '/sync/daily',
    _ => throw ArgumentError('Unknown sync data type $dataType'),
  };

  /// Drain order: grants/ledger before the balance they change.
  static const order = [
    SyncDataType.settings,
    SyncDataType.progress,
    SyncDataType.unlockedItem,
    SyncDataType.coinTransaction,
    SyncDataType.coinBalance,
    SyncDataType.equipped,
    SyncDataType.daily,
  ];

  /// Body for a group of outbox rows of one type; null = nothing to send
  /// (rows can be evicted).
  Future<Map<String, dynamic>?> build(String dataType, List<SyncQueueData> rows) async {
    switch (dataType) {
      case SyncDataType.settings:
        return settings();
      case SyncDataType.progress:
        final ids = <int>{for (final r in rows) ?int.tryParse(r.entityKey)};
        return progress(ids);
      case SyncDataType.coinBalance:
        return coinBalance();
      case SyncDataType.equipped:
        return equipped();
      case SyncDataType.coinTransaction:
        final items = [for (final r in rows) ?coinTransactionItem(_decode(r.payload))];
        return items.isEmpty ? null : {'items': items};
      case SyncDataType.unlockedItem:
        final items = [for (final r in rows) ?unlockedItem(_decode(r.payload))];
        return items.isEmpty ? null : {'items': items};
      case SyncDataType.daily:
        final items = [for (final r in rows) ?dailyItem(_decode(r.payload))];
        return items.isEmpty ? null : {'items': items};
    }
    return null;
  }

  static Map<String, dynamic>? _decode(String? payload) {
    if (payload == null) return null;
    try {
      final v = jsonDecode(payload);
      return v is Map ? v.cast<String, dynamic>() : null;
    } on Object {
      return null;
    }
  }

  Future<Map<String, dynamic>?> settings() async {
    final s = await (_db.select(_db.gameSettings)..where((t) => t.id.equals(1))).getSingleOrNull();
    if (s == null) return null;
    return {
      'sound_enabled': s.sound,
      'music_enabled': s.music,
      'haptics_enabled': s.haptics,
      'reduced_motion': s.reducedMotion,
      'locale_code': ?s.localeCode,
      'notify_daily_reminder': s.dailyReminder,
      'notify_streak_reminder': s.dailyReminder,
      'updated_at': WireIds.iso(s.updatedAt),
    };
  }

  /// Progress summary + the given (or all, when empty) cleared levels.
  Future<Map<String, dynamic>> progress(Set<int> levelIds) async {
    final all = await _db.select(_db.levelClears).get();
    final cleared = {for (final c in all) c.levelId};
    var current = 1;
    while (cleared.contains(current)) {
      current++;
    }
    final chapters = <int>[];
    for (var ch = 1; ch <= (cleared.isEmpty ? 0 : cleared.reduce((a, b) => a > b ? a : b) ~/ kLevelsPerChapter + 1); ch++) {
      final first = (ch - 1) * kLevelsPerChapter + 1;
      if (List.generate(kLevelsPerChapter, (i) => first + i).every(cleared.contains)) chapters.add(ch);
    }
    final rows = levelIds.isEmpty ? all : all.where((c) => levelIds.contains(c.levelId));
    final latest = all.isEmpty
        ? DateTime.now().toUtc()
        : all.map((c) => c.lastClearedAt).reduce((a, b) => a.isAfter(b) ? a : b);
    return {
      'current_level': current,
      'chapters_completed': chapters,
      'levels': [
        for (final c in rows)
          {
            'level_id': c.levelId,
            'best_moves': c.bestMoves,
            'best_time_ms': c.bestTimeMs,
            'mastered': c.mastered,
            'first_cleared_at': WireIds.iso(c.firstClearedAt),
          },
      ],
      'updated_at': WireIds.iso(latest),
    };
  }

  Future<Map<String, dynamic>> coinBalance() async {
    final profile = await (_db.select(_db.playerProfile)..where((p) => p.id.equals(1))).getSingleOrNull();
    final sums = await _db.customSelect(
      'SELECT COALESCE(SUM(CASE WHEN amount > 0 THEN amount END), 0) AS earned, '
      'COALESCE(-SUM(CASE WHEN amount < 0 THEN amount END), 0) AS spent FROM coin_transactions',
      readsFrom: {_db.coinTransactions},
    ).getSingle();
    return {
      'balance': (profile?.coins ?? 0).clamp(0, 10000000),
      'updated_at': WireIds.iso(profile?.updatedAt ?? DateTime.now()),
      'total_earned': sums.read<int>('earned'),
      'total_spent': sums.read<int>('spent'),
    };
  }

  Future<Map<String, dynamic>> equipped() async {
    final profile = await (_db.select(_db.playerProfile)..where((p) => p.id.equals(1))).getSingleOrNull();
    final theme = profile?.equippedTheme ?? 'blueprint';
    return {
      'theme_id': theme == 'blueprint' ? null : WireIds.themeToServer(theme),
      'updated_at': WireIds.iso(profile?.updatedAt ?? DateTime.now()),
    };
  }

  /// Ledger row → contract item. Server grants keep their own type/source.
  static Map<String, dynamic>? coinTransactionItem(Map<String, dynamic>? p) {
    if (p == null) return null;
    final key = p['idempotency_key'] ?? p['id'];
    final amount = p['amount'];
    if (key is! String || amount is! int) return null;
    final reason = (p['source'] ?? p['reason'] ?? 'other').toString();
    return {
      'amount': amount,
      'type': p['type'] ?? (amount >= 0 ? 'earned' : 'spent'),
      'source': reason.length > 50 ? reason.substring(0, 50) : reason,
      'idempotency_key': key,
      'created_at': p['created_at'] ?? WireIds.iso(DateTime.now()),
      if (p['description'] != null) 'description': p['description'],
      if (p['description'] == null && p['level_id'] != null) 'description': 'Level ${p['level_id']}',
    };
  }

  static Map<String, dynamic>? unlockedItem(Map<String, dynamic>? p) {
    if (p == null) return null;
    final type = p['item_type'];
    final id = p['item_id'];
    if (type is! String || id is! String) return null;
    return {
      'item_type': type,
      'item_id': type == 'theme' ? WireIds.themeToServer(id) : id,
      'unlocked_at': p['unlocked_at'] ?? WireIds.iso(DateTime.now()),
      'unlocked_by': WireIds.unlockedBy((p['source'] ?? 'reward').toString()),
    };
  }

  static Map<String, dynamic>? dailyItem(Map<String, dynamic>? p) {
    if (p == null) return null;
    final date = p['date'];
    final moves = p['moves'];
    if (date is! String || moves is! int || moves < 1) return null;
    return {
      'date': date,
      'moves': moves,
      'time_ms': p['time_ms'] ?? 0,
      'completed_at': p['completed_at'] ?? WireIds.iso(DateTime.now()),
      'mastered': p['mastered'] ?? false,
    };
  }
}

/// Server coin grants (coin packs, Pro monthly coins) — exactly-once
/// crediting per API_CONTRACT §3 "Server coin grants".
class CoinGrants {
  CoinGrants(this._db);

  final AppDatabase _db;

  /// Credits each grant whose idempotency key is not already in the local
  /// ledger, in one transaction, and enqueues it (plus the balance) so the
  /// next push acknowledges it. Returns the total credited.
  Future<int> credit(List<dynamic>? grants) async {
    if (grants == null || grants.isEmpty) return 0;
    return _db.transaction(() async {
      var credited = 0;
      for (final g in grants) {
        if (g is! Map) continue;
        final key = g['idempotency_key'];
        final amount = g['amount'];
        if (key is! String || amount is! int || amount == 0) continue;
        final existing = await (_db.select(_db.coinTransactions)..where((t) => t.id.equals(key))).getSingleOrNull();
        if (existing != null) continue;
        final created = DateTime.tryParse('${g['created_at']}')?.toUtc() ?? DateTime.now().toUtc();
        final source = (g['source'] ?? 'grant').toString();
        await _db.into(_db.coinTransactions).insert(
          CoinTransactionsCompanion.insert(id: key, amount: amount, reason: source, createdAt: created),
        );
        await _db.customUpdate(
          'UPDATE player_profile SET coins = MAX(0, coins + ?), updated_at = ? WHERE id = 1',
          variables: [Variable.withInt(amount), Variable.withDateTime(DateTime.now().toUtc())],
          updates: {_db.playerProfile},
        );
        await _db.enqueueSyncOutbox(
          dataType: SyncDataType.coinTransaction,
          entityKey: key,
          payload: {
            'idempotency_key': key,
            'amount': amount,
            'type': g['type'] ?? 'grant',
            'source': source,
            'description': ?g['description'],
            'created_at': WireIds.iso(created),
          },
        );
        credited += amount;
      }
      if (credited != 0) {
        await _db.enqueueSyncOutbox(dataType: SyncDataType.coinBalance, entityKey: 'balance');
      }
      return credited;
    });
  }
}
