// Synthesises every Screw Out sound effect and the music track.
//
//   dart run tool/generate_audio.dart      → assets/audio/sfx_*.wav
//                                            build/audio/music_workshop.wav
//   python tool/encode_music.py            → assets/audio/music_workshop.ogg
//
// Pure Dart, deterministic (seeded noise), every sound ours. The style is
// upbeat & playful: C major, 124 BPM, modelled marimba and glockenspiel,
// bouncy octave bass, offbeat chord stabs, claps and shakers. Everything
// hangs off one hook — G4 C5 E5 G5, the chorus' opening — which also opens
// the level, crowns a clear and lifts a new best, so the game's sound is
// recognisable.
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

const sr = 44100;

void main() {
  final out = Directory('assets/audio')..createSync(recursive: true);
  final sfx = <String, Float64List Function()>{
    'sfx_tick': tick,
    'sfx_toggle': toggle,
    'sfx_unscrew': unscrew,
    'sfx_clink': clink,
    'sfx_panel_slide': panelSlide,
    'sfx_slot_free': slotFree,
    'sfx_thunk': thunk,
    'sfx_undo': undo,
    'sfx_hint': hint,
    'sfx_tray_warn': trayWarn,
    'sfx_level_start': levelStart,
    'sfx_success': success,
    'sfx_best': best,
    'sfx_stuck': stuck,
    'sfx_coin': coin,
    'sfx_rescue': rescue,
    'sfx_chapter': chapterFanfare,
    'sfx_daily': dailyDone,
    'sfx_purchase': purchase,
  };
  for (final e in sfx.entries) {
    final x = master(highpass(e.value(), 35), peakDb: e.key == 'sfx_thunk' ? -10 : -6);
    writeWav('${out.path}/${e.key}.wav', [x], sr);
    stdout.writeln('${e.key.padRight(18)} ${(x.length / sr * 1000).round()} ms');
  }
  final build = Directory('build/audio')..createSync(recursive: true);
  final (l, r) = Song().render();
  writeWav('${build.path}/music_workshop.wav', [l, r], sr);
  stdout.writeln('music_workshop     ${(l.length / sr).toStringAsFixed(2)} s stereo (encode with tool/encode_music.py)');
}

// ================================================================= notes

double hz(num midi) => 440.0 * math.pow(2, (midi - 69) / 12);

const c4 = 60, d4 = 62, e4 = 64, f4 = 65, g4 = 67, a4 = 69, b4 = 71;
const c5 = 72, d5 = 74, e5 = 76, f5 = 77, g5 = 79, a5 = 81, b5 = 83;
const c6 = 84, d6 = 86, e6 = 88, g6 = 91, c7 = 96;

// ============================================================ primitives

final _rng = math.Random(2410);
double noise() => _rng.nextDouble() * 2 - 1;

Float64List buf(double seconds) => Float64List((seconds * sr).ceil() + 1);

void mix(Float64List dst, Float64List src, double at, {double gain = 1}) {
  final start = (at * sr).round();
  for (var i = 0; i < src.length; i++) {
    final j = start + i;
    if (j >= 0 && j < dst.length) dst[j] += src[i] * gain;
  }
}

double expEnv(double t, double attack, double decay) =>
    t < attack ? t / attack : math.exp(-(t - attack) / decay);

/// Modal percussion: sum of decaying partials (ratio, amplitude, decay).
Float64List modal(double f, double dur, List<(double, double, double)> partials, {double attack = 0.0015}) {
  final o = buf(dur);
  for (final (ratio, amp, decay) in partials) {
    if (f * ratio > sr / 2.2) continue;
    final w = 2 * math.pi * f * ratio / sr;
    for (var i = 0; i < o.length; i++) {
      o[i] += math.sin(w * i) * amp * expEnv(i / sr, attack, decay);
    }
  }
  final f2 = (0.004 * sr).round();
  for (var i = 0; i < f2 && i < o.length; i++) {
    o[o.length - 1 - i] *= i / f2;
  }
  return o;
}

/// Marimba: wooden bar modes (1 : 3.93 : 9.2) + a soft mallet knock.
Float64List marimba(double f, {double dur = 0.9, double vel = 1}) {
  final body = math.max(0.22, math.min(0.8, 160 / f));
  final o = modal(f, dur, [(1, 1, body), (3.93, 0.3 * vel, body * 0.16), (9.2, 0.1 * vel, body * 0.05)]);
  mix(o, lowpass(noiseBurst(0.02, decay: 0.004), 2500), 0, gain: 0.1 * vel);
  return o;
}

/// Glockenspiel: bright metal bar (1 : 2.76 : 5.40 : 8.93).
Float64List glock(double f, {double dur = 1.2}) =>
    modal(f, dur, [(1, 1, 0.55), (2.76, 0.4, 0.18), (5.4, 0.2, 0.07), (8.93, 0.1, 0.03)], attack: 0.0008);

/// Woodblock / temple block "tok".
Float64List woodblock(double f, {double dur = 0.12}) {
  final o = modal(f, dur, [(1, 1, 0.035), (2.57, 0.5, 0.018), (4.1, 0.25, 0.01)], attack: 0.0005);
  mix(o, highpass(noiseBurst(0.01, decay: 0.002), 2000), 0, gain: 0.25);
  return o;
}

