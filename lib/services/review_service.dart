// ignore_for_file: prefer_initializing_formals
import 'dart:async';

import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_log.dart';

/// The happy moment asking for a review. Only strong signals: Play and the
/// App Store cap the in-app sheet to a few per user per year and silently
/// skip the rest, so it is never spent on an ordinary clear.
enum ReviewTrigger {
  /// A chapter was just completed.
  chapterComplete,

  /// A replay beat the best moves or earned the first ◆.
  newBest,
}

/// The platform side, behind an interface so the gate is testable.
abstract interface class ReviewPlatform {
  Future<bool> isAvailable();
  Future<void> requestReview();
  Future<void> openStoreListing();
}

final class InAppReviewPlatform implements ReviewPlatform {
  const InAppReviewPlatform();
  @override
  Future<bool> isAvailable() => InAppReview.instance.isAvailable();
  @override
  Future<void> requestReview() => InAppReview.instance.requestReview();
  @override
  Future<void> openStoreListing() => InAppReview.instance.openStoreListing();
}

/// Lifetime play the gate reads: sheets cleared and the first clear's time.
typedef ReviewStats = ({int sheetsCleared, DateTime? firstClearAt});

/// In-app review with a local gate on top of the platform's own cap
/// (ported from snake-classic). The platform never says whether the sheet
/// showed or what was rated; this only makes sure we ask at a good moment.
class ReviewService {
  ReviewService({required Future<ReviewStats> Function() stats, ReviewPlatform platform = const InAppReviewPlatform()})
    : _stats = stats,
      _platform = platform;

  final Future<ReviewStats> Function() _stats;
  final ReviewPlatform _platform;

  /// Leaves headroom under the platform's few-per-year cap.
  static const minBetweenPrompts = Duration(days: 60);

  /// Enough play to have an opinion (~30+ minutes).
  static const minSheetsCleared = 10;

  /// Not on day one, however fast someone plays.
  static const minSinceFirstClear = Duration(days: 2);

  /// Let the stamp, confetti and fanfare finish before the sheet appears.
  static const promptDelay = Duration(milliseconds: 1800);

  static const _lastPromptKey = 'review_last_prompted_ms';

  Timer? _pending;

  /// Asks the platform to consider the review sheet when the gate allows.
  /// Fire-and-forget safe. True = dispatched (not a promise it showed).
  Future<bool> maybeRequestReview(ReviewTrigger trigger, {DateTime? now}) async {
    try {
      final at = now ?? DateTime.now();
      final s = await _stats();
      if (s.sheetsCleared < minSheetsCleared) return false;
      final first = s.firstClearAt;
      if (first == null || at.difference(first) < minSinceFirstClear) return false;

      final prefs = await SharedPreferences.getInstance();
      final last = prefs.getInt(_lastPromptKey);
      if (last != null && at.difference(DateTime.fromMillisecondsSinceEpoch(last)) < minBetweenPrompts) {
        return false;
      }
      if (!await _platform.isAvailable()) return false;

      // Stamp before the delayed call: better to skip one moment than to
      // ask twice in a row.
      await prefs.setInt(_lastPromptKey, at.millisecondsSinceEpoch);
      _pending?.cancel();
      _pending = Timer(promptDelay, () async {
        try {
          AppLog.info('Requesting in-app review (${trigger.name})');
          await _platform.requestReview();
        } on Object catch (e) {
          AppLog.warn('In-app review failed: $e');
        }
      });
      return true;
    } on Object catch (e) {
      AppLog.warn('Review gate failed: $e');
      return false;
    }
  }

  /// A deliberate "Rate Screw Out" tap: always the store page (Google's
  /// advice for an explicit button), never the quota-limited sheet.
  Future<void> openStoreListing() async {
    try {
      await _platform.openStoreListing();
    } on Object catch (e) {
      AppLog.warn('Opening the store listing failed: $e');
    }
  }

  void dispose() => _pending?.cancel();
}
