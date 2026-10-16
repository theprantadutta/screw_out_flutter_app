import '../../../game/domain/move_result.dart';
import 'game_host.dart';

/// What the visuals should depict. Emitted *after* the state change it
/// describes, synchronously, so animation and state never disagree.
sealed class BoardEvent {
  const BoardEvent();
}

final class ScrewTaken extends BoardEvent {
  const ScrewTaken(this.result);
  final ScrewRemoved result;
}

final class ScrewBlockedEvent extends BoardEvent {
  const ScrewBlockedEvent(this.screwId, this.blockerPanelId);
  final String screwId;
  final String blockerPanelId;
}

final class TrayFullEvent extends BoardEvent {
  const TrayFullEvent(this.screwId);
  final String screwId;
}

final class UndoEvent extends BoardEvent {
  const UndoEvent(this.undone);
  final Undone undone;
}

/// Hint: replay [rewinds] as fast undos, then ring [plan.screwId].
final class HintEvent extends BoardEvent {
  const HintEvent(this.plan, this.rewinds);
  final HintPlan plan;
  final List<Undone> rewinds;
}

final class RestartEvent extends BoardEvent {
  const RestartEvent();
}

final class RescueEvent extends BoardEvent {
  const RescueEvent(this.slot);
  final int slot;
}

final class WinEvent extends BoardEvent {
  const WinEvent(this.result);
  final LevelResult result;
}
