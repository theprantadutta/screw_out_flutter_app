import 'dart:async';

import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:refresh_rate/refresh_rate.dart';

import '../../../data/database/app_database.dart';

/// Where the high-refresh preference lives (Drift `DevicePreferences`).
abstract interface class DisplayPreferenceStore {
  Future<bool> loadHighRefreshRate();
  Future<void> saveHighRefreshRate(bool enabled);
}

final class DriftDisplayPreferenceStore implements DisplayPreferenceStore {
  DriftDisplayPreferenceStore(this._db);

  final AppDatabase _db;

  @override
  Future<bool> loadHighRefreshRate() async {
    final row = await (_db.select(_db.devicePreferences)..where((p) => p.id.equals(1))).getSingleOrNull();
    return row?.highRefreshRate ?? false;
  }

  @override
  Future<void> saveHighRefreshRate(bool enabled) => _db.into(_db.devicePreferences).insertOnConflictUpdate(
    DevicePreferencesCompanion(
      id: const Value(1),
      highRefreshRate: Value(enabled),
      updatedAt: Value(DateTime.now().toUtc()),
    ),
  );
}

/// The `refresh_rate` plugin behind a seam, so tests and unsupported
/// platforms never touch the platform channel.
abstract interface class RefreshRateBackend {
  Future<void> preferMax();
  Future<void> preferDefault();
  Future<DisplayInfo?> read();
  Stream<DisplayInfo> get changes;
}

final class PluginRefreshRateBackend implements RefreshRateBackend {
  const PluginRefreshRateBackend();

  @override
  Future<void> preferMax() async => RefreshRate.preferMax();
  @override
  Future<void> preferDefault() async => RefreshRate.preferDefault();
  @override
  Future<DisplayInfo?> read() => RefreshRate.refresh();
  @override
  Stream<DisplayInfo> get changes => RefreshRate.onChanged;
}

final class DisplayState extends Equatable {
  const DisplayState({this.loaded = false, this.highRefreshRate = false, this.info});

  final bool loaded;

  /// The player's choice (opt-in, off by default).
  final bool highRefreshRate;
  final DisplayInfo? info;

  /// Nothing to offer on a display that only does one rate.
  bool get supported {
    final i = info;
    if (i == null) return false;
    return i.maxRate > 61 || i.supportedRates.where((r) => r > 61).isNotEmpty;
  }

  /// Highest rate the screen can do, rounded (e.g. 120), or null if unknown.
  int? get maxHz => (info == null || info!.maxRate <= 0) ? null : info!.maxRate.round();

  /// Rate the display is running at right now, or null if unknown.
  int? get currentHz => (info == null || info!.currentRate <= 0) ? null : info!.currentRate.round();

  /// The OS caps the rate in battery saver / when hot, whatever we ask for.
  bool get throttledByBattery => info?.isLowPowerMode ?? false;
  bool get throttledByHeat =>
      info != null &&
      (info!.thermalState == ThermalState.serious || info!.thermalState == ThermalState.critical);

  DisplayState copyWith({bool? loaded, bool? highRefreshRate, DisplayInfo? info}) => DisplayState(
    loaded: loaded ?? this.loaded,
    highRefreshRate: highRefreshRate ?? this.highRefreshRate,
    info: info ?? this.info,
  );

  @override
  List<Object?> get props => [
    loaded,
    highRefreshRate,
    info?.currentRate,
    info?.maxRate,
    info?.isLowPowerMode,
    info?.thermalState,
  ];
}

/// Owns the high-refresh-rate opt-in (mirrors snake-classic's DisplayCubit).
///
/// Flutter's engine doesn't request a refresh rate on its own, so a 120 Hz
/// phone can render the board at 60 Hz. When the player opts in we submit a
/// high-rate *preference*; the OS still decides, based on battery saver,
/// heat and device settings. Device-only — never synced.
class DisplayCubit extends Cubit<DisplayState> {
  DisplayCubit(this._store, {this.backend = const PluginRefreshRateBackend()})
    : super(const DisplayState());

  final DisplayPreferenceStore _store;
  final RefreshRateBackend backend;
  StreamSubscription<DisplayInfo>? _changes;

  /// Reads the stored choice, applies it and starts watching the display.
  /// Call after the first frame (the plugin needs an attached view).
  Future<void> initialize() async {
    if (state.loaded) return;
    var enabled = false;
    try {
      enabled = await _store.loadHighRefreshRate();
    } catch (e) {
      debugPrint('Display: could not read refresh-rate preference: $e');
    }
    emit(state.copyWith(loaded: true, highRefreshRate: enabled));
    try {
      _changes = backend.changes.listen(
        (info) {
          if (!isClosed) emit(state.copyWith(info: info));
        },
        onError: (Object e) => debugPrint('Display: change stream failed: $e'),
      );
    } catch (e) {
      // Platforms without an implementation never wire the channel up.
      debugPrint('Display: could not watch display changes: $e');
    }
    await apply();
  }

  /// Pushes the preference to the platform and re-reads the display.
  /// Also called on resume: Android drops the window's preferred mode when
  /// the app is backgrounded.
  Future<void> apply() async {
    try {
      if (state.highRefreshRate) {
        await backend.preferMax();
      } else {
        await backend.preferDefault();
      }
    } catch (e) {
      debugPrint('Display: could not set refresh rate: $e');
    }
    await refreshInfo();
  }

  Future<void> refreshInfo() async {
    try {
      final info = await backend.read();
      if (info != null && !isClosed) emit(state.copyWith(info: info));
    } catch (e) {
      debugPrint('Display: could not read display info: $e');
    }
  }

  Future<void> setHighRefreshRate(bool value) async {
    if (state.highRefreshRate == value) return;
    emit(state.copyWith(highRefreshRate: value));
    try {
      await _store.saveHighRefreshRate(value);
    } catch (e) {
      debugPrint('Display: could not save refresh-rate preference: $e');
    }
    await apply();
  }

  @override
  Future<void> close() async {
    await _changes?.cancel();
    return super.close();
  }
}
