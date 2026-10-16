import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';

import '../../core/network/api_result.dart';
import '../cosmetics.dart';
import '../ports.dart';
import '../sync/wire_ids.dart';

/// Pure purchase logic (ported from snake-classic's purchase_mapping):
/// testable without a store or a socket.

/// Store product ids, prefixed and bare.
abstract final class ProductIds {
  static String withPrefix(String id) => id.startsWith(Products.prefix) ? id : '${Products.prefix}$id';
  static String stripPrefix(String id) => id.startsWith(Products.prefix) ? id.substring(Products.prefix.length) : id;

  static const _subscriptions = {Products.proMonthly, Products.proYearly};
  static const _consumables = {Products.coinsSmall, Products.coinsMedium, Products.coinsLarge};
  static const _oneTime = {
    Products.removeAds,
    Products.coinsSmall,
    Products.coinsMedium,
    Products.coinsLarge,
    Products.themePackWorkshop,
    Products.themePackOcean,
    Products.themePackMidnight,
    Products.themesBundle,
  };

  static List<String> get oneTimeProductIds => [for (final id in _oneTime) withPrefix(id)];
  static List<String> get subscriptionIds => [for (final id in _subscriptions) withPrefix(id)];

  static bool isSubscription(String id) => _subscriptions.contains(stripPrefix(id));
  static bool isConsumable(String id) => _consumables.contains(stripPrefix(id));
}

/// What the backend said about a receipt (migration playbook §5).
enum VerifyOutcome {
  /// `is_valid: true` — deliver, mark delivered, finish.
  granted,

  /// Could not decide now (no reply / 401 / 5xx, `PURCHASE_PENDING`,
  /// `PURCHASE_VERIFICATION_UNAVAILABLE`) — deliver locally, queue the receipt
  /// for retry, finish (so Play does not refund a real purchase).
  transient,

  /// `ANONYMOUS_ACCOUNT_PURCHASE_BLOCKED` — handled like [transient]; the
  /// queued receipt verifies once the player signs in.
  needsSignIn,

  /// Explicit `is_valid: false` (or the store said no / unknown product) —
  /// deliver nothing. Android: do NOT finish (Play refunds it within three
  /// days). iOS: finish, or StoreKit replays it on every launch.
  rejected,
}

/// What the client does with a purchase for a given verdict.
final class VerdictAction {
  const VerdictAction({required this.deliver, required this.queueRetry, required this.finish, required this.markDelivered});
  final bool deliver;
  final bool queueRetry;
  final bool finish;
  final bool markDelivered;
}

VerdictAction actionFor(VerifyOutcome outcome, {required bool isIOS}) => switch (outcome) {
  VerifyOutcome.granted => const VerdictAction(deliver: true, queueRetry: false, finish: true, markDelivered: true),
  VerifyOutcome.transient ||
  VerifyOutcome.needsSignIn => const VerdictAction(deliver: true, queueRetry: true, finish: true, markDelivered: false),
  VerifyOutcome.rejected => VerdictAction(deliver: false, queueRetry: false, finish: isIOS, markDelivered: false),
};

/// Classifies a `/purchases/verify` result by the contract `code`.
VerifyOutcome classifyVerify(ApiResult<Map<String, dynamic>> r) {
  if (r.isSuccess) {
    return r.value?['is_valid'] == true ? VerifyOutcome.granted : VerifyOutcome.rejected;
  }
  switch (r.errorCode) {
    case 'ANONYMOUS_ACCOUNT_PURCHASE_BLOCKED':
      return VerifyOutcome.needsSignIn;
    case 'PURCHASE_PENDING':
    case 'PURCHASE_VERIFICATION_UNAVAILABLE':
      return VerifyOutcome.transient;
    case 'PURCHASE_REJECTED':
    case 'UNKNOWN_PRODUCT':
      return VerifyOutcome.rejected;
  }
  return switch (r.failure!) {
    ApiFailure.validation => VerifyOutcome.rejected,
    _ => VerifyOutcome.transient,
  };
}

/// Receipt fields for `/purchases/verify` (API_CONTRACT §4).
class BackendPurchasePayload {
  const BackendPurchasePayload({
    required this.platform,
    required this.productId,
    required this.transactionId,
    required this.receiptData,
    this.purchaseToken,
  });

  final String platform;
  final String productId;
  final String transactionId;
  final String receiptData;
  final String? purchaseToken;

  Map<String, dynamic> toVerifyBody() => {
    'platform': platform,
    'purchase_data': {
      'product_id': productId,
      'transaction_id': transactionId,
      'receipt_data': receiptData,
      'purchase_token': ?purchaseToken,
    },
  };

  Map<String, dynamic> toJson() => {
    'platform': platform,
    'product_id': productId,
    'transaction_id': transactionId,
    'receipt_data': receiptData,
    'purchase_token': purchaseToken,
  };

