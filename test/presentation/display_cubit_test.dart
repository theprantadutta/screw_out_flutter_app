import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:screw_out/data/database/app_database.dart';
import 'package:screw_out/presentation/bloc/display/display_cubit.dart';

import '../helpers/screen_harness.dart';

class _RecordingBackend extends NoRefreshRate {
  final calls = <String>[];
  @override
  Future<void> preferMax() async => calls.add('max');
  @override
  Future<void> preferDefault() async => calls.add('default');
}

void main() {
  late AppDatabase db;
  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    await db.initializeDefaults();
  });
  tearDown(() => db.close());

  test('opt-in: off by default and the system default is requested', () async {
    final backend = _RecordingBackend();
    final cubit = DisplayCubit(DriftDisplayPreferenceStore(db), backend: backend);
    await cubit.initialize();
    expect(cubit.state.loaded, isTrue);
    expect(cubit.state.highRefreshRate, isFalse);
    expect(backend.calls, ['default']);
  });

  test('turning it on persists per device and requests max', () async {
    final backend = _RecordingBackend();
    final cubit = DisplayCubit(DriftDisplayPreferenceStore(db), backend: backend);
    await cubit.initialize();
    await cubit.setHighRefreshRate(true);
    expect(backend.calls.last, 'max');

    final again = DisplayCubit(DriftDisplayPreferenceStore(db), backend: _RecordingBackend());
    await again.initialize();
    expect(again.state.highRefreshRate, isTrue);
  });

  test('re-applying on resume re-sends the preference', () async {
    final backend = _RecordingBackend();
    final cubit = DisplayCubit(DriftDisplayPreferenceStore(db), backend: backend);
    await cubit.initialize();
    await cubit.setHighRefreshRate(true);
    await cubit.apply();
    expect(backend.calls, ['default', 'max', 'max']);
  });

  test('preference is not synced (no outbox row)', () async {
    final cubit = DisplayCubit(DriftDisplayPreferenceStore(db), backend: const NoRefreshRate());
    await cubit.initialize();
    await cubit.setHighRefreshRate(true);
    expect(await db.select(db.syncQueue).get(), isEmpty);
  });
}
