/// Sound + haptic cues for gameplay moments (MOTION_SPEC §12). The app
/// implementation respects the independent sound / haptics toggles.
abstract interface class GameFeedback {
  void pressDown();
  void unscrew();
  void seat();
  void panelRelease();
  void slotsFreed();
  void blocked();
  void undo();
  void hint();
  void success();
  void coins();

  /// A sheet starts (board slides in): the "start game" cue.
  void levelStart();

  /// Exactly one tray slot left (subtle, no alarm).
  void trayWarn();

  /// Tray full — the gentle "game over" for a sheet.
  void stuck();

  /// Clear with a new best / mastery ◆ ("high score").
  void best();

  /// Daily sheet cleared.
  void daily();

  /// Extra tray slot granted.
  void rescue();

  /// The gameplay screen is (no longer) showing — music sits lower in play.
  void gameplayVisible(bool visible);
}

/// Silent feedback for tests and previews.
final class NoFeedback implements GameFeedback {
  const NoFeedback();
  @override
  void pressDown() {}
  @override
  void unscrew() {}
  @override
  void seat() {}
  @override
  void panelRelease() {}
  @override
  void slotsFreed() {}
  @override
  void blocked() {}
  @override
  void undo() {}
  @override
  void hint() {}
  @override
  void success() {}
  @override
  void coins() {}
  @override
  void levelStart() {}
  @override
  void trayWarn() {}
  @override
  void stuck() {}
  @override
  void best() {}
  @override
  void daily() {}
  @override
  void rescue() {}
  @override
  void gameplayVisible(bool visible) {}
}
