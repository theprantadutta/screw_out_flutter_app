import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:screw_out/l10n/app_localizations.dart';
import 'package:screw_out/services/share_result.dart';

void main() {
  final l = lookupAppLocalizations(const Locale('en'));

  test('daily share text: code, moves, time, mastery, streak and link', () {
    final text = dailyShareText(l, code: 'D-289', moves: 11, time: const Duration(seconds: 62), mastered: true, streak: 5);
    expect(text, '🔩 Screw Out · D-289\n✅ 11 moves · 1:02 · ◆\n🔥 5-day streak\n$shareLink');
  });

  test('no streak line for a first day; singular move', () {
    final text = dailyShareText(l, code: 'D-1', moves: 1, time: const Duration(seconds: 9), mastered: false, streak: 1);
    expect(text, '🔩 Screw Out · D-1\n✅ 1 move · 0:09\n$shareLink');
    expect(text.contains('\u2014'), isFalse);
  });
}
