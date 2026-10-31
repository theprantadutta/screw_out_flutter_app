import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

import 'badges.dart';
import 'progress_service.dart';

/// Spots badges the moment they are earned in play, so the app can toast
/// them. Remembers what this device has already celebrated, and stays
/// silent when progress jumps by more than one step at once (a cloud
/// restore or another device's sync), so a sign-in never fires a burst.
class BadgeWatcher {
  BadgeWatcher(this._progress, this._onEarned);

  final Stream<ProgressSnapshot> _progress;
  final void Function(Badge badge) _onEarned;

  static const _seenKey = 'badges_seen_v1';

  StreamSubscription<ProgressSnapshot>? _sub;
  Set<String>? _seen;
  ProgressSnapshot? _last;

  Future<void> start(ProgressSnapshot current) async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList(_seenKey);
    _last = current;
    _seen = stored?.toSet() ?? _earnedIds(current);
    if (stored == null) await prefs.setStringList(_seenKey, _seen!.toList());
    _sub = _progress.listen((s) => unawaited(_check(s)));
  }

  Set<String> _earnedIds(ProgressSnapshot s) => {for (final b in evaluateBadges(s)) if (b.earned) b.badge.id};

  Future<void> _check(ProgressSnapshot s) async {
    final seen = _seen;
    final last = _last;
    if (seen == null || last == null) return;
    _last = s;
    final fresh = [for (final b in evaluateBadges(s)) if (b.earned && !seen.contains(b.badge.id)) b.badge];
    if (fresh.isEmpty) return;
    final bulk = s.clears.length - last.clears.length > 1 || s.dailyDone.length - last.dailyDone.length > 1;
    seen.addAll(fresh.map((b) => b.id));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_seenKey, seen.toList());
    if (!bulk) fresh.forEach(_onEarned);
  }

  void dispose() => _sub?.cancel();
}
