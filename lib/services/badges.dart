import 'package:flutter/widgets.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../game/generator/curriculum.dart';
import '../l10n/app_localizations.dart';
import 'progress_service.dart';

/// One workshop-record milestone, derived purely from progress already on
/// the device (and synced), so it needs no server and can't drift.
final class Badge {
  const Badge({
    required this.id,
    required this.icon,
    required this.target,
    required this.title,
    required this.detail,
    required this.measure,
  });

  /// Stable key (stored once "seen", so the toast fires only once).
  final String id;
  final IconData icon;
  final int target;
  final String Function(AppLocalizations l) title;
  final String Function(AppLocalizations l) detail;

  /// How far the player is toward [target].
  final int Function(ProgressSnapshot s) measure;
}

final class BadgeStatus {
  const BadgeStatus(this.badge, this.progress);
  final Badge badge;

  /// Capped at the target.
  final int progress;
  bool get earned => progress >= badge.target;
}

/// The longest run of consecutive days in [days] (yyyymmdd keys).
int bestStreak(Set<int> days) {
  final sorted = days.map((k) => DateTime.utc(k ~/ 10000, k ~/ 100 % 100, k % 100)).toList()..sort();
  var best = 0, run = 0;
  DateTime? prev;
  for (final d in sorted) {
    run = prev != null && d.difference(prev).inDays == 1 ? run + 1 : 1;
    if (run > best) best = run;
    prev = d;
  }
  return best;
}

int _sheets(ProgressSnapshot s) => s.clears.length;
int _mastered(ProgressSnapshot s) => s.clears.values.where((c) => c.mastered).length;

Badge _clearBadge(String id, int n, IconData icon, String Function(AppLocalizations l) title) => Badge(
  id: id,
  icon: icon,
  target: n,
  title: title,
  detail: (l) => n == 1 ? l.badgeFirstDetail : l.badgeClearDetail(n),
  measure: _sheets,
);

Badge _chapterBadge(int chapter) => Badge(
  id: 'chapter_$chapter',
  icon: Symbols.verified_sharp,
  target: kLevelsPerChapter,
  title: (_) => chapterInfo(chapter).name,
  detail: (l) => l.badgeChapterDetail(chapter),
  measure: (s) => s.clearedIn(chapter),
);

Badge _streakBadge(String id, int n, String Function(AppLocalizations l) title) => Badge(
  id: id,
  icon: Symbols.local_fire_department_sharp,
  target: n,
  title: title,
  detail: (l) => l.badgeStreakDetail(n),
  measure: (s) => bestStreak(s.dailyDone),
);

/// Every badge, in display order.
final List<Badge> kBadges = [
  _clearBadge('sheets_1', 1, Symbols.build_sharp, (l) => l.badgeFirstTurn),
  _clearBadge('sheets_10', 10, Symbols.handyman_sharp, (l) => l.badgeApprentice),
  _clearBadge('sheets_25', 25, Symbols.construction_sharp, (l) => l.badgeJourneyman),
  _clearBadge('sheets_50', 50, Symbols.engineering_sharp, (l) => l.badgeCraftsman),
  _clearBadge('sheets_100', 100, Symbols.workspace_premium_sharp, (l) => l.badgeChiefEngineer),
  for (var c = 1; c <= kBundledChapters; c++) _chapterBadge(c),
  Badge(
    id: 'mastered_10',
    icon: Symbols.diamond_sharp,
    target: 10,
    title: (l) => l.badgeCleanWork,
    detail: (l) => l.badgeMasterDetail(10),
    measure: _mastered,
  ),
  Badge(
    id: 'mastered_50',
    icon: Symbols.diamond_sharp,
    target: 50,
    title: (l) => l.badgePerfectionist,
    detail: (l) => l.badgeMasterDetail(50),
    measure: _mastered,
  ),
  Badge(
    id: 'daily_7',
    icon: Symbols.calendar_month_sharp,
    target: 7,
    title: (l) => l.badgeRegular,
    detail: (l) => l.badgeDailyDetail(7),
    measure: (s) => s.dailyDone.length,
  ),
  _streakBadge('streak_3', 3, (l) => l.badgeOnARoll),
  _streakBadge('streak_7', 7, (l) => l.badgeFullWeek),
  _streakBadge('streak_14', 14, (l) => l.badgeFortnight),
];

List<BadgeStatus> evaluateBadges(ProgressSnapshot s) => [
  for (final b in kBadges) BadgeStatus(b, b.measure(s).clamp(0, b.target)),
];
