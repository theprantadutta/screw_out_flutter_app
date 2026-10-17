import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/blueprint_tokens.dart';
import '../../../game/domain/level.dart';
import '../../../game/domain/move_result.dart';
import '../../../game/engine/engine.dart';
import 'game_events.dart';
import 'game_host.dart';
import 'game_state.dart';

export 'game_events.dart';
export 'game_state.dart';

/// One level session. Owns the authoritative [GameEngine]; every tap commits
/// synchronously, then a [BoardEvent] tells the visuals what to depict.
/// Nothing here waits for an animation - the only timers are *when sheets
/// appear*, mirroring MOTION_SPEC §4 and §9.
class GameCubit extends Cubit<GameSessionState> {
  GameCubit({
    required Level level,
    required GameHost host,
    SavedGame? resume,
    this.isDaily = false,
    Duration Function()? clock,
  }) : _host = host,
       _engine = resume != null && resume.levelId == level.id
           ? GameEngine.restore(level, resume)
           : GameEngine(level),
       super(GameSessionState.initial(level, host.isPro)) {
    _clock = clock;
    final meta = resume?.levelId == level.id ? resume!.meta : const {};
    _hintsLeft = (meta['hintsLeft'] as num?)?.toInt() ?? GameEconomy.hintsPerSession;
    _usedHint = meta['usedHint'] == true;
    _restarted = meta['restarted'] == true;
    _rescued = meta['rescued'] == true;
    _elapsedBefore = Duration(milliseconds: (meta['elapsedMs'] as num?)?.toInt() ?? 0);
    _stopwatch.start();
    // A resumed game already has moves: its objective chip stays collapsed.
    _emitBoard(objectiveVisible: _engine.state.moves == 0);
    _host.track('level_started', {'level_id': level.id, 'resumed': resume != null});
  }

  final GameHost _host;
  final GameEngine _engine;
  final bool isDaily;
  final _events = StreamController<BoardEvent>.broadcast(sync: true);
  final _stopwatch = Stopwatch();
  Duration Function()? _clock;
  Duration _elapsedBefore = Duration.zero;
  int _hintsLeft = GameEconomy.hintsPerSession;
  bool _usedHint = false;
  bool _restarted = false;
  bool _rescued = false;
  bool _completed = false;
  int _session = 0;
  Timer? _overlayTimer;

  /// Animation feed for the board, tray and flyers.
  Stream<BoardEvent> get events => _events.stream;
  GameEngine get engine => _engine;
  Level get level => _engine.level;

  Duration get elapsed =>
      _elapsedBefore + (_clock?.call() ?? _stopwatch.elapsed);

  // ------------------------------------------------------------------ moves

  void tapScrew(String screwId) {
    if (state.overlay != GameOverlay.none || _completed) return;
    final result = _engine.tap(screwId);
    switch (result) {
      case ScrewRemoved():
        _emitBoard(objectiveVisible: false);
        _events.add(ScrewTaken(result));
        if (result.status == GameStatus.won) {
          _onWin();
        } else {
          _save();
          if (result.status == GameStatus.stuck && result.releases.isEmpty) {
            // Let the screw land, then explain (MOTION_SPEC §4).
            _showOverlayLater(
              GameOverlay.stuck,
              BpMotion.flight + BpMotion.stuckDelay,
            );
            _host.track('stuck', _levelParams);
          }
        }
      case ScrewBlocked():
        _events.add(ScrewBlockedEvent(result.screwId, result.blockerPanelId));
        _host.track('blocked_tap', {..._levelParams, 'screw': screwId});
      case TrayFull():
        _events.add(TrayFullEvent(screwId));
        _setOverlay(GameOverlay.stuck);
      case TapIgnored():
        break;
    }
  }

  void undo() {
    if (_completed) return;
    final undone = _engine.undo();
    if (undone == null) return;
    _cancelOverlayTimer();
    _emitBoard(overlay: GameOverlay.none);
    _events.add(UndoEvent(undone));
    _save();
    _host.track('undo_used', _levelParams);
  }

  void restart() {
    if (_completed) return;
    _cancelOverlayTimer();
    _engine.restart();
    _restarted = true;
    _session++;
    _emitBoard(overlay: GameOverlay.none, objectiveVisible: true);
    _events.add(const RestartEvent());
    unawaited(_host.clearProgress(level.id));
    _host.track('level_restarted', _levelParams);
  }

  // ------------------------------------------------------------------ hints

  bool get hasHints => _host.isPro || _hintsLeft > 0;

  /// Hint button: shows a hint, or the out-of-hints sheet (never an ad).
  void requestHint() {
    if (_completed) return;
    if (!hasHints) {
      _setOverlay(GameOverlay.outOfHints);
      return;
    }
    _useHint();
  }

  void _useHint() {
    final plan = _engine.planHint();
    if (plan == null) return;
    final rewinds = <Undone>[
      for (var i = 0; i < plan.rewind; i++) _engine.undo()!,
    ];
    if (!_host.isPro) _hintsLeft--;
    _usedHint = true;
    _cancelOverlayTimer();
    _emitBoard(overlay: GameOverlay.none);
    _events.add(HintEvent(plan, rewinds));
    if (rewinds.isNotEmpty) _save();
    _host.track('hint_used', {..._levelParams, 'rewind': plan.rewind});
  }

