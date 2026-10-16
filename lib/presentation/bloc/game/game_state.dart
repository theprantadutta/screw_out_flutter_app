import 'package:equatable/equatable.dart';

import '../../../game/domain/game_state.dart';
import '../../../game/domain/level.dart';
import '../../../game/domain/move_result.dart';
import 'game_host.dart';

enum GameOverlay { none, paused, stuck, outOfHints, won }

final class GameSessionState extends Equatable {
  const GameSessionState({
    required this.level,
    required this.board,
    required this.status,
    required this.capacity,
    required this.canUndo,
    required this.hintsLeft,
    required this.isPro,
    required this.canRescue,
    required this.overlay,
    required this.objectiveVisible,
    this.result,
    this.reward,
  });

  factory GameSessionState.initial(Level level, bool isPro) => GameSessionState(
    level: level,
    board: GameState.initial(level.trayCapacity),
    status: GameStatus.playing,
    capacity: level.trayCapacity,
    canUndo: false,
    hintsLeft: 0,
    isPro: isPro,
    canRescue: true,
    overlay: GameOverlay.none,
    objectiveVisible: level.objective != null,
  );

  final Level level;

  /// Authoritative engine snapshot.
  final GameState board;
  final GameStatus status;
  final int capacity;
  final bool canUndo;
  final int hintsLeft;
  final bool isPro;
  final bool canRescue;
  final GameOverlay overlay;
  final bool objectiveVisible;
  final LevelResult? result;
  final LevelReward? reward;

  int get moves => board.moves;
  int get trayFilled => board.filledSlots;

  GameSessionState copyWith({
    GameState? board,
    GameStatus? status,
    int? capacity,
    bool? canUndo,
    int? hintsLeft,
    bool? isPro,
    bool? canRescue,
    GameOverlay? overlay,
    bool? objectiveVisible,
    LevelResult? result,
    LevelReward? reward,
  }) => GameSessionState(
    level: level,
    board: board ?? this.board,
    status: status ?? this.status,
    capacity: capacity ?? this.capacity,
    canUndo: canUndo ?? this.canUndo,
    hintsLeft: hintsLeft ?? this.hintsLeft,
    isPro: isPro ?? this.isPro,
    canRescue: canRescue ?? this.canRescue,
    overlay: overlay ?? this.overlay,
    objectiveVisible: (objectiveVisible ?? this.objectiveVisible) &&
        level.objective != null,
    result: result ?? this.result,
    reward: reward ?? this.reward,
  );

  @override
  List<Object?> get props => [
    level.id,
    board,
    status,
    capacity,
    canUndo,
    hintsLeft,
    isPro,
    canRescue,
    overlay,
    objectiveVisible,
    result,
    reward,
  ];
}