/// PolyBLEP residual for band-limited saw/square.
double _blep(double t, double dt) {
  if (t < dt) {
    final x = t / dt;
    return x + x - x * x - 1;
  }
  if (t > 1 - dt) {
    final x = (t - 1) / dt;
    return x * x + x + x + 1;
  }
  return 0;
}

Float64List saw(double f, double dur, {double detune = 0}) {
  final o = buf(dur);
  final dt = f * (1 + detune) / sr;
  var ph = _rng.nextDouble();
  for (var i = 0; i < o.length; i++) {
    o[i] = 2 * ph - 1 - _blep(ph, dt);
    ph += dt;
    if (ph >= 1) ph -= 1;
  }
  return o;
}

Float64List square(double f, double dur, {double width = 0.5}) {
  final o = buf(dur);
  final dt = f / sr;
  var ph = 0.0;
  for (var i = 0; i < o.length; i++) {
    var v = ph < width ? 1.0 : -1.0;
    v += _blep(ph, dt);
    var p2 = ph - width;
    if (p2 < 0) p2 += 1;
    v -= _blep(p2, dt);
    o[i] = v;
    ph += dt;
    if (ph >= 1) ph -= 1;
  }
  return o;
}

Float64List shape(Float64List x, double Function(double t) env) {
  for (var i = 0; i < x.length; i++) {
    x[i] *= env(i / sr);
  }
  return x;
}

/// Bouncy synth bass: saw + sine sub through a lowpass that snaps shut.
Float64List bass(double f, double dur) {
  final raw = saw(f, dur);
  for (var i = 0; i < raw.length; i++) {
    raw[i] += math.sin(2 * math.pi * f * i / sr) * 0.8;
  }
  final o = Float64List(raw.length);
  var y = 0.0;
  for (var i = 0; i < raw.length; i++) {
    final t = i / sr;
    final fc = 180 + 1400 * math.exp(-t / 0.06);
    final a = 1 - math.exp(-2 * math.pi * fc / sr);
    y += a * (raw[i] - y);
    o[i] = y * expEnv(t, 0.003, dur * 0.55) * (t > dur - 0.02 ? math.max(0, (dur - t) / 0.02) : 1);
  }
  return o;
}

/// Offbeat chord stab: two detuned saws + a thin square, short and bright.
Float64List stab(List<int> notes, {double dur = 0.16}) {
  final o = buf(dur + 0.05);
  for (final n in notes) {
    mix(o, saw(hz(n), dur + 0.05), 0, gain: 0.35);
    mix(o, saw(hz(n), dur + 0.05, detune: 0.006), 0, gain: 0.35);
    mix(o, square(hz(n + 12), dur + 0.05, width: 0.3), 0, gain: 0.12);
  }
  return lowpass(shape(o, (t) => expEnv(t, 0.004, dur * 0.45) * (t > dur ? math.max(0, 1 - (t - dur) / 0.05) : 1)), 2800);
}

/// Karplus–Strong pizzicato pluck.
Float64List pluck(double f, {double dur = 0.6, double damping = 0.994, double bright = 0.55}) {
  final o = buf(dur);
  final n = (sr / f).round().clamp(2, 100000);
  final line = Float64List(n);
  for (var i = 0; i < n; i++) {
    line[i] = noise();
  }
  for (var i = 1; i < n; i++) {
    line[i] = line[i] * bright + line[i - 1] * (1 - bright);
  }
  var p = 0;
  for (var i = 0; i < o.length; i++) {
    final next = (p + 1) % n;
    final v = line[p];
    line[p] = damping * 0.5 * (line[p] + line[next]);
    final t = i / sr;
    o[i] = v * (t > dur - 0.03 ? math.max(0, (dur - t) / 0.03) : 1);
    p = next;
  }
  return o;
}

/// Sine with exponential glide + optional vibrato (slide whistle, boings).
Float64List glide(double f0, double f1, double dur, {double vib = 0, double vibRate = 6, double attack = 0.01, double decay = 10}) {
  final o = buf(dur);
  var ph = 0.0;
  for (var i = 0; i < o.length; i++) {
    final t = i / sr;
    final f = f0 * math.pow(f1 / f0, math.min(1, t / dur)) * (1 + vib * math.sin(2 * math.pi * vibRate * t));
    ph += 2 * math.pi * f / sr;
    final release = t > dur - 0.03 ? math.max(0, (dur - t) / 0.03) : 1.0;
    o[i] = math.sin(ph) * expEnv(t, attack, decay) * release;
  }
  return o;
}

Float64List noiseBurst(double dur, {double decay = 0.03}) {
  final o = buf(dur);
  for (var i = 0; i < o.length; i++) {
    o[i] = noise() * expEnv(i / sr, 0.0005, decay);
  }
  return o;
}

// ---------------------------------------------------------------- drums

Float64List kick() {
  final o = glide(160, 48, 0.32, attack: 0.001, decay: 0.12);
  mix(o, lowpass(noiseBurst(0.01, decay: 0.002), 3000), 0, gain: 0.3);
  return o;
}

Float64List clap() {
  final o = buf(0.3);
  for (final t in [0.0, 0.011, 0.021]) {
    mix(o, noiseBurst(0.02, decay: 0.006), t, gain: 0.8);
  }
  mix(o, noiseBurst(0.25, decay: 0.07), 0.03, gain: 0.5);
  return bandpass(o, 1300, 0.9);
}

