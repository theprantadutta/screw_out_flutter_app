import 'package:flutter/widgets.dart';
import 'package:share_plus/share_plus.dart';

import '../l10n/app_localizations.dart';
import 'app_log.dart';

/// Where shared results point: the marketing page, which links both stores,
/// so one link works for Android and iPhone friends alike.
const shareLink = 'https://screwout.pranta.dev';

/// The text of a shared daily result, Wordle-style:
///
///     🔩 Screw Out · D-289
///     ✅ 11 moves · 1:02 · ◆
///     🔥 5-day streak
///     https://screwout.pranta.dev
String dailyShareText(
  AppLocalizations l, {
  required String code,
  required int moves,
  required Duration time,
  required bool mastered,
  required int streak,
}) {
  final m = time.inMinutes, s = (time.inSeconds % 60).toString().padLeft(2, '0');
  return [
    '🔩 ${l.shareDailyTitle(code)}',
    '✅ ${l.shareDailyMoves(moves, '$m:$s')}${mastered ? ' · ◆' : ''}',
    if (streak >= 2) '🔥 ${l.shareDailyStreak(streak)}',
    shareLink,
  ].join('\n');
}

/// The global rect of the widget behind [context]: iPad shows the share
/// sheet as a popover and needs an anchor, or share_plus throws.
Rect? shareOriginOf(BuildContext context) {
  final box = context.findRenderObject();
  if (box is! RenderBox || !box.hasSize) return null;
  return box.localToGlobal(Offset.zero) & box.size;
}

/// Opens the system share sheet. Never throws.
Future<void> shareText(String text, {Rect? origin}) async {
  try {
    await SharePlus.instance.share(ShareParams(text: text, sharePositionOrigin: origin));
  } on Object catch (e) {
    AppLog.warn('Share failed: $e');
  }
}
