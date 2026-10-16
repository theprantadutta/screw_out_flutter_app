import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

/// Single source of truth (offline-first, mirrors snake-classic):
/// every user-changeable value is written here first and, in the same
/// transaction, enqueued in [SyncQueue]. Only the SyncEngine talks to the
/// API. SharedPreferences holds device-only flags (JWT, FCM cache, ad caps).

/// Single row (id = 1).
class GameSettings extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  BoolColumn get sound => boolean().withDefault(const Constant(true))();
  BoolColumn get music => boolean().withDefault(const Constant(true))();
  BoolColumn get haptics => boolean().withDefault(const Constant(true))();
  BoolColumn get reducedMotion => boolean().withDefault(const Constant(false))();
  TextColumn get localeCode => text().nullable()();
  BoolColumn get dailyReminder => boolean().withDefault(const Constant(true))();
  BoolColumn get tutorialDone => boolean().withDefault(const Constant(false))();
  BoolColumn get initialized => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Single row (id = 1): wallet + cosmetic choice.
class PlayerProfile extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  IntColumn get coins => integer().withDefault(const Constant(0))();
  TextColumn get equippedTheme => text().withDefault(const Constant('blueprint'))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  /// When the coin balance last changed on this device (earn, spend, grant,
  /// merge). The balance syncs last-write-wins on THIS, never on
  /// [updatedAt], which also moves when a theme is equipped.
  DateTimeColumn get coinsUpdatedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// One row per cleared sheet. Merges are monotonic (never lose a clear).
@DataClassName('LevelClear')
class LevelClears extends Table {
  IntColumn get levelId => integer()();
  IntColumn get bestMoves => integer()();
  IntColumn get bestTimeMs => integer()();
  BoolColumn get mastered => boolean().withDefault(const Constant(false))();
  IntColumn get clears => integer().withDefault(const Constant(1))();
  DateTimeColumn get firstClearedAt => dateTime()();
  DateTimeColumn get lastClearedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {levelId};
}

/// Append-only coin ledger; the id doubles as the server idempotency key.
class CoinTransactions extends Table {
  TextColumn get id => text()();
  IntColumn get amount => integer()();
  TextColumn get reason => text()();
  IntColumn get levelId => integer().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Themes and other cosmetics the player owns.
class UnlockedItems extends Table {
  TextColumn get itemType => text()();
  TextColumn get itemId => text()();

  /// chapter | coins | purchase | pro | default
  TextColumn get source => text()();
  DateTimeColumn get unlockedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {itemType, itemId};
}

/// One row per completed daily sheet (date key yyyymmdd).
class DailyCompletions extends Table {
  IntColumn get dateKey => integer()();
  IntColumn get moves => integer()();
  IntColumn get timeMs => integer()();
  DateTimeColumn get completedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {dateKey};
}

/// Server-authoritative entitlements, cached for offline (single row).
class Entitlements extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  BoolColumn get isPro => boolean().withDefault(const Constant(false))();
  DateTimeColumn get proExpiresAt => dateTime().nullable()();
  TextColumn get proPlan => text().nullable()();
  BoolColumn get adsRemoved => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Device-only: the in-progress position per level (not synced).
@DataClassName('SavedGameRow')
class SavedGames extends Table {
  IntColumn get levelId => integer()();
  TextColumn get json => text()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {levelId};
}

/// Device-only: chapter packs downloaded from the API (chapters 6+).
@DataClassName('LevelPackRow')
class LevelPacks extends Table {
  IntColumn get chapter => integer()();
  IntColumn get version => integer()();
  TextColumn get json => text()();
  TextColumn get sha256 => text().withDefault(const Constant(''))();
  DateTimeColumn get downloadedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {chapter};
}

/// Device-only preferences (single row, id = 1). Never synced: whether
/// 120 Hz is worth the battery depends on the hardware in your hand, so a
/// phone and a tablet on the same account may disagree.
class DevicePreferences extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();

