import 'dart:async';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:screw_out/data/database/app_database.dart';
import 'package:screw_out/services/badge_watcher.dart';
import 'package:screw_out/services/badges.dart';
import 'package:screw_out/services/progress_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late AppDatabase db;
  late ProgressService progress;
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    db = AppDatabase.forTesting(NativeDatabase.memory());
    await db.initializeDefaults();
    progress = ProgressService(db);
  });
  tearDown(() => db.close());

  Set<String> earned(ProgressSnapshot s) => {for (final b in evaluateBadges(s)) if (b.earned) b.badge.id};

  test('best streak is the longest run of consecutive days', () {
    expect(bestStreak({}), 0);
    expect(bestStreak({20261029, 20261030, 20261031}), 3);
    expect(bestStreak({20261001, 20261002, 20261010, 20261011, 20261012, 20261013}), 4);
    expect(bestStreak({20261031, 20261101}), 2, reason: 'across a month boundary');
  });

  test('badges follow sheets cleared, chapters and progress caps at the target', () async {
    expect(earned(await progress.snapshot()), isEmpty);
    await progress.debugMarkCleared(20);
    final s = await progress.snapshot();
    expect(earned(s), containsAll(['sheets_1', 'sheets_10', 'chapter_1']));
    expect(earned(s), isNot(contains('sheets_25')));
    final sheets25 = evaluateBadges(s).firstWhere((b) => b.badge.id == 'sheets_25');
    expect(sheets25.progress, 20);
    expect(kBadges.map((b) => b.id).toSet(), hasLength(kBadges.length), reason: 'ids are unique');
  });

  test('watcher toasts a badge earned in play, once; a bulk restore stays silent', () async {
    final stream = StreamController<ProgressSnapshot>();
    final toasts = <String>[];
    await BadgeWatcher(stream.stream, (b) => toasts.add(b.id)).start(await progress.snapshot());

    await progress.debugMarkCleared(1); // one clear: First Turn
    stream.add(await progress.snapshot());
    await pumpEventQueue();
    expect(toasts, ['sheets_1']);

    stream.add(await progress.snapshot()); // same state again
    await pumpEventQueue();
    expect(toasts, ['sheets_1'], reason: 'never twice');

    await db.delete(db.levelClears).go();
    await progress.debugMarkCleared(30); // a cloud restore brings 30 at once
    stream.add(await progress.snapshot());
    await pumpEventQueue();
    expect(toasts, ['sheets_1'], reason: 'restores are silent');
    await stream.close();
  });

  test('an existing player is not flooded on the first launch with badges', () async {
    await progress.debugMarkCleared(25);
    final stream = StreamController<ProgressSnapshot>();
    final toasts = <String>[];
    await BadgeWatcher(stream.stream, (b) => toasts.add(b.id)).start(await progress.snapshot());
    stream.add(await progress.snapshot());
    await pumpEventQueue();
    expect(toasts, isEmpty);
    await stream.close();
  });
}