  static BackendPurchasePayload? fromJson(Map<String, dynamic> j) {
    final productId = j['product_id']?.toString();
    final platform = j['platform']?.toString();
    if (productId == null || productId.isEmpty || platform == null || platform.isEmpty) return null;
    return BackendPurchasePayload(
      platform: platform,
      productId: productId,
      transactionId: j['transaction_id']?.toString() ?? '',
      receiptData: j['receipt_data']?.toString() ?? '',
      purchaseToken: j['purchase_token']?.toString(),
    );
  }
}

BackendPurchasePayload? backendPayloadFor(Purchase purchase) {
  if (purchase is PurchaseIOS) {
    // OpenIAP puts the StoreKit 2 JWS on the unified purchaseToken field.
    final jws = purchase.purchaseToken;
    if (jws == null || jws.isEmpty) return null;
    return BackendPurchasePayload(
      platform: 'ios',
      productId: purchase.productId,
      transactionId: purchase.transactionId,
      receiptData: jws,
    );
  }
  if (purchase is PurchaseAndroid) {
    final token = purchase.purchaseToken;
    if (token == null || token.isEmpty) return null;
    final orderId = purchase.transactionId;
    return BackendPurchasePayload(
      platform: 'android',
      productId: purchase.productId,
      transactionId: (orderId != null && orderId.isNotEmpty) ? orderId : token,
      receiptData: token,
      purchaseToken: token,
    );
  }
  return null;
}

/// Stable identity for de-duplicating deliveries.
String? purchaseIdentity(Purchase purchase) {
  final id = purchase is PurchaseIOS ? purchase.transactionId : purchase.id;
  return id.isEmpty ? null : id;
}

