import '../domain/board.dart';
import '../domain/game_state.dart';
import '../domain/level.dart';
import '../domain/move_result.dart';
import 'solver.dart';

/// Authoritative rules for one level. Pure Dart, synchronous: a tap commits
/// (and settles) immediately; animations only depict the returned results
/// and never feed back into state.
final class GameEngine {
  GameEngine(this.level) : board = Board(level) {
    _state = _settle(GameState.initial(level.trayCapacity)).$1;
  }

  /// Rebuilds an engine mid-level from persisted data.
  factory GameEngine.restore(Level level, SavedGame saved) {
    final engine = GameEngine(level).._bonusSlots = saved.bonusSlots;
    engine._history
      ..clear()
      ..addAll(saved.history.map(_HistoryEntry.fromJson));
    engine._state = saved.state.withCapacity(engine.capacity);
    return engine;
  }

  final Level level;
  final Board board;
  late GameState _state;
  final List<_HistoryEntry> _history = [];
  int _bonusSlots = 0;

  GameState get state => _state;
  int get capacity => level.trayCapacity + _bonusSlots;
  int get bonusSlots => _bonusSlots;
  bool get canUndo => _history.isNotEmpty;
  int get historyLength => _history.length;

  GameStatus get status {
    if (_state.released.length == board.panelCount) return GameStatus.won;
    if (_state.emptySlots == 0) return GameStatus.stuck;
    return GameStatus.playing;
  }

  bool isRemoved(String screwId) => _state.removed.contains(screwId);

  /// Topmost unreleased panel covering [screwId], or null when free.
  String? blockerOf(String screwId) =>
      board.blockerOf(screwId, _state.released);

  TapResult tap(String screwId) {
    if (!board.screwIndex.containsKey(screwId) ||
        _state.removed.contains(screwId) ||
        status == GameStatus.won) {
      return TapIgnored(screwId);
    }
    final blocker = blockerOf(screwId);
    if (blocker != null) return ScrewBlocked(screwId, blocker);
    final slot = _state.firstEmptySlot;
    if (slot < 0) return TrayFull(screwId);

    final before = _state;
    final tray = [..._state.tray]..[slot] = screwId;
    final (settled, releases) = _settle(
      _state.copyWith(
        removed: {..._state.removed, screwId},
        tray: tray,
        moves: _state.moves + 1,
      ),
    );
    _history.add(_HistoryEntry(before, screwId, slot, releases));
    _state = settled;
    return ScrewRemoved(
      screwId,
      slot: slot,
      releases: releases,
      status: status,
      state: settled,
    );
  }

  /// Restores the exact previous snapshot. Hint counts are not refunded
  /// (that lives outside the engine).
  Undone? undo() {
    if (_history.isEmpty) return null;
    final entry = _history.removeLast();
    _state = entry.before.withCapacity(capacity);
    return Undone(
      screwId: entry.screwId,
      slot: entry.slot,
      unreleased: entry.releases,
      state: _state,
    );
  }

  void restart() {
    _history.clear();
    _bonusSlots = 0;
    _state = _settle(GameState.initial(level.trayCapacity)).$1;
  }

  /// Stuck rescue: one extra tray slot for the rest of this attempt.
  /// Survives undo (snapshots are padded); cleared by [restart].
  void addBonusSlot() {
    _bonusSlots++;
    _state = _state.withCapacity(capacity);
  }

  /// Plans the next hint without mutating anything. If the current position
  /// is unsolvable, walks back through history to the latest solvable one.
  /// Null only when the level itself is unsolvable or already won.
  HintPlan? planHint() {
    if (status == GameStatus.won) return null;
    final solver = Solver(board, capacity: capacity);
    final positions = <Set<String>>[
      _state.removed,
      for (final e in _history.reversed) e.before.removed,
    ];
    for (var rewind = 0; rewind < positions.length; rewind++) {
      final solution = solver.solve(positions[rewind]);
      if (solution == null || solution.isEmpty) continue;
      final screw = solution.first;
      final panel = board.panelOfScrew(screw);
      final others = board
          .screwsOfPanel(panel)
          .where((s) => s != screw && !positions[rewind].contains(s));
      return HintPlan(
        rewind: rewind,
        screwId: screw,
        releasesPanelId: others.isEmpty ? panel : null,
      );
    }
    return null;
  }

