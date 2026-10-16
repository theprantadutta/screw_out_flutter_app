import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../data/database/app_database.dart';
import '../game/engine/engine.dart';
import '../game/generator/curriculum.dart';
import '../presentation/bloc/game/game_host.dart';
import 'cosmetics.dart';

/// Coin rewards (light, never pressure — design system §9).
abstract final class Rewards {
  /// First clear of a campaign sheet: 15 + 5 × chapter (DWG 024 → +25).
  static int firstClear(int chapter) => 15 + 5 * chapter.clamp(1, 10);
  static const masteryBonus = 5;
  static const chapterBonus = 200;
  static const daily = 50;
}

/// Everything the player has earned, as one immutable snapshot.
final class ProgressSnapshot {
  const ProgressSnapshot({
    required this.clears,
    required this.coins,
    required this.equippedTheme,
    required this.unlocked,
    required this.dailyDone,
  });

  static const empty = ProgressSnapshot(
    clears: {},
    coins: 0,
    equippedTheme: Cosmetics.defaultTheme,
    unlocked: {Cosmetics.defaultTheme},
    dailyDone: {},
  );

  final Map<int, LevelClear> clears;
  final int coins;
  final String equippedTheme;

  /// Owned theme ids.
  final Set<String> unlocked;

  /// Completed daily date keys (yyyymmdd).
  final Set<int> dailyDone;

  bool isCleared(int id) => clears.containsKey(id);
  bool isMastered(int id) => clears[id]?.mastered ?? false;

  /// Highest unlocked sheet: first uncleared one after the furthest clear
  /// contiguous from 1. Sheets unlock strictly in order.
  int get currentLevel {
    var id = 1;
    while (clears.containsKey(id)) {
      id++;
    }
    return id;
  }

  bool isUnlocked(int id) => id <= currentLevel;

  int clearedIn(int chapter) => _countIn(chapter, (c) => true);
  int masteredIn(int chapter) => _countIn(chapter, (c) => c.mastered);

  int _countIn(int chapter, bool Function(LevelClear) test) {
    final first = (chapter - 1) * kLevelsPerChapter + 1;
    var n = 0;
    for (var id = first; id < first + kLevelsPerChapter; id++) {
      final c = clears[id];
      if (c != null && test(c)) n++;
    }
    return n;
  }

  int get totalCleared => clears.length;
  int get totalMastered => clears.values.where((c) => c.mastered).length;
}

/// Daily streak: consecutive completed days ending today (or yesterday, so a
/// streak isn't "lost" before the player has had a chance today).
int dailyStreak(Set<int> done, DateTime today) {
  var day = DateTime(today.year, today.month, today.day);
  int key(DateTime d) => d.year * 10000 + d.month * 100 + d.day;
  if (!done.contains(key(day))) day = day.subtract(const Duration(days: 1));
  var streak = 0;
  while (done.contains(key(day))) {
    streak++;
    day = day.subtract(const Duration(days: 1));
  }
  return streak;
}

/// Local progress, wallet and cosmetics. Writes go to Drift first and are
/// enqueued for sync in the same transaction.
class ProgressService {
  ProgressService(this._db);

  final AppDatabase _db;
  static const _uuid = Uuid();

  Stream<ProgressSnapshot> watch() {
    final clears = _db.select(_db.levelClears).watch();
    return clears.asyncMap((_) => snapshot());
  }

  /// Re-emits on any table the snapshot reads.
  Stream<ProgressSnapshot> watchAll() => _db
      .customSelect(
        'SELECT 1',
        readsFrom: {_db.levelClears, _db.playerProfile, _db.unlockedItems, _db.dailyCompletions},
      )
      .watch()
      .asyncMap((_) => snapshot());

  Future<ProgressSnapshot> snapshot() async {
    final clears = await _db.select(_db.levelClears).get();
    final profile = await (_db.select(_db.playerProfile)..where((p) => p.id.equals(1))).getSingleOrNull();
    final items = await (_db.select(_db.unlockedItems)..where((i) => i.itemType.equals('theme'))).get();
    final daily = await _db.select(_db.dailyCompletions).get();
    return ProgressSnapshot(
      clears: {for (final c in clears) c.levelId: c},
      coins: profile?.coins ?? 0,
      equippedTheme: profile?.equippedTheme ?? Cosmetics.defaultTheme,
      unlocked: {Cosmetics.defaultTheme, for (final i in items) i.itemId},
      dailyDone: {for (final d in daily) d.dateKey},
    );
  }

  // ---------------------------------------------------------------- clears