Float64List hat({bool open = false}) =>
    highpass(noiseBurst(open ? 0.25 : 0.05, decay: open ? 0.09 : 0.012), 7500, 0.8);

Float64List shaker() {
  final o = buf(0.08);
  for (var i = 0; i < o.length; i++) {
    final t = i / sr;
    o[i] = noise() * (t < 0.015 ? t / 0.015 : math.exp(-(t - 0.015) / 0.02));
  }
  return bandpass(o, 6500, 1.2);
}

Float64List tom(double f) => glide(f, f * 0.6, 0.3, attack: 0.001, decay: 0.12);

Float64List snap() => bandpass(noiseBurst(0.12, decay: 0.012), 2200, 2);

// ---------------------------------------------------------------- filters

Float64List _biquad(Float64List x, double b0, double b1, double b2, double a1, double a2) {
  final y = Float64List(x.length);
  var x1 = 0.0, x2 = 0.0, y1 = 0.0, y2 = 0.0;
  for (var i = 0; i < x.length; i++) {
    final v = b0 * x[i] + b1 * x1 + b2 * x2 - a1 * y1 - a2 * y2;
    x2 = x1;
    x1 = x[i];
    y2 = y1;
    y1 = v;
    y[i] = v;
  }
  return y;
}

Float64List lowpass(Float64List x, double fc, [double q = 0.707]) {
  final w = 2 * math.pi * fc / sr, al = math.sin(w) / (2 * q), c = math.cos(w), a0 = 1 + al;
  return _biquad(x, (1 - c) / 2 / a0, (1 - c) / a0, (1 - c) / 2 / a0, -2 * c / a0, (1 - al) / a0);
}

Float64List highpass(Float64List x, double fc, [double q = 0.707]) {
  final w = 2 * math.pi * fc / sr, al = math.sin(w) / (2 * q), c = math.cos(w), a0 = 1 + al;
  return _biquad(x, (1 + c) / 2 / a0, -(1 + c) / a0, (1 + c) / 2 / a0, -2 * c / a0, (1 - al) / a0);
}

Float64List bandpass(Float64List x, double fc, [double q = 1]) {
  final w = 2 * math.pi * fc / sr, al = math.sin(w) / (2 * q), c = math.cos(w), a0 = 1 + al;
  return _biquad(x, al / a0, 0, -al / a0, -2 * c / a0, (1 - al) / a0);
}

/// Schroeder room; [seed] shifts the delays so L and R decorrelate.
Float64List reverb(Float64List x, {double wet = 0.2, double size = 1, int seed = 0}) {
  const base = [1557, 1617, 1491, 1422, 1277, 1356];
  final y = Float64List(x.length);
  for (var k = 0; k < 4; k++) {
    final d = ((base[(k + seed) % base.length] + seed * 23) * size).round();
    final line = Float64List(d);
    var p = 0;
    var lp = 0.0;
    for (var i = 0; i < x.length; i++) {
      final out = line[p];
      lp = out * 0.7 + lp * 0.3; // damped feedback
      line[p] = x[i] + lp * 0.8;
      y[i] += out * 0.25;
      p = (p + 1) % d;
    }
  }
  var z = y;
  for (final d in [225 + seed * 7, 556 + seed * 11]) {
    final line = Float64List(d);
    final o = Float64List(z.length);
    var p = 0;
    for (var i = 0; i < z.length; i++) {
      final b = line[p];
      final v = z[i] + b * 0.5;
      line[p] = v;
      o[i] = b - v * 0.5;
      p = (p + 1) % d;
    }
    z = o;
  }
  return Float64List.fromList([for (var i = 0; i < x.length; i++) x[i] * (1 - wet) + z[i] * wet]);
}

Float64List pad(Float64List x, double seconds) {
  final o = Float64List(x.length + (seconds * sr).round());
  o.setAll(0, x);
  return o;
}

Float64List trim(Float64List x) {
  var end = x.length;
  while (end > 1 && x[end - 1].abs() < 2e-4) {
    end--;
  }
  final o = Float64List.fromList(Float64List.sublistView(x, 0, end));
  final f = (0.01 * sr).round();
  for (var i = 0; i < f && i < o.length; i++) {
    o[o.length - 1 - i] *= i / f;
  }
  return o;
}

Float64List master(Float64List x, {double peakDb = -6}) {
  var peak = 1e-9;
  for (final v in x) {
    peak = math.max(peak, v.abs());
  }
  final g = math.pow(10, peakDb / 20) / peak;
  return Float64List.fromList([for (final v in x) v * g]);
}

void writeWav(String path, List<Float64List> ch, int rate) {
  final n = ch.first.length;
  final c = ch.length;
  final data = ByteData(44 + n * 2 * c);
  void str(int o, String s) {
    for (var i = 0; i < s.length; i++) {
      data.setUint8(o + i, s.codeUnitAt(i));
    }
  }

  str(0, 'RIFF');
  data.setUint32(4, 36 + n * 2 * c, Endian.little);
  str(8, 'WAVE');
  str(12, 'fmt ');
  data
    ..setUint32(16, 16, Endian.little)
    ..setUint16(20, 1, Endian.little)
    ..setUint16(22, c, Endian.little)
    ..setUint32(24, rate, Endian.little)
    ..setUint32(28, rate * 2 * c, Endian.little)
    ..setUint16(32, 2 * c, Endian.little)
    ..setUint16(34, 16, Endian.little);
  str(36, 'data');
  data.setUint32(40, n * 2 * c, Endian.little);
  for (var i = 0; i < n; i++) {
    for (var k = 0; k < c; k++) {
      data.setInt16(44 + (i * c + k) * 2, (ch[k][i].clamp(-1.0, 1.0) * 32767).round(), Endian.little);
    }
  }
  File(path).writeAsBytesSync(data.buffer.asUint8List());
}

