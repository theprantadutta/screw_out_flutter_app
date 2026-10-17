import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../core/theme/blueprint_tokens.dart';
import '../../game/domain/move_result.dart';
import '../../game/presentation/board_view.dart';
import '../../game/presentation/flyer_layer.dart';
import '../../game/presentation/game_feedback.dart';
import '../../game/presentation/gameplay_visuals.dart';
import '../../game/presentation/tray_view.dart';
import '../../l10n/app_localizations.dart';
import '../../presentation/bloc/game/game_cubit.dart';
import '../../presentation/bloc/game/game_host.dart';
import '../../presentation/bloc/settings/settings_cubit.dart';
import '../../services/cosmetics.dart';
import '../../widgets/bp/bp_buttons.dart';
import '../../widgets/bp/bp_grid.dart';
import '../../widgets/bp/bp_screen.dart';
import 'widgets/game_sheets.dart';
import 'widgets/result_overlay.dart';

/// Navigation + economy hooks the gameplay screen needs from its route.
final class GameplayCallbacks {
  const GameplayCallbacks({
    required this.onExit,
    required this.onNext,
    required this.onReplay,
    required this.nextLabel,
    this.secondaryLabel,
    this.onSecondary,
  });

  /// Pause → EXIT TO SHEETS, result → SHEETS.
  final VoidCallback onExit;
  final void Function(LevelReward? reward) onNext;
  final VoidCallback onReplay;
  final String nextLabel;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;
}

/// 07 Gameplay (+ 08 feedback states, 09 pause, 10 stuck, 11 complete,
/// 13 out of hints). Expects a [GameCubit] and [SettingsCubit] above it.
class GameplayScreen extends StatefulWidget {
  const GameplayScreen({
    super.key,
    required this.coins,
    required this.callbacks,
    this.feedback = const NoFeedback(),
    this.adAvailable = false,
    this.tutorial,
    this.theme,
  });

  /// Equipped cosmetic board theme (Blueprint when null).
  final BoardTheme? theme;

  final int coins;
  final GameplayCallbacks callbacks;
  final GameFeedback feedback;
  final bool adAvailable;

  /// First-run coach mark (DWG 001), drawn full-screen above board, tray
  /// and actions. It must let taps through where it wants them to land.
  final Widget Function(GameplayVisuals visuals)? tutorial;

  @override
  State<GameplayScreen> createState() => _GameplayScreenState();
}

