import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Persistence for settings (Drift `GameSettings` row in the app).
abstract interface class SettingsStore {
  Future<SettingsState?> load();
  Future<void> save(SettingsState state);
}

final class SettingsState extends Equatable {
  const SettingsState({
    this.sound = true,
    this.music = true,
    this.haptics = true,
    this.reducedMotion = false,
    this.localeCode,
    this.dailyReminder = true,
    this.tutorialDone = false,
  });

  final bool sound;

  /// On by default (the "Workshop" loop; ducks under SFX, quieter in play).
  final bool music;
  final bool haptics;
  final bool reducedMotion;

  /// Null = follow the device.
  final String? localeCode;
  final bool dailyReminder;
  final bool tutorialDone;

  SettingsState copyWith({
    bool? sound,
    bool? music,
    bool? haptics,
    bool? reducedMotion,
    String? localeCode,
    bool clearLocale = false,
    bool? dailyReminder,
    bool? tutorialDone,
  }) => SettingsState(
    sound: sound ?? this.sound,
    music: music ?? this.music,
    haptics: haptics ?? this.haptics,
    reducedMotion: reducedMotion ?? this.reducedMotion,
    localeCode: clearLocale ? null : (localeCode ?? this.localeCode),
    dailyReminder: dailyReminder ?? this.dailyReminder,
    tutorialDone: tutorialDone ?? this.tutorialDone,
  );

  @override
  List<Object?> get props => [
    sound,
    music,
    haptics,
    reducedMotion,
    localeCode,
    dailyReminder,
    tutorialDone,
  ];
}

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(this._store, {SettingsState? initial})
    : super(initial ?? const SettingsState());

  final SettingsStore _store;

  /// Loads persisted settings. On first run, Reduced motion follows the OS
  /// (`MediaQuery.disableAnimations`).
  Future<void> load({required bool osReducedMotion}) async {
    final saved = await _store.load();
    if (saved != null) {
      emit(saved);
    } else {
      final first = state.copyWith(reducedMotion: osReducedMotion);
      emit(first);
      await _store.save(first);
    }
  }

  Future<void> _update(SettingsState next) async {
    emit(next);
    await _store.save(next);
  }

  Future<void> setSound(bool v) => _update(state.copyWith(sound: v));
  Future<void> setMusic(bool v) => _update(state.copyWith(music: v));
  Future<void> setHaptics(bool v) => _update(state.copyWith(haptics: v));
  Future<void> setReducedMotion(bool v) => _update(state.copyWith(reducedMotion: v));
  Future<void> setDailyReminder(bool v) => _update(state.copyWith(dailyReminder: v));
  Future<void> setLocale(String? code) =>
      _update(code == null ? state.copyWith(clearLocale: true) : state.copyWith(localeCode: code));
  Future<void> markTutorialDone() => _update(state.copyWith(tutorialDone: true));
  Future<void> setTutorialDone(bool v) => _update(state.copyWith(tutorialDone: v));
}

/// In-memory store for tests and previews.
final class MemorySettingsStore implements SettingsStore {
  SettingsState? value;
  @override
  Future<SettingsState?> load() async => value;
  @override
  Future<void> save(SettingsState state) async => value = state;
}
