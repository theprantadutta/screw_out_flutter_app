// Synthesises every Screw Out sound effect and the music loop.
//
//   dart run tool/generate_audio.dart          → assets/audio/*.wav
//
// Pure Dart, deterministic (seeded noise): re-running produces identical
// files, and every sound is ours (no licensing). The whole palette is built
// around one motif — D5 F#5 A5 B5 (a rising "screw out" arpeggio) in
// D-major pentatonic — so the game's sound is recognisable: it opens the
// sheet, resolves a clear, lifts for a new best and crowns a chapter.
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

const sr = 44100; // SFX sample rate
const musicSr = 32000; // music: smaller asset, still clean (lo-fi by design)

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
    // 30 Hz high-pass removes DC / sub-rumble before levelling.
    final samples = master(highpass(e.value(), 30), peakDb: e.key == 'sfx_thunk' ? -12 : -6);
    writeWav('${out.path}/${e.key}.wav', samples, sr);
    stdout.writeln('${e.key.padRight(18)} ${(samples.length / sr * 1000).round()} ms');
  }
  final music = master(musicLoop(), peakDb: -9);
  writeWav('${out.path}/music_workshop.wav', music, musicSr);
  stdout.writeln('music_workshop     ${(music.length / musicSr).toStringAsFixed(1)} s');
}

// =================================================================== notes

double hz(int midi) => 440.0 * math.pow(2, (midi - 69) / 12);

// D-major pentatonic + friends, as MIDI numbers.
const a3 = 57, d4 = 62, e4 = 64, fs4 = 66, g4 = 67, a4 = 69, b4 = 71, cs5 = 73;
const d5 = 74, e5 = 76, fs5 = 78, g5 = 79, a5 = 81, b5 = 83, d6 = 86, e6 = 88, fs6 = 90, a6 = 93;

// ============================================================ primitives

final _rng = math.Random(1904);
double noise() => _rng.nextDouble() * 2 - 1;

Float64List buf(double seconds, [int rate = sr]) => Float64List((seconds * rate).ceil());

/// Adds [src] into [dst] at [atSeconds] with [gain].
void mix(Float64List dst, Float64List src, double atSeconds, {double gain = 1, int rate = sr}) {
  final start = (atSeconds * rate).round();
  for (var i = 0; i < src.length; i++) {
    final j = start + i;
    if (j >= 0 && j < dst.length) dst[j] += src[i] * gain;
  }
}

/// Exponential decay envelope with a short linear attack.
double env(double t, {double attack = 0.002, double decay = 0.3}) {
  if (t < attack) return t / attack;
  return math.exp(-(t - attack) / decay);
}

/// FM bell / mallet: inharmonic modulator ratio gives the metal.
Float64List bell(double f, double dur, {double ratio = 3.5, double index = 4, double decay = 0.45, int rate = sr}) {
  final o = buf(dur, rate);
  for (var i = 0; i < o.length; i++) {
    final t = i / rate;
    final e = env(t, attack: 0.001, decay: decay);
    final idx = index * math.exp(-t / (decay * 0.35));
    final mod = math.sin(2 * math.pi * f * ratio * t) * idx;
    o[i] = math.sin(2 * math.pi * f * t + mod) * e;
  }
  return o;
}

/// Soft electric keys (FM 1:1, gentle index, slow tremolo).
Float64List keys(double f, double dur, {double decay = 1.2, int rate = musicSr}) {
  final o = buf(dur, rate);
  for (var i = 0; i < o.length; i++) {
    final t = i / rate;
    final e = env(t, attack: 0.006, decay: decay);
    final idx = 1.2 * math.exp(-t / 0.35) + 0.25;
    final trem = 1 - 0.12 * (0.5 + 0.5 * math.sin(2 * math.pi * 4.5 * t));
    o[i] = (math.sin(2 * math.pi * f * t + idx * math.sin(2 * math.pi * f * t)) +
            0.18 * math.sin(2 * math.pi * f * 2.001 * t)) *
        e *
        trem;
  }
  return o;
}

