import 'package:flutter/material.dart';

import '../../core/theme/blueprint_tokens.dart';
import '../../game/domain/level.dart';
import '../../game/presentation/plate_painter.dart';
import '../../services/cosmetics.dart';

/// Static, non-interactive render of a level's initial board — previews on
/// home, chapter map, daily and theme sheets. [size] is the 300-unit play
/// area in dp (no frame).
class BpMiniBoard extends StatelessWidget {
  const BpMiniBoard({
    super.key,
    required this.level,
    required this.size,
    this.theme,
    this.screws = true,
  });

  final Level level;
  final double size;
  final BoardTheme? theme;
  final bool screws;

  @override
  Widget build(BuildContext context) {
    final scale = size / BpSize.boardPlay;
    final t = theme ?? Cosmetics.blueprint;
    final pieces = <(int, int, Widget)>[];
    for (var i = 0; i < level.panels.length; i++) {
      final p = level.panels[i];
      pieces.add((
        p.depth * 10 + 1,
        i,
        Positioned(
          left: p.x * scale,
          top: p.y * scale,
          width: p.w * scale,
          height: p.h * scale,
          child: CustomPaint(
            painter: PlatePainter(
              panel: p,
              holes: const [],
              scale: scale,
              plateColors: t.plates,
            ),
          ),
        ),
      ));
    }
    if (screws) {
      for (var i = 0; i < level.screws.length; i++) {
        final s = level.screws[i];
        final depth = level.panelById(s.panelId).depth;
        final d = BpSize.screwHead * scale;
        pieces.add((
          depth * 10 + 5,
          i,
          Positioned(
            left: s.x * scale - d / 2,
            top: s.y * scale - d / 2,
            width: d,
            height: d,
            child: CustomPaint(
              painter: ScrewHeadPainter(unit: scale, fill: t.screwFill, line: t.screwLine),
            ),
          ),
        ));
      }
    }
    pieces.sort((a, b) => a.$1 != b.$1 ? a.$1.compareTo(b.$1) : a.$2.compareTo(b.$2));
    return IgnorePointer(
      child: RepaintBoundary(
        child: SizedBox.square(
          dimension: size,
          child: Stack(clipBehavior: Clip.none, children: [for (final p in pieces) p.$3]),
        ),
      ),
    );
  }
}

/// Number of distinct plate depths.
int layerCount(Level level) => {for (final p in level.panels) p.depth}.length;
