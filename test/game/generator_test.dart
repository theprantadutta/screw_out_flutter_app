import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:screw_out/game/generator/curriculum.dart';
import 'package:screw_out/game/generator/daily.dart';
import 'package:screw_out/game/generator/generator.dart';
import 'package:screw_out/game/generator/rng.dart';
import 'package:screw_out/game/level/level_pack.dart';
import 'package:screw_out/game/level/validator.dart';

void main() {
  test('rng is stable (pinned sequence)', () {
    final rng = SeededRng(20261015);
    // Pinned values: if these change, every daily sheet changes.
    final seq = [for (var i = 0; i < 4; i++) rng.nextUint32()];
    expect(seq, [1723338109, 2185057250, 2352635611, 2168576706]);
  });

  test('generator is deterministic', () {
    final plan = planFor(37);
    String gen() => jsonEncode(
      const LevelGenerator()
          .generate(
            seed: seedFor(37),
            spec: plan.spec,
            id: 37,
            code: codeFor(37),
            chapter: 2,
            title: titleFor(37),
          )!
          .level
          .toJson(),
    );
    expect(gen(), gen());
  });

  test('daily sheets: same date → same sheet; a year of dates all valid', () {
    const daily = DailySheets();
    final a = jsonEncode(daily.sheetFor(DateTime(2026, 10, 15)).toJson());
    final b = jsonEncode(daily.sheetFor(DateTime(2026, 10, 15, 23, 59)).toJson());
    expect(a, b);
    expect(DailySheets.codeFor(DateTime(2026, 10, 15)), 'D-288');
    final start = DateTime(2026, 1, 1);
    for (var d = 0; d < 366; d++) {
      final level = daily.sheetFor(start.add(Duration(days: d)));
      expect(validateLevel(level), isEmpty, reason: level.code);
    }
  });

  test('bundled packs: 100 contiguous, valid sheets', () {
    var expected = 1;
    for (var c = 1; c <= kBundledChapters; c++) {
      final pack = LevelPack.fromJson(
        (jsonDecode(
          File('assets/levels/ch${c.toString().padLeft(2, '0')}.json')
              .readAsStringSync(),
        ) as Map).cast(),
      );
      expect(pack.levels, hasLength(kLevelsPerChapter));
      for (final level in pack.levels) {
        expect(level.id, expected++);
        expect(level.chapter, c);
        expect(validateLevel(level), isEmpty, reason: level.code);
      }
    }
  });
}

