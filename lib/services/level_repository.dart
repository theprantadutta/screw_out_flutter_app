import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/services.dart';

import '../data/database/app_database.dart';
import '../game/domain/level.dart';
import '../game/generator/curriculum.dart';
import '../game/generator/daily.dart';
import '../game/level/level_pack.dart';
import '../game/level/validator.dart';

/// Source of every sheet: the five bundled chapter packs (identical on every
/// install), packs downloaded from the API for chapter 6+, and the daily
/// sheet generated from the date.
class LevelRepository {
  LevelRepository(this._db, {AssetBundle? bundle}) : _bundle = bundle ?? rootBundle;

  final AppDatabase _db;
  final AssetBundle _bundle;
  final Map<int, LevelPack> _packs = {};
  final Map<int, Level> _daily = {};
  static const _dailySheets = DailySheets();

  /// Loads bundled packs + any downloaded ones. Call once at startup.
  Future<void> load() async {
    for (var c = 1; c <= kBundledChapters; c++) {
      final raw = await _bundle.loadString('assets/levels/ch${c.toString().padLeft(2, '0')}.json');
      _packs[c] = LevelPack.fromJson((jsonDecode(raw) as Map).cast());
    }
    for (final row in await _db.select(_db.levelPacks).get()) {
      try {
        _packs[row.chapter] = LevelPack.fromJson((jsonDecode(row.json) as Map).cast());
      } on Object {
        // Corrupt download — drop it; it will be fetched again.
        await (_db.delete(_db.levelPacks)..where((p) => p.chapter.equals(row.chapter))).go();
      }
    }
  }

  List<LevelPack> get packs => [for (final c in _packs.keys.toList()..sort()) _packs[c]!];
  int get chapterCount => _packs.length;
  int get totalLevels => _packs.values.fold<int>(0, (n, p) => n + p.levels.length);
  int get lastChapter => _packs.isEmpty ? 0 : _packs.keys.reduce((a, b) => a > b ? a : b);
  LevelPack? pack(int chapter) => _packs[chapter];
  bool hasChapter(int chapter) => _packs.containsKey(chapter);

  Level? level(int id) {
    if (id <= 0) return null;
    final pack = _packs[(id - 1) ~/ kLevelsPerChapter + 1];
    if (pack == null) return null;
    for (final l in pack.levels) {
      if (l.id == id) return l;
    }
    return null;
  }

  static int chapterOf(int levelId) => (levelId - 1) ~/ kLevelsPerChapter + 1;

  /// Today's daily sheet (generated, cached per date).
  Level daily(DateTime date) =>
      _daily.putIfAbsent(DailySheets.dateKey(date), () => _dailySheets.sheetFor(date));

  /// Daily sheets use their date key (yyyymmdd) as id.
  static bool isDailyId(int id) => id > 19000000;

  /// Stores a downloaded pack after validating every sheet. Returns false
  /// (and stores nothing) if any sheet fails the fairness checks.
  Future<bool> installPack(String json, {required String sha256}) async {
    final pack = LevelPack.fromJson((jsonDecode(json) as Map).cast());
    for (final l in pack.levels) {
      if (validateLevel(l).isNotEmpty) return false;
    }
    await _db.into(_db.levelPacks).insertOnConflictUpdate(
      LevelPacksCompanion.insert(
        chapter: Value(pack.chapter),
        version: pack.version,
        json: json,
        sha256: Value(sha256),
        downloadedAt: DateTime.now().toUtc(),
      ),
    );
    _packs[pack.chapter] = pack;
    return true;
  }

  int? installedVersion(int chapter) => _packs[chapter]?.version;
}
