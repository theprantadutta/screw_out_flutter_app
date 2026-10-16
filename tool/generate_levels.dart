// Generates campaign chapter packs (assets/levels/chNN.json).
//
//   dart run tool/generate_levels.dart                  # chapters 1–5 → assets/levels
//   dart run tool/generate_levels.dart --from 6 --to 8 --out build/packs
//
// Deterministic: re-running produces byte-identical files. Chapters beyond
// the bundled five are uploaded to the API as downloadable packs.
import 'dart:convert';
import 'dart:io';

import 'package:screw_out/game/domain/level.dart';
import 'package:screw_out/game/generator/curriculum.dart';
import 'package:screw_out/game/generator/generator.dart';
import 'package:screw_out/game/level/level_pack.dart';

void main(List<String> args) {
  var from = 1;
  var to = kBundledChapters;
  var out = 'assets/levels';
  for (var i = 0; i < args.length; i++) {
    switch (args[i]) {
      case '--from':
        from = int.parse(args[++i]);
      case '--to':
        to = int.parse(args[++i]);
      case '--out':
        out = args[++i];
    }
  }

  final handmadeJson = jsonDecode(
    File('tool/handmade_levels.json').readAsStringSync(),
  ) as Map<String, Object?>;
  final handmade = {
    for (final l in handmadeJson['levels']! as List)
      (l as Map)['id'] as int: Level.fromJson(l.cast()),
  };

  Directory(out).createSync(recursive: true);
  const generator = LevelGenerator();
  var failed = false;
  for (var chapter = from; chapter <= to; chapter++) {
    final info = chapter <= kChapters.length
        ? kChapters[chapter - 1]
        : ChapterInfo(chapter, 'Drawing Set ${chapter.toString().padLeft(2, '0')}',
            'MASTER-LEVEL SHEETS', null);
    final levels = <Level>[];
    for (var k = 0; k < kLevelsPerChapter; k++) {
      final id = (chapter - 1) * kLevelsPerChapter + k + 1;
      final made = handmade[id];
      if (made != null && kHandmadeSheets.contains(id)) {
        levels.add(made);
        stdout.writeln('${codeFor(id)}  handmade  "${made.title}"');
        continue;
      }
      final plan = planFor(id);
      final result = generator.generate(
        seed: seedFor(id),
        spec: plan.spec,
        id: id,
        code: codeFor(id),
        chapter: chapter,
        title: titleFor(id),
        mechanics: plan.mechanics,
        objective: plan.objective,
      );
      if (result == null) {
        stderr.writeln('${codeFor(id)}  FAILED to generate');
        failed = true;
        continue;
      }
      final l = result.level;
      levels.add(l);
      stdout.writeln(
        '${l.code}  d${l.difficulty.toString().padLeft(2)}  '
        'tray ${l.trayCapacity}  ${l.panels.length}p/${l.screws.length}s  '
        '${result.analysis}  "${l.title}"',
      );
    }
    final pack = LevelPack(
      chapter: chapter,
      name: info.name,
      goal: info.goal,
      newMechanic: info.newMechanic,
      levels: levels,
    );
    final file = File('$out/ch${chapter.toString().padLeft(2, '0')}.json');
    file.writeAsStringSync('${const JsonEncoder.withIndent(' ').convert(pack.toJson())}\n');
  }
  if (failed) exit(1);
}
