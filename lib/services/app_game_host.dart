// ignore_for_file: prefer_initializing_formals
import 'package:flutter/services.dart';

import '../game/engine/engine.dart';
import '../game/presentation/game_feedback.dart';
import '../presentation/bloc/game/game_host.dart';
import '../presentation/bloc/premium/premium_cubit.dart';
import '../presentation/bloc/progress/progress_cubit.dart';
import '../presentation/bloc/settings/settings_cubit.dart';
import 'ports.dart';
import 'progress_service.dart';

/// Real [GameHost]: Drift progress + wallet, Pro entitlement, rewarded ads,
/// analytics.

class AppGameHost implements GameHost {
  AppGameHost({
    required ProgressService progress,
    required ProgressCubit progressCubit,
    required PremiumCubit premium,
    required AdsPort ads,
    required AnalyticsPort analytics,
  }) : _progress = progress,
       _progressCubit = progressCubit,
       _premium = premium,
       _ads = ads,
       _analytics = analytics;

  final ProgressService _progress;
  final ProgressCubit _progressCubit;
  final PremiumCubit _premium;
  final AdsPort _ads;
  final AnalyticsPort _analytics;

  @override
  bool get isPro => _premium.state.isPro;

  @override
  int get coins => _progressCubit.state.coins;

  @override
  Future<void> saveProgress(SavedGame game) => _progress.saveGame(game);

  @override
  Future<void> clearProgress(int levelId) => _progress.clearGame(levelId);

  @override
  Future<LevelReward> completeLevel(LevelResult result) => _progress.recordClear(result);

  @override
  Future<bool> spendCoins(int amount, {required String reason}) => _progress.spend(amount, reason);

  @override
  bool get rewardedAdAvailable => _ads.rewardedAvailable;

  @override
  Future<bool> showRewardedAd({required String placement}) async {
    _analytics.track('rewarded_ad_started', {'placement': placement});
    final ok = await _ads.showRewarded(placement: placement);
    if (ok) _analytics.track('rewarded_ad_completed', {'placement': placement});
    return ok;
  }

  @override
  void track(String event, [Map<String, Object?> params = const {}]) => _analytics.track(event, params);
}

/// Sound + haptics for gameplay (MOTION_SPEC §12); toggles are independent.
class AppGameFeedback implements GameFeedback {
  AppGameFeedback(this._settings, this._sound);

  final SettingsCubit _settings;
  final SoundPort _sound;

  void _sfx(Sfx s) {
    if (_settings.state.sound) _sound.play(s);
  }

  void _haptic(Future<void> Function() f) {
    if (_settings.state.haptics) f();
  }

  @override
  void pressDown() => _haptic(HapticFeedback.selectionClick);
  @override
  void unscrew() {
    _sfx(Sfx.unscrew);
    _haptic(HapticFeedback.lightImpact);
  }

  @override
  void seat() => _sfx(Sfx.clink);
  @override
  void panelRelease() {
    _sfx(Sfx.panelSlide);
    _haptic(HapticFeedback.mediumImpact);
  }

  @override
  void slotsFreed() => _sfx(Sfx.slotFree);
  @override
  void blocked() {
    _sfx(Sfx.thunk);
    _haptic(HapticFeedback.lightImpact);
  }

  @override
  void undo() {
    _sfx(Sfx.undo);
    _haptic(HapticFeedback.lightImpact);
  }

  @override
  void hint() {
    _sfx(Sfx.hint);
    _haptic(HapticFeedback.lightImpact);
  }

  @override
  void success() {
    _sfx(Sfx.success);
    _haptic(HapticFeedback.mediumImpact);
  }

  @override
  void coins() {
    _sfx(Sfx.coin);
    _haptic(HapticFeedback.lightImpact);
  }

  @override
  void levelStart() => _sfx(Sfx.levelStart);

  @override
  void trayWarn() => _sfx(Sfx.trayWarn);

  @override
  void stuck() {
    _sfx(Sfx.stuck);
    _haptic(HapticFeedback.lightImpact);
  }

  @override
  void best() {
    _sfx(Sfx.best);
    _haptic(HapticFeedback.heavyImpact);
  }

  @override
  void daily() {
    _sfx(Sfx.daily);
    _haptic(HapticFeedback.mediumImpact);
  }

  @override
  void rescue() {
    _sfx(Sfx.rescue);
    _haptic(HapticFeedback.lightImpact);
  }

  @override
  void gameplayVisible(bool visible) => _sound.setGameplay(visible);
}