  /// Opt-in (snake-classic lesson: max refresh by default starved the frame
  /// budget on low-end phones).
  BoolColumn get highRefreshRate => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Sync outbox drained by the SyncEngine.
class SyncQueue extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get dataType => text()();
  TextColumn get entityKey => text()();

  /// Frozen payload for event types; null for snapshot types (read latest).
  TextColumn get payload => text().nullable()();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable()();

  /// 0 = pending, 2 = dead-lettered (permanently refused / max retries).
  IntColumn get status => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// Analytics/telemetry events waiting for upload (device-only).
class TelemetryEvents extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get json => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// Sync data types (server endpoints under /sync).
abstract final class SyncDataType {
  static const settings = 'settings';
  static const progress = 'progress';
  static const coinBalance = 'coin_balance';
  static const coinTransaction = 'coin_transaction';
  static const unlockedItem = 'unlocked_item';
  static const equipped = 'equipped';
  static const daily = 'daily';

  /// Snapshot types send the latest local row when drained.
  static const snapshots = {settings, coinBalance, equipped};
}

@DriftDatabase(
  tables: [
    GameSettings,
    PlayerProfile,
    LevelClears,
    CoinTransactions,
    UnlockedItems,
    DailyCompletions,
    Entitlements,
    DevicePreferences,
    SavedGames,
    LevelPacks,
    SyncQueue,
    TelemetryEvents,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_open());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.addColumn(playerProfile, playerProfile.coinsUpdatedAt);
        // Best local evidence of when the coins last moved: the ledger.
        await customStatement(
          'UPDATE player_profile SET coins_updated_at = (SELECT MAX(created_at) FROM coin_transactions)',
        );
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  /// Seeds single-row tables and the default theme.
  Future<void> initializeDefaults() => transaction(() async {
    await into(gameSettings).insert(GameSettingsCompanion.insert(), mode: InsertMode.insertOrIgnore);
    await into(playerProfile).insert(PlayerProfileCompanion.insert(), mode: InsertMode.insertOrIgnore);
    await into(entitlements).insert(EntitlementsCompanion.insert(), mode: InsertMode.insertOrIgnore);
    await into(devicePreferences).insert(DevicePreferencesCompanion.insert(), mode: InsertMode.insertOrIgnore);
    await into(unlockedItems).insert(
      UnlockedItemsCompanion.insert(
        itemType: 'theme',
        itemId: 'blueprint',
        source: 'default',
        unlockedAt: DateTime.now().toUtc(),
      ),
      mode: InsertMode.insertOrIgnore,
    );
  });

  /// Wipes every account-scoped table (sign-out / account deletion) and
  /// re-seeds the single-row defaults. Settings and device-only caches (saved games,
  /// downloaded level packs, telemetry) are kept.
  Future<void> clearAccountData() => transaction(() async {
    for (final TableInfo<Table, Object?> table in [playerProfile, levelClears, coinTransactions, unlockedItems, dailyCompletions, entitlements, syncQueue]) {
      await delete(table).go();
    }
    await initializeDefaults();
  });

  /// Enqueue a change for upload. Call inside the transaction that wrote it.
  /// Snapshot types collapse to a single pending row per entity.
  Future<void> enqueueSyncOutbox({
    required String dataType,
    required String entityKey,
    Object? payload,
  }) async {
    if (SyncDataType.snapshots.contains(dataType)) {
      await (delete(syncQueue)
            ..where((q) => q.dataType.equals(dataType) & q.entityKey.equals(entityKey)))
          .go();
    }
    await into(syncQueue).insert(
      SyncQueueCompanion.insert(
        dataType: dataType,
        entityKey: entityKey,
        payload: Value(payload == null ? null : jsonEncode(payload)),
      ),
    );
  }
}

LazyDatabase _open() => LazyDatabase(() async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File(p.join(dir.path, 'screw_out.db'));
  return NativeDatabase.createInBackground(file);
});
