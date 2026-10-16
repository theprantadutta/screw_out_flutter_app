import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:screw_out/core/network/api_service.dart';
import 'package:screw_out/core/network/connectivity_service.dart';
import 'package:screw_out/data/database/app_database.dart';
import 'package:screw_out/game/domain/level.dart';
import 'package:screw_out/presentation/bloc/game/game_host.dart';
import 'package:screw_out/services/progress_service.dart';
import 'package:screw_out/services/sync/pull_merger.dart';
import 'package:screw_out/services/sync/sync_engine.dart';
import 'package:screw_out/services/sync/sync_payloads.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _level = Level(
  id: 7,
  code: 'DWG 007',
  chapter: 1,
  title: 't',
  trayCapacity: 3,
  panels: [Panel.rect(id: 'a', x: 20, y: 20, w: 100, h: 100, depth: 0, label: 'PL-01')],
  screws: [Screw(id: 'a0', panelId: 'a', x: 70, y: 70)],
);

LevelResult _result({Level level = _level, int moves = 4, bool mastered = true}) => LevelResult(
  level: level,
  moves: moves,
  elapsed: const Duration(seconds: 12),
  mastered: mastered,
  usedHint: false,
  restarted: false,
  rescued: false,
  isDaily: false,
);

/// A JWT whose `exp` is far in the future (signature irrelevant client-side).
String _jwt() {
  String b64(Object o) => base64Url.encode(utf8.encode(jsonEncode(o))).replaceAll('=', '');
  return '${b64({'alg': 'HS256'})}.${b64({'exp': 4102444800, 'sub': 'u1'})}.sig';
}

