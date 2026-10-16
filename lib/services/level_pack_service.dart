import 'dart:async';
import 'dart:convert';

import '../core/network/api_service.dart';
import '../game/generator/curriculum.dart';
import 'app_log.dart';
import 'level_repository.dart';

/// Chapters past the bundled five come from the API in packs of 20
/// (API_CONTRACT §6). Every downloaded sheet passes the fairness validator
/// before it is stored ([LevelRepository.installPack]).
class LevelPackService {
  LevelPackService(this._api, this._levels);

  final ApiService _api;
  final LevelRepository _levels;

  final _remote = StreamController<Set<int>>.broadcast();
  Set<int> _available = const {};
  final Map<int, _PackInfo> _info = {};
  DateTime? _lastCheck;

  /// Chapters the server publishes that are not installed yet (or have a
  /// newer version). Replays the latest value to new listeners.
  Stream<Set<int>> get availableRemoteChapters async* {
    yield _available;
    yield* _remote.stream;
  }

  Set<int> get available => _available;

  /// GET /levels/packs (cached for 5 minutes).
  Future<void> refresh({bool force = false}) async {
    final last = _lastCheck;
    if (!force && last != null && DateTime.now().difference(last) < const Duration(minutes: 5)) return;
    _lastCheck = DateTime.now();
    final r = await _api.levelPacks();
    if (!r.isSuccess) return;
    final packs = r.value?['packs'];
    if (packs is! List) return;
    final next = <int>{};
    for (final p in packs) {
      if (p is! Map) continue;
      final chapter = p['chapter'];
      final version = p['version'];
      if (chapter is! int || version is! int || chapter <= kBundledChapters) continue;
      _info[chapter] = _PackInfo(version, '${p['sha256'] ?? ''}');
      final installed = _levels.installedVersion(chapter);
      if (installed == null || installed < version) next.add(chapter);
    }
    _available = next;
    _remote.add(next);
  }

  /// Downloads, validates and installs one chapter. False on any failure.
  Future<bool> downloadChapter(int chapter) async {
    final r = await _api.levelPack(chapter);
    final data = r.value;
    if (!r.isSuccess || data == null || data['levels'] is! List) return false;
    final info = chapterInfo(chapter, name: data['title'] as String?);
    final json = jsonEncode({
      'chapter': chapter,
      'name': info.name,
      'goal': info.goal,
      'version': data['version'] ?? 1,
      'levels': [
        for (final l in data['levels'] as List)
          if (l is Map) {'chapter': chapter, 'title': 'Sheet ${l['id']}', ...l},
      ],
    });
    try {
      final ok = await _levels.installPack(json, sha256: '${data['sha256'] ?? _info[chapter]?.sha256 ?? ''}');
      if (ok) {
        _available = {..._available}..remove(chapter);
        _remote.add(_available);
      } else {
        AppLog.warn('Pack $chapter failed validation — not installed');
      }
      return ok;
    } on Object catch (e) {
      AppLog.warn('Installing pack $chapter failed: $e');
      return false;
    }
  }

  /// On resume: within 10 sheets of the last available level, check for and
  /// fetch the next chapter so the player never hits a wall.
  Future<void> prefetchIfNear(int currentLevel) async {
    if (_levels.totalLevels - currentLevel > 10) return;
    await refresh();
    final next = _levels.lastChapter + 1;
    if (_available.contains(next)) await downloadChapter(next);
  }

  void dispose() => _remote.close();
}

class _PackInfo {
  const _PackInfo(this.version, this.sha256);
  final int version;
  final String sha256;
}
