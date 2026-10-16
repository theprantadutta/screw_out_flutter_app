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

/// What the backend said about a receipt.
enum VerifyOutcome {
  /// Verified: deliver and finish the store transaction.
  granted,

  /// Could not decide now (store API down, deferred payment, 5xx, offline):
  /// keep the receipt, do not finish.
  transient,

  /// Guest account: resolves once they sign in. Keep the receipt.
  needsSignIn,

  /// The store said no / unknown product: finish, grant nothing.
  rejected,
}

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

/// Base plan first (no trials configured for Screw Out).
SubscriptionOffer? pickSubscriptionOffer(List<SubscriptionOffer> offers) {
  if (offers.isEmpty) return null;
  for (final offer in offers) {
    final basePlan = offer.basePlanIdAndroid;
    if (basePlan != null && offer.id == basePlan) return offer;
  }
  return offers.first;
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
