import 'dart:async';

import 'package:flutter/widgets.dart';

import '../../core/theme/blueprint_tokens.dart';
import '../../presentation/bloc/game/game_events.dart';
import '../domain/board.dart';
import '../domain/game_state.dart';
import '../domain/level.dart';
import '../domain/move_result.dart';
import 'game_feedback.dart';

/// Animation orchestrator for one gameplay screen.
///
/// It *depicts* [BoardEvent]s and never mutates game state. Renderers listen
/// to individual controllers so a screw animation repaints that screw only.
/// [reconcile] snaps anything at rest to the authoritative state, so rapid
/// taps can never leave the picture out of sync with the engine.
class GameplayVisuals extends ChangeNotifier {
  GameplayVisuals({
    required TickerProvider vsync,
    required this.level,
    required GameState initial,
    required this.feedback,
    required bool reducedMotion,
  }) : _vsync = vsync, // ignore: prefer_initializing_formals
       board = Board(level),
       _reduced = reducedMotion {
    for (final s in level.screws) {
      screwOut[s.id] = _ctrl(value: initial.removed.contains(s.id) ? 1 : 0);
      shake[s.id] = _ctrl(duration: BpMotion.blockStep * 4);
    }
    for (final p in level.panels) {
      panelOut[p.id] = _ctrl(value: initial.released.contains(p.id) ? 1 : 0);
      panelMode[p.id] = PanelMotion.drop;
    }
    _ensureSlots(initial.tray.length);
    for (var i = 0; i < initial.tray.length; i++) {
      slots[i].show(initial.tray[i]);
    }
    blocker = _ctrl(duration: BpMotion.blockerHold);
    hint = _ctrl(duration: BpMotion.hintTotal);
    risk = _ctrl(duration: const Duration(milliseconds: 240));
    boardIn = _ctrl(duration: _reduced ? BpMotion.reduced : BpMotion.transition);
    objectiveIn = _ctrl(duration: BpMotion.feedback);
    enter();
  }

  final TickerProvider _vsync;
  final Level level;
  final Board board;
  final GameFeedback feedback;
  bool _reduced;

  bool get reducedMotion => _reduced;
  set reducedMotion(bool v) {
    if (_reduced == v) return;
    _reduced = v;
    notifyListeners();
  }

  /// Play-area key: its RenderBox maps level units → global coordinates.
  final GlobalKey boardKey = GlobalKey(debugLabel: 'board');
  final List<GlobalKey> slotKeys = [];

  /// dp per level unit, set by the board on layout.
  double scale = 1;

  final Map<String, AnimationController> screwOut = {};
  final Map<String, AnimationController> shake = {};
  final Map<String, AnimationController> panelOut = {};
  final Map<String, PanelMotion> panelMode = {};
  final List<SlotVisual> slots = [];
  final List<Flight> flights = [];
  late final AnimationController blocker;
  late final AnimationController hint;
  late final AnimationController risk;
  late final AnimationController boardIn;
  late final AnimationController objectiveIn;

  String? blockerPanel;
  String? hintScrew;
  String? hintPanel;

  /// Slot index of the last free slot when its one-shot pulse runs.
  int? riskSlot;

  final Set<String> _pendingPanels = {};
  final Set<int> _pendingSlots = {};
  final List<Timer> _timers = [];
  final List<AnimationController> _owned = [];
  bool _disposed = false;

  AnimationController _ctrl({double value = 0, Duration? duration}) {
    final c = AnimationController(
      vsync: _vsync,
      value: value,
      duration: duration ?? BpMotion.feedback,
    );
    _owned.add(c);
    return c;
  }

  void _later(Duration delay, VoidCallback fn) {
    if (delay == Duration.zero) {
      fn();
      return;
    }
    late Timer t;
    t = Timer(delay, () {
      _timers.remove(t);
      if (!_disposed) fn();
    });
    _timers.add(t);
  }

