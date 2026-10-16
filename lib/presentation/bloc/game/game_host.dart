import '../../../game/domain/level.dart';
import '../../../game/engine/engine.dart';

/// Everything a level session needs from the rest of the app. The app wires a
/// real implementation (progress, economy, ads, analytics); tests use fakes.
/// Keeps [GameCubit] free of service locators.
abstract interface class GameHost {
  /// Persist the in-progress position (after every committed move).
  Future<void> saveProgress(SavedGame game);

  /// Clear the in-progress position (on restart/exit/complete).
  Future<void> clearProgress(int levelId);

  /// Record a clear and award coins. Called exactly once per session win.
  /// Returns the reward breakdown.
  Future<LevelReward> completeLevel(LevelResult result);

  /// Unlimited hints, free rescues, no ads.
  bool get isPro;

  int get coins;

  /// Spends coins; false when the balance is too low.
  Future<bool> spendCoins(int amount, {required String reason});

  /// Shows a rewarded video. Resolves true only when the reward was earned.
  Future<bool> showRewardedAd({required String placement});

  bool get rewardedAdAvailable;

  void track(String event, [Map<String, Object?> params = const {}]);
}

/// Outcome of one cleared session.
final class LevelResult {
  const LevelResult({
    required this.level,
    required this.moves,
    required this.elapsed,
    required this.mastered,
    required this.usedHint,
    required this.restarted,
    required this.rescued,
    required this.isDaily,
  });

  final Level level;
  final int moves;
  final Duration elapsed;

  /// ◆ — cleared without hint, restart or rescue in this session.
  final bool mastered;
  final bool usedHint;
  final bool restarted;
  final bool rescued;
  final bool isDaily;
}

final class LevelReward {
  const LevelReward({
    required this.coins,
    required this.balanceBefore,
    required this.balanceAfter,
    required this.firstClear,
    this.chapterCompleted,
  });

  final int coins;
  final int balanceBefore;
  final int balanceAfter;
  final bool firstClear;

  /// Set when this clear finished a chapter (screen 12 follows).
  final int? chapterCompleted;
}

/// Economy constants shared by gameplay and sheets.
abstract final class GameEconomy {
  static const hintsPerSession = 3;
  static const hintCoinCost = 60;
  static const rescueCoinCost = 120;
  static const maxRescuesPerSession = 1;
}
