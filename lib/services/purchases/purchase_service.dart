// ignore_for_file: prefer_initializing_formals
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/network/api_service.dart';
import '../../data/database/app_database.dart';
import '../../presentation/bloc/premium/premium_cubit.dart';
import '../app_log.dart';
import '../cosmetics.dart';
import '../ports.dart';
import '../progress_service.dart';
import '../sync/sync_payloads.dart';
import '../user_service.dart';
import 'purchase_mapping.dart';

/// Store purchases on flutter_inapp_purchase (OpenIAP: Play Billing /
/// StoreKit 2), ported from snake-classic:
///
///  1. listeners attached, THEN the connection opened;
///  2. every paid purchase is verified by the API before delivery;
///  3. only then finished (consumed for coin packs, acknowledged otherwise);
///  4. transient verification failures are delivered locally (Pro / no-ads /
///     themes, provisional for 3 days), queued, retried on resume, and
///     finished so Play never refunds a real purchase;
///  5. delivery = apply the API's entitlements (Pro / no-ads / owned themes)
///     and credit its pending coin grants exactly once. Coin packs are only
///     credited through those server grants, never provisionally, so a
///     retried receipt cannot pay twice;
///  6. rejected receipts: Android left unfinished (Play refunds them),
///     iOS finished (StoreKit would replay them forever).
class PurchaseService implements PurchasesPort {
  PurchaseService({
    required ApiService api,
    required UserService user,
    required PremiumCubit premium,
    required ProgressService progress,
    required AppDatabase db,
    required AnalyticsPort analytics,
    this.onPurchaseFlowStarted,
  }) : _api = api,
       _user = user,
       _premium = premium,
       _progress = progress,
       _db = db,
       _analytics = analytics;

  final ApiService _api;
  final UserService _user;
  final PremiumCubit _premium;
  final ProgressService _progress;
  final AppDatabase _db;
  final AnalyticsPort _analytics;

  /// The billing sheet backgrounds the app: lets AdService skip the
  /// app-open ad on return.
  final VoidCallback? onPurchaseFlowStarted;

  FlutterInappPurchase get _iap => FlutterInappPurchase.instance;
  StreamSubscription<Purchase>? _purchaseSub;
  StreamSubscription<PurchaseError>? _errorSub;
  bool _available = false;
  bool _initialized = false;
  bool _reconciling = false;
  final Map<String, ProductCommon> _products = {};
  final Map<String, Completer<PurchaseOutcome>> _waiting = {};
  final Set<String> _delivered = {};
  final Set<String> _fulfilling = {};

  /// Bare product ids currently being verified (resume watchdog).
  final Set<String> _verifyingProducts = {};
  Timer? _watchdog;
  ProvisionalEntitlements _provisional = const ProvisionalEntitlements({});

  static const _pendingKey = 'pending_purchase_verifications';
  static const _deliveredKey = 'delivered_purchase_ids';
  static const _provisionalKey = 'provisional_entitlements';