  void _ensureSlots(int n) {
    while (slots.length < n) {
      slots.add(SlotVisual(_ctrl(value: 1), _ctrl()));
      slotKeys.add(GlobalKey(debugLabel: 'slot${slots.length - 1}'));
    }
  }

  // ------------------------------------------------------------- geometry

  Offset? holeGlobal(String screwId) {
    final box = boardKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.attached) return null;
    final s = level.screws.firstWhere((s) => s.id == screwId);
    return box.localToGlobal(Offset(s.x * scale, s.y * scale));
  }

  /// Centre of the screw area of a tray slot (above its PL tag).
  Offset? slotGlobal(int slot) {
    if (slot >= slotKeys.length) return null;
    final box = slotKeys[slot].currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.attached) return null;
    return box.localToGlobal(Offset(box.size.width / 2, (box.size.height - 14) / 2));
  }

  // --------------------------------------------------------------- events

  void handle(BoardEvent event) {
    switch (event) {
      case ScrewTaken(:final result):
        _onTaken(result);
      case ScrewBlockedEvent(:final screwId, :final blockerPanelId):
        _onBlocked(screwId, blockerPanelId);
      case TrayFullEvent(:final screwId):
        _shake(screwId);
        feedback.blocked();
      case UndoEvent(:final undone):
        _onUndo(undone, BpMotion.undo);
        feedback.undo();
      case HintEvent(:final plan, :final rewinds):
        _onHint(plan, rewinds);
      case RestartEvent():
        _reset();
      case RescueEvent():
        notifyListeners();
      case WinEvent():
        break;
    }
  }

  void _onTaken(ScrewRemoved r) {
    feedback.unscrew();
    final out = screwOut[r.screwId]!;
    hintScrew == r.screwId ? _clearHint() : null;
    _ensureSlots(r.state.tray.length);

    if (_reduced) {
      out.animateTo(1, duration: BpMotion.reducedBoard, curve: Curves.linear);
    } else {
      out.animateTo(1, duration: BpMotion.unscrew, curve: Curves.linear);
      final from = holeGlobal(r.screwId);
      final to = slotGlobal(r.slot);
      if (from != null && to != null) {
        _fly(Flight(
          screwId: r.screwId,
          from: from,
          to: to.translate(0, -7),
          controller: _ctrl(duration: BpMotion.flight),
          reverse: false,
          unit: scale,
        ));
      }
    }

    // Seat in the slot.
    final slot = slots[r.slot];
    _pendingSlots.add(r.slot);
    slot.arriveHidden(r.screwId);
    final seatDelay = _reduced ? BpMotion.reducedBoard : BpMotion.slotPopDelay;
    _later(seatDelay, () {
      if (slot.screwId != r.screwId) return;
      slot.pop(_reduced ? BpMotion.reducedSlot : BpMotion.slotPop, _reduced);
      feedback.seat();
      if (r.releases.isEmpty) _pendingSlots.remove(r.slot);
    });

    // Settle: releases depicted after the screw visibly arrives (§3).
    if (r.releases.isNotEmpty) {
      for (final rel in r.releases) {
        _pendingPanels.add(rel.panelId);
        for (final f in rel.freed) {
          _pendingSlots.add(f.slot);
        }
      }
      _later(BpMotion.settleDelay, () => _depictReleases(r.releases));
    }

    // Last-slot risk pulse (one-shot, no loop).
    if (r.state.emptySlots == 1 && r.releases.isEmpty && !_reduced) {
      riskSlot = r.state.firstEmptySlot;
      risk.forward(from: 0);
    }
  }

  void _depictReleases(List<PanelRelease> releases) {
    feedback.panelRelease();
    var freedAny = false;
    for (final rel in releases) {
      final c = panelOut[rel.panelId]!;
      panelMode[rel.panelId] = PanelMotion.drop;
      if (hintPanel == rel.panelId) hintPanel = null;
      if (_reduced) {
        c.animateTo(1, duration: BpMotion.reduced, curve: Curves.linear);
      } else {
        _later(BpMotion.panelDelay, () {
          c.animateTo(1, duration: BpMotion.panelRelease, curve: Curves.linear);
        });
      }
      _later(BpMotion.panelRelease + BpMotion.panelDelay, () {
        _pendingPanels.remove(rel.panelId);
      });
      for (var k = 0; k < rel.freed.length; k++) {
        final f = rel.freed[k];
        freedAny = true;
        _later(BpMotion.trayFreeStagger * k, () {
          final slot = slots[f.slot];
          if (slot.screwId != f.screwId) {
            _pendingSlots.remove(f.slot);
            return;
          }
          slot.shrink(_reduced ? BpMotion.reduced : BpMotion.trayFree).whenComplete(() {
            if (slot.screwId == f.screwId) slot.show(null);
            _pendingSlots.remove(f.slot);
          });
        });
      }
    }
    if (freedAny) feedback.slotsFreed();
    notifyListeners();
  }

  void _onBlocked(String screwId, String panelId) {
    feedback.blocked();
    if (!_reduced) _shake(screwId);
    blockerPanel = panelId;
    blocker.forward(from: 0);
    notifyListeners();
  }

  void _shake(String screwId) {
    if (_reduced) return;
    shake[screwId]!.forward(from: 0);
  }

  void _onUndo(Undone u, Duration duration) {
    _ensureSlots(u.state.tray.length);
    final out = screwOut[u.screwId]!;
    if (_reduced) {
      out.animateTo(0, duration: BpMotion.reducedBoard, curve: Curves.linear);
    } else {
      final from = slotGlobal(u.slot);
      final to = holeGlobal(u.screwId);
      if (from != null && to != null) {
        _fly(Flight(
          screwId: u.screwId,
          from: from,
          to: to,
          controller: _ctrl(duration: duration),
          reverse: true,
          unit: scale,
        ));
      }
      out.animateTo(0, duration: duration, curve: BpMotion.standardOut);
    }
    slots[u.slot].show(null);
    _pendingSlots.remove(u.slot);
    for (final rel in u.unreleased) {
      _pendingPanels.remove(rel.panelId);
      panelMode[rel.panelId] = PanelMotion.rise;
      panelOut[rel.panelId]!.animateTo(
        0,
        duration: _reduced ? BpMotion.reduced : duration,
        curve: BpMotion.standardOut,
      );
      for (final f in rel.freed) {
        _pendingSlots.remove(f.slot);
        slots[f.slot]
          ..arriveHidden(f.screwId)
          ..pop(_reduced ? BpMotion.reducedSlot : duration, _reduced);
      }
    }
    // Restore any slot the engine says is filled but we show empty.
    for (var i = 0; i < u.state.tray.length; i++) {
      if (!_pendingSlots.contains(i) && slots[i].screwId != u.state.tray[i]) {
        slots[i].show(u.state.tray[i]);
      }
    }
    notifyListeners();
  }

  void _onHint(HintPlan plan, List<Undone> rewinds) {
    _clearHint();
    for (var i = 0; i < rewinds.length; i++) {
      _later(BpMotion.hintRewindStep * i, () => _onUndo(rewinds[i], BpMotion.hintRewindStep));
    }
    _later(BpMotion.hintRewindStep * rewinds.length, () {
      feedback.hint();
      hintScrew = plan.screwId;
      hintPanel = plan.releasesPanelId;
      hint.forward(from: 0).whenComplete(() {
        if (hintScrew == plan.screwId) _clearHint();
      });
      notifyListeners();
    });
  }

  void _clearHint() {
    if (hintScrew == null && hintPanel == null) return;
    hint.stop();
    hint.value = 0;
    hintScrew = null;
    hintPanel = null;
    notifyListeners();
  }

  void _fly(Flight f) {
    flights.add(f);
    notifyListeners();
    f.controller.forward().whenComplete(() {
      flights.remove(f);
      _owned.remove(f.controller);
      f.controller.dispose();
      if (!_disposed) notifyListeners();
    });
  }

  /// Level entry: board scales 0.94 → 1 and fades in; objective follows.
  void enter() {
    boardIn.forward(from: 0);
    _later(BpMotion.feedback, () => objectiveIn.forward(from: 0));
  }

  void _reset() {
    for (final t in _timers) {
      t.cancel();
    }
    _timers.clear();
    for (final f in [...flights]) {
      f.controller.stop();
    }
    flights.clear();
    _pendingPanels.clear();
    _pendingSlots.clear();
    _clearHint();
    blockerPanel = null;
    blocker.value = 0;
    for (final c in screwOut.values) {
      c.value = 0;
    }
    for (final c in panelOut.values) {
      c.value = 0;
    }
    for (final s in slots) {
      s.show(null);
    }
    boardIn.forward(from: 0);
    notifyListeners();
  }

  /// Snap everything at rest to [state]. Safe to call on every state change.
  void reconcile(GameState state) {
    _ensureSlots(state.tray.length);
    for (final s in level.screws) {
      final c = screwOut[s.id]!;
      final target = state.removed.contains(s.id) ? 1.0 : 0.0;
      if (!c.isAnimating && c.value != target) c.value = target;
    }
    for (final p in level.panels) {
      if (_pendingPanels.contains(p.id)) continue;
      final c = panelOut[p.id]!;
      final target = state.released.contains(p.id) ? 1.0 : 0.0;
      if (!c.isAnimating && c.value != target) c.value = target;
    }
    for (var i = 0; i < state.tray.length; i++) {
      if (_pendingSlots.contains(i) || slots[i].isAnimating) continue;
      if (slots[i].screwId != state.tray[i]) slots[i].show(state.tray[i]);
    }
  }

  bool get isIdle =>
      _timers.isEmpty &&
      flights.isEmpty &&
      _pendingPanels.isEmpty &&
      _pendingSlots.isEmpty;

  @override
  void dispose() {
    _disposed = true;
    for (final t in _timers) {
      t.cancel();
    }
    for (final c in _owned) {
      c.dispose();
    }
    for (final s in slots) {
      s.dispose();
    }
    super.dispose();
  }
}

