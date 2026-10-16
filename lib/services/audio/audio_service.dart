import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart' show AppLifecycleListener, AppLifecycleState, WidgetsBinding;
import 'package:flutter_soloud/flutter_soloud.dart';

import '../../presentation/bloc/settings/settings_cubit.dart';
import '../app_log.dart';
import '../ports.dart';

/// The game's single audio engine (SoLoud): preloaded low-latency SFX plus
/// the looping "Workshop" track. Ported from snake-classic's service, with
/// its hard-won rules kept:
///
/// * `SoLoud.instance` is resolved lazily, so constructing this never loads
///   the native library (tests, settings-only callers).
/// * The engine is torn down in the background and rebuilt on resume — a
///   mixer left running past the activity crashed snake (SIGABRT minutes
///   after backgrounding). Init / suspend / resume are serialised.
/// * Every voice handle is validated before use: SoLoud hands back a zeroed
///   handle (no exception) when it runs out of voices.
/// * Output device idle timeout off, so a sound after silence isn't late.
///
/// Mix rules (MOTION_SPEC §12): at most 2 SFX at once; music sits under the
/// SFX and dips for jingles; quieter during gameplay.
class AudioService implements SoundPort {
  AudioService(this._settings);

  final SettingsCubit _settings;
  SoLoud get _soloud => SoLoud.instance;

  final Map<Sfx, AudioSource> _sfx = {};
  final List<SoundHandle> _active = [];
  AudioSource? _musicSource;
  SoundHandle? _music;
  bool _initialized = false;
  bool _suspended = false;
  bool _gameplay = false;
  int _generation = 0;
  Timer? _duckTimer;
  StreamSubscription<SettingsState>? _settingsSub;
  AppLifecycleListener? _lifecycle;
  Future<void> _ops = Future.value();

  static const _maxConcurrentSfx = 2;
  static const _musicMenu = 0.42;
  static const _musicGameplay = 0.24;
  static const _duck = 0.5; // −6 dB
  static const _fadeIn = Duration(milliseconds: 1200);
  static const _fadeShort = Duration(milliseconds: 250);

  /// Per-cue gain, balancing perceived loudness across the set.
  static const _gain = <Sfx, double>{
    Sfx.tick: 0.55,
    Sfx.toggle: 0.55,
    Sfx.unscrew: 0.9,
    Sfx.clink: 0.7,
    Sfx.panelSlide: 0.8,
    Sfx.slotFree: 0.5,
    Sfx.thunk: 0.9,
    Sfx.undo: 0.7,
    Sfx.hint: 0.7,
    Sfx.trayWarn: 0.45,
    Sfx.levelStart: 0.75,
    Sfx.success: 0.9,
    Sfx.best: 1,
    Sfx.stuck: 0.75,
    Sfx.coin: 0.6,
    Sfx.rescue: 0.8,
    Sfx.chapter: 1,
    Sfx.daily: 0.95,
    Sfx.purchase: 0.85,
  };

  Future<void> _enqueue(Future<void> Function() op) {
    final next = _ops.then((_) => op());
    _ops = next.catchError((Object _) {});
    return next;
  }

  Future<void> initialize() => _enqueue(_initialize);

