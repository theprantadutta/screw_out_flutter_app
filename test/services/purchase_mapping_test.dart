import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:screw_out/core/network/api_result.dart';
import 'package:screw_out/services/ports.dart';
import 'package:screw_out/services/purchases/purchase_mapping.dart';

/// The money-moving decisions of the flutter_inapp_purchase migration
/// playbook, tested without a store.
void main() {
  PurchaseAndroid android({String? token = 'tok_1', String? orderId = 'GPA.1', String productId = 'com.pranta.screwout.coins_small'}) =>
      PurchaseAndroid(
        id: orderId ?? token ?? '',
        isAutoRenewing: false,
        productId: productId,
        purchaseState: PurchaseState.Purchased,
        purchaseToken: token,
        quantity: 1,
        store: IapStore.Google,
        transactionDate: 0,
        transactionId: orderId,
        isAcknowledgedAndroid: false,
      );

  PurchaseIOS ios({String? jws = 'eyJ.jws.sig', String transactionId = '2000000123'}) => PurchaseIOS(
    id: transactionId,
    isAutoRenewing: false,
    productId: 'com.pranta.screwout.remove_ads',
    purchaseState: PurchaseState.Purchased,
    purchaseToken: jws,
    quantity: 1,
    store: IapStore.Apple,
    transactionDate: 0,
    transactionId: transactionId,
  );

  PricingPhaseAndroid phase({required String micros, String period = 'P1M', int recurrence = 1, int cycles = 0, String formatted = r'$4.99'}) =>
      PricingPhaseAndroid(
        billingCycleCount: cycles,
        billingPeriod: period,
        formattedPrice: formatted,
        priceAmountMicros: micros,
        priceCurrencyCode: 'USD',
        recurrenceMode: recurrence,
      );

  SubscriptionOffer offer({required String id, String basePlan = 'monthly', String? token = 'offer_tok', required List<PricingPhaseAndroid> phases}) =>
      SubscriptionOffer(
        id: id,
        basePlanIdAndroid: basePlan,
        offerTokenAndroid: token,
        displayPrice: phases.first.formattedPrice,
        price: 0,
        type: DiscountOfferType.Introductory,
        pricingPhasesAndroid: PricingPhasesAndroid(pricingPhaseList: phases),
      );

  ApiResult<Map<String, dynamic>> fail(ApiFailure f, {int? status, String? code}) =>
      ApiResult.failed(f, statusCode: status, errorCode: code);

  group('verdict classification (playbook §5 table)', () {
    test('no reply / 401 / 5xx are transient', () {
      expect(classifyVerify(fail(ApiFailure.offlineOrTransport)), VerifyOutcome.transient);
      expect(classifyVerify(fail(ApiFailure.timeout)), VerifyOutcome.transient);
      expect(classifyVerify(fail(ApiFailure.unauthorized, status: 401)), VerifyOutcome.transient);
      expect(classifyVerify(fail(ApiFailure.serverUnavailable, status: 503)), VerifyOutcome.transient);
      expect(classifyVerify(fail(ApiFailure.badResponse, status: 500)), VerifyOutcome.transient);
    });

    test('prefixed backend codes', () {
      expect(classifyVerify(fail(ApiFailure.validation, status: 400, code: 'PURCHASE_PENDING')), VerifyOutcome.transient);
      expect(classifyVerify(fail(ApiFailure.serverUnavailable, status: 503, code: 'PURCHASE_VERIFICATION_UNAVAILABLE')), VerifyOutcome.transient);
      expect(classifyVerify(fail(ApiFailure.validation, status: 400, code: 'ANONYMOUS_ACCOUNT_PURCHASE_BLOCKED')), VerifyOutcome.needsSignIn);
    });

    test('explicit is_valid false is rejected', () {
      expect(classifyVerify(ApiResult.success({'is_valid': false})), VerifyOutcome.rejected);
      expect(classifyVerify(ApiResult.success({'is_valid': true})), VerifyOutcome.granted);
    });
  });

  group('verdict actions', () {
    test('granted: deliver, mark, finish; never queued', () {
      final a = actionFor(VerifyOutcome.granted, isIOS: false);
      expect([a.deliver, a.markDelivered, a.finish, a.queueRetry], [true, true, true, false]);
    });

    test('transient and needs-sign-in: deliver locally, queue, finish, not marked', () {
      for (final o in [VerifyOutcome.transient, VerifyOutcome.needsSignIn]) {
        for (final isIOS in [true, false]) {
          final a = actionFor(o, isIOS: isIOS);
          expect([a.deliver, a.queueRetry, a.finish, a.markDelivered], [true, true, true, false], reason: '$o ios=$isIOS');
        }
      }
    });

    test('rejected: nothing delivered; Android unfinished, iOS finished', () {
      final droid = actionFor(VerifyOutcome.rejected, isIOS: false);
      final apple = actionFor(VerifyOutcome.rejected, isIOS: true);
      expect([droid.deliver, droid.finish, droid.queueRetry], [false, false, false]);
      expect([apple.deliver, apple.finish, apple.queueRetry], [false, true, false]);
    });
  });

  group('subscription offers', () {
    final base = offer(id: 'monthly', phases: [phase(micros: '2990000', formatted: r'$2.99')]);
    final trial = offer(
      id: 'trial7',
      token: 'trial_tok',
      phases: [
        phase(micros: '0', period: 'P1W', recurrence: 2, cycles: 1, formatted: 'Free'),
        phase(micros: '2990000', formatted: r'$2.99'),
      ],
    );
    final promo = offer(id: 'promo', phases: [phase(micros: '990000', recurrence: 2, cycles: 1, formatted: r'$0.99')]);

    test('trial first, then base plan, then first', () {
      expect(pickSubscriptionOffer([base, promo, trial])?.id, 'trial7');
      expect(pickSubscriptionOffer([promo, base])?.id, 'monthly');
      expect(pickSubscriptionOffer([promo])?.id, 'promo');
      expect(pickSubscriptionOffer([]), isNull);
    });

    test('a free base plan (infinite recurrence) is not a trial', () {
      final freeForever = offer(id: 'free', phases: [phase(micros: '0', recurrence: 1)]);
      expect(trialDaysFromOffer(freeForever), isNull);
      expect(trialDaysFromOffer(trial), 7);
    });

    test('display price skips the free trial phase', () {
      expect(recurringPriceFromOffers([trial]), r'$2.99');
      expect(recurringPriceFromOffers([promo, base]), r'$2.99');
      expect(recurringPriceFromOffers(null), isNull);
    });

    test('iso period parsing', () {
      expect(iso8601PeriodInDays('P3D'), 3);
      expect(iso8601PeriodInDays('P1W'), 7);
      expect(iso8601PeriodInDays('P1M'), 30);
      expect(iso8601PeriodInDays('bogus'), isNull);
    });
  });

  group('payload and identity', () {
    test('Android: order id when present, token otherwise (pending orders have none)', () {
      final paid = backendPayloadFor(android())!;
      expect(paid.transactionId, 'GPA.1');
      expect(paid.purchaseToken, 'tok_1');
      expect(paid.receiptData, 'tok_1');
      final pending = backendPayloadFor(android(orderId: null))!;
      expect(pending.transactionId, 'tok_1');
      expect(purchaseIdentity(android(orderId: null)), 'tok_1');
    });

    test('iOS: receipt_data is the StoreKit 2 JWS, identity the transaction id', () {
      final p = backendPayloadFor(ios())!;
      expect(p.platform, 'ios');
      expect(p.receiptData, 'eyJ.jws.sig');
      expect(p.transactionId, '2000000123');
      expect(purchaseIdentity(ios()), '2000000123');
      expect(backendPayloadFor(ios(jws: null)), isNull);
    });

    test('wire body keeps the retry-queue field names', () {
      final json = backendPayloadFor(android())!.toJson();
      expect(json.keys, containsAll(['product_id', 'transaction_id', 'platform', 'receipt_data', 'purchase_token']));
      final body = backendPayloadFor(android())!.toVerifyBody();
      expect(body['platform'], 'android');
      expect((body['purchase_data'] as Map)['product_id'], 'com.pranta.screwout.coins_small');
    });
  });

  group('purchase request', () {
    final product = ProductAndroid(
      currency: 'USD',
      description: 'd',
      displayPrice: r'$2.99',
      id: 'com.pranta.screwout.remove_ads',
      nameAndroid: 'Remove ads',
      title: 't',
    );

    test('iOS appAccountToken only for a UUID; Android account id always', () {
      final uuid = buildPurchaseRequest(product: product, accountId: '3f2b1c4e-9a7d-4e21-b1a3-0c9d8e7f6a5b');
      final notUuid = buildPurchaseRequest(product: product, accountId: 'user-42');
      String? apple(RequestPurchaseProps r) => (r.toJson()['request'] as Map?)?['apple']?['appAccountToken'] as String?;
      String? google(RequestPurchaseProps r) => (r.toJson()['request'] as Map?)?['google']?['obfuscatedAccountId'] as String?;
      final uuidJson = uuid.toJson().toString();
      expect(uuidJson, contains('3f2b1c4e-9a7d-4e21-b1a3-0c9d8e7f6a5b'));
      final notUuidJson = notUuid.toJson().toString();
      expect(notUuidJson, contains('user-42'));
      expect(apple(notUuid), isNull);
      expect(google(notUuid) ?? notUuidJson, contains('user-42'));
    });
  });

  group('provisional entitlements', () {
    final now = DateTime.utc(2026, 10, 16);

    test('remove ads and Pro hold for three days, then lapse', () {
      final p = const ProvisionalEntitlements({}).add(Products.removeAds, now).add(Products.proYearly, now);
      expect(p.adsRemoved(now), isTrue);
      expect(p.pro(now), isTrue);
      final later = now.add(ProvisionalEntitlements.ttl + const Duration(minutes: 1));
      expect(p.adsRemoved(later), isFalse);
      expect(p.pro(later), isFalse);
    });

    test('round-trips through json and removes cleanly', () {
      final p = const ProvisionalEntitlements({}).add(Products.proMonthly, now);
      final back = ProvisionalEntitlements.fromJson(p.toJson());
      expect(back.pro(now), isTrue);
      expect(back.remove(Products.proMonthly).pro(now), isFalse);
    });
  });
}