/// Karplus–Strong plucked string.
Float64List pluck(double f, double dur, {double damping = 0.996, double bright = 0.5, int rate = sr}) {
  final o = buf(dur, rate);
  final n = (rate / f).round().clamp(2, 100000);
  final line = Float64List(n);
  for (var i = 0; i < n; i++) {
    line[i] = noise();
  }
  // Pre-filter the burst: darker excitation = warmer pluck.
  for (var i = 1; i < n; i++) {
    line[i] = line[i] * bright + line[i - 1] * (1 - bright);
  }
  var p = 0;
  for (var i = 0; i < o.length; i++) {
    final next = (p + 1) % n;
    final v = line[p];
    line[p] = damping * 0.5 * (line[p] + line[next]);
    o[i] = v;
    p = next;
  }
  return o;
}

/// Pitched sine with exponential glide [f0] → [f1].
Float64List sweep(double f0, double f1, double dur, {double decay = 0.1, double attack = 0.001, int rate = sr}) {
  final o = buf(dur, rate);
  var phase = 0.0;
  for (var i = 0; i < o.length; i++) {
    final t = i / rate;
    final f = f0 * math.pow(f1 / f0, t / dur);
    phase += 2 * math.pi * f / rate;
    o[i] = math.sin(phase) * env(t, attack: attack, decay: decay);
  }
  return o;
}

/// Noise burst, band-limited by [bandpass].
Float64List noiseBurst(double dur, {double decay = 0.03, double center = 3000, double q = 1.5, int rate = sr}) {
  final o = buf(dur, rate);
  for (var i = 0; i < o.length; i++) {
    o[i] = noise() * env(i / rate, attack: 0.0005, decay: decay);
  }
  return bandpass(o, center, q, rate);
}

/// Inharmonic metal partials (clink / ping).
Float64List metal(double base, double dur, {List<double> ratios = const [1, 1.58, 2.31, 3.17], double decay = 0.12, int rate = sr}) {
  final o = buf(dur, rate);
  for (var i = 0; i < o.length; i++) {
    final t = i / rate;
    var v = 0.0;
    for (var k = 0; k < ratios.length; k++) {
      v += math.sin(2 * math.pi * base * ratios[k] * t) * math.exp(-t / (decay / (1 + k * 0.6))) / (k + 1);
    }
    o[i] = v * env(t, attack: 0.0008, decay: 10);
  }
  return o;
}

// ------------------------------------------------------------- filters

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

Float64List lowpass(Float64List x, double fc, [double q = 0.707, int rate = sr]) {
  final w = 2 * math.pi * fc / rate, alpha = math.sin(w) / (2 * q), c = math.cos(w), a0 = 1 + alpha;
  return _biquad(x, (1 - c) / 2 / a0, (1 - c) / a0, (1 - c) / 2 / a0, -2 * c / a0, (1 - alpha) / a0);
}

Float64List highpass(Float64List x, double fc, [double q = 0.707, int rate = sr]) {
  final w = 2 * math.pi * fc / rate, alpha = math.sin(w) / (2 * q), c = math.cos(w), a0 = 1 + alpha;
  return _biquad(x, (1 + c) / 2 / a0, -(1 + c) / a0, (1 + c) / 2 / a0, -2 * c / a0, (1 - alpha) / a0);
}

Float64List bandpass(Float64List x, double fc, [double q = 1, int rate = sr]) {
  final w = 2 * math.pi * fc / rate, alpha = math.sin(w) / (2 * q), c = math.cos(w), a0 = 1 + alpha;
  return _biquad(x, alpha / a0, 0, -alpha / a0, -2 * c / a0, (1 - alpha) / a0);
}

