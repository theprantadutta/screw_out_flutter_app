import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:screw_out/core/network/api_result.dart';
import 'package:screw_out/services/ads/ad_gate.dart';
import 'package:screw_out/services/purchases/purchase_mapping.dart';

void main() {
  group('ApiFailureClassifier', () {
    test('maps statuses', () {
      expect(ApiFailureClassifier.forStatus(200), isNull);
      expect(ApiFailureClassifier.forStatus(401), ApiFailure.unauthorized);
      expect(ApiFailureClassifier.forStatus(403), ApiFailure.forbidden);
      expect(ApiFailureClassifier.forStatus(404), ApiFailure.validation);
      expect(ApiFailureClassifier.forStatus(422), ApiFailure.validation);
      expect(ApiFailureClassifier.forStatus(429), ApiFailure.rateLimited);
      expect(ApiFailureClassifier.forStatus(503), ApiFailure.serverUnavailable);
    });

    test('maps exceptions', () {
      expect(ApiFailureClassifier.forError(TimeoutException('x')), ApiFailure.timeout);
      expect(ApiFailureClassifier.forError(const SocketException('x')), ApiFailure.offlineOrTransport);
      expect(ApiFailureClassifier.forError(http.ClientException('x')), ApiFailure.offlineOrTransport);
      expect(ApiFailureClassifier.forError(const FormatException('x')), ApiFailure.badResponse);
    });

    test('decodes the contract error code', () {
      final r = ApiFailureClassifier.decodeObject(
        http.Response('{"error":"PURCHASE_PENDING: later","code":"PURCHASE_PENDING"}', 400),
      );
      expect(r.failure, ApiFailure.validation);
      expect(r.errorCode, 'PURCHASE_PENDING');
      // 429 / proxy pages carry no body.
      expect(ApiFailureClassifier.decodeObject(http.Response('', 429)).errorCode, isNull);
    });

    test('Retry-After seconds', () {
      expect(ApiFailureClassifier.retryAfterFrom({'retry-after': '30'}), const Duration(seconds: 30));
    });

    test('sync outcome routing', () {
      SyncOutcomeKind kind(int status) =>
          SyncOutcome.fromResult(ApiFailureClassifier.decodeObject(http.Response('{}', status))).kind;
      expect(kind(200), SyncOutcomeKind.success);
      expect(kind(401), SyncOutcomeKind.transient);
      expect(kind(429), SyncOutcomeKind.transient);
      expect(kind(503), SyncOutcomeKind.transient);
      expect(kind(422), SyncOutcomeKind.permanent);
      expect(kind(400), SyncOutcomeKind.permanent);
    });
  });

  group('purchase mapping', () {
    ApiResult<Map<String, dynamic>> fail(int status, String code) =>
        ApiFailureClassifier.decodeObject(http.Response('{"error":"x","code":"$code"}', status));

    test('classifies verify responses by code', () {
      expect(classifyVerify(ApiResult.success({'is_valid': true})), VerifyOutcome.granted);
      expect(classifyVerify(ApiResult.success({'is_valid': false})), VerifyOutcome.rejected);
      expect(classifyVerify(fail(400, 'PURCHASE_PENDING')), VerifyOutcome.transient);
      expect(classifyVerify(fail(503, 'PURCHASE_VERIFICATION_UNAVAILABLE')), VerifyOutcome.transient);
      expect(classifyVerify(fail(400, 'ANONYMOUS_ACCOUNT_PURCHASE_BLOCKED')), VerifyOutcome.needsSignIn);
      expect(classifyVerify(fail(400, 'PURCHASE_REJECTED')), VerifyOutcome.rejected);
      expect(classifyVerify(fail(400, 'UNKNOWN_PRODUCT')), VerifyOutcome.rejected);
      expect(classifyVerify(ApiResult.failed(ApiFailure.offlineOrTransport)), VerifyOutcome.transient);
      expect(classifyVerify(fail(500, 'INTERNAL_ERROR')), VerifyOutcome.transient);
    });

    test('product ids', () {
      expect(ProductIds.withPrefix('pro_monthly'), 'com.pranta.screwout.pro_monthly');
      expect(ProductIds.stripPrefix('com.pranta.screwout.coins_small'), 'coins_small');
      expect(ProductIds.isSubscription('com.pranta.screwout.pro_yearly'), isTrue);
      expect(ProductIds.isConsumable('coins_large'), isTrue);
      expect(ProductIds.isConsumable('remove_ads'), isFalse);
      expect(ProductIds.oneTimeProductIds, hasLength(8));
    });

    test('entitlements: Pro themes are not persisted, purchased ones are', () {
      final e = EntitlementsSnapshot.fromJson({
        'is_pro': true,
        'ads_removed': true,
        'pro_expires_at': '2026-11-16T09:00:00Z',
        'pro_product_id': 'pro_yearly',
        'owned_themes': ['blueprint', 'midnight', 'ocean', 'workshop'],
        'owned_products': ['theme_pack_workshop'],
        'pending_coin_grants': [
          {'idempotency_key': 'pro_coins:1', 'amount': 1000},
        ],
      })!;
      expect(e.isPro, isTrue);
      expect(e.adsRemoved, isTrue);
      expect(e.proPlan, 'yearly');
      expect(e.proExpiresAt, DateTime.utc(2026, 11, 16, 9));
      expect(e.purchasedThemes, ['walnut']); // server "workshop" = client "walnut"
      expect(e.pendingGrants, hasLength(1));
    });
  });

  group('ad gate', () {
    bool inter({
      bool noAds = false,
      bool loaded = true,
      bool daily = false,
      int level = 20,
      int clears = 20,
      int since = 5,
      int msLast = 1 << 30,
      int msAny = 1 << 30,
    }) => AdGate.interstitial(
      noAds: noAds,
      adsEnabled: true,
      loaded: loaded,
      isDaily: daily,
      levelId: level,
      clearsThisInstall: clears,
      completionsSinceLastAd: since,
      msSinceLastInterstitial: msLast,
      msSinceAnyFullScreenAd: msAny,
    );

    test('interstitial caps', () {
      expect(inter(), isTrue);
      expect(inter(noAds: true), isFalse);
      expect(inter(loaded: false), isFalse);
      expect(inter(daily: true), isFalse);
      // Never on the first 15 sheets / before 15 clears.
      expect(inter(level: 15), isFalse);
      expect(inter(level: 16), isTrue);
      expect(inter(clears: 14), isFalse);
      // At most every 6th completion.
      expect(inter(since: 4), isFalse);
      expect(inter(since: 5), isTrue);
      // At least 6 minutes between interstitials…
      expect(inter(msLast: 5 * 60 * 1000), isFalse);
      expect(inter(msLast: 6 * 60 * 1000), isTrue);
      // …and 3 minutes after any full-screen ad (incl. app-open).
      expect(inter(msAny: 2 * 60 * 1000), isFalse);
      expect(inter(msAny: 3 * 60 * 1000), isTrue);
    });

    test('app open', () {
      bool open({bool cold = false, bool suppressed = false, int away = 31 * 60 * 1000}) => AdGate.appOpen(
        noAds: false,
        adsEnabled: true,
        loaded: true,
        coldStart: cold,
        suppressed: suppressed,
        msAway: away,
        msSinceLastAppOpen: 1 << 30,
        msSinceAnyFullScreenAd: 1 << 30,
      );
      expect(open(), isTrue);
      expect(open(cold: true), isFalse);
      expect(open(suppressed: true), isFalse);
      expect(open(away: 10 * 60 * 1000), isFalse);
    });
  });
}
