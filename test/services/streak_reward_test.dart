import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:screw_out/data/database/app_database.dart';
import 'package:screw_out/game/domain/level.dart';
import 'package:screw_out/presentation/bloc/game/game_host.dart';
import 'package:screw_out/services/progress_service.dart';
import 'package:screw_out/services/sync/pull_merger.dart';

/// A daily sheet whose id is its date key (yyyymmdd), as the app's are.
Level _daily(int key) => Level(
  id: key,
  code: 'D-$key',
  chapter: 0,
  title: 'Daily',
  trayCapacity: 3,
  panels: const [Panel.rect(id: 'a', x: 20, y: 20, w: 100, h: 100, depth: 0, label: 'PL-01')],
  screws: const [Screw(id: 'a0', panelId: 'a', x: 70, y: 70)],
);

LevelResult _win(int key) => LevelResult(
  level: _daily(key),
  moves: 1,
  elapsed: const Duration(seconds: 20),
  mastered: true,
  usedHint: false,
  restarted: false,
  rescued: false,
  isDaily: true,
);

void main() {
  late AppDatabase db;
  late ProgressService progress;
  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    await db.initializeDefaults();
    progress = ProgressService(db);
  });
  tearDown(() => db.close());

  test('milestones: day 3, 7 and 14, then every 7 days', () {
    expect([for (var d = 1; d <= 30; d++) if (Rewards.streakBonus(d) > 0) d], [3, 7, 14, 21, 28]);
    expect(Rewards.streakBonus(3), 25);
    expect(Rewards.streakBonus(7), 75);
    expect(Rewards.streakBonus(14), 150);
    expect(Rewards.streakBonus(21), 100);
  });

  test('day 3 of a streak pays the bonus once, on top of the daily reward', () async {
    expect((await progress.recordClear(_win(20261029))).streakBonus, 0);
    expect((await progress.recordClear(_win(20261030))).streakBonus, 0);

    final day3 = await progress.recordClear(_win(20261031));
    expect(day3.streakDays, 3);
    expect(day3.streakBonus, 25);
    expect(day3.coins, Rewards.daily + 25);

    // Replaying the same day pays nothing more.
    final again = await progress.recordClear(_win(20261031));
    expect(again.coins, 0);
    expect(again.streakBonus, 0);

    final ledger = await db.select(db.coinTransactions).get();
    expect(ledger.where((t) => t.reason == 'streak_bonus').map((t) => t.amount), [25]);
  });

  test('a daily pulled from another device never pays a bonus here', () async {
    await progress.recordClear(_win(20261029));
    await progress.recordClear(_win(20261030));
    await PullMerger(db).apply({
      'daily': {
        'completions': [
          {'date': '2026-10-31', 'moves': 4, 'time_ms': 30000},
        ],
      },
    });
    final ledger = await db.select(db.coinTransactions).get();
    expect(ledger.where((t) => t.reason == 'streak_bonus'), isEmpty);
    // And clearing that pulled day locally is a replay, not a first clear.
    expect((await progress.recordClear(_win(20261031))).streakBonus, 0);
  });
}
