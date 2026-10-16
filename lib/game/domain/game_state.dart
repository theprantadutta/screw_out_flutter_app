/// Immutable snapshot of a level in progress. Undo restores these exactly:
/// removed set, tray array *including order and gaps*, released set and the
/// move counter.
final class GameState {
  GameState({
    required Set<String> removed,
    required List<String?> tray,
    required Set<String> released,
    required this.moves,
  }) : removed = Set.unmodifiable(removed),
       tray = List.unmodifiable(tray),
       released = Set.unmodifiable(released);

  factory GameState.initial(int capacity) => GameState(
    removed: const {},
    tray: List.filled(capacity, null),
    released: const {},
    moves: 0,
  );

  final Set<String> removed;

  /// Fixed-length tray. `null` = empty slot. Never compacted.
  final List<String?> tray;
  final Set<String> released;
  final int moves;

  int get filledSlots => tray.where((s) => s != null).length;
  int get emptySlots => tray.length - filledSlots;
  int get firstEmptySlot => tray.indexOf(null);

  GameState copyWith({
    Set<String>? removed,
    List<String?>? tray,
    Set<String>? released,
    int? moves,
  }) => GameState(
    removed: removed ?? this.removed,
    tray: tray ?? this.tray,
    released: released ?? this.released,
    moves: moves ?? this.moves,
  );

  /// Pads (never truncates) the tray to [capacity] — used when a rescue slot
  /// was added after this snapshot was taken.
  GameState withCapacity(int capacity) => tray.length >= capacity
      ? this
      : copyWith(
          tray: [...tray, ...List<String?>.filled(capacity - tray.length, null)],
        );

  Map<String, Object?> toJson() => {
    'removed': removed.toList()..sort(),
    'tray': tray,
    'released': released.toList()..sort(),
    'moves': moves,
  };

  factory GameState.fromJson(Map<String, Object?> j) => GameState(
    removed: {...(j['removed']! as List).cast<String>()},
    tray: (j['tray']! as List).cast<String?>(),
    released: {...(j['released']! as List).cast<String>()},
    moves: (j['moves']! as num).toInt(),
  );

  @override
  bool operator ==(Object other) =>
      other is GameState &&
      other.moves == moves &&
      _setEq(other.removed, removed) &&
      _setEq(other.released, released) &&
      _listEq(other.tray, tray);

  @override
  int get hashCode => Object.hash(
    moves,
    Object.hashAllUnordered(removed),
    Object.hashAllUnordered(released),
    Object.hashAll(tray),
  );

  @override
  String toString() =>
      'GameState(moves: $moves, tray: $tray, removed: $removed, released: $released)';
}

bool _setEq(Set<String> a, Set<String> b) =>
    a.length == b.length && a.containsAll(b);

bool _listEq(List<String?> a, List<String?> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
