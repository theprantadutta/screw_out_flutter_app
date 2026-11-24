import 'dart:async';

import 'package:flutter/widgets.dart';

/// Swallows every tap for a moment before a full-screen ad appears, so a
/// tap meant for "Next sheet" (or a quick double tap) can never land on an
/// ad that has just opened. AdMob flags those as accidental clicks.
/// Invisible: it paints nothing.
abstract final class TapGuard {
  static const duration = Duration(milliseconds: 700);

  /// Covers [overlay] with a transparent tap absorber for [duration], then
  /// removes it. Without an overlay it only waits.
  static Future<void> absorb(OverlayState? overlay, {Duration duration = TapGuard.duration}) async {
    if (overlay == null || !overlay.mounted) {
      await Future<void>.delayed(duration);
      return;
    }
    final entry = OverlayEntry(
      builder: (_) => const AbsorbPointer(key: ValueKey('ad-tap-guard'), child: SizedBox.expand()),
    );
    overlay.insert(entry);
    try {
      await Future<void>.delayed(duration);
    } finally {
      if (entry.mounted) entry.remove();
      entry.dispose();
    }
  }
}