// ======================================================== sound effects
// Same instruments and key as the music: the effects belong to the song.

/// UI tap: a crisp little woodblock "tok".
Float64List tick() => trim(woodblock(1500, dur: 0.07));

/// Toggle: two-tone tok (latch).
Float64List toggle() {
  final o = buf(0.15);
  mix(o, woodblock(1200, dur: 0.07), 0);
  mix(o, woodblock(1600, dur: 0.07), 0.055, gain: 0.8);
  return trim(o);
}

/// Unscrew: a quick ratchet "zip" that springs up into a cartoon twirl.
Float64List unscrew() {
  final o = buf(0.42);
  var t = 0.0;
  for (var k = 0; k < 6; k++) {
    mix(o, woodblock(2200 + k * 180, dur: 0.03), t, gain: 0.45);
    t += 0.03 - k * 0.003;
  }
  mix(o, glide(500, 1400, 0.2, vib: 0.03, vibRate: 22, attack: 0.02, decay: 0.12), 0.12, gain: 0.35);
  mix(o, glock(hz(g6), dur: 0.25), 0.3, gain: 0.12);
  return trim(reverb(pad(o, 0.1), wet: 0.08));
}

/// Clink: the screw lands in its slot — a bright glock "ding".
Float64List clink() {
  final o = buf(0.6);
  mix(o, glock(hz(e6), dur: 0.6), 0, gain: 0.6);
  mix(o, modal(2600, 0.2, [(1, 1, 0.05), (1.73, 0.6, 0.03), (2.41, 0.3, 0.02)]), 0, gain: 0.3);
  return trim(reverb(pad(o, 0.2), wet: 0.12));
}

/// Plate release: a cartoon swoosh down, ending in a soft wooden plop.
Float64List panelSlide() {
  final o = buf(0.75);
  final swoosh = buf(0.35);
  for (var i = 0; i < swoosh.length; i++) {
    swoosh[i] = noise() * math.sin(math.pi * i / swoosh.length);
  }
  // Sweep the band down with the fall (block-wise filter).
  final shaped = Float64List(swoosh.length);
  const block = 256;
  for (var s = 0; s < swoosh.length; s += block) {
    final seg = Float64List.fromList(Float64List.sublistView(swoosh, s, math.min(swoosh.length, s + block)));
    shaped.setAll(s, bandpass(seg, 2600 - 2000 * (s / swoosh.length), 1.8));
  }
  mix(o, shaped, 0, gain: 0.5);
  mix(o, glide(900, 300, 0.3, attack: 0.005, decay: 0.2), 0, gain: 0.15);
  mix(o, marimba(hz(c4), dur: 0.4), 0.3, gain: 0.55); // plop
  return trim(reverb(o, wet: 0.12));
}

/// Tray slots freed: two bubbly "bloops".
Float64List slotFree() {
  final o = buf(0.25);
  mix(o, glide(600, 1100, 0.08, attack: 0.003, decay: 0.05), 0, gain: 0.55);
  mix(o, glide(800, 1500, 0.08, attack: 0.003, decay: 0.05), 0.07, gain: 0.45);
  return trim(o);
}

/// Blocked tap: a soft comic "bonk".
Float64List thunk() {
  final o = buf(0.2);
  mix(o, woodblock(420, dur: 0.15), 0, gain: 0.9);
  mix(o, glide(260, 180, 0.12, attack: 0.002, decay: 0.05), 0, gain: 0.5);
  return trim(o);
}

/// Undo: the zip played backwards (descending).
Float64List undo() {
  final o = buf(0.3);
  mix(o, glide(1300, 500, 0.16, vib: 0.03, vibRate: 22, attack: 0.01, decay: 0.1), 0, gain: 0.3);
  var t = 0.12;
  for (var k = 0; k < 4; k++) {
    mix(o, woodblock(2400 - k * 250, dur: 0.03), t, gain: 0.4);
    t += 0.025;
  }
  return trim(o);
}

/// Hint: a three-note twinkle (G5 C6 E6).
Float64List hint() {
  final o = buf(1.2);
  for (final (i, n) in [g5, c6, e6].indexed) {
    mix(o, glock(hz(n), dur: 0.8), i * 0.08, gain: 0.35);
  }
  return trim(reverb(pad(o, 0.3), wet: 0.3));
}

/// One slot left: two soft marimba notes (a gentle heads-up).
Float64List trayWarn() {
  final o = buf(0.45);
  mix(o, marimba(hz(e5), dur: 0.3, vel: 0.6), 0, gain: 0.5);
  mix(o, marimba(hz(e5), dur: 0.3, vel: 0.6), 0.12, gain: 0.4);
  return trim(o);
}