class _GameplayScreenState extends State<GameplayScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late final GameCubit _cubit = context.read<GameCubit>();
  late final GameplayVisuals _visuals;
  late final AnimationController _sheet;
  late final AnimationController _objective;
  StreamSubscription<BoardEvent>? _sub;
  GameOverlay _shownOverlay = GameOverlay.none;
  bool _confirmRestart = false;
  bool _coinsCounted = false;
  double _stuckSheetHeight = 260;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    final reduced = context.read<SettingsCubit>().state.reducedMotion;
    _visuals = GameplayVisuals(
      vsync: this,
      level: _cubit.level,
      initial: _cubit.state.board,
      feedback: widget.feedback,
      reducedMotion: reduced,
    );
    if (widget.theme != null) _visuals.theme = widget.theme!;
    _sheet = AnimationController(vsync: this, duration: BpMotion.sheet, reverseDuration: BpMotion.sheetOut);
    _objective = AnimationController(
      vsync: this,
      duration: BpMotion.objective,
      value: _cubit.state.objectiveVisible ? 1 : 0,
    );
    _sub = _cubit.events.listen(_visuals.handle);
    widget.feedback.gameplayVisible(true);
    _syncOverlay(_cubit.state.overlay);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      _cubit.onBackground();
    } else if (state == AppLifecycleState.resumed) {
      _cubit.onForeground();
    }
  }

  @override
  void dispose() {
    widget.feedback.gameplayVisible(false);
    WidgetsBinding.instance.removeObserver(this);
    _sub?.cancel();
    _visuals.dispose();
    _sheet.dispose();
    _objective.dispose();
    super.dispose();
  }

  void _syncOverlay(GameOverlay overlay) {
    final reduced = _visuals.reducedMotion;
    _sheet.duration = reduced ? BpMotion.reduced : (overlay == GameOverlay.won ? const Duration(milliseconds: 420) : BpMotion.sheet);
    _sheet.reverseDuration = reduced ? BpMotion.reduced : BpMotion.sheetOut;
    if (overlay != GameOverlay.none) {
      setState(() => _shownOverlay = overlay);
      _sheet.forward();
    } else if (_shownOverlay != GameOverlay.none) {
      _sheet.reverse().whenComplete(() {
        if (mounted && _cubit.state.overlay == GameOverlay.none) {
          setState(() => _shownOverlay = GameOverlay.none);
        }
      });
    }
  }

  // ------------------------------------------------------------- layout

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final settings = context.watch<SettingsCubit>().state;
    _visuals.reducedMotion = settings.reducedMotion;

    return MultiBlocListener(
      listeners: [
        BlocListener<GameCubit, GameSessionState>(
          listenWhen: (a, b) => a.overlay != b.overlay,
          listener: (context, s) {
            if (s.overlay != GameOverlay.paused) _confirmRestart = false;
            if (s.overlay == GameOverlay.stuck) widget.feedback.stuck();
            _syncOverlay(s.overlay);
          },
        ),
        BlocListener<GameCubit, GameSessionState>(
          listenWhen: (a, b) => a.objectiveVisible != b.objectiveVisible,
          listener: (context, s) {
            if (s.objectiveVisible) {
              _objective.forward();
            } else {
              _objective.animateTo(0, duration: BpMotion.objective, curve: BpMotion.standardIn);
            }
          },
        ),
        BlocListener<GameCubit, GameSessionState>(
          listenWhen: (a, b) => a.board != b.board,
          listener: (context, s) => _visuals.reconcile(s.board),
        ),
      ],
      child: PopScope(
        // System back never drops the player out of a level by accident:
        // play → Pause; open sheet → close it; result card → leave.
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (didPop) return;
          switch (_cubit.state.overlay) {
            case GameOverlay.none:
              _cubit.pause();
            case GameOverlay.won:
              widget.callbacks.onExit();
            case GameOverlay.paused || GameOverlay.outOfHints || GameOverlay.stuck:
              if (_confirmRestart) {
                setState(() => _confirmRestart = false);
              } else {
                _cubit.dismissOverlay();
              }
          }
        },
        child: BlocBuilder<GameCubit, GameSessionState>(
          builder: (context, s) => BpGridBackground(
            child: LayoutBuilder(
              builder: (context, constraints) => _layout(context, l, s, settings, constraints),
            ),
          ),
        ),
      ),
    );
  }

  Widget _layout(
    BuildContext context,
    AppLocalizations l,
    GameSessionState s,
    SettingsState settings,
    BoxConstraints c,
  ) {
    final pad = MediaQuery.paddingOf(context);
    final won = s.overlay == GameOverlay.won || _shownOverlay == GameOverlay.won;
    final stuckShown = _shownOverlay == GameOverlay.stuck;

    // Anchors (design frame: header 48, objective 112, board 162, tray
    // bottom 100, actions bottom 34). Status bar = 38 on the frame.
    final top = math.max(pad.top, 24.0) + 10;
    final actionsBottom = math.max(BpSize.actionsBottom, pad.bottom + 14);
    final trayBottom = actionsBottom + BpSize.primaryH + 12;
    final trayHeight = 10 + 12 + 8 + BpSize.traySlotH + 12;
    final boardTop = top + 114;
    final boardBottom = c.maxHeight - trayBottom - trayHeight - 16;
    final width = c.maxWidth;
    final boardSize = math.max(
      200.0,
      math.min(math.min(width - 2 * BpSpace.gameplay, boardBottom - boardTop), BpSize.boardMax),
    );

    final hintLabel = l.hintCount(s.isPro ? l.hintUnlimited : '${s.hintsLeft}');

    final tray = TrayView(
      visuals: _visuals,
      state: s.board,
      trayLabel: l.tray,
      trayFullLabel: l.trayFull,
      stuck: stuckShown,
    );

    return Stack(
      children: [
        // Header.
        Positioned(
          top: top,
          left: BpSpace.gameplay,
          right: BpSpace.gameplay,
          height: 52,
          child: _Header(
            code: s.level.code,
            title: s.level.title,
            coins: (s.reward != null && !_coinsCounted) ? s.reward!.balanceBefore : widget.coins,
            showControls: !won,
            showCoins: widget.tutorial == null,
            onPause: _cubit.pause,
            pauseLabel: l.pause,
          ),
        ),
        // Objective chip - collapses after the first valid move.
        if (s.level.objective != null)
          Positioned(
            top: top + 64,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: Listenable.merge([_objective, _visuals.objectiveIn]),
              builder: (context, child) => Opacity(
                opacity: _objective.value * _visuals.objectiveIn.value,
                child: Transform.translate(offset: Offset(0, -8 * (1 - _objective.value)), child: child),
              ),
              child: Center(child: _ObjectiveChip(text: s.level.objective!)),
            ),
          ),
        // Board.
        Positioned(
          top: boardTop + math.max(0, (boardBottom - boardTop - boardSize) / 4),
          left: (width - boardSize) / 2,
          width: boardSize,
          height: boardSize,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              BoardView(
                visuals: _visuals,
                state: s.board,
                size: boardSize,
                onTapScrew: _cubit.tapScrew,
                onPressScrew: widget.feedback.pressDown,
                interactive: s.overlay == GameOverlay.none,
              ),
              if (won && s.result != null)
                Positioned.fill(
                  child: CelebrationLayer(
                    seed: s.level.id,
                    reducedMotion: _visuals.reducedMotion,
                    onStamp: () => _celebrate(s),
                  ),
                ),
            ],
          ),
        ),
        // Actions (hidden while the first-run coach mark is up).
        Positioned(
          left: BpSpace.gameplay,
          right: BpSpace.gameplay,
          bottom: actionsBottom,
          child: widget.tutorial != null ? const SizedBox.shrink() : Row(
            children: [
              Expanded(
                child: BpOutlineButton(
                  height: BpSize.primaryH,
                  fill: BpColor.sheet,
                  dimmed: !s.canUndo,
                  onPressed: _cubit.undo,
                  semanticLabel: l.undo,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Symbols.undo_sharp, size: 20),
                      const SizedBox(width: 8),
                      Text(l.undo),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: BpPrimaryButton(
                  onPressed: _cubit.requestHint,
                  semanticLabel: hintLabel,
                  padding: EdgeInsets.zero,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Symbols.lightbulb_sharp, size: 20, fill: 1),
                      const SizedBox(width: 8),
                      AnimatedSwitcher(
                        duration: BpMotion.feedback,
                        transitionBuilder: (child, a) => SlideTransition(
                          position: Tween(begin: const Offset(0, .4), end: Offset.zero).animate(a),
                          child: FadeTransition(opacity: a, child: child),
                        ),
                        child: Text(
                          hintLabel,
                          key: ValueKey(hintLabel),
                          style: BpType.monoButtonBold.copyWith(color: BpColor.ink),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        // Scrim - tray sits above it so the cause of "stuck" stays visible.
        if (_shownOverlay != GameOverlay.none)
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _sheet,
              builder: (context, _) {
                final dim = (_shownOverlay == GameOverlay.won ? 0.0 : 1.0) * _sheet.value;
                return GestureDetector(
                  onTap: _shownOverlay == GameOverlay.paused || _shownOverlay == GameOverlay.outOfHints
                      ? _cubit.dismissOverlay
                      : null,
                  child: ColoredBox(color: BpColor.scrim.withValues(alpha: BpColor.scrim.a * dim)),
                );
              },
            ),
          ),
        // Tray (lifts above the stuck sheet).
        AnimatedBuilder(
          animation: _sheet,
          builder: (context, child) {
            final lift = stuckShown
                ? (_stuckSheetHeight + 14 - trayBottom) * _sheetCurve(_sheet)
                : 0.0;
            return Positioned(
              left: BpSpace.gameplay,
              right: BpSpace.gameplay,
              bottom: trayBottom + lift,
              child: child!,
            );
          },
          child: tray,
        ),
        // Sheet.
        if (_shownOverlay != GameOverlay.none)
          AnimatedBuilder(
            animation: _sheet,
            builder: (context, child) {
              final reduced = _visuals.reducedMotion;
              final t = _sheetCurve(_sheet);
              return Positioned(
                left: BpSize.sheetInset,
                right: BpSize.sheetInset,
                bottom: 14,
                child: Opacity(
                  opacity: reduced ? _sheet.value : 1,
                  child: FractionalTranslation(
                    translation: Offset(0, reduced ? 0 : 1.15 * (1 - t)),
                    child: child,
                  ),
                ),
              );
            },
            child: _MeasureHeight(
              onHeight: (h) {
                if (_shownOverlay == GameOverlay.stuck && h != _stuckSheetHeight) {
                  setState(() => _stuckSheetHeight = h);
                }
              },
              child: _sheetFor(context, l, s, settings),
            ),
          ),
        // First-run coach mark: above board, tray and actions.
        if (widget.tutorial != null && _shownOverlay == GameOverlay.none)
          Positioned.fill(child: widget.tutorial!(_visuals)),
        // Flyers above everything.
        Positioned.fill(child: FlyerLayer(visuals: _visuals)),
      ],
    );
  }

  double _sheetCurve(AnimationController c) =>
      (c.status == AnimationStatus.reverse ? BpMotion.standardIn : BpMotion.sheetCurve).transform(c.value);

  Widget _sheetFor(BuildContext context, AppLocalizations l, GameSessionState s, SettingsState settings) {
    final settingsCubit = context.read<SettingsCubit>();
    switch (_shownOverlay) {
      case GameOverlay.paused:
        if (_confirmRestart) {
          return RestartConfirmSheet(
            moves: s.moves,
            onCancel: () => setState(() => _confirmRestart = false),
            onConfirm: () {
              _confirmRestart = false;
              _cubit.restart();
            },
          );
        }
        return PauseSheet(
          code: s.level.code,
          moves: s.moves,
          sound: settings.sound,
          haptics: settings.haptics,
          reducedMotion: settings.reducedMotion,
          onResume: _cubit.resume,
          onSound: settingsCubit.setSound,
          onHaptics: settingsCubit.setHaptics,
          onReducedMotion: settingsCubit.setReducedMotion,
          onRestart: () {
            if (s.moves >= 6) {
              setState(() => _confirmRestart = true);
            } else {
              _cubit.restart();
            }
          },
          onExit: widget.callbacks.onExit,
        );
      case GameOverlay.stuck:
        return StuckSheet(
          reason: _stuckReason(l, s),
          hintLabel: l.hintCount(s.isPro ? l.hintUnlimited : '${s.hintsLeft}'),
          canUndo: s.canUndo,
          onUndo: _cubit.undo,
          onRestart: _cubit.restart,
          onHint: _cubit.requestHint,
          rescue: s.canRescue
              ? RescueRow(
                  isPro: s.isPro,
                  cost: GameEconomy.rescueCoinCost,
                  adAvailable: widget.adAvailable,
                  onCoins: () => _rescue(l, viaAd: false),
                  onAd: () => _rescue(l, viaAd: true),
                  onPro: () => _rescue(l, viaAd: false),
                )
              : null,
        );
      case GameOverlay.outOfHints:
        return OutOfHintsSheet(
          balance: widget.coins,
          cost: GameEconomy.hintCoinCost,
          adAvailable: widget.adAvailable,
          onWatch: () => _hintFromAd(l),
          onCoins: () => _hintFromCoins(l),
          onKeepThinking: _cubit.dismissOverlay,
        );
      case GameOverlay.won:
        final result = s.result;
        if (result == null) return const SizedBox.shrink();
        return ResultCard(
          result: result,
          reward: s.reward,
          reducedMotion: _visuals.reducedMotion,
          nextLabel: widget.callbacks.nextLabel,
          secondaryLabel: widget.callbacks.secondaryLabel,
          onNext: () => widget.callbacks.onNext(s.reward),
          onReplay: widget.callbacks.onReplay,
          onSheets: widget.callbacks.onSecondary ?? widget.callbacks.onExit,
          onCoinsCounted: () {
            widget.feedback.coins();
            if (mounted) setState(() => _coinsCounted = true);
          },
        );
      case GameOverlay.none:
        return const SizedBox.shrink();
    }
  }

  /// The stamp lands: daily cue, "high score" for a new best, else success.
  void _celebrate(GameSessionState s) {
    if (s.result?.isDaily ?? false) {
      widget.feedback.daily();
    } else if (_cubit.state.reward?.newBest ?? false) {
      widget.feedback.best();
    } else {
      widget.feedback.success();
    }
  }

  // ------------------------------------------------- purchase feedback

  Future<void> _hintFromCoins(AppLocalizations l) async {
    if (widget.coins < GameEconomy.hintCoinCost) {
      showBpToast(context, l.notEnoughCoins, kind: BpToastKind.error);
      return;
    }
    final ok = await _cubit.buyHintWithCoins();
    if (!mounted) return;
    ok
        ? showBpToast(context, l.hintBoughtToast(GameEconomy.hintCoinCost), kind: BpToastKind.success)
        : showBpToast(context, l.notEnoughCoins, kind: BpToastKind.error);
  }

  Future<void> _hintFromAd(AppLocalizations l) async {
    final ok = await _cubit.watchAdForHint();
    if (!mounted) return;
    ok
        ? showBpToast(context, l.hintEarnedToast, kind: BpToastKind.success)
        : showBpToast(context, widget.adAvailable ? l.adNotCompleted : l.adUnavailable, kind: BpToastKind.error);
  }

  Future<void> _rescue(AppLocalizations l, {required bool viaAd}) async {
    final pro = _cubit.state.isPro;
    if (!pro && !viaAd && widget.coins < GameEconomy.rescueCoinCost) {
      showBpToast(context, l.notEnoughCoins, kind: BpToastKind.error);
      return;
    }
    final ok = await _cubit.rescue(viaAd: viaAd);
    if (!mounted) return;
    if (ok) {
      widget.feedback.rescue();
      showBpToast(
        context,
        pro || viaAd ? l.rescueToast : l.rescuePaidToast(GameEconomy.rescueCoinCost),
        kind: BpToastKind.success,
      );
    } else {
      showBpToast(
        context,
        viaAd ? (widget.adAvailable ? l.adNotCompleted : l.adUnavailable) : l.notEnoughCoins,
        kind: BpToastKind.error,
      );
    }
  }

  /// "PL-03 still holds one screw on the board. Undo frees a slot."
  String _stuckReason(AppLocalizations l, GameSessionState s) {
    final board = _visuals.board;
    String? best;
    var bestLeft = 1 << 30;
    for (final id in s.board.tray.whereType<String>()) {
      final panel = board.panelOfScrew(id);
      final left = board.screwsOfPanel(panel).where((x) => !s.board.removed.contains(x)).length;
      if (left > 0 && left < bestLeft) {
        bestLeft = left;
        best = panel;
      }
    }
    if (best == null || s.status != GameStatus.stuck) return l.stuckReasonGeneric;
    return l.stuckReasonHolding(s.level.panelById(best).label, bestLeft);
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.code,
    required this.title,
    required this.coins,
    required this.showControls,
    this.showCoins = true,
    required this.onPause,
    required this.pauseLabel,
  });

  final String code;
  final String title;
  final int coins;
  final bool showControls;
  final bool showCoins;
  final VoidCallback onPause;
  final String pauseLabel;

  @override
  Widget build(BuildContext context) => Stack(
    alignment: Alignment.center,
    children: [
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(code, style: BpType.caption.copyWith(color: BpColor.textMuted)),
          const SizedBox(height: 2),
          Text(title, style: BpType.title.copyWith(color: BpColor.line), maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
      if (showControls) ...[
        Align(
          alignment: Alignment.centerLeft,
          child: BpIconButton(
            icon: const Icon(Symbols.pause_sharp, fill: 1),
            onPressed: onPause,
            semanticLabel: pauseLabel,
          ),
        ),
        if (showCoins) Align(alignment: Alignment.centerRight, child: BpCoinChip(coins: coins)),
      ],
    ],
  );
}

class _ObjectiveChip extends StatelessWidget {
  const _ObjectiveChip({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) => CustomPaint(
    foregroundPainter: const BpBorderPainter(color: BpColor.lineDashed, width: 1, dashed: true),
    child: Container(
      color: BpColor.sheet,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      child: Text(text, style: BpType.objective.copyWith(color: BpColor.line)),
    ),
  );
}

/// Reports its child's height after layout.
class _MeasureHeight extends StatefulWidget {
  const _MeasureHeight({required this.child, required this.onHeight});

  final Widget child;
  final ValueChanged<double> onHeight;

  @override
  State<_MeasureHeight> createState() => _MeasureHeightState();
}

class _MeasureHeightState extends State<_MeasureHeight> {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final box = context.findRenderObject() as RenderBox?;
      if (box != null && box.hasSize) widget.onHeight(box.size.height);
    });
    return widget.child;
  }
}
