/// Client ↔ API id differences.
///
/// The client's Walnut Workshop theme is `walnut`; the API catalog calls the
/// same theme `workshop` (theme_pack_workshop). Everything else matches.
abstract final class WireIds {
  static const _toServer = {'walnut': 'workshop'};
  static const _fromServer = {'workshop': 'walnut'};

  static String themeToServer(String id) => _toServer[id] ?? id;
  static String themeFromServer(String id) => _fromServer[id] ?? id;

  /// Local unlock source → contract `unlocked_by`.
  static String unlockedBy(String source) => switch (source) {
    'chapter' => 'reward',
    'coins' || 'purchase' || 'pro' || 'default' => source,
    _ => 'reward',
  };

  /// `2026-10-16` ↔ 20261016.
  static String dateFromKey(int key) =>
      '${key ~/ 10000}-${((key ~/ 100) % 100).toString().padLeft(2, '0')}-${(key % 100).toString().padLeft(2, '0')}';

  static int? keyFromDate(String? date) {
    if (date == null) return null;
    final parts = date.split('-');
    if (parts.length != 3) return null;
    final y = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    final d = int.tryParse(parts[2]);
    if (y == null || m == null || d == null) return null;
    return y * 10000 + m * 100 + d;
  }

  static String iso(DateTime t) => t.toUtc().toIso8601String();
}