  SavedGame save({Map<String, Object?> meta = const {}}) => SavedGame(
    levelId: level.id,
    state: _state,
    history: [for (final e in _history) e.toJson()],
    bonusSlots: _bonusSlots,
    meta: meta,
  );

  /// Releases every unreleased panel whose screws are all out, returning their
  /// screws' tray slots (positions kept - the tray is never compacted).
  /// Repeats until stable.
  (GameState, List<PanelRelease>) _settle(GameState s) {
    var state = s;
    final releases = <PanelRelease>[];
    var changed = true;
    while (changed) {
      changed = false;
      for (final panelId in board.panelIds) {
        if (state.released.contains(panelId)) continue;
        final screws = board.screwsOfPanel(panelId);
        if (!screws.every(state.removed.contains)) continue;
        final tray = [...state.tray];
        final freed = <FreedSlot>[];
        for (var i = 0; i < tray.length; i++) {
          final id = tray[i];
          if (id != null && screws.contains(id)) {
            freed.add(FreedSlot(i, id));
            tray[i] = null;
          }
        }
        state = state.copyWith(
          tray: tray,
          released: {...state.released, panelId},
        );
        releases.add(PanelRelease(panelId, freed));
        changed = true;
      }
    }
    return (state, releases);
  }
}

/// Persisted mid-level position (written after every committed move).
final class SavedGame {
  const SavedGame({
    required this.levelId,
    required this.state,
    required this.history,
    this.bonusSlots = 0,
    this.meta = const {},
  });

  final int levelId;
  final GameState state;
  final List<Map<String, Object?>> history;
  final int bonusSlots;

  /// Session data owned by the caller (hints left, mastery flags, time…).
  final Map<String, Object?> meta;

  Map<String, Object?> toJson() => {
    'levelId': levelId,
    'state': state.toJson(),
    'history': history,
    'bonusSlots': bonusSlots,
    'meta': meta,
  };

  factory SavedGame.fromJson(Map<String, Object?> j) => SavedGame(
    levelId: (j['levelId']! as num).toInt(),
    state: GameState.fromJson((j['state']! as Map).cast()),
    history: [
      for (final h in j['history']! as List) (h as Map).cast<String, Object?>(),
    ],
    bonusSlots: (j['bonusSlots'] as num? ?? 0).toInt(),
    meta: (j['meta'] as Map?)?.cast<String, Object?>() ?? const {},
  );
}

final class _HistoryEntry {
  const _HistoryEntry(this.before, this.screwId, this.slot, this.releases);

  final GameState before;
  final String screwId;
  final int slot;
  final List<PanelRelease> releases;

  Map<String, Object?> toJson() => {
    'before': before.toJson(),
    'screw': screwId,
    'slot': slot,
    'releases': [
      for (final r in releases)
        {
          'panel': r.panelId,
          'freed': [
            for (final f in r.freed) [f.slot, f.screwId],
          ],
        },
    ],
  };

  factory _HistoryEntry.fromJson(Map<String, Object?> j) => _HistoryEntry(
    GameState.fromJson((j['before']! as Map).cast()),
    j['screw']! as String,
    (j['slot']! as num).toInt(),
    [
      for (final r in j['releases']! as List)
        PanelRelease((r as Map)['panel']! as String, [
          for (final f in r['freed']! as List)
            FreedSlot(((f as List)[0] as num).toInt(), f[1] as String),
        ]),
    ],
  );
}
