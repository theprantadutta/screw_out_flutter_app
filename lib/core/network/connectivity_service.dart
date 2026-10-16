// ignore_for_file: prefer_initializing_formals
import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

import '../../services/app_log.dart';

enum LinkState { none, available, unknown }

enum BackendState { unknown, reachable, unavailable }

@immutable
class ConnectivitySnapshot {
  const ConnectivitySnapshot({
    this.link = LinkState.unknown,
    this.backend = BackendState.unknown,
    this.lastBackendSuccessAt,
    this.lastBackendFailureAt,
  });

  final LinkState link;
  final BackendState backend;
  final DateTime? lastBackendSuccessAt;
  final DateTime? lastBackendFailureAt;

  /// Only "the OS is certain there is no transport" forbids network work.
  bool get shouldAttemptNetworkWork => link != LinkState.none;

  /// Optimistic: unknown counts as online.
  bool get isOnline => link != LinkState.none && backend != BackendState.unavailable;

  ConnectivitySnapshot copyWith({
    LinkState? link,
    BackendState? backend,
    DateTime? lastBackendSuccessAt,
    DateTime? lastBackendFailureAt,
  }) => ConnectivitySnapshot(
    link: link ?? this.link,
    backend: backend ?? this.backend,
    lastBackendSuccessAt: lastBackendSuccessAt ?? this.lastBackendSuccessAt,
    lastBackendFailureAt: lastBackendFailureAt ?? this.lastBackendFailureAt,
  );

  @override
  bool operator ==(Object other) =>
      other is ConnectivitySnapshot &&
      other.link == link &&
      other.backend == backend &&
      other.lastBackendSuccessAt == lastBackendSuccessAt &&
      other.lastBackendFailureAt == lastBackendFailureAt;

  @override
  int get hashCode => Object.hash(link, backend, lastBackendSuccessAt, lastBackendFailureAt);
}

/// What the app knows about reaching the network and the backend (ported
/// from snake-classic). Nothing here probes: the OS link is a scheduling
/// hint, and the outcome of each real request is the record of
/// reachability ([recordBackendSuccess]/[recordBackendFailure], called by
/// ApiService).
class ConnectivityService extends ChangeNotifier {
  ConnectivityService({
    Stream<List<ConnectivityResult>>? linkChanges,
    Future<List<ConnectivityResult>> Function()? initialLink,
    DateTime Function()? clock,
  }) : _linkChanges = linkChanges,
       _initialLink = initialLink,
       _clock = clock ?? DateTime.now;

  final Stream<List<ConnectivityResult>>? _linkChanges;
  final Future<List<ConnectivityResult>> Function()? _initialLink;
  final DateTime Function() _clock;
  StreamSubscription<List<ConnectivityResult>>? _sub;
  bool _initialized = false;
  ConnectivitySnapshot _snapshot = const ConnectivitySnapshot();
  final _controller = StreamController<ConnectivitySnapshot>.broadcast();

  ConnectivitySnapshot get snapshot => _snapshot;
  bool get isOnline => _snapshot.isOnline;
  bool get shouldAttemptNetworkWork => _snapshot.shouldAttemptNetworkWork;
  bool get hasNetworkConnection => _snapshot.link == LinkState.available;

  /// Replays the current value to each new subscriber.
  Stream<ConnectivitySnapshot> get snapshots async* {
    yield _snapshot;
    yield* _controller.stream;
  }

  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;
    try {
      final connectivity = Connectivity();
      _sub = (_linkChanges ?? connectivity.onConnectivityChanged).listen(_applyLink);
      _applyLink(await (_initialLink?.call() ?? connectivity.checkConnectivity()));
    } on Object catch (e) {
      // Unknown still permits work; a guess of "none" would suppress it.
      AppLog.warn('Connectivity: initial link check failed: $e');
    }
  }

  void _applyLink(List<ConnectivityResult> results) {
    final hasLink = results.isNotEmpty && !results.contains(ConnectivityResult.none);
    final link = hasLink ? LinkState.available : LinkState.none;
    _publish(_snapshot.copyWith(link: link, backend: link == LinkState.none ? BackendState.unknown : _snapshot.backend));
  }

  void recordBackendSuccess() => _publish(
    _snapshot.copyWith(link: LinkState.available, backend: BackendState.reachable, lastBackendSuccessAt: _clock()),
  );

  /// Transport failure, timeout or 5xx only — never 4xx.
  void recordBackendFailure() =>
      _publish(_snapshot.copyWith(backend: BackendState.unavailable, lastBackendFailureAt: _clock()));

  void _publish(ConnectivitySnapshot next) {
    if (next == _snapshot) return;
    _snapshot = next;
    if (!_controller.isClosed) _controller.add(next);
    notifyListeners();
  }

  @visibleForTesting
  void applyLinkForTesting(List<ConnectivityResult> results) => _applyLink(results);

  @override
  void dispose() {
    _sub?.cancel();
    _controller.close();
    super.dispose();
  }
}
