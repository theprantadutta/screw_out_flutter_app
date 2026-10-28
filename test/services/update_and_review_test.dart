import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:screw_out/services/review_service.dart';
import 'package:screw_out/services/update/update_policy.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeReview implements ReviewPlatform {
  bool available = true;
  int requests = 0;
  int listings = 0;
  @override
  Future<bool> isAvailable() async => available;
  @override
  Future<void> requestReview() async => requests++;
  @override
  Future<void> openStoreListing() async => listings++;
}

void main() {
  group('update policy', () {
    UpdateFlow decide({
      bool available = true,
      int priority = 0,
      bool immediate = true,
      bool flexible = true,
      Duration? declined,
      bool belowMin = false,
    }) => UpdatePolicy.decide(
      updateAvailable: available,
      priority: priority,
      immediateAllowed: immediate,
      flexibleAllowed: flexible,
      sinceDeclined: declined,
      belowMinimumSupported: belowMin,
    );

    test('routine releases download in the background', () {
      expect(decide(), UpdateFlow.flexible);
      expect(decide(available: false), UpdateFlow.none);
    });

    test('a declined offer is snoozed for a day', () {
      expect(decide(declined: const Duration(hours: 3)), UpdateFlow.none);
      expect(decide(declined: const Duration(hours: 25)), UpdateFlow.flexible);
    });

    test('urgent priority or a build below the minimum blocks, even when snoozed', () {
      expect(decide(priority: 4, declined: const Duration(minutes: 5)), UpdateFlow.immediate);
      expect(decide(belowMin: true, declined: const Duration(minutes: 5)), UpdateFlow.immediate);
      expect(decide(belowMin: true, immediate: false), UpdateFlow.flexible);
    });

    test('version comparison', () {
      expect(UpdatePolicy.isBelow('1.0.1', '1.0.2'), isTrue);
      expect(UpdatePolicy.isBelow('1.0.1', '1.0.1'), isFalse);
      expect(UpdatePolicy.isBelow('1.2', '1.1.9'), isFalse);
      expect(UpdatePolicy.isBelow('1.0.1+2', '1.0.1'), isFalse);
      expect(UpdatePolicy.isBelow('1.0.1', ''), isFalse);
      expect(UpdatePolicy.isBelow('1.0.1', 'garbage'), isFalse, reason: 'never block on a bad policy');
    });
  });

  group('review gate', () {
    final now = DateTime(2026, 10, 28, 12);
    setUp(() => SharedPreferences.setMockInitialValues({}));

    ReviewService service(_FakeReview platform, {int sheets = 25, Duration playedFor = const Duration(days: 9)}) =>
        ReviewService(
          stats: () async => (sheetsCleared: sheets, firstClearAt: now.subtract(playedFor)),
          platform: platform,
        );

    test('new players are never asked', () async {
      final p = _FakeReview();
      expect(await service(p, sheets: 4).maybeRequestReview(ReviewTrigger.newBest, now: now), isFalse);
      expect(await service(p, playedFor: const Duration(hours: 20)).maybeRequestReview(ReviewTrigger.newBest, now: now), isFalse);
    });

    test('asks after the celebration, then not again for 60 days', () {
      fakeAsync((async) {
        final p = _FakeReview();
        final s = service(p);
        bool? first, again, later;
        s.maybeRequestReview(ReviewTrigger.chapterComplete, now: now).then((v) => first = v);
        async.flushMicrotasks();
        expect(first, isTrue);
        expect(p.requests, 0, reason: 'waits for the fanfare');
        async.elapse(ReviewService.promptDelay);
        expect(p.requests, 1);

        s.maybeRequestReview(ReviewTrigger.newBest, now: now.add(const Duration(days: 10))).then((v) => again = v);
        s.maybeRequestReview(ReviewTrigger.newBest, now: now.add(const Duration(days: 61))).then((v) => later = v);
        async.flushMicrotasks();
        async.elapse(ReviewService.promptDelay);
        expect(again, isFalse);
        expect(later, isTrue);
        expect(p.requests, 2);
      });
    });

    test('Rate Screw Out always opens the store page', () async {
      final p = _FakeReview()..available = false;
      await service(p, sheets: 0).openStoreListing();
      expect(p.listings, 1);
    });
  });
}