void main() {
  late AppDatabase db;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    await db.initializeDefaults();
  });

  tearDown(() => db.close());

  group('payloads', () {
    test('progress, ledger, balance and daily bodies follow the contract', () async {
      final progress = ProgressService(db);
      await progress.recordClear(_result());
      final payloads = SyncPayloads(db);

      final p = await payloads.progress({7});
      expect(p['current_level'], 1); // sheet 1 not cleared yet
      final level = (p['levels'] as List).single as Map;
      expect(level['level_id'], 7);
      expect(level['best_moves'], 4);
      expect(level['mastered'], isTrue);

      final rows = await (db.select(db.syncQueue)..where((q) => q.dataType.equals(SyncDataType.coinTransaction))).get();
      final body = (await payloads.build(SyncDataType.coinTransaction, rows))!;
      final item = (body['items'] as List).single as Map;
      expect(item['amount'], Rewards.firstClear(1) + Rewards.masteryBonus);
      expect(item['type'], 'earned');
      expect(item['source'], 'level_clear');
      expect(item['idempotency_key'], rows.single.entityKey);
      expect(item['description'], 'Level 7');

      final balance = await payloads.coinBalance();
      expect(balance['balance'], Rewards.firstClear(1) + Rewards.masteryBonus);
      expect(balance['total_spent'], 0);
    });

    test('equipped and unlocked themes use API ids', () async {
      final progress = ProgressService(db);
      await progress.grantThemes(['walnut'], 'purchase');
      await progress.equipTheme('walnut');
      expect((await SyncPayloads(db).equipped())['theme_id'], 'workshop');
      final rows = await (db.select(db.syncQueue)..where((q) => q.dataType.equals(SyncDataType.unlockedItem))).get();
      final item = ((await SyncPayloads(db).build(SyncDataType.unlockedItem, rows))!['items'] as List).single as Map;
      expect(item, containsPair('item_id', 'workshop'));
      expect(item, containsPair('unlocked_by', 'purchase'));
    });
  });

  group('server coin grants', () {
    test('credited exactly once and enqueued for acknowledgement', () async {
      final grants = [
        {'idempotency_key': 'purchase:abc', 'amount': 1500, 'type': 'purchase', 'source': 'coin_pack', 'created_at': '2026-10-16T09:07:00Z'},
      ];
      expect(await CoinGrants(db).credit(grants), 1500);
      expect(await CoinGrants(db).credit(grants), 0); // replay is a no-op
      final profile = await db.select(db.playerProfile).getSingle();
      expect(profile.coins, 1500);
      final queued = await (db.select(db.syncQueue)..where((q) => q.dataType.equals(SyncDataType.coinTransaction))).get();
      final item = SyncPayloads.coinTransactionItem((jsonDecode(queued.single.payload!) as Map).cast())!;
      expect(item['idempotency_key'], 'purchase:abc');
      expect(item['type'], 'purchase');
    });
  });

  group('pull merger', () {
    test('never loses local clears or unpushed coins', () async {
      final progress = ProgressService(db);
      await progress.recordClear(_result(moves: 9, mastered: false)); // guest clear of 7
      final localCoins = (await db.select(db.playerProfile).getSingle()).coins;

      await PullMerger(db).apply({
        'progress': {
          'levels': [
            {'level_id': 1, 'best_moves': 3, 'best_time_ms': 4000, 'mastered': true, 'first_cleared_at': '2026-10-01T00:00:00Z'},
            {'level_id': 7, 'best_moves': 6, 'best_time_ms': 0, 'mastered': true, 'first_cleared_at': '2026-10-01T00:00:00Z'},
          ],
        },
        'coins': {
          'balance': 800,
          'pending_grants': [
            {'idempotency_key': 'pro_coins:1', 'amount': 1000, 'type': 'grant', 'source': 'pro_monthly'},
          ],
        },
        'unlocked_items': [
          {'item_type': 'theme', 'item_id': 'workshop', 'unlocked_by': 'purchase'},
        ],
        'daily': {
          'completions': [
            {'date': '2026-10-15', 'moves': 18, 'time_ms': 64000},
          ],
        },
      });

      final clears = {for (final c in await db.select(db.levelClears).get()) c.levelId: c};
      expect(clears.keys, containsAll([1, 7]));
      expect(clears[7]!.bestMoves, 6); // MIN
      expect(clears[7]!.mastered, isTrue); // sticky
      expect(clears[7]!.bestTimeMs, 12000); // 0 never overwrites a real best

      // server 800 + unpushed local ledger + pending Pro grant.
      final coins = (await db.select(db.playerProfile).getSingle()).coins;
      expect(coins, 800 + localCoins + 1000);

      final themes = await db.select(db.unlockedItems).get();
      expect(themes.map((t) => t.itemId), contains('walnut'));
      final daily = await db.select(db.dailyCompletions).get();
      expect(daily.single.dateKey, 20261015);
    });

    test('reports what arrived and what this device added', () async {
      await ProgressService(db).recordClear(_result()); // local-only sheet 7
      final stats = await PullMerger(db).apply({
        'progress': {
          'levels': [
            {'level_id': 1, 'best_moves': 3, 'best_time_ms': 4000, 'mastered': true},
            {'level_id': 2, 'best_moves': 5, 'best_time_ms': 5000, 'mastered': false},
          ],
        },
        'coins': {'balance': 0},
      });
      expect(stats.cloudClears, 2);
      expect(stats.clearsAdded, 2);
      expect(stats.localClearsUploaded, 1);

      // Pulling the same snapshot again changes nothing.
      final again = await PullMerger(db).apply({
        'progress': {
          'levels': [
            {'level_id': 1, 'best_moves': 3, 'best_time_ms': 4000, 'mastered': true},
            {'level_id': 2, 'best_moves': 5, 'best_time_ms': 5000, 'mastered': false},
          ],
        },
        'coins': {'balance': 0},
      });
      expect(again.clearsAdded, 0);
      expect(again.clearsImproved, 0);
    });

    test('routine pull: a newer balance from another device wins', () async {
      await ProgressService(db).recordClear(_result()); // ledger row "now"
      await db.delete(db.syncQueue).go(); // as if already pushed
      final later = DateTime.now().toUtc().add(const Duration(minutes: 5)).toIso8601String();
      final stats = await PullMerger(db).apply({
        'coins': {'balance': 4321, 'updated_at': later},
      }, coins: CoinMerge.newestWins);
      expect((await db.select(db.playerProfile).getSingle()).coins, 4321);
      expect(stats.coinsAfter, 4321);
      // Adopted, not bounced back to the server.
      final queued = await (db.select(db.syncQueue)..where((q) => q.dataType.equals(SyncDataType.coinBalance))).get();
      expect(queued, isEmpty);
    });

    test('equipping a theme never makes stale coins look newer', () async {
      final progress = ProgressService(db);
      await progress.recordClear(_result());
      await db.delete(db.syncQueue).go();
      final hourAgo = DateTime.now().toUtc().subtract(const Duration(hours: 1));
      await db.update(db.playerProfile).write(PlayerProfileCompanion(coinsUpdatedAt: Value(hourAgo)));
      await progress.equipTheme('blueprint'); // bumps the profile's updated_at to now

      // The balance push carries the coins' own clock.
      final payload = await SyncPayloads(db).coinBalance();
      expect(DateTime.parse(payload['updated_at'] as String).isBefore(DateTime.now().toUtc().subtract(const Duration(minutes: 30))), isTrue);

      // Another device's balance from 10 minutes ago still wins.
      final tenAgo = DateTime.now().toUtc().subtract(const Duration(minutes: 10)).toIso8601String();
      await PullMerger(db).apply({
        'coins': {'balance': 1025, 'updated_at': tenAgo},
      }, coins: CoinMerge.newestWins);
      expect((await db.select(db.playerProfile).getSingle()).coins, 1025);
    });

    test('routine pull: this device spent/earned since → it keeps its coins', () async {
      await ProgressService(db).recordClear(_result());
      await db.delete(db.syncQueue).go();
      final mine = (await db.select(db.playerProfile).getSingle()).coins;
      final earlier = DateTime.now().toUtc().subtract(const Duration(hours: 1)).toIso8601String();
      await PullMerger(db).apply({
        'coins': {'balance': 5, 'updated_at': earlier},
      }, coins: CoinMerge.newestWins);
      expect((await db.select(db.playerProfile).getSingle()).coins, mine);
      final queued = await (db.select(db.syncQueue)..where((q) => q.dataType.equals(SyncDataType.coinBalance))).get();
      expect(queued, hasLength(1), reason: 'the newer local balance is pushed');
    });
  });

  group('sync engine', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({'jwt_access_token': _jwt(), 'backend_user_id': 'u1'});
      ApiService.baseUrlOverride = 'http://test/api/v1';
    });

    Future<(SyncEngine, List<http.Request>)> engine(int Function(http.Request r) status) async {
      final seen = <http.Request>[];
      final api = ApiService(
        ConnectivityService(),
        client: MockClient((r) async {
          seen.add(r);
          return http.Response('{"accepted":1,"rejected":0,"replayed":false}', status(r));
        }),
      );
      await api.initialize();
      return (SyncEngine(db, api, ConnectivityService()), seen);
    }

    test('success evicts rows and sends Idempotency-Key + install headers', () async {
      await ProgressService(db).recordClear(_result());
      final (e, seen) = await engine((_) => 200);
      await e.drainForTesting();
      expect(await db.select(db.syncQueue).get(), isEmpty);
      expect(seen.map((r) => r.url.path), containsAll(['/api/v1/sync/progress', '/api/v1/sync/coins/transactions', '/api/v1/sync/coins/balance']));
      // Ledger is pushed before the balance it changes.
      final paths = seen.map((r) => r.url.path).toList();
      expect(paths.indexOf('/api/v1/sync/coins/transactions'), lessThan(paths.indexOf('/api/v1/sync/coins/balance')));
      expect(seen.first.headers['Idempotency-Key'], isNotNull);
      expect(seen.first.headers['Authorization'], startsWith('Bearer '));
    });

    test('5xx keeps rows pending; 422 dead-letters after max retries', () async {
      await ProgressService(db).recordClear(_result());
      final (down, _) = await engine((_) => 503);
      await down.drainForTesting();
      final pending = await db.select(db.syncQueue).get();
      expect(pending, isNotEmpty);
      expect(pending.every((r) => r.attempts == 0 && r.status == 0), isTrue);

      final (refusing, _) = await engine((_) => 422);
      for (var i = 0; i < SyncEngine.maxRetries; i++) {
        await refusing.drainForTesting();
      }
      final rows = await db.select(db.syncQueue).get();
      expect(rows.every((r) => r.status == 2), isTrue);
    });
  });
}