/// The hook: G4 C5 E5 G5 on marimba with a glock double.
Float64List _hook({List<int> notes = const [g4, c5, e5, g5], double step = 0.085, double gain = 1}) {
  final o = buf(step * notes.length + 1.4);
  for (final (i, n) in notes.indexed) {
    final last = i == notes.length - 1;
    mix(o, marimba(hz(n), dur: last ? 1.2 : 0.6), i * step, gain: 0.55 * gain);
    mix(o, glock(hz(n + 12), dur: last ? 1.0 : 0.4), i * step, gain: 0.18 * gain);
  }
  return o;
}

/// Level start: "ready… go!" — a quick pickup into the hook's first note.
Float64List levelStart() {
  final o = buf(1.0);
  mix(o, _hook(notes: const [e4, g4, c5], step: 0.07), 0, gain: 0.9);
  final swoosh = buf(0.25);
  for (var i = 0; i < swoosh.length; i++) {
    swoosh[i] = noise() * math.sin(math.pi * i / swoosh.length);
  }
  mix(o, highpass(swoosh, 3000), 0, gain: 0.08);
  mix(o, clap(), 0.14, gain: 0.25);
  return trim(reverb(pad(o, 0.2), wet: 0.15));
}

/// Sheet cleared: "ta-da!" — the hook resolving onto a bright C chord.
Float64List success() {
  final o = buf(2.0);
  mix(o, _hook(), 0);
  mix(o, stab([c5, e5, g5, c6], dur: 0.5), 0.34, gain: 0.35);
  mix(o, kick(), 0.34, gain: 0.4);
  mix(o, hat(open: true), 0.34, gain: 0.2);
  return trim(reverb(pad(o, 0.3), wet: 0.22));
}

/// New best ("high score"): the hook climbing an octave, a big chord and a
/// sparkle run on top.
Float64List best() {
  final o = buf(2.8);
  mix(o, _hook(notes: const [g4, c5, e5, g5, c6, e6], step: 0.07), 0);
  const hit = 0.42;
  mix(o, stab([c5, e5, g5, c6], dur: 0.7), hit, gain: 0.4);
  mix(o, kick(), hit, gain: 0.5);
  mix(o, clap(), hit, gain: 0.3);
  for (final (i, n) in [c6, e6, g6, c7, g6, c7].indexed) {
    mix(o, glock(hz(n), dur: 0.5), hit + 0.08 + i * 0.05, gain: 0.14);
  }
  mix(o, highpass(noiseBurst(1.2, decay: 0.4), 7000), hit, gain: 0.15);
  return trim(reverb(pad(o, 0.4), wet: 0.28));
}

/// Tray full — the comic "wah-wah-waaah": a soft muted horn sliding down.
Float64List stuck() {
  final o = buf(1.7);
  final notes = [(g4, 0.22), (f4 + 1, 0.22), (f4, 0.22), (e4, 0.75)];
  var t = 0.0;
  for (final (n, len) in notes) {
    final last = n == e4;
    final tone = saw(hz(n), len + 0.05);
    mix(tone, saw(hz(n), len + 0.05, detune: 0.004), 0);
    // "Wah": a mute opening and closing over each note.
    final w = Float64List(tone.length);
    var y = 0.0;
    for (var i = 0; i < tone.length; i++) {
      final tt = i / sr;
      final open = math.sin(math.pi * math.min(1, tt / len));
      final vib = last ? 1 + 0.02 * math.sin(2 * math.pi * 6 * tt) : 1.0;
      final fc = (300 + 1100 * open) * vib;
      final a = 1 - math.exp(-2 * math.pi * fc / sr);
      y += a * (tone[i] - y);
      w[i] = y * expEnv(tt, 0.02, last ? 0.6 : 0.3) * (tt > len ? math.max(0, 1 - (tt - len) / 0.05) : 1);
    }
    mix(o, w, t, gain: 0.35);
    t += len;
  }
  return trim(reverb(pad(o, 0.3), wet: 0.2));
}

/// Coins: the classic bright two-note "bling".
Float64List coin() {
  final o = buf(0.6);
  mix(o, lowpass(shape(square(hz(b5), 0.08), (t) => t > 0.07 ? math.max(0, 1 - (t - 0.07) / 0.01) : 1), 6000), 0, gain: 0.18);
  mix(o, lowpass(shape(square(hz(e6), 0.45), (t) => expEnv(t, 0.002, 0.15)), 6000), 0.075, gain: 0.18);
  mix(o, glock(hz(e6 + 12), dur: 0.4), 0.075, gain: 0.15);
  return trim(o);
}

/// Extra tray slot: a power-up arpeggio up to a clink.
Float64List rescue() {
  final o = buf(1.0);
  for (final (i, n) in [c5, e5, g5, c6, e6].indexed) {
    mix(o, lowpass(shape(square(hz(n), 0.1, width: 0.25), (t) => expEnv(t, 0.002, 0.05)), 5000), i * 0.045, gain: 0.14);
    mix(o, glock(hz(n + 12), dur: 0.3), i * 0.045, gain: 0.1);
  }
  mix(o, clink(), 0.24, gain: 0.7);
  return trim(reverb(o, wet: 0.15));
}

/// Daily sheet done: the hook's first bar on glock, then a coin bling.
Float64List dailyDone() {
  final o = buf(2.0);
  for (final (i, n) in [g5, c6, e6, g6].indexed) {
    mix(o, glock(hz(n), dur: i == 3 ? 1.2 : 0.5), i * 0.09, gain: 0.4);
    mix(o, marimba(hz(n - 12), dur: 0.5), i * 0.09, gain: 0.35);
  }
  mix(o, coin(), 0.45, gain: 0.8);
  return trim(reverb(pad(o, 0.3), wet: 0.25));
}