  /// Screen 13: +1 hint for coins, used immediately.
  Future<bool> buyHintWithCoins() async {
    final ok = await _host.spendCoins(GameEconomy.hintCoinCost, reason: 'hint');
    if (!ok || isClosed) return false;
    _hintsLeft++;
    _useHint();
    return true;
  }

  /// Screen 13: +1 hint for an optional rewarded video, used immediately.
  Future<bool> watchAdForHint() async {
    final ok = await _host.showRewardedAd(placement: 'hint');
    if (!ok || isClosed) return false;
    _hintsLeft++;
    _useHint();
    return true;
  }

  // ----------------------------------------------------------------- rescue

  bool get canRescue =>
      _engine.bonusSlots < GameEconomy.maxRescuesPerSession && !_completed;

  /// Stuck rescue: one extra tray slot. Free for Pro; otherwise coins or a
  /// rewarded video ([viaAd]).
  Future<bool> rescue({bool viaAd = false}) async {
    if (!canRescue) return false;
    if (!_host.isPro) {
      final ok = viaAd
          ? await _host.showRewardedAd(placement: 'rescue')
          : await _host.spendCoins(GameEconomy.rescueCoinCost, reason: 'rescue');
      if (!ok || isClosed) return false;
    }
    _engine.addBonusSlot();
    _rescued = true;
    _cancelOverlayTimer();
    _emitBoard(overlay: GameOverlay.none);
    _events.add(RescueEvent(_engine.capacity - 1));
    _save();
    _host.track('rescue_used', {..._levelParams, 'via': _host.isPro ? 'pro' : (viaAd ? 'ad' : 'coins')});
    return true;
  }

  // --------------------------------------------------------------- overlays

  void pause() {
    if (_completed || state.overlay != GameOverlay.none) return;
    _stopwatch.stop();
    _setOverlay(GameOverlay.paused);
  }

  void resume() {
    if (state.overlay == GameOverlay.won) return;
    _stopwatch.start();
    _setOverlay(GameOverlay.none);
  }

  void dismissOverlay() {
    if (state.overlay == GameOverlay.won) return;
    _stopwatch.start();
    _setOverlay(GameOverlay.none);
  }

  /// App went to background.
  void onBackground() {
    _stopwatch.stop();
    if (!_completed) _save();
  }

  void onForeground() {
    if (state.overlay != GameOverlay.paused) _stopwatch.start();
  }

  // -------------------------------------------------------------- internals

  Future<void> _onWin() async {
    if (_completed) return; // level_completed fires exactly once
    _completed = true;
    _stopwatch.stop();
    final session = _session;
    final result = LevelResult(
      level: level,
      moves: _engine.state.moves,
      elapsed: elapsed,
      mastered: !_usedHint && !_restarted && !_rescued,
      usedHint: _usedHint,
      restarted: _restarted,
      rescued: _rescued,
      isDaily: isDaily,
    );
    _emitBoard(result: result);
    _events.add(WinEvent(result));
    _host.track('level_completed', {
      ..._levelParams,
      'moves': result.moves,
      'time_ms': result.elapsed.inMilliseconds,
      'mastered': result.mastered,
    });
    // Card rises 650 ms after the final release, which starts at settle.
    _showOverlayLater(GameOverlay.won, BpMotion.settleDelay + const Duration(milliseconds: 650));
    final reward = await _host.completeLevel(result);
    await _host.clearProgress(level.id);
    if (isClosed || session != _session) return;
    emit(state.copyWith(reward: reward));
  }

  void _save() {
    unawaited(
      _host.saveProgress(
        _engine.save(
          meta: {
            'hintsLeft': _hintsLeft,
            'usedHint': _usedHint,
            'restarted': _restarted,
            'rescued': _rescued,
            'elapsedMs': elapsed.inMilliseconds,
          },
        ),
      ),
    );
  }

  Map<String, Object?> get _levelParams => {
    'level_id': level.id,
    'daily': isDaily,
    'moves': _engine.state.moves,
  };

  void _showOverlayLater(GameOverlay overlay, Duration delay) {
    _cancelOverlayTimer();
    final session = _session;
    _overlayTimer = Timer(delay, () {
      if (isClosed || session != _session) return;
      if (overlay == GameOverlay.stuck && _engine.status != GameStatus.stuck) {
        return; // undone in the meantime
      }
      _setOverlay(overlay);
    });
  }

  void _cancelOverlayTimer() {
    _overlayTimer?.cancel();
    _overlayTimer = null;
  }

  void _setOverlay(GameOverlay overlay) {
    if (state.overlay == overlay) return;
    emit(state.copyWith(overlay: overlay));
  }

  void _emitBoard({
    GameOverlay? overlay,
    bool? objectiveVisible,
    LevelResult? result,
  }) {
    emit(
      state.copyWith(
        board: _engine.state,
        status: _engine.status,
        capacity: _engine.capacity,
        canUndo: _engine.canUndo,
        hintsLeft: _hintsLeft,
        isPro: _host.isPro,
        canRescue: canRescue,
        overlay: overlay,
        objectiveVisible: objectiveVisible,
        result: result,
      ),
    );
  }

  @override
  Future<void> close() async {
    _cancelOverlayTimer();
    if (!_completed && _engine.state.moves > 0) _save();
    await _events.close();
    return super.close();
  }
}