  Future<void> _initialize() async {
    if (_initialized || _suspended) return;
    _lifecycle ??= AppLifecycleListener(
      onPause: () => unawaited(_enqueue(_suspend)),
      onDetach: () => unawaited(_enqueue(_suspend)),
      onResume: () => unawaited(_enqueue(_resume)),
    );
    _settingsSub ??= _settings.stream.listen(_onSettings);
    await _startEngine();
    _initialized = true;
    _syncMusic();
    final state = WidgetsBinding.instance.lifecycleState;
    if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      await _suspend();
    }
  }

  Future<void> _startEngine() async {
    try {
      await _soloud.init();
      _soloud.setAudioDeviceIdleTimeout(null);
      for (final s in Sfx.values) {
        try {
          _sfx[s] = await _soloud.loadAsset('assets/audio/${s.file}.wav');
        } on Object catch (e) {
          AppLog.warn('SFX ${s.file} failed to load: $e');
        }
      }
    } on Object catch (e) {
      AppLog.warn('Audio engine failed to start: $e');
    }
  }

  Future<void> _suspend() async {
    if (!_initialized || _suspended) return;
    _suspended = true;
    _initialized = false;
    _generation++;
    _duckTimer?.cancel();
    _sfx.clear();
    _active.clear();
    _musicSource = null;
    _music = null;
    try {
      await _soloud.deinitAsync();
    } on Object catch (e) {
      debugPrint('Audio suspend failed: $e');
    }
  }

  Future<void> _resume() async {
    if (!_suspended) return;
    _suspended = false;
    await _startEngine();
    _initialized = true;
    _syncMusic();
  }

  void _onSettings(SettingsState s) => _syncMusic();

  // ----------------------------------------------------------------- SFX

  @override
  void play(Sfx sfx) {
    if (!_initialized || !_settings.state.sound) return;
    final source = _sfx[sfx];
    if (source == null) return;
    try {
      _active.removeWhere((h) => !_soloud.getIsValidVoiceHandle(h));
      while (_active.length >= _maxConcurrentSfx) {
        final oldest = _active.removeAt(0);
        if (_soloud.getIsValidVoiceHandle(oldest)) unawaited(_soloud.stop(oldest));
      }
      final handle = _soloud.play(source, volume: _gain[sfx] ?? 0.8);
      if (_soloud.getIsValidVoiceHandle(handle)) _active.add(handle);
      if (sfx.isJingle) _duckFor(source);
    } on Object catch (e) {
      debugPrint('SFX ${sfx.file} failed: $e');
    }
  }

  void _duckFor(AudioSource source) {
    final music = _liveMusic;
    if (music == null) return;
    final length = _soloud.getLength(source);
    _soloud.fadeVolume(music, _musicTarget * _duck, const Duration(milliseconds: 120));
    _duckTimer?.cancel();
    _duckTimer = Timer(length, () {
      final m = _liveMusic;
      if (m != null) _soloud.fadeVolume(m, _musicTarget, const Duration(milliseconds: 600));
    });
  }

  // --------------------------------------------------------------- music

  @override
  void setGameplay(bool active) {
    if (_gameplay == active) return;
    _gameplay = active;
    final m = _liveMusic;
    if (m != null) _soloud.fadeVolume(m, _musicTarget, const Duration(milliseconds: 500));
  }

  double get _musicTarget => _gameplay ? _musicGameplay : _musicMenu;

  SoundHandle? get _liveMusic {
    final h = _music;
    if (h == null || !_initialized) return null;
    if (!_soloud.getIsValidVoiceHandle(h)) {
      _music = null;
      return null;
    }
    return h;
  }

  void _syncMusic() {
    if (!_initialized) return;
    final want = _settings.state.music;
    final live = _liveMusic;
    if (want && live == null) {
      unawaited(_startMusic());
    } else if (!want && live != null) {
      _music = null;
      try {
        _soloud.fadeVolume(live, 0, _fadeShort);
        _soloud.scheduleStop(live, _fadeShort);
      } on Object catch (e) {
        debugPrint('Music stop failed: $e');
      }
    }
  }

  Future<void> _startMusic() async {
    try {
      final generation = _generation;
      // Streamed from disk: a 43 s loop doesn't need to sit in RAM.
      final source = _musicSource ?? await _soloud.loadAsset('assets/audio/music_workshop.wav', mode: LoadMode.disk);
      if (generation != _generation || !_initialized) return;
      _musicSource = source;
      if (_liveMusic != null || !_settings.state.music) return;
      final h = _soloud.play(source, volume: 0, looping: true);
      if (!_soloud.getIsValidVoiceHandle(h)) return;
      _music = h;
      _soloud.fadeVolume(h, _musicTarget, _fadeIn);
    } on Object catch (e) {
      AppLog.warn('Music unavailable: $e');
    }
  }
}