final _uuid = RegExp(r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$');

/// Android: `obfuscatedAccountId` = API user id on every purchase.
RequestPurchaseProps buildPurchaseRequest({required ProductCommon product, required String? accountId}) {
  final sku = product.id;
  final appAccountToken = accountId != null && _uuid.hasMatch(accountId) ? accountId : null;
  if (!ProductIds.isSubscription(sku)) {
    return RequestPurchaseProps.inApp((
      apple: RequestPurchaseIosProps(sku: sku, appAccountToken: appAccountToken),
      google: RequestPurchaseAndroidProps(skus: [sku], obfuscatedAccountId: accountId),
    ));
  }
  final offers = product is ProductSubscriptionAndroid ? product.subscriptionOffers : const <SubscriptionOffer>[];
  final offer = pickSubscriptionOffer(offers);
  final offerToken = offer?.offerTokenAndroid;
  return RequestPurchaseProps.subs((
    apple: RequestSubscriptionIosProps(sku: sku, appAccountToken: appAccountToken),
    google: RequestSubscriptionAndroidProps(
      skus: [sku],
      obfuscatedAccountId: accountId,
      subscriptionOffers: offerToken == null ? null : [AndroidSubscriptionOfferInput(sku: sku, offerToken: offerToken)],
    ),
  ));
}

/// Android subscriptions need an offer token: the free-trial offer when the
/// store offers one (Play only returns offers the user is eligible for),
/// else the base plan, else the first.
SubscriptionOffer? pickSubscriptionOffer(List<SubscriptionOffer> offers) {
  if (offers.isEmpty) return null;
  for (final offer in offers) {
    if (trialDaysFromOffer(offer) != null) return offer;
  }
  for (final offer in offers) {
    final basePlan = offer.basePlanIdAndroid;
    if (basePlan != null && offer.id == basePlan) return offer;
  }
  return offers.first;
}

/// Price to show for a product. A subscription's `displayPrice` reads "Free"
/// when a trial phase comes first, so subscriptions use the base plan's last
/// non-zero pricing phase.
String displayPriceFor(ProductCommon product) {
  final offers = switch (product) {
    ProductSubscriptionAndroid p => p.subscriptionOffers,
    _ => null,
  };
  return recurringPriceFromOffers(offers) ?? product.displayPrice;
}

/// Play's recurrenceMode for the perpetual base price.
const _infiniteRecurring = 1;

/// Formatted price of the recurring (non-zero) phase, base plan first.
String? recurringPriceFromOffers(List<SubscriptionOffer>? offers) {
  if (offers == null) return null;
  for (final offer in _basePlanFirst(offers)) {
    final phases = offer.pricingPhasesAndroid?.pricingPhaseList;
    if (phases == null) continue;
    PricingPhaseAndroid? recurring;
    for (final phase in phases) {
      if (_micros(phase) > 0) recurring = phase;
    }
    if (recurring != null && recurring.formattedPrice.isNotEmpty) return recurring.formattedPrice;
  }
  return null;
}

/// Days of free trial one offer carries, or null when it is not a trial.
/// Android: a zero-priced phase that does not recur forever. iOS: a
/// free-trial payment mode with a period.
int? trialDaysFromOffer(SubscriptionOffer offer) {
  final phases = offer.pricingPhasesAndroid?.pricingPhaseList;
  if (phases != null) {
    for (final phase in phases) {
      if (_micros(phase) != 0) continue;
      if (phase.recurrenceMode == _infiniteRecurring) continue;
      final days = iso8601PeriodInDays(phase.billingPeriod);
      if (days == null) continue;
      final cycles = phase.billingCycleCount > 0 ? phase.billingCycleCount : 1;
      return days * cycles;
    }
    return null;
  }
  if (offer.paymentMode != PaymentMode.FreeTrial) return null;
  final period = offer.period;
  if (period == null || period.value <= 0) return null;
  final unitDays = switch (period.unit) {
    SubscriptionPeriodUnit.Day => 1,
    SubscriptionPeriodUnit.Week => 7,
    SubscriptionPeriodUnit.Month => 30,
    SubscriptionPeriodUnit.Year => 365,
    SubscriptionPeriodUnit.Unknown => 0,
  };
  if (unitDays == 0) return null;
  final count = (offer.periodCount ?? 1) > 0 ? (offer.periodCount ?? 1) : 1;
  final days = period.value * unitDays * count;
  return days > 0 ? days : null;
}

/// Days in an ISO-8601 period such as "P3D", "P1W", "P1M".
int? iso8601PeriodInDays(String period) {
  final match = RegExp(r'^P(?:(\d+)Y)?(?:(\d+)M)?(?:(\d+)W)?(?:(\d+)D)?$').firstMatch(period);
  if (match == null) return null;
  int part(int group) => int.tryParse(match.group(group) ?? '') ?? 0;
  final days = part(1) * 365 + part(2) * 30 + part(3) * 7 + part(4);
  return days > 0 ? days : null;
}

int _micros(PricingPhaseAndroid phase) => int.tryParse(phase.priceAmountMicros) ?? -1;

Iterable<SubscriptionOffer> _basePlanFirst(List<SubscriptionOffer> offers) {
  bool isBasePlan(SubscriptionOffer o) => o.basePlanIdAndroid != null && o.id == o.basePlanIdAndroid;
  return [...offers.where(isBasePlan), ...offers.where((o) => !isBasePlan(o))];
}

/// Locally-delivered entitlements while a receipt waits for verification
/// (transient verdicts). Server entitlements win once the receipt verifies
/// or is rejected; an entry also expires on its own after [ttl].
final class ProvisionalEntitlements {
  const ProvisionalEntitlements(this.expiry);

  static const ttl = Duration(days: 3);

  /// Bare product id → expiry.
  final Map<String, DateTime> expiry;

  static ProvisionalEntitlements fromJson(Object? json) {
    final out = <String, DateTime>{};
    if (json is Map) {
      json.forEach((k, v) {
        final t = DateTime.tryParse('$v');
        if (t != null) out['$k'] = t.toUtc();
      });
    }
    return ProvisionalEntitlements(out);
  }

  Map<String, String> toJson() => {for (final e in expiry.entries) e.key: e.value.toIso8601String()};

  bool active(String bareId, DateTime now) {
    final t = expiry[bareId];
    return t != null && t.isAfter(now);
  }

  bool pro(DateTime now) => active(Products.proMonthly, now) || active(Products.proYearly, now);
  bool adsRemoved(DateTime now) => active(Products.removeAds, now);

  ProvisionalEntitlements add(String bareId, DateTime now) => ProvisionalEntitlements({...expiry, bareId: now.add(ttl)});
  ProvisionalEntitlements remove(String bareId) => ProvisionalEntitlements({...expiry}..remove(bareId));
}

/// `EntitlementsDto` (API_CONTRACT §4) as client values.
class EntitlementsSnapshot {
  const EntitlementsSnapshot({
    required this.isPro,
    required this.adsRemoved,
    this.proExpiresAt,
    this.proPlan,
    this.purchasedThemes = const [],
    this.pendingGrants = const [],
  });

  final bool isPro;
  final bool adsRemoved;
  final DateTime? proExpiresAt;

  /// monthly | yearly
  final String? proPlan;

  /// Client theme ids owned through *purchases* (not Pro), to persist.
  final List<String> purchasedThemes;
  final List<dynamic> pendingGrants;

  static EntitlementsSnapshot? fromJson(Object? json) {
    if (json is! Map) return null;
    final product = json['pro_product_id']?.toString();
    final themes = <String>{};
    final owned = json['owned_products'];
    if (owned is List) {
      for (final p in owned) {
        themes.addAll(Cosmetics.themesForProduct(ProductIds.stripPrefix('$p')));
      }
    }
    return EntitlementsSnapshot(
      isPro: json['is_pro'] == true,
      adsRemoved: json['ads_removed'] == true || json['owns_remove_ads'] == true,
      proExpiresAt: DateTime.tryParse('${json['pro_expires_at']}')?.toUtc(),
      proPlan: product == null
          ? null
          : (ProductIds.stripPrefix(product) == Products.proYearly ? 'yearly' : 'monthly'),
      purchasedThemes: [for (final t in themes) WireIds.themeFromServer(t)],
      pendingGrants: json['pending_coin_grants'] as List? ?? const [],
    );
  }
}

/// Analytics product type.
String productTypeFor(String productId) {
  final id = ProductIds.stripPrefix(productId);
  if (ProductIds.isSubscription(id)) return 'subscription';
  if (ProductIds.isConsumable(id)) return 'coins';
  if (id == Products.removeAds) return 'remove_ads';
  return 'theme';
}
