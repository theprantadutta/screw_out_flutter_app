import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:screw_out/game/domain/game_state.dart';
import 'package:screw_out/game/domain/level.dart';
import 'package:screw_out/game/domain/move_result.dart';
import 'package:screw_out/game/engine/engine.dart';
import 'package:screw_out/game/engine/solver.dart';
import 'package:screw_out/game/level/validator.dart';

List<Level> _samples() {
  final json = jsonDecode(
    File('test/fixtures/sample-levels.json').readAsStringSync(),
  ) as Map<String, Object?>;
  return [
    for (final l in json['levels']! as List)
      Level.fromJson((l as Map).cast()),
  ];
}

Level _sample(int id) => _samples().firstWhere((l) => l.id == id);

void main() {
  group('blocking', () {
    test('rect: screw under a higher rect is blocked by it', () {
      final engine = GameEngine(_sample(12));
      // P2-0 (150,106) sits 4 units above PL-04's top edge (y 110).
      expect(engine.blockerOf('P2-0'), 'P3');
      expect(engine.tap('P2-0'), isA<ScrewBlocked>());
      expect(engine.state.moves, 0);
    });

    test('circle: corner screw under the PL-04 disc is blocked', () {
      final engine = GameEngine(_sample(24));
      expect(engine.blockerOf('A-0'), 'D');
      expect(engine.blockerOf('D-0'), isNull);
    });

    test('reports the topmost of several covering panels', () {
      final engine = GameEngine(_sample(24));
      // B-0 (120,130) is covered by PL-03 (depth 2) only; B-1 likewise.
      expect(engine.blockerOf('B-1'), 'C');
      // A-? under the big disc: B (depth 1) covers nothing at the corners.
      expect(engine.blockerOf('A-3'), isNull);
    });

    test('blocked tap never changes state', () {
      final engine = GameEngine(_sample(24));
      final before = engine.state;
      engine.tap('A-0');
      expect(engine.state, before);
      expect(engine.canUndo, isFalse);
    });

    test('screws at the same depth never block each other', () {
      const level = Level(
        id: 900,
        code: 'T',
        chapter: 1,
        title: 't',
        trayCapacity: 3,
        panels: [
          Panel.rect(id: 'a', x: 20, y: 20, w: 150, h: 150, depth: 0, label: 'PL-01'),
          Panel.rect(id: 'b', x: 100, y: 100, w: 150, h: 150, depth: 0, label: 'PL-02'),
        ],
        screws: [
          Screw(id: 'a0', panelId: 'a', x: 140, y: 140),
          Screw(id: 'b0', panelId: 'b', x: 130, y: 130),
        ],
      );
      final engine = GameEngine(level);
      expect(engine.blockerOf('a0'), isNull);
      expect(engine.blockerOf('b0'), isNull);
    });
  });

  group('tray', () {
    test('screw goes to the first empty slot and counts a move', () {
      final engine = GameEngine(_sample(24));
      final r = engine.tap('D-0') as ScrewRemoved;
      // D has one screw, so it released and freed slot 0 at once.
      expect(r.slot, 0);
      expect(r.releases.single.panelId, 'D');
      expect(r.releases.single.freed.single.slot, 0);
      expect(engine.state.tray, [null, null, null, null]);
      expect(engine.state.moves, 1);
    });

    test('release frees slots in place; the tray is never compacted', () {
      final engine = GameEngine(_sample(24));
      engine.tap('D-0'); // PL-04 out
      engine.tap('A-1'); // slot 0
      engine.tap('C-0'); // slot 1
      engine.tap('A-2'); // slot 2
      final r = engine.tap('C-1') as ScrewRemoved; // slot 3 → PL-03 released
      expect(r.slot, 3);
      expect(r.releases.single.panelId, 'C');
      expect([for (final f in r.releases.single.freed) f.slot], [1, 3]);
      expect(engine.state.tray, ['A-1', null, 'A-2', null]);
      // Next screw fills the first gap, not the end.
      final next = engine.tap('B-0') as ScrewRemoved;
      expect(next.slot, 1);
    });

    test('full tray with no release is stuck; further taps are TrayFull', () {
      final engine = GameEngine(_sample(24));
      // The documented trap: A-1, A-2, A-3, C-0 fill the tray.
      for (final id in ['A-1', 'A-2', 'A-3', 'C-0']) {
        engine.tap(id);
      }
      expect(engine.status, GameStatus.stuck);
      expect(engine.tap('D-0'), isA<TrayFull>());
      expect(engine.state.moves, 4);
    });

    test('bonus slot rescues a stuck tray and survives undo', () {
      final engine = GameEngine(_sample(24));
      for (final id in ['A-1', 'A-2', 'A-3', 'C-0']) {
        engine.tap(id);
      }
      engine.addBonusSlot();
      expect(engine.status, GameStatus.playing);
      expect(engine.state.tray.length, 5);
      expect(engine.tap('D-0'), isA<ScrewRemoved>());
      engine.undo();
      engine.undo();
      expect(engine.state.tray.length, 5);
      engine.restart();
      expect(engine.state.tray.length, 4);
    });
  });

  group('win', () {
    test('reported exactly once, on the final move', () {
      for (final level in _samples()) {
        final engine = GameEngine(level);
        var wins = 0;
        for (final id in level.solution!) {
          final r = engine.tap(id) as ScrewRemoved;
          if (r.status == GameStatus.won) wins++;
        }
        expect(wins, 1, reason: level.code);
        expect(engine.status, GameStatus.won);
        expect(engine.tap(level.screws.first.id), isA<TapIgnored>());
      }
    });
  });

  group('undo', () {
    test('restores the exact previous snapshot incl. a release', () {
      final engine = GameEngine(_sample(24));
      engine.tap('D-0');
      engine.tap('A-1');
      engine.tap('C-0');
      final before = engine.state;
      engine.tap('C-1'); // releases PL-03
      final u = engine.undo()!;
      expect(u.screwId, 'C-1');
      expect(u.unreleased.single.panelId, 'C');
      expect(engine.state, before);
    });

    test('property: random legal play then undo-all == initial', () {
      final rng = Random(7);
      for (final level in _samples()) {
        for (var run = 0; run < 200; run++) {
          final engine = GameEngine(level);
          final initial = engine.state;
          final snapshots = <GameState>[initial];
          for (var step = 0; step < 40; step++) {
            final id = level.screws[rng.nextInt(level.screws.length)].id;
            if (engine.tap(id) is ScrewRemoved) snapshots.add(engine.state);
          }
          while (engine.canUndo) {
            snapshots.removeLast();
            engine.undo();
            expect(engine.state, snapshots.last);
          }
          expect(engine.state, initial);
        }
      }
    });
  });

  group('solver', () {
    test('solves every sample and the solution replays legally', () {
      for (final level in _samples()) {
        final solver = Solver(GameEngine(level).board, capacity: level.trayCapacity);
        final solution = solver.solve(const []);
        expect(solution, isNotNull, reason: level.code);
        expect(solution, hasLength(level.screws.length));
        expect(replaySolution(level, solution!), isNull, reason: level.code);
      }
    });

    test('documented trap position is unsolvable', () {
      final level = _sample(24);
      final solver = Solver(GameEngine(level).board, capacity: 4);
      expect(solver.solve(['A-1', 'A-2', 'A-3', 'C-0']), isNull);
    });

    test('analysis finds dead ends in DWG 024 but none in DWG 001', () {
      final trap = Solver(GameEngine(_sample(24)).board, capacity: 4).analyze();
      expect(trap.deadEnds, greaterThan(0));
      expect(trap.randomWinProbability, inExclusiveRange(0, 1));
      final easy = Solver(GameEngine(_sample(1)).board, capacity: 3).analyze();
      expect(easy.randomWinProbability, 1);
    });
  });

  group('hint', () {
    test('points at a legal winning move from the start', () {
      final engine = GameEngine(_sample(24));
      final plan = engine.planHint()!;
      expect(plan.rewind, 0);
      expect(engine.blockerOf(plan.screwId), isNull);
    });

    test('rewinds out of an unsolvable position', () {
      final engine = GameEngine(_sample(24));
      for (final id in ['A-1', 'A-2', 'A-3', 'C-0']) {
        engine.tap(id);
      }
      final plan = engine.planHint()!;
      expect(plan.rewind, greaterThan(0));
      for (var i = 0; i < plan.rewind; i++) {
        engine.undo();
      }
      expect(engine.tap(plan.screwId), isA<ScrewRemoved>());
      expect(
        Solver(engine.board, capacity: 4).isSolvable(engine.state.removed),
        isTrue,
      );
    });

    test('flags the panel the hinted screw releases', () {
      final engine = GameEngine(_sample(1));
      expect(engine.planHint()!.releasesPanelId, 'T');
      expect(GameEngine(_sample(24)).planHint()!.releasesPanelId, isNull);
    });
  });

  group('persistence', () {
    test('save → json → restore keeps state and undo history', () {
      final level = _sample(12);
      final engine = GameEngine(level);
      for (final id in level.solution!.take(5)) {
        engine.tap(id);
      }
      final json = jsonDecode(jsonEncode(engine.save().toJson()));
      final restored = GameEngine.restore(
        level,
        SavedGame.fromJson((json as Map).cast()),
      );
      expect(restored.state, engine.state);
      while (engine.canUndo) {
        engine.undo();
        restored.undo();
        expect(restored.state, engine.state);
      }
    });
  });

  group('validator', () {
    test('all sample levels pass', () {
      for (final level in _samples()) {
        expect(validateLevel(level), isEmpty, reason: level.code);
      }
    });

    test('rejects an unsolvable tray', () {
      final l = _sample(24);
      final tight = Level.fromJson({...l.toJson(), 'trayCapacity': 2});
      expect(
        validateLevel(tight).map((i) => i.code),
        contains('unsolvable'),
      );
    });

    test('rejects a panel without screws', () {
      const level = Level(
        id: 901,
        code: 'T',
        chapter: 1,
        title: 't',
        trayCapacity: 3,
        panels: [
          Panel.rect(id: 'a', x: 20, y: 20, w: 200, h: 200, depth: 0, label: 'PL-01'),
          Panel.rect(id: 'b', x: 60, y: 60, w: 60, h: 60, depth: 1, label: 'PL-02'),
        ],
        screws: [
          Screw(id: 'a0', panelId: 'a', x: 180, y: 180),
          Screw(id: 'a1', panelId: 'a', x: 190, y: 190),
        ],
      );
      final codes = validateLevel(level).map((i) => i.code);
      expect(codes, contains('empty_panel'));
    });
  });
}
