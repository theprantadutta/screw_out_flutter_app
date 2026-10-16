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
}