  /// Records a clear and pays rewards, atomically. Called once per win.
  Future<LevelReward> recordClear(LevelResult r) => _db.transaction(() async {
    final now = DateTime.now().toUtc();
    final before = await _coins();
    var earned = 0;
    var firstClear = false;
    var newBest = false;
    int? chapterCompleted;

    if (r.isDaily) {
      final key = r.level.id;
      final existing = await (_db.select(_db.dailyCompletions)..where((d) => d.dateKey.equals(key))).getSingleOrNull();
      if (existing == null) {
        firstClear = true;
        earned += Rewards.daily;
        await _db.into(_db.dailyCompletions).insert(
          DailyCompletionsCompanion.insert(
            dateKey: Value(key),
            moves: r.moves,
            timeMs: r.elapsed.inMilliseconds,
            completedAt: now,
          ),
        );
        await _db.enqueueSyncOutbox(
          dataType: SyncDataType.daily,
          entityKey: '$key',
          payload: {'date': _dateString(key), 'moves': r.moves, 'time_ms': r.elapsed.inMilliseconds, 'completed_at': now.toIso8601String()},
        );
      }
    } else {
      final existing = await (_db.select(_db.levelClears)..where((c) => c.levelId.equals(r.level.id))).getSingleOrNull();
      if (existing == null) {
        firstClear = true;
        earned += Rewards.firstClear(r.level.chapter);
        if (r.mastered) earned += Rewards.masteryBonus;
        await _db.into(_db.levelClears).insert(
          LevelClearsCompanion.insert(
            levelId: Value(r.level.id),
            bestMoves: r.moves,
            bestTimeMs: r.elapsed.inMilliseconds,
            mastered: Value(r.mastered),
            firstClearedAt: now,
            lastClearedAt: now,
          ),
        );
      } else {
        if (r.mastered && !existing.mastered) earned += Rewards.masteryBonus;
        newBest = r.moves < existing.bestMoves || (r.mastered && !existing.mastered);
        await (_db.update(_db.levelClears)..where((c) => c.levelId.equals(r.level.id))).write(
          LevelClearsCompanion(
            bestMoves: Value(r.moves < existing.bestMoves ? r.moves : existing.bestMoves),
            bestTimeMs: Value(r.elapsed.inMilliseconds < existing.bestTimeMs ? r.elapsed.inMilliseconds : existing.bestTimeMs),
            mastered: Value(existing.mastered || r.mastered),
            clears: Value(existing.clears + 1),
            lastClearedAt: Value(now),
          ),
        );
      }
      await _db.enqueueSyncOutbox(dataType: SyncDataType.progress, entityKey: '${r.level.id}');

      // Chapter complete (first time only).
      if (firstClear) {
        final chapter = r.level.chapter;
        final first = (chapter - 1) * kLevelsPerChapter + 1;
        final cleared = await (_db.select(_db.levelClears)
              ..where((c) => c.levelId.isBetweenValues(first, first + kLevelsPerChapter - 1)))
            .get();
        if (cleared.length == kLevelsPerChapter) {
          chapterCompleted = chapter;
          earned += Rewards.chapterBonus;
          final theme = Cosmetics.chapterReward(chapter);
          if (theme != null) await _unlock(theme, 'chapter', now);
        }
      }
    }

    if (earned > 0) await _earn(earned, r.isDaily ? 'daily' : 'level_clear', r.level.id, now);
    return LevelReward(
      coins: earned,
      balanceBefore: before,
      balanceAfter: before + earned,
      firstClear: firstClear,
      chapterCompleted: chapterCompleted,
      newBest: newBest,
    );
  });

  // --------------------------------------------------------------- wallet

  Future<int> _coins() async =>
      (await (_db.select(_db.playerProfile)..where((p) => p.id.equals(1))).getSingleOrNull())?.coins ?? 0;

  Future<void> earn(int amount, String reason) =>
      _db.transaction(() => _earn(amount, reason, null, DateTime.now().toUtc()));

  Future<void> _earn(int amount, String reason, int? levelId, DateTime now) async {
    await _ledger(amount, reason, levelId, now);
  }

  /// Spends coins; false (no change) when the balance is too low.
  Future<bool> spend(int amount, String reason) => _db.transaction(() async {
    if (await _coins() < amount) return false;
    await _ledger(-amount, reason, null, DateTime.now().toUtc());
    return true;
  });

  Future<void> _ledger(int amount, String reason, int? levelId, DateTime now) async {
    final id = _uuid.v4();
    await _db.into(_db.coinTransactions).insert(
      CoinTransactionsCompanion.insert(id: id, amount: amount, reason: reason, levelId: Value(levelId), createdAt: now),
    );
    await _db.customUpdate(
      'UPDATE player_profile SET coins = coins + ?, updated_at = ? WHERE id = 1',
      variables: [Variable.withInt(amount), Variable.withDateTime(now)],
      updates: {_db.playerProfile},
    );
    await _db.enqueueSyncOutbox(
      dataType: SyncDataType.coinTransaction,
      entityKey: id,
      payload: {
        'id': id,
        'amount': amount,
        'reason': reason,
        'level_id': levelId,
        'created_at': now.toIso8601String(),
      },
    );
    await _db.enqueueSyncOutbox(dataType: SyncDataType.coinBalance, entityKey: 'balance');
  }

