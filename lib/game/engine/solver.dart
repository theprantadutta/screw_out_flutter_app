import '../domain/board.dart';

/// Exhaustive solver over bitmasks.
///
/// Solvability from a position depends only on the *removed* set: released
/// panels follow from it, and tray occupancy is "removed screws whose panel
/// is not released". Slot order is irrelevant to the future, so the removed
/// mask is a complete memo key.
///
/// Masks are Dart ints, so a level may hold at most [maxScrews] screws and
/// [maxPanels] panels (the validator enforces this).
final class Solver {
  Solver(this.board, {required this.capacity})
    : _n = board.screwCount,
      _m = board.panelCount {
    if (_n > maxScrews || _m > maxPanels) {
      throw ArgumentError(
        'Level ${board.level.id} too large for the solver '
        '($_n screws, $_m panels).',
      );
    }
    for (var p = 0; p < _m; p++) {
      var mask = 0;
      for (final s in board.panelScrews[p]) {
        mask |= 1 << s;
      }
      _panelMask.add(mask);
    }
    for (var s = 0; s < _n; s++) {
      var mask = 0;
      for (final p in board.blockers[s]) {
        mask |= 1 << p;
      }
      _blockerMask.add(mask);
    }
    _order = List.generate(_n, (i) => i)
      ..sort((a, b) => board.screwIds[a].compareTo(board.screwIds[b]));
    _allPanels = _m == 0 ? 0 : (1 << _m) - 1;
  }

  static const maxScrews = 52;
  static const maxPanels = 52;

  final Board board;
  final int capacity;
  final int _n;
  final int _m;
  final List<int> _panelMask = [];
  final List<int> _blockerMask = [];
  late final List<int> _order;
  late final int _allPanels;
  final Set<int> _dead = {};

  int maskOf(Iterable<String> removed) {
    var mask = 0;
    for (final id in removed) {
      mask |= 1 << board.screwIndex[id]!;
    }
    return mask;
  }

  int releasedMask(int removed) {
    var rel = 0;
    for (var p = 0; p < _m; p++) {
      if (removed & _panelMask[p] == _panelMask[p]) rel |= 1 << p;
    }
    return rel;
  }

  int trayCount(int removed, int released) {
    var held = 0;
    for (var p = 0; p < _m; p++) {
      if (released & (1 << p) != 0) held |= _panelMask[p];
    }
    return _popcount(removed & ~held);
  }

  /// Screws that can be tapped successfully from [removed] (free and the
  /// tray has room), in solver order.
  List<int> legalMoves(int removed) {
    final rel = releasedMask(removed);
    if (rel == _allPanels) return const [];
    if (trayCount(removed, rel) >= capacity) return const [];
    return [
      for (final s in _order)
        if (removed & (1 << s) == 0 && _blockerMask[s] & ~rel == 0) s,
    ];
  }

  bool isWon(int removed) => releasedMask(removed) == _allPanels;

  /// Solution from the position where [removed] screws are out, as screw
  /// ids; `[]` when already won; null when unsolvable.
  List<String>? solve(Iterable<String> removed) {
    final path = <int>[];
    return _dfs(maskOf(removed), path)
        ? [for (final s in path) board.screwIds[s]]
        : null;
  }

  bool isSolvable(Iterable<String> removed) => solve(removed) != null;

  bool _dfs(int removed, List<int> path) {
    if (isWon(removed)) return true;
    if (_dead.contains(removed)) return false;
    for (final s in legalMoves(removed)) {
      path.add(s);
      if (_dfs(removed | (1 << s), path)) return true;
      path.removeLast();
    }
    _dead.add(removed);
    return false;
  }

  /// Full reachable-state analysis from the start, used to rate difficulty.
  SolverAnalysis analyze() {
    final winProb = <int, double>{};
    var deadEnds = 0;
    double visit(int removed) {
      final cached = winProb[removed];
      if (cached != null) return cached;
      double p;
      if (isWon(removed)) {
        p = 1;
      } else {
        final moves = legalMoves(removed);
        if (moves.isEmpty) {
          deadEnds++;
          p = 0;
        } else {
          var sum = 0.0;
          for (final s in moves) {
            sum += visit(removed | (1 << s));
          }
          p = sum / moves.length;
        }
      }
      winProb[removed] = p;
      return p;
    }

    final p = visit(0);
    final first = legalMoves(0);
    final trapFirstMoves = first
        .where((s) => winProb[1 << s] == 0)
        .length;
    return SolverAnalysis(
      reachableStates: winProb.length,
      deadEnds: deadEnds,
      randomWinProbability: p,
      firstMoves: first.length,
      trapFirstMoves: trapFirstMoves,
    );
  }
}

final class SolverAnalysis {
  const SolverAnalysis({
    required this.reachableStates,
    required this.deadEnds,
    required this.randomWinProbability,
    required this.firstMoves,
    required this.trapFirstMoves,
  });

  final int reachableStates;

  /// Reachable stuck positions.
  final int deadEnds;

  /// Chance that a player tapping uniformly random legal screws wins.
  /// 1.0 = impossible to get stuck.
  final double randomWinProbability;
  final int firstMoves;

  /// Opening moves from which the level can no longer be won.
  final int trapFirstMoves;

  bool get solvable => randomWinProbability > 0;

  @override
  String toString() =>
      'states=$reachableStates deadEnds=$deadEnds '
      'pRandomWin=${randomWinProbability.toStringAsFixed(3)} '
      'firstMoves=$firstMoves traps=$trapFirstMoves';
}

int _popcount(int v) {
  var c = 0;
  while (v != 0) {
    v &= v - 1;
    c++;
  }
  return c;
}
