/// Mulberry32 - a tiny, fully specified 32-bit PRNG.
///
/// `dart:math`'s `Random` makes no cross-platform or cross-version stability
/// promise; daily sheets must be bit-identical on every install forever, so
/// we own the algorithm.
final class SeededRng {
  SeededRng(int seed) : _state = seed & 0xFFFFFFFF;

  int _state;

  int nextUint32() {
    _state = (_state + 0x6D2B79F5) & 0xFFFFFFFF;
    var t = _state;
    t = _imul(t ^ (t >>> 15), t | 1);
    t ^= (t + _imul(t ^ (t >>> 7), t | 61)) & 0xFFFFFFFF;
    return (t ^ (t >>> 14)) & 0xFFFFFFFF;
  }

  /// Uniform in [0, 1).
  double nextDouble() => nextUint32() / 4294967296.0;

  /// Uniform in [0, max).
  int nextInt(int max) => (nextDouble() * max).floor();

  /// Uniform in [min, max] inclusive.
  int range(int min, int max) => min + nextInt(max - min + 1);

  /// Uniform multiple of [step] in [min, max].
  int snapped(int min, int max, int step) =>
      (range((min / step).ceil(), (max / step).floor())) * step;

  bool chance(double p) => nextDouble() < p;

  T pick<T>(List<T> items) => items[nextInt(items.length)];

  void shuffle<T>(List<T> items) {
    for (var i = items.length - 1; i > 0; i--) {
      final j = nextInt(i + 1);
      final tmp = items[i];
      items[i] = items[j];
      items[j] = tmp;
    }
  }

  /// Derives an independent stream (e.g. one per generation attempt).
  SeededRng fork(int salt) => SeededRng(_mix(nextUint32() ^ _mix(salt)));
}

int _imul(int a, int b) => (a * b) & 0xFFFFFFFF;

int _mix(int x) {
  var h = x & 0xFFFFFFFF;
  h = _imul(h ^ (h >>> 16), 0x85EBCA6B);
  h = _imul(h ^ (h >>> 13), 0xC2B2AE35);
  return (h ^ (h >>> 16)) & 0xFFFFFFFF;
}