/// Purchase: "cha-ching" — a register click, a bell and a sparkle.
Float64List purchase() {
  final o = buf(1.4);
  mix(o, woodblock(900, dur: 0.06), 0, gain: 0.5);
  mix(o, woodblock(1300, dur: 0.06), 0.06, gain: 0.5);
  mix(o, glock(hz(c6), dur: 1.0), 0.1, gain: 0.4);
  mix(o, glock(hz(g6), dur: 0.9), 0.14, gain: 0.3);
  mix(o, stab([c5, e5, g5], dur: 0.4), 0.1, gain: 0.25);
  for (final (k, n) in [c6, e6, g6, c7, e6 + 12].indexed) {
    mix(o, glock(hz(n), dur: 0.3), 0.2 + k * 0.04, gain: 0.1);
  }
  return trim(reverb(pad(o, 0.3), wet: 0.25));
}

/// Chapter complete: the chorus hook as a full little fanfare with drums.
Float64List chapterFanfare() {
  final o = buf(3.6);
  const beat = 60 / 124.0;
  const melody = [(0.0, g4, .5), (.5, c5, .5), (1.0, e5, .5), (1.5, g5, 1.0), (2.5, e5, .5), (3.0, g5, .5), (3.5, c6, 2.0)];
  for (final (b, n, len) in melody) {
    mix(o, marimba(hz(n), dur: len * beat + 0.6), b * beat, gain: 0.5);
    mix(o, glock(hz(n + 12), dur: len * beat + 0.4), b * beat, gain: 0.15);
  }
  for (final (b, notes) in const [(0.0, [c4, e4, g4]), (1.5, [c4, f4, a4]), (3.5, [c4, e4, g4, c5])]) {
    mix(o, stab([for (final n in notes) n + 12], dur: b == 3.5 ? 0.9 : 0.3), b * beat, gain: 0.3);
  }
  for (final b in [0.0, 1.0, 2.0, 3.0, 3.5]) {
    mix(o, kick(), b * beat, gain: 0.45);
  }
  for (final b in [1.0, 3.0]) {
    mix(o, clap(), b * beat, gain: 0.3);
  }
  for (var k = 0; k < 4; k++) {
    mix(o, tom(220 - k * 30.0), (2.5 + k * 0.25) * beat, gain: 0.3);
  }
  mix(o, highpass(noiseBurst(1.6, decay: 0.5), 7000), 3.5 * beat, gain: 0.18);
  return trim(reverb(pad(o, 0.4), wet: 0.25));
}

// ================================================================= song

/// "Workshop" — upbeat & playful. 124 BPM, C major, 32 bars:
/// Chorus · Verse · Chorus (bigger) · Verse (break). The hook comes first.
class Song {
  static const bpm = 124.0;
  static const beat = 60 / bpm;
  static const bar = 4 * beat;
  static const bars = 32;

  final _len = bars * bar + 3;
  late final lead = buf(_len), glockBus = buf(_len), stabL = buf(_len), stabR = buf(_len);
  late final bassBus = buf(_len), kickBus = buf(_len), clapBus = buf(_len), hatBus = buf(_len);
  late final shakerBus = buf(_len), arp = buf(_len), fx = buf(_len);
  final List<double> _kicks = [];

  (Float64List, Float64List) render() {
    _chorus(0, big: false);
    _verse(8, breakdown: false);
    _chorus(16, big: true);
    _verse(24, breakdown: true);

    // Sidechain pump: chords and bass duck on every kick (wrapping at the
    // loop point so the pump is continuous at the seam).
    final n = (bars * bar * sr).round();
    final duck = Float64List(kickBus.length)..fillRange(0, kickBus.length, 1);
    for (final t in _kicks) {
      final s = (t * sr).round();
      final w = (0.22 * sr).round();
      for (var i = 0; i < w; i++) {
        final x = i / w;
        final j = s + i;
        final g = 0.5 + 0.5 * x * x;
        if (j < duck.length) duck[j] = math.min(duck[j], g);
        if (j + n < duck.length) duck[j + n] = math.min(duck[j + n], g);
      }
    }
    for (final bus in [stabL, stabR, bassBus, arp]) {
      for (var i = 0; i < bus.length; i++) {
        bus[i] *= duck[i];
      }
    }

    final l = buf(_len), r = buf(_len);
    void pan(Float64List src, double p, double gain) {
      final gl = math.cos((p + 1) * math.pi / 4) * gain, gr = math.sin((p + 1) * math.pi / 4) * gain;
      for (var i = 0; i < src.length; i++) {
        l[i] += src[i] * gl;
        r[i] += src[i] * gr;
      }
    }

    // Lead in the middle with a stereo room around it.
    final leadDry = lead;
    pan(leadDry, 0, 0.6);
    pan(reverb(lead, wet: 1, seed: 1), -0.8, 0.14);
    pan(reverb(lead, wet: 1, seed: 2), 0.8, 0.14);
    pan(reverb(glockBus, wet: 0.35, seed: 3), 0.35, 0.5);
    pan(reverb(arp, wet: 0.25, seed: 8), -0.35, 0.5);
    pan(reverb(stabL, wet: 0.15, seed: 4), -0.6, 0.5);
    pan(reverb(stabR, wet: 0.15, seed: 5), 0.6, 0.5);
    pan(lowpass(bassBus, 1600), 0, 0.8);
    pan(kickBus, 0, 0.9);
    pan(reverb(clapBus, wet: 0.2, seed: 6), 0.05, 0.55);
    pan(hatBus, 0.35, 0.45);
    pan(shakerBus, -0.4, 0.4);
    pan(reverb(fx, wet: 0.3, seed: 7), 0.2, 0.55);

    // Fold the tail onto the start → seamless loop.
    final ll = Float64List(n), rr = Float64List(n);
    for (var i = 0; i < l.length; i++) {
      ll[i % n] += l[i];
      rr[i % n] += r[i];
    }
    return _glue(ll, rr);
  }