  // ------------------------------------------------------------ cosmetics

  Future<void> _unlock(String themeId, String source, DateTime now) async {
    await _db.into(_db.unlockedItems).insert(
      UnlockedItemsCompanion.insert(itemType: 'theme', itemId: themeId, source: source, unlockedAt: now),
      mode: InsertMode.insertOrIgnore,
    );
    await _db.enqueueSyncOutbox(
      dataType: SyncDataType.unlockedItem,
      entityKey: 'theme:$themeId',
      payload: {'item_type': 'theme', 'item_id': themeId, 'source': source, 'unlocked_at': now.toIso8601String()},
    );
  }

  /// Grants themes from a store purchase / Pro (no coins involved).
  Future<void> grantThemes(Iterable<String> themeIds, String source) =>
      _db.transaction(() async {
        final now = DateTime.now().toUtc();
        for (final t in themeIds) {
          await _unlock(t, source, now);
        }
      });

  /// Buys a theme with coins. False when unaffordable or already owned.
  Future<bool> buyTheme(String themeId) => _db.transaction(() async {
    final theme = Cosmetics.byId(themeId);
    if (theme == null || theme.price == null) return false;
    final owned = await (_db.select(_db.unlockedItems)
          ..where((i) => i.itemType.equals('theme') & i.itemId.equals(themeId)))
        .getSingleOrNull();
    if (owned != null) return false;
    if (await _coins() < theme.price!) return false;
    final now = DateTime.now().toUtc();
    await _ledger(-theme.price!, 'theme:$themeId', null, now);
    await _unlock(themeId, 'coins', now);
    return true;
  });

  Future<void> equipTheme(String themeId) => _db.transaction(() async {
    await (_db.update(_db.playerProfile)..where((p) => p.id.equals(1))).write(
      PlayerProfileCompanion(equippedTheme: Value(themeId), updatedAt: Value(DateTime.now().toUtc())),
    );
    await _db.enqueueSyncOutbox(dataType: SyncDataType.equipped, entityKey: 'theme');
  });

  // ---------------------------------------------------------- saved games

  Future<SavedGame?> savedGame(int levelId) async {
    final row = await (_db.select(_db.savedGames)..where((s) => s.levelId.equals(levelId))).getSingleOrNull();
    if (row == null) return null;
    try {
      return SavedGame.fromJson((jsonDecode(row.json) as Map).cast());
    } on Object {
      return null; // corrupt/old format: start fresh
    }
  }

  Future<void> saveGame(SavedGame game) => _db.into(_db.savedGames).insertOnConflictUpdate(
    SavedGamesCompanion.insert(
      levelId: Value(game.levelId),
      json: jsonEncode(game.toJson()),
      updatedAt: DateTime.now().toUtc(),
    ),
  );

  Future<void> clearGame(int levelId) =>
      (_db.delete(_db.savedGames)..where((s) => s.levelId.equals(levelId))).go();

  /// QA only: marks sheets 1…[upTo] cleared (not mastered), without
  /// rewards or sync. Debug builds only (see DebugScreen).
  Future<void> debugMarkCleared(int upTo) => _db.transaction(() async {
    final now = DateTime.now().toUtc();
    for (var id = 1; id <= upTo; id++) {
      await _db.into(_db.levelClears).insert(
        LevelClearsCompanion.insert(
          levelId: Value(id),
          bestMoves: 10,
          bestTimeMs: 30000,
          mastered: Value(id.isOdd),
          firstClearedAt: now,
          lastClearedAt: now,
        ),
        mode: InsertMode.insertOrIgnore,
      );
    }
  });

  /// QA only: wipes clears, coins, dailies, saved games and owned themes.
  Future<void> debugReset() => _db.transaction(() async {
    await _db.delete(_db.levelClears).go();
    await _db.delete(_db.dailyCompletions).go();
    await _db.delete(_db.savedGames).go();
    await (_db.delete(_db.unlockedItems)..where((i) => i.itemId.equals(Cosmetics.defaultTheme).not())).go();
    await _db.customUpdate(
      "UPDATE player_profile SET coins = 0, equipped_theme = 'blueprint' WHERE id = 1",
      updates: {_db.playerProfile},
    );
  });

  static String _dateString(int key) =>
      '${key ~/ 10000}-${((key ~/ 100) % 100).toString().padLeft(2, '0')}-${(key % 100).toString().padLeft(2, '0')}';
}
