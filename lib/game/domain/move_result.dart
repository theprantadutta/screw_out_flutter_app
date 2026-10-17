import 'game_state.dart';

enum GameStatus { playing, stuck, won }

/// A tray slot emptied because its screw's panel was released.
final class FreedSlot {
  const FreedSlot(this.slot, this.screwId);
  final int slot;
  final String screwId;
}

/// A panel released during settle, with the tray slots it gave back
/// (left → right, which is also the stagger order of the animation).
final class PanelRelease {
  const PanelRelease(this.panelId, this.freed);
  final String panelId;
  final List<FreedSlot> freed;
}

/// Result of tapping a screw. Every variant is decided synchronously; the
/// UI only depicts it.
sealed class TapResult {
  const TapResult(this.screwId);
  final String screwId;
}

/// The move was committed: the screw went to [slot], then settle ran.
final class ScrewRemoved extends TapResult {
  const ScrewRemoved(
    super.screwId, {
    required this.slot,
    required this.releases,
    required this.status,
    required this.state,
  });

  final int slot;

  /// Panels released by this move's settle (usually 0 or 1).
  final List<PanelRelease> releases;

  /// Status after settle. [GameStatus.won] is reported by exactly one move.
  final GameStatus status;
  final GameState state;
}

/// No state change: [blockerPanelId] is the topmost panel covering the screw.
final class ScrewBlocked extends TapResult {
  const ScrewBlocked(super.screwId, this.blockerPanelId);
  final String blockerPanelId;
}

/// No state change: the screw is free but the tray has no empty slot.
final class TrayFull extends TapResult {
  const TrayFull(super.screwId);
}

/// No state change: already removed, unknown id, or the level is won.
final class TapIgnored extends TapResult {
  const TapIgnored(super.screwId);
}

/// What an undo reversed - enough for the reverse animation.
final class Undone {
  const Undone({
    required this.screwId,
    required this.slot,
    required this.unreleased,
    required this.state,
  });

  /// The screw that flies back from [slot] into its hole.
  final String screwId;
  final int slot;

  /// Panels that come back, with the screws that return to their slots.
  final List<PanelRelease> unreleased;
  final GameState state;
}

/// The next hint: undo [rewind] moves first (fast undos), then tap [screwId].
final class HintPlan {
  const HintPlan({
    required this.rewind,
    required this.screwId,
    this.releasesPanelId,
  });

  final int rewind;
  final String screwId;

  /// Set when [screwId] is the last screw holding that panel.
  final String? releasesPanelId;
}