  void _note(Float64List bus, Float64List src, double beats, {double gain = 1}) => mix(bus, src, beats * beat, gain: gain);

  // Chorus: C G Am F | C G F C — the hook on marimba.
  static const _chorusChords = [
    [c4, e4, g4], [b4 - 12, d4, g4], [a4 - 12, c4, e4], [a4 - 12, c4, f4], //
    [c4, e4, g4], [b4 - 12, d4, g4], [a4 - 12, c4, f4], [c4, e4, g4],
  ];
  static const _chorusRoots = [36, 43, 45, 41, 36, 43, 41, 36];
  static const _hookMelody = <(double, int, double)>[
    (0, g4, .5), (.5, c5, .5), (1, e5, .5), (1.5, g5, 1), (2.5, e5, .5), (3, g5, 1),
    (4, f5, .5), (4.5, e5, .5), (5, d5, .5), (5.5, b4, .5), (6, d5, 1.5),
    (8, a4, .5), (8.5, c5, .5), (9, e5, .5), (9.5, a5, 1), (10.5, g5, .5), (11, e5, 1),
    (12, f5, .5), (12.5, e5, .5), (13, d5, .5), (13.5, c5, .5), (14, d5, .5), (14.5, e5, 1.5),
    (16, g4, .5), (16.5, c5, .5), (17, e5, .5), (17.5, g5, 1), (18.5, e5, .5), (19, g5, 1),
    (20, f5, .5), (20.5, e5, .5), (21, d5, .5), (21.5, b4, .5), (22, d5, 1.5),
    (24, a5, .5), (24.5, g5, .5), (25, f5, .5), (25.5, e5, .5), (26, f5, .5), (26.5, a5, 1), (27.5, g5, .5),
    (28, e5, .5), (28.5, d5, .5), (29, c5, 2),
  ];

  void _chorus(int startBar, {required bool big}) {
    final s = startBar * 4.0;
    for (final (b, n, len) in _hookMelody) {
      _note(lead, marimba(hz(n), dur: len * beat + 0.5), s + b, gain: 0.6);
      if (big) _note(glockBus, glock(hz(n + 12), dur: len * beat + 0.4), s + b, gain: 0.2);
    }
    for (var k = 0; k < 8; k++) {
      final b0 = s + k * 4;
      final chord = _chorusChords[k];
      // Offbeat stabs, alternating sides for a bouncy stereo picture.
      for (final (i, off) in [0.5, 1.5, 2.5, 3.5].indexed) {
        _note(i.isEven ? stabL : stabR, stab([for (final n in chord) n + 12]), b0 + off, gain: 0.3);
      }
      // Octave-bounce bass in eighths.
      final r = _chorusRoots[k];
      for (var e = 0; e < 8; e++) {
        _note(bassBus, bass(hz(r + (e.isOdd ? 12 : 0)), beat * 0.45), b0 + e * 0.5, gain: 0.5);
      }
      // Four-on-the-floor, claps on 2 & 4, hats on the offbeats.
      for (var q = 0; q < 4; q++) {
        _note(kickBus, kick(), b0 + q, gain: 0.9);
        _kicks.add((b0 + q) * beat);
      }
      for (final q in [1.0, 3.0]) {
        _note(clapBus, clap(), b0 + q, gain: 0.55);
      }
      for (var e = 0; e < 8; e++) {
        _note(hatBus, hat(open: e.isOdd && big), b0 + e * 0.5, gain: e.isOdd ? 0.22 : 0.12);
      }
      if (big) {
        for (var x = 0; x < 16; x++) {
          _note(shakerBus, shaker(), b0 + x * 0.25, gain: x.isOdd ? 0.12 : 0.07);
        }
      }
      // Bar 8: a tom run and a slide-whistle up into the next section.
      if (k == 7) {
        for (var x = 0; x < 4; x++) {
          _note(fx, tom(240 - x * 35.0), b0 + 2 + x * 0.5, gain: 0.35);
        }
        _note(fx, glide(hz(c5), hz(c6), beat * 1.2, vib: 0.01, attack: 0.05), b0 + 2.8, gain: 0.12);
      }
    }
  }

