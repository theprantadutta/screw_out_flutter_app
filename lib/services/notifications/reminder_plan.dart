/// When the local reminders fire. Pure, so the rules are unit-tested.
///
/// * The **daily** reminder: 19:00 local for today's sheet (tomorrow when
///   today's is done or 19:00 has passed).
/// * The **comeback** reminder for new players: about a day after they last
///   played, during the install's first week. A local nudge reaches guests
///   who have no backend identity, and lands while the game is still fresh.
///   It is pushed back every time the app runs, so someone who keeps
///   playing never gets it.
///
/// At most one reminder per local calendar day: when the comeback would
/// share a day with the daily reminder, the daily one covers it.
abstract final class ReminderPlan {
  static const dailyHour = 19;
  static const comebackAfter = Duration(hours: 24);
  static const comebackWindow = Duration(days: 7);

  static DateTime dailyAt({required DateTime now, required bool todayDone}) {
    var fire = DateTime(now.year, now.month, now.day, dailyHour);
    if (todayDone || !fire.isAfter(now)) fire = DateTime(now.year, now.month, now.day + 1, dailyHour);
    return fire;
  }

  /// Null = no comeback reminder this time.
  static DateTime? comebackAt({
    required DateTime now,
    required DateTime? installedAt,
    required bool enabled,
    required bool permitted,
    required DateTime dailyAt,
  }) {
    if (!enabled || !permitted || installedAt == null) return null;
    if (now.difference(installedAt) >= comebackWindow) return null;
    final fire = now.add(comebackAfter);
    if (_sameDay(fire, dailyAt)) return null;
    return fire;
  }

  static bool _sameDay(DateTime a, DateTime b) {
    final x = a.toLocal();
    final y = b.toLocal();
    return x.year == y.year && x.month == y.month && x.day == y.day;
  }
}
