/// How an available Play Store update is offered.
enum UpdateFlow {
  /// Nothing this session.
  none,

  /// Play's blocking full-screen flow: the app can't be used until the
  /// update installs. Only for emergencies (see [UpdatePolicy.decide]).
  immediate,

  /// Play downloads in the background while the player keeps playing; the
  /// app offers a restart once the download lands.
  flexible,
}

/// Which flow to run, kept pure so it can be tested (ported from
/// snake-classic). Play never installs an update silently; both flows need
/// the player to accept a Play dialog. What we control is which one, and
/// how often we ask. Flexible is the default; the blocking flow is for:
///
/// * a release published with a high update priority (Play Developer API;
///   a console upload is priority 0), or
/// * this build being older than the API's `minimum_supported_version`
///   (set on the dashboard's App releases sheet).
abstract final class UpdatePolicy {
  /// Priority at or above which a release is an emergency (Play: 0 to 5).
  static const immediatePriorityThreshold = 4;

  /// How long a declined flexible offer is left alone.
  static const snooze = Duration(hours: 24);

  static UpdateFlow decide({
    required bool updateAvailable,
    required int priority,
    required bool immediateAllowed,
    required bool flexibleAllowed,
    required Duration? sinceDeclined,
    bool belowMinimumSupported = false,
  }) {
    if (!updateAvailable) return UpdateFlow.none;

    // Emergencies cut through a snooze: they can't wait for a better moment.
    final urgent = priority >= immediatePriorityThreshold || belowMinimumSupported;
    if (urgent && immediateAllowed) return UpdateFlow.immediate;

    if (sinceDeclined != null && sinceDeclined < snooze) return UpdateFlow.none;
    if (flexibleAllowed) return UpdateFlow.flexible;

    // Play sometimes allows only the immediate flow. A routine release is
    // not worth a wall; wait for the next launch.
    return UpdateFlow.none;
  }

  /// True when [current] is older than [minimum] ("1.2.0" style; missing
  /// parts count as 0, anything unparsable never blocks).
  static bool isBelow(String current, String? minimum) {
    if (minimum == null || minimum.trim().isEmpty) return false;
    List<int>? parts(String v) {
      final p = v.split('+').first.split('.').map(int.tryParse).toList();
      return p.contains(null) ? null : p.cast<int>();
    }

    final a = parts(current), b = parts(minimum.trim());
    if (a == null || b == null) return false;
    for (var i = 0; i < 4; i++) {
      final x = i < a.length ? a[i] : 0, y = i < b.length ? b[i] : 0;
      if (x != y) return x < y;
    }
    return false;
  }
}