  static bool get _supported => !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  Future<void> initialize() async {
    if (_initialized || !_supported) return;
    _initialized = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      _delivered.addAll(prefs.getStringList(_deliveredKey) ?? const []);
      final rawProvisional = prefs.getString(_provisionalKey);
      if (rawProvisional != null) _provisional = ProvisionalEntitlements.fromJson(jsonDecode(rawProvisional));
      // Listeners BEFORE the connection: StoreKit replays unfinished
      // transactions as soon as it is up.
      _purchaseSub = _iap.purchaseUpdatedListener.listen((p) => unawaited(_onPurchaseUpdated(p)));
      _errorSub = _iap.purchaseErrorListener.listen(_onPurchaseError);
      _available = await _iap.initConnection().timeout(const Duration(seconds: 10));
      if (_available) await loadProducts().timeout(const Duration(seconds: 10), onTimeout: () {});
    } on Object catch (e) {
      _available = false;
      AppLog.warn('Purchases unavailable: $e');
    }
  }

  Future<void> loadProducts() async {
    if (!_available) return;
    try {
      final oneTime = await _iap.fetchProducts<Product>(skus: ProductIds.oneTimeProductIds, type: ProductQueryType.InApp);
      final subs = await _iap.fetchProducts<ProductSubscription>(skus: ProductIds.subscriptionIds, type: ProductQueryType.Subs);
      _products
        ..clear()
        ..addEntries([...oneTime, ...subs].map((p) => MapEntry(ProductIds.stripPrefix(p.id), p)));
    } on Object catch (e) {
      AppLog.warn('Loading products failed: $e');
    }
  }

  // -------------------------------------------------------------- port

  @override
  String? priceOf(String productId) {
    final p = _products[ProductIds.stripPrefix(productId)];
    if (p == null) return null;
    return displayPriceFor(p);
  }

  @override
  Future<PurchaseOutcome> buy(String productId) async {
    final bare = ProductIds.stripPrefix(productId);
    if (!_user.canPurchase) return PurchaseOutcome.needsSignIn;
    if (!_available) return PurchaseOutcome.failed;
    var product = _products[bare];
    if (product == null) {
      await loadProducts();
      product = _products[bare];
      if (product == null) return PurchaseOutcome.failed;
    }
    final waiter = _waiting[bare];
    if (waiter != null) return waiter.future;
    final completer = Completer<PurchaseOutcome>();
    _waiting[bare] = completer;
    _analytics.track('purchase_started', {'product_id': bare, 'product_type': productTypeFor(bare)});
    onPurchaseFlowStarted?.call();
    try {
      await _iap.requestPurchase(buildPurchaseRequest(product: product, accountId: _user.backendUserId));
    } on PurchaseError catch (e) {
      _complete(bare, _outcomeForError(e));
    } on Object catch (e) {
      AppLog.warn('requestPurchase failed: $e');
      _complete(bare, PurchaseOutcome.failed);
    }
    // A backed-out sheet sometimes reports nothing: give up after 3 minutes.
    return completer.future.timeout(const Duration(minutes: 3), onTimeout: () {
      _waiting.remove(bare);
      return PurchaseOutcome.cancelled;
    });
  }

  @override
  Future<PurchaseOutcome> restore() async {
    if (!_user.canPurchase) return PurchaseOutcome.needsSignIn;
    try {
      if (_available) {
        await _iap.restorePurchases();
        await reconcileStoreState();
      }
      final r = await _api.restorePurchases(InstallPlatform.name);
      if (!r.isSuccess) return PurchaseOutcome.failed;
      await _applyEntitlements(r.value?['entitlements']);
      return PurchaseOutcome.granted;
    } on Object catch (e) {
      AppLog.warn('Restore failed: $e');
      return PurchaseOutcome.failed;
    }
  }

  void _complete(String bareId, PurchaseOutcome outcome) {
    final c = _waiting.remove(bareId);
    if (c != null && !c.isCompleted) c.complete(outcome);
  }

  PurchaseOutcome _outcomeForError(PurchaseError e) => switch (e.code) {
    ErrorCode.UserCancelled => PurchaseOutcome.cancelled,
    ErrorCode.DeferredPayment || ErrorCode.Pending => PurchaseOutcome.pending,
    _ => PurchaseOutcome.failed,
  };

  // ------------------------------------------------------------ events

  Future<void> _onPurchaseUpdated(Purchase purchase) async {
    final bare = ProductIds.stripPrefix(purchase.productId);
    switch (purchase.purchaseState) {
      case PurchaseState.Pending:
        // Deferred payment: nothing delivered, transaction left open.
        _complete(bare, PurchaseOutcome.pending);
      case PurchaseState.Purchased:
        final outcome = await _fulfil(purchase);
        _complete(bare, outcome);
      case PurchaseState.Unknown:
        _complete(bare, PurchaseOutcome.failed);
    }
  }

  void _onPurchaseError(PurchaseError error) {
    final ids = error.productId != null ? {ProductIds.stripPrefix(error.productId!)} : {..._waiting.keys};
    if (error.code == ErrorCode.AlreadyOwned) unawaited(reconcileStoreState());
    for (final id in ids) {
      _complete(id, _outcomeForError(error));
    }
  }

  /// Verify → deliver → finish. Safe to repeat for the same purchase.
  Future<PurchaseOutcome> _fulfil(Purchase purchase) async {
    final identity = purchaseIdentity(purchase);
    if (identity != null && !_fulfilling.add(identity)) return PurchaseOutcome.pending;
    final bare = ProductIds.stripPrefix(purchase.productId);
    _verifyingProducts.add(bare);
    try {
      final consumable = ProductIds.isConsumable(purchase.productId);
      if (identity != null && _delivered.contains(identity)) {
        await _finish(purchase, consumable: consumable);
        return PurchaseOutcome.granted;
      }
      final payload = backendPayloadFor(purchase);
      if (payload == null) {
        // No token / JWS: nothing to verify. Same as a rejection.
        if (_isIOS) await _finish(purchase, consumable: consumable);
        return PurchaseOutcome.failed;
      }
      final result = await _api.verifyPurchase(payload.toVerifyBody());
      final outcome = classifyVerify(result);
      final action = actionFor(outcome, isIOS: _isIOS);
      if (outcome == VerifyOutcome.granted) {
        await _clearProvisional(bare);
        await _applyEntitlements(result.value?['entitlements']);
      } else if (action.deliver) {
        await _deliverProvisional(bare);
      } else {
        await _clearProvisional(bare);
      }
      if (action.queueRetry) await _queuePending(payload);
      if (action.markDelivered && identity != null) await _markDelivered(identity);
      if (action.finish) await _finish(purchase, consumable: consumable);
      switch (outcome) {
        case VerifyOutcome.granted:
          _analytics.track(
            bare == Products.removeAds ? 'remove_ads_purchase' : 'purchase_completed',
            {'product_id': bare, 'product_type': productTypeFor(bare)},
          );
          return PurchaseOutcome.granted;
        case VerifyOutcome.transient:
          return PurchaseOutcome.pending;
        case VerifyOutcome.needsSignIn:
          return PurchaseOutcome.needsSignIn;
        case VerifyOutcome.rejected:
          return PurchaseOutcome.failed;
      }
    } finally {
      _verifyingProducts.remove(bare);
      if (identity != null) _fulfilling.remove(identity);
    }
  }

  static bool get _isIOS => !kIsWeb && Platform.isIOS;

  /// Local delivery while the receipt waits for the API (transient verdict).
  Future<void> _deliverProvisional(String bare) async {
    if (bare == Products.removeAds || ProductIds.isSubscription(bare)) {
      _provisional = _provisional.add(bare, DateTime.now().toUtc());
      await _saveProvisional();
      final sub = ProductIds.isSubscription(bare);
      await _premium.apply(
        isPro: _premium.state.isPro || sub,
        proExpiresAt: sub ? _provisional.expiry[bare] : _premium.state.proExpiresAt,
        proPlan: sub ? (bare == Products.proYearly ? 'yearly' : 'monthly') : _premium.state.proPlan,
        adsRemoved: _premium.state.adsRemoved || bare == Products.removeAds,
      );
    }
    final themes = Cosmetics.themesForProduct(bare);
    if (themes.isNotEmpty) await _progress.grantThemes(themes, 'purchase');
    // Coin packs: credited only via the server grant once verified.
  }

  Future<void> _clearProvisional(String bare) async {
    if (!_provisional.expiry.containsKey(bare)) return;
    _provisional = _provisional.remove(bare);
    await _saveProvisional();
  }

  Future<void> _saveProvisional() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_provisionalKey, jsonEncode(_provisional.toJson()));
  }

  Future<void> _finish(Purchase purchase, {required bool consumable}) async {
    if (!consumable && purchase is PurchaseAndroid && purchase.isAcknowledgedAndroid == true) return;
    try {
      await _iap.finishTransaction(purchase: purchase, isConsumable: consumable);
    } on Object catch (e) {
      // Comes back on the next reconcile (Play allows three days).
      AppLog.warn('finishTransaction failed for ${purchase.productId}: $e');
    }
  }

  // ------------------------------------------------------- entitlements

  /// GET /purchases/entitlements → local state. Called after sign-in, on
  /// resume and after a `pro_coins` push.
  Future<void> refreshEntitlements() async {
    if (!_api.isAuthenticated) return;
    final r = await _api.entitlements();
    if (r.isSuccess) await _applyEntitlements(r.value);
  }

  Future<void> _applyEntitlements(Object? json) async {
    final e = EntitlementsSnapshot.fromJson(json);
    if (e == null) return;
    // A receipt still waiting for verification keeps its local delivery.
    final now = DateTime.now().toUtc();
    final provisionalPro = !e.isPro && _provisional.pro(now);
    final plan = _provisional.active(Products.proYearly, now) ? Products.proYearly : Products.proMonthly;
    await _premium.apply(
      isPro: e.isPro || provisionalPro,
      proExpiresAt: provisionalPro ? _provisional.expiry[plan] : e.proExpiresAt,
      proPlan: provisionalPro ? (plan == Products.proYearly ? 'yearly' : 'monthly') : e.proPlan,
      adsRemoved: e.adsRemoved || _provisional.adsRemoved(now),
    );
    if (e.purchasedThemes.isNotEmpty) await _progress.grantThemes(e.purchasedThemes, 'purchase');
    await CoinGrants(_db).credit(e.pendingGrants);
  }

  // ------------------------------------------------- retry & reconcile

  Future<void> _queuePending(BackendPurchasePayload payload) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_pendingKey) ?? [];
    final encoded = jsonEncode(payload.toJson());
    if (!list.contains(encoded)) await prefs.setStringList(_pendingKey, [...list, encoded]);
  }

  /// Re-verifies receipts that failed transiently. On resume and after auth.
  Future<void> retryPendingVerifications() async {
    if (!_api.isAuthenticated) return;
    final prefs = await SharedPreferences.getInstance();
    final pending = prefs.getStringList(_pendingKey) ?? [];
    if (pending.isEmpty) return;
    final remaining = <String>[];
    for (final raw in pending) {
      final payload = BackendPurchasePayload.fromJson((jsonDecode(raw) as Map).cast());
      if (payload == null) continue;
      final r = await _api.verifyPurchase(payload.toVerifyBody());
      final bare = ProductIds.stripPrefix(payload.productId);
      switch (classifyVerify(r)) {
        case VerifyOutcome.granted:
          await _clearProvisional(bare);
          await _applyEntitlements(r.value?['entitlements']);
        case VerifyOutcome.transient:
        case VerifyOutcome.needsSignIn:
          remaining.add(raw);
        case VerifyOutcome.rejected:
          await _clearProvisional(bare);
      }
    }
    await prefs.setStringList(_pendingKey, remaining);
    // A fresh reconcile finishes anything verified above; the refresh drops
    // a rejected receipt's provisional entitlement.
    if (pending.length != remaining.length) {
      unawaited(reconcileStoreState());
      unawaited(refreshEntitlements());
    }
  }

  /// Runs every purchase the store still reports through delivery
  /// (restores, cleared deferred payments, crash leftovers).
  Future<void> reconcileStoreState() async {
    if (!_available || _reconciling || !_api.isAuthenticated) return;
    _reconciling = true;
    try {
      for (final p in await _iap.getAvailablePurchases()) {
        if (p.purchaseState == PurchaseState.Purchased) await _fulfil(p);
      }
    } on Object catch (e) {
      AppLog.warn('Reconcile failed: $e');
    } finally {
      _reconciling = false;
    }
  }

  /// After every API session: drain the retry queue, reconcile, refresh.
  Future<void> onSession() async {
    await retryPendingVerifications();
    await reconcileStoreState();
    await refreshEntitlements();
  }

  /// On resume. The billing sheet closing is itself a resume, and a
  /// backed-out sheet on Android sometimes reports nothing: a watchdog
  /// releases any buy() still waiting once nothing is being verified for it.
  Future<void> onResume() async {
    _watchdog?.cancel();
    if (_waiting.isNotEmpty) {
      _watchdog = Timer(const Duration(seconds: 6), () {
        for (final id in [..._waiting.keys]) {
          if (!_verifyingProducts.contains(id)) _complete(id, PurchaseOutcome.cancelled);
        }
      });
    }
    await _premium.recheckLocalExpiry();
    if (!_api.isAuthenticated) return;
    await retryPendingVerifications();
    await reconcileStoreState();
    await refreshEntitlements();
  }

  Future<void> _markDelivered(String id) async {
    _delivered.add(id);
    final prefs = await SharedPreferences.getInstance();
    final ids = _delivered.toList();
    await prefs.setStringList(_deliveredKey, ids.length > 500 ? ids.sublist(ids.length - 500) : ids);
  }

  Future<void> dispose() async {
    _watchdog?.cancel();
    await _purchaseSub?.cancel();
    await _errorSub?.cancel();
    if (_available) {
      try {
        await _iap.endConnection();
      } on Object catch (e) {
        AppLog.warn('endConnection failed: $e');
      }
    }
  }
}

/// Platform name for purchase endpoints.
abstract final class InstallPlatform {
  static String get name => !kIsWeb && Platform.isIOS ? 'ios' : 'android';
}
