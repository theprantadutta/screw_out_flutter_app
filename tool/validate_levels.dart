// Validates every chapter pack. Exits non-zero on any issue (run in CI).
//
//   dart run tool/validate_levels.dart [dir]     (default assets/levels)
import 'dart:convert';
import 'dart:io';

import 'package:screw_out/game/level/level_pack.dart';
import 'package:screw_out/game/level/validator.dart';

void main(List<String> args) {
  final dir = Directory(args.isEmpty ? 'assets/levels' : args.first);
  final files = dir
      .listSync()
      .whereType<File>()
      .where((f) => f.path.endsWith('.json'))
      .toList()
    ..sort((a, b) => a.path.compareTo(b.path));
  var issues = 0;
  var count = 0;
  int? expectedId;
  for (final file in files) {
    final pack = LevelPack.fromJson(
      (jsonDecode(file.readAsStringSync()) as Map).cast(),
    );
    for (final level in pack.levels) {
      count++;
      if (expectedId != null && level.id != expectedId) {
        stderr.writeln('${file.path}: expected sheet $expectedId, got ${level.id}');
        issues++;
      }
      expectedId = level.id + 1;
      if (level.chapter != pack.chapter) {
        stderr.writeln('${level.code}: chapter ${level.chapter} in pack ${pack.chapter}');
        issues++;
      }
      for (final issue in validateLevel(level)) {
        stderr.writeln('${file.path}: $issue');
        issues++;
      }
    }
  }
  stdout.writeln('$count sheets in ${files.length} packs, $issues issue(s).');
  if (issues > 0 || count == 0) exit(1);
}