enum PanelMotion {
  /// Release: anticipation lift, fall outward (dir × 28, +420), rotate dir × 5°.
  drop,

  /// Undo of a release: fade in while rising 24 → 0.
  rise,
}

/// One tray slot as displayed (converges to the engine tray).
class SlotVisual extends ChangeNotifier {
  SlotVisual(this.popIn, this.shrinkOut) {
    popIn.addListener(notifyListeners);
    shrinkOut.addListener(notifyListeners);
  }

  /// 1 = fully seated.
  final AnimationController popIn;

  /// 1 = shrunk away.
  final AnimationController shrinkOut;
  String? screwId;
  bool reducedPop = false;

  bool get isAnimating => popIn.isAnimating || shrinkOut.isAnimating;

  void show(String? id) {
    screwId = id;
    popIn.value = 1;
    shrinkOut.value = 0;
    notifyListeners();
  }

  void arriveHidden(String id) {
    screwId = id;
    popIn.value = 0;
    shrinkOut.value = 0;
    notifyListeners();
  }

  void pop(Duration duration, bool reduced) {
    reducedPop = reduced;
    popIn.animateTo(1, duration: duration, curve: Curves.linear);
  }

  TickerFuture shrink(Duration duration) =>
      shrinkOut.animateTo(1, duration: duration, curve: Curves.linear);
}

/// A screw copy travelling between a hole and a tray slot, above everything.
class Flight {
  Flight({
    required this.screwId,
    required this.from,
    required this.to,
    required this.controller,
    required this.reverse,
    required this.unit,
  });

  final String screwId;
  final Offset from;
  final Offset to;
  final AnimationController controller;

  /// Tray → hole (undo).
  final bool reverse;

  /// Board scale at launch (flyer head size).
  final double unit;
}
