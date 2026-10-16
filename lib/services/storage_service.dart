import 'package:drift/drift.dart';

import '../data/database/app_database.dart';
import '../presentation/bloc/settings/settings_cubit.dart';

/// Settings persistence in the Drift `GameSettings` row (synced).
class DriftSettingsStore implements SettingsStore {
  DriftSettingsStore(this._db);

  final AppDatabase _db;

  @override
  Future<SettingsState?> load() async {
    final row = await (_db.select(_db.gameSettings)..where((s) => s.id.equals(1))).getSingleOrNull();
    if (row == null || !row.initialized) return null;
    return SettingsState(
      sound: row.sound,
      music: row.music,
      haptics: row.haptics,
      reducedMotion: row.reducedMotion,
      localeCode: row.localeCode,
      dailyReminder: row.dailyReminder,
      tutorialDone: row.tutorialDone,
    );
  }

  @override
  Future<void> save(SettingsState s) => _db.transaction(() async {
    await _db.into(_db.gameSettings).insertOnConflictUpdate(
      GameSettingsCompanion(
        id: const Value(1),
        sound: Value(s.sound),
        music: Value(s.music),
        haptics: Value(s.haptics),
        reducedMotion: Value(s.reducedMotion),
        localeCode: Value(s.localeCode),
        dailyReminder: Value(s.dailyReminder),
        tutorialDone: Value(s.tutorialDone),
        initialized: const Value(true),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
    await _db.enqueueSyncOutbox(dataType: SyncDataType.settings, entityKey: 'settings');
  });
}
