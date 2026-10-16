import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/database/app_database.dart';

final class PremiumState extends Equatable {
  const PremiumState({this.isPro = false, this.proExpiresAt, this.proPlan, this.adsRemoved = false});

  final bool isPro;
  final DateTime? proExpiresAt;

  /// monthly | yearly
  final String? proPlan;
  final bool adsRemoved;

  /// Pro or Remove-ads: no interstitials, banners or app-open ads.
  bool get noAds => isPro || adsRemoved;

  @override
  List<Object?> get props => [isPro, proExpiresAt, proPlan, adsRemoved];
}

/// Entitlements are server-authoritative (verified purchases); this caches
/// them in Drift so they hold offline, and drops Pro locally once expired.
class PremiumCubit extends Cubit<PremiumState> {
  PremiumCubit(this._db) : super(const PremiumState());

  final AppDatabase _db;

  Future<void> initialize() async {
    final row = await (_db.select(_db.entitlements)..where((e) => e.id.equals(1))).getSingleOrNull();
    if (row != null) {
      emit(PremiumState(isPro: row.isPro, proExpiresAt: row.proExpiresAt, proPlan: row.proPlan, adsRemoved: row.adsRemoved));
    }
    await recheckLocalExpiry();
  }

  /// Applies entitlements from the API (or a just-verified purchase).
  Future<void> apply({
    required bool isPro,
    DateTime? proExpiresAt,
    String? proPlan,
    required bool adsRemoved,
  }) async {
    final next = PremiumState(isPro: isPro, proExpiresAt: proExpiresAt, proPlan: proPlan, adsRemoved: adsRemoved);
    await _db.into(_db.entitlements).insertOnConflictUpdate(
      EntitlementsCompanion(
        id: const Value(1),
        isPro: Value(isPro),
        proExpiresAt: Value(proExpiresAt),
        proPlan: Value(proPlan),
        adsRemoved: Value(adsRemoved),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
    emit(next);
  }

  /// Offline safety net: Pro lapses once its expiry has passed.
  Future<void> recheckLocalExpiry() async {
    final exp = state.proExpiresAt;
    if (state.isPro && exp != null && exp.isBefore(DateTime.now().toUtc())) {
      await apply(isPro: false, proExpiresAt: exp, proPlan: state.proPlan, adsRemoved: state.adsRemoved);
    }
  }
}
