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
///  4. transient verification failures are kept and retried on resume;
///  5. delivery = apply the API's entitlements (Pro / no-ads / owned themes)
///     and credit its pending coin grants exactly once.
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

  static const _pendingKey = 'pending_purchase_verifications';
  static const _deliveredKey = 'delivered_purchase_ids';

  static bool get _supported => !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  Future<void> initialize() async {
    if (_initialized || !_supported) return;
    _initialized = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      _delivered.addAll(prefs.getStringList(_deliveredKey) ?? const []);
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
    return p.displayPrice;
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
    try {
      final consumable = ProductIds.isConsumable(purchase.productId);
      if (identity != null && _delivered.contains(identity)) {
        await _finish(purchase, consumable: consumable);
        return PurchaseOutcome.granted;
      }
      final payload = backendPayloadFor(purchase);
      if (payload == null) return PurchaseOutcome.failed;
      final result = await _api.verifyPurchase(payload.toVerifyBody());
      switch (classifyVerify(result)) {
        case VerifyOutcome.granted:
          await _applyEntitlements(result.value?['entitlements']);
          if (identity != null) await _markDelivered(identity);
          await _finish(purchase, consumable: consumable);
          _analytics.track(
            ProductIds.stripPrefix(purchase.productId) == 'remove_ads' ? 'remove_ads_purchase' : 'purchase_completed',
            {'product_id': ProductIds.stripPrefix(purchase.productId), 'product_type': productTypeFor(purchase.productId)},
          );
          return PurchaseOutcome.granted;
        case VerifyOutcome.transient:
          await _queuePending(payload);
          return PurchaseOutcome.pending;
        case VerifyOutcome.needsSignIn:
          await _queuePending(payload);
          return PurchaseOutcome.needsSignIn;
        case VerifyOutcome.rejected:
          // The store says no: finish so it stops replaying, grant nothing.
          await _finish(purchase, consumable: consumable);
          return PurchaseOutcome.failed;
      }
    } finally {
      if (identity != null) _fulfilling.remove(identity);
    }
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
    await _premium.apply(isPro: e.isPro, proExpiresAt: e.proExpiresAt, proPlan: e.proPlan, adsRemoved: e.adsRemoved);
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
      switch (classifyVerify(r)) {
        case VerifyOutcome.granted:
          await _applyEntitlements(r.value?['entitlements']);
        case VerifyOutcome.transient:
        case VerifyOutcome.needsSignIn:
          remaining.add(raw);
        case VerifyOutcome.rejected:
          break;
      }
    }
    await prefs.setStringList(_pendingKey, remaining);
    // A fresh reconcile finishes anything verified above.
    if (pending.length != remaining.length) unawaited(reconcileStoreState());
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

  /// On resume.
  Future<void> onResume() async {
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

  void dispose() {
    _purchaseSub?.cancel();
    _errorSub?.cancel();
  }
}

/// Platform name for purchase endpoints.
abstract final class InstallPlatform {
  static String get name => !kIsWeb && Platform.isIOS ? 'ios' : 'android';
}
