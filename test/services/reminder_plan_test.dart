import 'package:flutter_test/flutter_test.dart';
import 'package:screw_out/services/notifications/reminder_plan.dart';

void main() {
  group('daily reminder', () {
    test('19:00 today, or tomorrow once done or past', () {
      expect(ReminderPlan.dailyAt(now: DateTime(2026, 11, 24, 10), todayDone: false), DateTime(2026, 11, 24, 19));
      expect(ReminderPlan.dailyAt(now: DateTime(2026, 11, 24, 10), todayDone: true), DateTime(2026, 11, 25, 19));
      expect(ReminderPlan.dailyAt(now: DateTime(2026, 11, 24, 20), todayDone: false), DateTime(2026, 11, 25, 19));
      // Month end rolls over.
      expect(ReminderPlan.dailyAt(now: DateTime(2026, 11, 30, 21), todayDone: false), DateTime(2026, 12, 1, 19));
    });
  });

  group('comeback reminder', () {
    final installed = DateTime(2026, 11, 24, 9);

    DateTime? comeback(
      DateTime now, {
      bool enabled = true,
      bool permitted = true,
      bool todayDone = false,
      DateTime? installedAt,
      bool noInstall = false,
    }) => ReminderPlan.comebackAt(
      now: now,
      installedAt: noInstall ? null : (installedAt ?? installed),
      enabled: enabled,
      permitted: permitted,
      dailyAt: ReminderPlan.dailyAt(now: now, todayDone: todayDone),
    );

    test('a day after a first session that ends before the evening', () {
      final now = DateTime(2026, 11, 24, 10, 30);
      expect(comeback(now), DateTime(2026, 11, 25, 10, 30));
    });

    test('needs the reminder setting, OS permission and a known install', () {
      final now = DateTime(2026, 11, 24, 10);
      expect(comeback(now, enabled: false), isNull);
      expect(comeback(now, permitted: false), isNull);
      expect(comeback(now, noInstall: true), isNull);
    });

    test('only in the first week', () {
      expect(comeback(DateTime(2026, 11, 30, 10)), isNotNull);
      expect(comeback(DateTime(2026, 12, 1, 9)), isNull);
    });

    test('never two reminders on one day: the daily one covers it', () {
      // Played at 20:00: the daily fires tomorrow at 19:00, the same day.
      expect(comeback(DateTime(2026, 11, 24, 20)), isNull);
      // Today's daily already done: the next daily is tomorrow evening.
      expect(comeback(DateTime(2026, 11, 24, 10), todayDone: true), isNull);
    });
  });
}
