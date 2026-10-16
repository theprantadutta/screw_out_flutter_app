import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../services/progress_service.dart';

/// Live view of clears, coins, cosmetics and daily completions (Drift).
class ProgressCubit extends Cubit<ProgressSnapshot> {
  ProgressCubit(this._service) : super(ProgressSnapshot.empty);

  final ProgressService _service;
  StreamSubscription<ProgressSnapshot>? _sub;

  Future<void> initialize() async {
    emit(await _service.snapshot());
    _sub = _service.watchAll().listen(emit);
  }

  Future<bool> buyTheme(String id) => _service.buyTheme(id);
  Future<void> equipTheme(String id) => _service.equipTheme(id);

  @override
  Future<void> close() async {
    await _sub?.cancel();
    return super.close();
  }
}
