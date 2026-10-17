import 'dart:io';
import 'dart:typed_data';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:screw_out/data/database/app_database.dart';
import 'package:screw_out/presentation/bloc/game/game_host.dart';
import 'package:screw_out/services/ports.dart';
import 'package:screw_out/services/progress_service.dart';

import '../helpers/harness.dart';

/// Reads a PCM WAV header: (sample rate, channels, bits, frames).
(int, int, int, int) _wav(String path) {
  final b = ByteData.sublistView(File(path).readAsBytesSync());
  expect(String.fromCharCodes(b.buffer.asUint8List(0, 4)), 'RIFF', reason: path);
  expect(String.fromCharCodes(b.buffer.asUint8List(8, 4)), 'WAVE', reason: path);
  final rate = b.getUint32(24, Endian.little);
  final channels = b.getUint16(22, Endian.little);
  final bits = b.getUint16(34, Endian.little);
  final frames = b.getUint32(40, Endian.little) ~/ (channels * bits ~/ 8);
  return (rate, channels, bits, frames);
}

/// Reads an Ogg Vorbis stream: (sample rate, channels, frames) - frames from
/// the last page's granule position.
(int, int, int) _ogg(String path) {
  final bytes = File(path).readAsBytesSync();
  final b = ByteData.sublistView(bytes);
  expect(String.fromCharCodes(bytes.sublist(0, 4)), 'OggS', reason: path);
  expect(String.fromCharCodes(bytes.sublist(29, 35)), 'vorbis', reason: path);
  final channels = bytes[39];
  final rate = b.getUint32(40, Endian.little);
  var last = bytes.length - 4;
  while (last > 0 && String.fromCharCodes(bytes.sublist(last, last + 4)) != 'OggS') {
    last--;
  }
  return (rate, channels, b.getUint64(last + 6, Endian.little));
}

void main() {
  test('every cue has a valid, short, mono 16-bit WAV', () {
    for (final s in Sfx.values) {
      final (rate, channels, bits, frames) = _wav('assets/audio/${s.file}.wav');
      expect((rate, channels, bits), (44100, 1, 16), reason: s.file);
      expect(frames / rate, inInclusiveRange(0.04, 3.6), reason: s.file);
    }
  });

  test('the music loop is stereo Ogg Vorbis, exactly 32 bars (seamless loop)', () {
    final (rate, channels, frames) = _ogg('assets/audio/music_workshop.ogg');
    expect((rate, channels), (44100, 2));
    const bar = 4 * 60 / 124; // 124 BPM, 4/4
    expect((frames / rate / bar - 32).abs(), lessThan(0.001));
  });

  group('new best ("high score")', () {
    late AppDatabase db;
    late ProgressService progress;
    setUp(() async {
      db = AppDatabase.forTesting(NativeDatabase.memory());
      await db.initializeDefaults();
      progress = ProgressService(db);
    });
    tearDown(() => db.close());

    LevelResult result({required int moves, bool mastered = false}) => LevelResult(
      level: sampleLevel(24),
      moves: moves,
      elapsed: const Duration(seconds: 40),
      mastered: mastered,
      usedHint: !mastered,
      restarted: false,
      rescued: false,
      isDaily: false,
    );

    test('first clear is never a new best; a better replay is', () async {
      expect((await progress.recordClear(result(moves: 12))).newBest, isFalse);
      expect((await progress.recordClear(result(moves: 12))).newBest, isFalse);
      expect((await progress.recordClear(result(moves: 10))).newBest, isTrue);
      expect((await progress.recordClear(result(moves: 11, mastered: true))).newBest, isTrue, reason: 'first ◆');
      expect((await progress.recordClear(result(moves: 11, mastered: true))).newBest, isFalse);
    });
  });
}