/// Small Schroeder room: 4 combs + 2 allpasses. [wet] 0…1.
Float64List reverb(Float64List x, {double wet = 0.2, double size = 1, int rate = sr}) {
  final combDelays = [1557, 1617, 1491, 1422].map((d) => (d * size * rate / 44100).round()).toList();
  final y = Float64List(x.length);
  for (final d in combDelays) {
    final line = Float64List(d);
    var p = 0;
    for (var i = 0; i < x.length; i++) {
      final out = line[p];
      line[p] = x[i] + out * 0.78;
      y[i] += out * 0.25;
      p = (p + 1) % d;
    }
  }
  var z = y;
  for (final d in [225, 556].map((d) => (d * rate / 44100).round())) {
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
  final out = Float64List(x.length);
  for (var i = 0; i < x.length; i++) {
    out[i] = x[i] * (1 - wet) + z[i] * wet;
  }
  return out;
}

/// Pads with silence so reverb tails have room.
Float64List pad(Float64List x, double seconds, [int rate = sr]) {
  final o = Float64List(x.length + (seconds * rate).round());
  o.setAll(0, x);
  return o;
}

/// Trims trailing near-silence and fades the last 8 ms.
Float64List trim(Float64List x, [int rate = sr]) {
  var end = x.length;
  while (end > 1 && x[end - 1].abs() < 1e-4) {
    end--;
  }
  final o = Float64List.sublistView(x, 0, end);
  final f = (0.008 * rate).round();
  for (var i = 0; i < f && i < o.length; i++) {
    o[o.length - 1 - i] *= i / f;
  }
  return Float64List.fromList(o);
}

/// Normalises to [peakDb] dBFS with a gentle soft clip (SFX ≤ −6 dBFS).
Float64List master(Float64List x, {double peakDb = -6}) {
  var peak = 1e-9;
  for (final v in x) {
    peak = math.max(peak, v.abs());
  }
  final target = math.pow(10, peakDb / 20).toDouble();
  final g = target / peak;
  return Float64List.fromList([for (final v in x) _soft(v * g / target) * target]);
}

double _soft(double v) => v.abs() < 0.9 ? v : v.sign * (0.9 + 0.1 * (1 - math.exp(-(v.abs() - 0.9) * 10)));

void writeWav(String path, Float64List samples, int rate) {
  final data = ByteData(44 + samples.length * 2);
  void str(int o, String s) {
    for (var i = 0; i < s.length; i++) {
      data.setUint8(o + i, s.codeUnitAt(i));
    }
  }

  str(0, 'RIFF');
  data.setUint32(4, 36 + samples.length * 2, Endian.little);
  str(8, 'WAVE');
  str(12, 'fmt ');
  data
    ..setUint32(16, 16, Endian.little)
    ..setUint16(20, 1, Endian.little) // PCM
    ..setUint16(22, 1, Endian.little) // mono
    ..setUint32(24, rate, Endian.little)
    ..setUint32(28, rate * 2, Endian.little)
    ..setUint16(32, 2, Endian.little)
    ..setUint16(34, 16, Endian.little);
  str(36, 'data');
  data.setUint32(40, samples.length * 2, Endian.little);
  for (var i = 0; i < samples.length; i++) {
    data.setInt16(44 + i * 2, (samples[i].clamp(-1.0, 1.0) * 32767).round(), Endian.little);
  }
  File(path).writeAsBytesSync(data.buffer.asUint8List());
}

// ======================================================= sound effects

/// UI tap: a tiny dry click.
Float64List tick() {
  final o = buf(0.05);
  mix(o, sweep(2400, 1800, 0.05, decay: 0.008), 0, gain: 0.7);
  mix(o, noiseBurst(0.03, decay: 0.004, center: 4500, q: 2), 0, gain: 0.5);
  return trim(o);
}

/// Toggle: two-step click (latch).
Float64List toggle() {
  final o = buf(0.09);
  mix(o, tick(), 0, gain: 0.8);
  mix(o, sweep(1600, 1400, 0.04, decay: 0.008), 0.045, gain: 0.5);
  return trim(o);
}

/// Unscrew: an accelerating ratchet + a rising metallic squeak.
Float64List unscrew() {
  final o = buf(0.32);
  var t = 0.0;
  for (var k = 0; k < 5; k++) {
    mix(o, noiseBurst(0.02, decay: 0.004, center: 3200 + k * 250, q: 3), t, gain: 0.55);
    mix(o, metal(1900 + k * 120, 0.04, decay: 0.012), t, gain: 0.25);
    t += 0.045 - k * 0.006;
  }
  mix(o, sweep(700, 1150, 0.16, decay: 0.07, attack: 0.02), 0.13, gain: 0.32);
  return trim(reverb(o, wet: 0.08));
}

/// Clink: a screw seating into a tray slot.
Float64List clink() {
  final o = buf(0.3);
  mix(o, metal(2100, 0.3, decay: 0.1), 0, gain: 0.6);
  mix(o, metal(2900, 0.2, decay: 0.05), 0.035, gain: 0.3);
  mix(o, noiseBurst(0.015, decay: 0.003, center: 6000, q: 2), 0, gain: 0.3);
  return trim(reverb(pad(o, 0.15), wet: 0.12));
}

/// Plate release: a soft lift, then a wooden slide away.
Float64List panelSlide() {
  final o = buf(0.55);
  // Slide: band-passed noise whose centre falls as the plate drops.
  final slide = buf(0.45);
  for (var i = 0; i < slide.length; i++) {
    final t = i / sr;
    slide[i] = noise() * math.sin(math.pi * math.min(1, t / 0.45)) * 0.9;
  }
  var shaped = Float64List(slide.length);
  const block = 512;
  for (var s = 0; s < slide.length; s += block) {
    final t = s / sr;
    final seg = Float64List.sublistView(slide, s, math.min(slide.length, s + block));
    final f = bandpass(Float64List.fromList(seg), 1400 - 900 * (t / 0.45), 2.5);
    shaped.setAll(s, f);
  }
  shaped = lowpass(shaped, 3500);
  mix(o, shaped, 0.04, gain: 0.5);
  mix(o, sweep(220, 140, 0.12, decay: 0.05), 0, gain: 0.35); // lift knock
  mix(o, pluck(hz(a3), 0.35, damping: 0.99, bright: 0.3), 0, gain: 0.25); // woody body
  return trim(reverb(o, wet: 0.15));
}

/// Tray slots freed: a light double pop.
Float64List slotFree() {
  final o = buf(0.18);
  mix(o, sweep(1100, 1500, 0.06, decay: 0.02), 0, gain: 0.5);
  mix(o, sweep(1400, 1900, 0.06, decay: 0.02), 0.055, gain: 0.4);
  return trim(o);
}

/// Blocked tap: a muted low thunk (mixed −12 dB).
Float64List thunk() {
  final o = buf(0.16);
  mix(o, sweep(140, 70, 0.14, decay: 0.035), 0, gain: 0.9);
  mix(o, lowpass(noiseBurst(0.05, decay: 0.01, center: 800, q: 0.8), 900), 0, gain: 0.4);
  return trim(o);
}

/// Undo: the ratchet run backwards (descending).
Float64List undo() {
  final o = buf(0.24);
  var t = 0.0;
  for (var k = 0; k < 4; k++) {
    mix(o, noiseBurst(0.02, decay: 0.004, center: 3600 - k * 300, q: 3), t, gain: 0.5);
    t += 0.03 + k * 0.008;
  }
  mix(o, sweep(1000, 650, 0.12, decay: 0.05, attack: 0.01), 0.06, gain: 0.28);
  return trim(o);
}

/// Hint: a quiet two-bell chime (D6 + A6).
Float64List hint() {
  final o = buf(0.9);
  mix(o, bell(hz(d6), 0.9, decay: 0.35, index: 2), 0, gain: 0.35);
  mix(o, bell(hz(a6), 0.8, decay: 0.3, index: 1.5), 0.09, gain: 0.25);
  return trim(reverb(pad(o, 0.3), wet: 0.3));
}

/// Last free slot: two soft amber ticks (subtle, no alarm).
Float64List trayWarn() {
  final o = buf(0.2);
  mix(o, bell(hz(e6), 0.12, decay: 0.04, index: 1), 0, gain: 0.35);
  mix(o, bell(hz(e6), 0.12, decay: 0.04, index: 1), 0.09, gain: 0.25);
  return trim(o);
}

/// Start of a sheet: pickup A4 → D5 plucks under a soft rising whoosh.
Float64List levelStart() {
  final o = buf(0.8);
  final whoosh = buf(0.3);
  for (var i = 0; i < whoosh.length; i++) {
    final t = i / sr;
    whoosh[i] = noise() * math.sin(math.pi * t / 0.3);
  }
  mix(o, lowpass(highpass(whoosh, 900), 4000), 0, gain: 0.15);
  mix(o, pluck(hz(a4), 0.5, bright: 0.6), 0.08, gain: 0.5);
  mix(o, pluck(hz(d5), 0.6, bright: 0.6), 0.2, gain: 0.55);
  mix(o, bell(hz(d6), 0.5, decay: 0.2, index: 1.5), 0.2, gain: 0.18);
  return trim(reverb(pad(o, 0.3), wet: 0.2));
}

/// The motif on bells: D5 F#5 A5 then a landing note.
Float64List _motif(List<int> notes, {double step = 0.075, double decay = 0.5, double gain = 0.5}) {
  final o = buf(step * notes.length + 1.2);
  for (var k = 0; k < notes.length; k++) {
    final last = k == notes.length - 1;
    mix(o, bell(hz(notes[k]), last ? 1.1 : 0.6, decay: last ? decay * 1.6 : decay, index: 2.5), k * step, gain: gain);
    mix(o, pluck(hz(notes[k] - 12), 0.5, bright: 0.5), k * step, gain: gain * 0.35);
  }
  return o;
}

/// Sheet cleared: the motif, resolved (< 700 ms of body).
Float64List success() {
  final o = _motif(const [d5, fs5, a5, d6]);
  return trim(reverb(pad(o, 0.4), wet: 0.25));
}

/// New best / mastery ◆ ("high score"): motif up an octave + sparkle.
Float64List best() {
  final o = buf(2.2);
  mix(o, _motif(const [d5, fs5, a5, b5, d6], step: 0.07), 0, gain: 0.9);
  for (var k = 0; k < 6; k++) {
    mix(o, bell(hz([d6, fs6, a6, d6 + 12, a6, fs6 + 12][k]), 0.4, decay: 0.12, index: 1), 0.36 + k * 0.05, gain: 0.12);
  }
  return trim(reverb(pad(o, 0.4), wet: 0.3));
}

/// Tray full ("game over", kept gentle): a soft descending sigh A4 → E4.
Float64List stuck() {
  final o = buf(1.1);
  mix(o, bell(hz(a4), 0.7, decay: 0.3, index: 1.5), 0, gain: 0.4);
  mix(o, bell(hz(e4), 0.9, decay: 0.45, index: 1.2), 0.18, gain: 0.45);
  mix(o, sweep(150, 90, 0.25, decay: 0.08), 0.18, gain: 0.25);
  return trim(reverb(pad(o, 0.3), wet: 0.25));
}

/// Coins counted: a bright two-note B6 → E7 ping.
Float64List coin() {
  final o = buf(0.5);
  mix(o, bell(hz(b5 + 12), 0.25, decay: 0.07, index: 3, ratio: 2), 0, gain: 0.35);
  mix(o, bell(hz(e6 + 12), 0.45, decay: 0.18, index: 3, ratio: 2), 0.06, gain: 0.4);
  return trim(reverb(pad(o, 0.2), wet: 0.15));
}

/// Extra tray slot: a rising power-up glide that lands on a clink.
Float64List rescue() {
  final o = buf(0.8);
  mix(o, sweep(300, 1200, 0.3, decay: 0.2, attack: 0.03), 0, gain: 0.3);
  mix(o, clink(), 0.28, gain: 0.8);
  mix(o, bell(hz(a5), 0.4, decay: 0.2, index: 2), 0.28, gain: 0.2);
  return trim(reverb(o, wet: 0.15));
}

/// Daily sheet done: motif variant ending on the sixth + a coin.
Float64List dailyDone() {
  final o = buf(1.8);
  mix(o, _motif(const [a4, d5, fs5, b5], step: 0.08), 0, gain: 0.9);
  mix(o, coin(), 0.42, gain: 0.7);
  return trim(reverb(pad(o, 0.3), wet: 0.28));
}

/// Purchase: a sparkle run over a warm chord.
Float64List purchase() {
  final o = buf(1.3);
  for (final n in [d5, fs5, a5]) {
    mix(o, keys(hz(n), 1.0, decay: 0.5, rate: sr), 0, gain: 0.18);
  }
  for (var k = 0; k < 5; k++) {
    mix(o, bell(hz([a5, d6, e6, fs6, a6][k]), 0.4, decay: 0.12, index: 1.5), 0.05 + k * 0.045, gain: 0.16);
  }
  return trim(reverb(pad(o, 0.3), wet: 0.3));
}

/// Chapter complete: a short fanfare — motif harmonised, kick, cymbal-ish air.
Float64List chapterFanfare() {
  final o = buf(3.2);
  const step = 0.16;
  final melody = [d5, fs5, a5, b5, a5, d6];
  for (var k = 0; k < melody.length; k++) {
    final last = k == melody.length - 1;
    mix(o, bell(hz(melody[k]), last ? 1.8 : 0.5, decay: last ? 0.9 : 0.3, index: 2.5), k * step, gain: 0.45);
  }
  // Chords under it.
  for (final (t, chord) in [(0.0, [d4, fs4, a4]), (step * 3, [g4, b4, d5]), (step * 5, [d4, a4, d5, fs5])]) {
    for (final n in chord) {
      mix(o, keys(hz(n), 1.6, decay: 0.7, rate: sr), t, gain: 0.16);
    }
  }
  mix(o, sweep(110, 45, 0.3, decay: 0.12), 0, gain: 0.6);
  mix(o, sweep(110, 45, 0.3, decay: 0.12), step * 5, gain: 0.7);
  final air = buf(1.4);
  for (var i = 0; i < air.length; i++) {
    air[i] = noise() * env(i / sr, attack: 0.002, decay: 0.4);
  }
  mix(o, highpass(air, 6000), step * 5, gain: 0.12);
  return trim(reverb(pad(o, 0.5), wet: 0.3));
}

// ============================================================== music

/// "Workshop" — a lo-fi loop, 90 BPM, 16 bars (I–vi–IV–V in D), the motif
/// as the hook. Rendered with a reverb tail folded back to the start so it
/// loops seamlessly.
Float64List musicLoop() {
  const bpm = 90.0;
  const beat = 60 / bpm;
  const bars = 16;
  final loopLen = bars * 4 * beat;
  final total = buf(loopLen + 3, musicSr);

  // Chords per bar (8-bar progression played twice).
  final chords = <List<int>>[
    [50, 54, 57, 61, 64], // Dmaj9
    [47, 50, 54, 57], // Bm7
    [43, 47, 50, 54], // Gmaj7
    [45, 49, 52, 54], // A6
    [50, 54, 57, 61, 64],
    [47, 50, 54, 57],
    [43, 47, 50, 54],
    [45, 49, 52, 55], // A7
  ];
  final roots = [38, 35, 31, 33, 38, 35, 31, 33];

  final keysBus = buf(loopLen + 3, musicSr);
  final bassBus = buf(loopLen + 3, musicSr);
  final drums = buf(loopLen + 3, musicSr);
  final lead = buf(loopLen + 3, musicSr);

  double swing(double b) => (b % 1) == 0.5 ? b + 0.08 : b; // lazy 8ths

  for (var bar = 0; bar < bars; bar++) {
    final c = chords[bar % 8];
    final t0 = bar * 4 * beat;
    // Keys: syncopated stabs on 1, the "and" of 2, and 4.
    for (final b in [0.0, 1.5, 3.0]) {
      for (final n in c) {
        mix(keysBus, keys(hz(n), beat * (b == 3.0 ? 1.2 : 1.6), decay: 0.9), t0 + swing(b) * beat, gain: 0.11, rate: musicSr);
      }
    }
    // Bass: root on 1, fifth on the "and" of 2, octave on the "and" of 3.
    final r = roots[bar % 8];
    for (final (b, n, len) in [(0.0, r, 1.4), (1.5, r + 7, 0.9), (2.5, r + 12, 0.6), (3.0, r, 0.9)]) {
      mix(bassBus, pluck(hz(n), len * beat * 1.3, damping: 0.995, bright: 0.25, rate: musicSr), t0 + swing(b) * beat, gain: 0.5, rate: musicSr);
    }
    // Drums: boom-bap kick / rim / swung hats; drop the kick in bar 8 & 16.
    final fill = bar % 8 == 7;
    for (final b in fill ? [0.0] : [0.0, 1.75, 2.5]) {
      mix(drums, sweep(120, 45, 0.25, decay: 0.09, rate: musicSr), t0 + b * beat, gain: 0.55, rate: musicSr);
    }
    for (final b in [1.0, 3.0]) {
      mix(drums, noiseBurst(0.12, decay: 0.035, center: 1900, q: 0.9, rate: musicSr), t0 + b * beat, gain: 0.35, rate: musicSr);
      mix(drums, sweep(330, 260, 0.05, decay: 0.02, rate: musicSr), t0 + b * beat, gain: 0.15, rate: musicSr);
    }
    for (var h = 0; h < 8; h++) {
      final b = swing(h / 2);
      mix(drums, highpass(noiseBurst(0.04, decay: 0.008, center: 9000, q: 1, rate: musicSr), 6000, 0.7, musicSr), t0 + b * beat,
          gain: h.isEven ? 0.12 : 0.07, rate: musicSr);
    }
  }

  // Lead hook (bars 1–8), then a sparser answer an octave down (9–16).
  final hook = <(double, int, double)>[
    (0, d5, .5), (0.5, fs5, .5), (1, a5, .5), (1.5, b5, 1.25), (3, a5, 1), //
    (4, fs5, 1.25), (5.5, e5, .5), (6, d5, 1.75),
    (8, b4, .5), (8.5, d5, .5), (9, e5, 1.25), (10.5, d5, .5), (11, b4, 1),
    (12, e5, 1.25), (13.5, fs5, .5), (14, e5, 2),
    (16, d5, .5), (16.5, fs5, .5), (17, a5, .5), (17.5, b5, 1.25), (19, a5, 1),
    (20, fs5, 1.25), (21.5, e5, .5), (22, d5, 1.75),
    (24, b5, .5), (24.5, a5, .5), (25, fs5, 1.25), (26.5, e5, .5), (27, d5, 1),
    (28, e5, 1), (29, cs5, 1), (30, a4, 2),
  ];
  for (final (b, n, len) in hook) {
    mix(lead, bell(hz(n), len * beat + 0.6, decay: 0.35 + len * 0.15, index: 2, rate: musicSr), swing(b) * beat, gain: 0.32, rate: musicSr);
  }
  final answer = <(double, int, double)>[
    (32, a4, 1), (33.5, d5, .5), (34, fs5, 2),
    (40, g4, 1), (41.5, b4, .5), (42, d5, 2),
    (48, a4, .5), (48.5, d5, .5), (49, fs5, .5), (49.5, a5, 1.5),
    (56, e5, 1), (57, cs5, 1), (58, a4, 2),
  ];
  for (final (b, n, len) in answer) {
    mix(lead, pluck(hz(n), len * beat + 0.4, damping: 0.997, bright: 0.55, rate: musicSr), swing(b) * beat, gain: 0.42, rate: musicSr);
  }

  // Mix buses: warm keys, round bass, soft drums, lead in front.
  mix(total, reverb(lowpass(keysBus, 3000, 0.707, musicSr), wet: 0.25, size: 1.1, rate: musicSr), 0, rate: musicSr);
  mix(total, lowpass(bassBus, 900, 0.707, musicSr), 0, gain: 0.9, rate: musicSr);
  mix(total, lowpass(drums, 7000, 0.707, musicSr), 0, gain: 0.8, rate: musicSr);
  mix(total, reverb(lead, wet: 0.3, size: 1.2, rate: musicSr), 0, gain: 0.9, rate: musicSr);
  // Faint tape hiss for the lo-fi texture.
  for (var i = 0; i < total.length; i++) {
    total[i] += noise() * 0.004;
  }

  // Filter first, then fold the tail past the loop point back onto the
  // start, so the seam is sample-continuous (no filter restart click).
  final filtered = lowpass(total, 7500, 0.707, musicSr);
  final n = (loopLen * musicSr).round();
  final loop = Float64List(n);
  for (var i = 0; i < filtered.length; i++) {
    loop[i % n] += filtered[i];
  }
  return loop;
}