  // Verse: F G Em Am | Dm G C G — pizzicato call-and-response.
  static const _verseChords = [
    [a4 - 12, c4, f4], [b4 - 12, d4, g4], [b4 - 12, e4, g4], [a4 - 12, c4, e4], //
    [a4 - 12, d4, f4], [b4 - 12, d4, g4], [c4, e4, g4], [b4 - 12, d4, g4],
  ];
  static const _verseRoots = [41, 43, 40, 45, 38, 43, 36, 43];
  static const _verseMelody = <(double, int, double)>[
    (0, a4, .5), (.5, c5, .5), (1, f5, 1), (2.5, e5, .5), (3, f5, .5),
    (4, d5, .5), (4.5, b4, .5), (5, g4, 1), (7, d5, .5), (7.5, e5, .5),
    (8, g5, .5), (8.5, e5, .5), (9, b4, 1), (10.5, e5, .5), (11, g5, .5),
    (12, a5, 1), (13, g5, .5), (13.5, e5, .5), (14, c5, 1.5),
    (16, f5, .5), (16.5, d5, .5), (17, a4, 1), (18.5, d5, .5), (19, f5, .5),
    (20, g5, 1), (21, f5, .5), (21.5, d5, .5), (22, b4, 1.5),
    (24, c5, .5), (24.5, e5, .5), (25, g5, .5), (25.5, c6, 1), (27, b5, .5), (27.5, g5, .5),
    (28, d5, .5), (28.5, g5, .5), (29, b5, .5), (29.5, d6, 1.5),
  ];

  void _verse(int startBar, {required bool breakdown}) {
    final s = startBar * 4.0;
    for (final (b, n, len) in _verseMelody) {
      _note(lead, pluck(hz(n), dur: len * beat + 0.4), s + b, gain: breakdown ? 0.55 : 0.7);
      if (breakdown) _note(glockBus, glock(hz(n + 12), dur: len * beat + 0.3), s + b, gain: 0.16);
    }
    for (var k = 0; k < 8; k++) {
      final b0 = s + k * 4;
      final chord = _verseChords[k];
      for (final (i, off) in [1.5, 3.5].indexed) {
        _note(i.isEven ? stabL : stabR, stab([for (final n in chord) n + 12], dur: 0.12), b0 + off, gain: 0.24);
      }
      // A soft marimba arpeggio keeps the bounce under the pizz lead.
      for (var x = 0; x < 4; x++) {
        _note(arp, marimba(hz(chord[x % chord.length] + 12), dur: 0.35, vel: 0.5), b0 + x + 0.25, gain: 0.22);
      }
      final r = _verseRoots[k];
      for (final (b, n) in [(0.0, r), (1.0, r + 12), (2.0, r + 7), (3.0, r + 12)]) {
        _note(bassBus, bass(hz(n), beat * 0.4), b0 + b, gain: breakdown ? 0.32 : 0.45);
      }
      // Lighter groove; the break thins the kick out.
      for (final q in breakdown ? [0.0, 2.0] : [0.0, 1.5, 2.0]) {
        _note(kickBus, kick(), b0 + q, gain: 0.8);
        _kicks.add((b0 + q) * beat);
      }
      for (final q in [1.0, 3.0]) {
        _note(clapBus, breakdown ? snap() : clap(), b0 + q, gain: breakdown ? 0.4 : 0.45);
      }
      for (var e = 0; e < 8; e++) {
        _note(hatBus, hat(), b0 + e * 0.5, gain: e.isOdd ? 0.16 : 0.09);
      }
      if (k == 7) {
        _note(fx, glide(hz(g4), hz(g5), beat * 1.5, vib: 0.012, attack: 0.05), b0 + 2.5, gain: 0.12);
        for (final (x, n) in [c6, d6, e6, g6, c7, e6 + 12].indexed) {
          _note(fx, glock(hz(n), dur: 0.25), b0 + 3 + x * 0.16, gain: 0.08);
        }
      }
    }
  }

  /// Bus compressor, run over two laps of the loop (keeping the second) so
  /// its envelope is continuous at the seam, then a soft-knee limiter.
  (Float64List, Float64List) _glue(Float64List l, Float64List r) {
    final n = l.length;
    var env = 0.0;
    final att = math.exp(-1 / (0.005 * sr)), rel = math.exp(-1 / (0.12 * sr));
    var peakIn = 1e-9;
    for (var i = 0; i < n; i++) {
      peakIn = math.max(peakIn, math.max(l[i].abs(), r[i].abs()));
    }
    final threshold = peakIn * 0.4;
    const ratio = 3.0;
    final ol = Float64List(n), or = Float64List(n);
    for (var lap = 0; lap < 2; lap++) {
      for (var i = 0; i < n; i++) {
        final x = math.max(l[i].abs(), r[i].abs());
        env = x > env ? att * env + (1 - att) * x : rel * env + (1 - rel) * x;
        final g = env > threshold ? math.pow(env / threshold, 1 / ratio - 1).toDouble() : 1.0;
        if (lap == 1) {
          ol[i] = l[i] * g;
          or[i] = r[i] * g;
        }
      }
    }
    var peak = 1e-9;
    for (var i = 0; i < n; i++) {
      peak = math.max(peak, math.max(ol[i].abs(), or[i].abs()));
    }
    final gain = math.pow(10, -1 / 20) / peak * 1.15; // drive the limiter a touch
    double soft(double v) => v.abs() < 0.75 ? v : v.sign * (0.75 + 0.2 * (1 - math.exp(-(v.abs() - 0.75) * 5)));
    for (var i = 0; i < n; i++) {
      ol[i] = soft(ol[i] * gain);
      or[i] = soft(or[i] * gain);
    }
    return (ol, or);
  }
}
