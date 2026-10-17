// Screw Out - Blueprint theme tokens.
// Generated from design/design-tokens.json. This file is the single source of
// truth in code: never hard-code colours, type, sizes or durations in widgets.
// (`grep "Color(0x"` outside this file must return nothing.)

import 'package:flutter/animation.dart';
import 'package:flutter/painting.dart';

abstract final class BpColor {
  static const sheet = Color(0xFF1E4B7E);
  static const card = Color(0xFF173D68);
  static const ink = Color(0xFF0F2A4D);
  static const hole = Color(0xFF163A63);

  /// Plate fills, indexed by plate pattern (PL-01 solid … PL-04 crosshatch).
  static const plates = [
    Color(0xFF2A5B93),
    Color(0xFF2E6299),
    Color(0xFF336AA3),
    Color(0xFF3A73AD),
  ];
  static const line = Color(0xFFFFFFFF);
  static const lineDefault = Color(0xD9FFFFFF); // 85%
  static const textSecondary = Color(0xCCFFFFFF); // 80%
  static const textMuted = Color(0xBFFFFFFF); // 75%
  static const lineMuted = Color(0xB3FFFFFF); // 70%
  static const lineDashed = Color(0x99FFFFFF); // 60%
  static const lineFaint = Color(0x80FFFFFF); // 50%
  static const divider = Color(0x4DFFFFFF); // 30%
  static const pressFill = Color(0x26FFFFFF); // 15%
  static const gridMinor = Color(0x0EFFFFFF); // 5.5%
  static const gridMajor = Color(0x1AFFFFFF); // 10%
  static const action = Color(0xFFF2C14E);
  static const caution = Color(0xFFFF9F43);
  static const success = Color(0xFF7FD1AE);
  static const blocked = Color(0xFFFF8F80);
  static const scrim = Color(0x800A1E3A);
  static const spotlight = Color(0xB80F2A4D);
  static const confettiBlue = Color(0xFF9CC3F0);

  /// Plate tag text (90%) and plate edge (92%).
  static const plateTag = Color(0xE6FFFFFF);
  static const plateEdge = Color(0xEBFFFFFF);
  static const holeEdge = Color(0xB3FFFFFF);

  /// Drop shadows: plates (α .75) and screws (α .5).
  static const plateShadow = Color(0xBF05142D);
  static const screwShadow = Color(0x8005142D);

  /// Pattern ink on plates.
  static const hatch = Color(0x29FFFFFF); // .16
  static const dots = Color(0x42FFFFFF); // .26
  static const crosshatch = Color(0x26FFFFFF); // .15

  /// Logo on light backgrounds only.
  static const paper = Color(0xFFF4F1EA);
  static const transparent = Color(0x00000000);
}

abstract final class BpType {
  static const display = 'SpaceGrotesk';
  static const mono = 'JetBrainsMono';

  // Variable fonts: weight must be applied as a `wght` variation too.
  static const _w400 = [FontVariation('wght', 400)];
  static const _w500 = [FontVariation('wght', 500)];
  static const _w600 = [FontVariation('wght', 600)];
  static const _w700 = [FontVariation('wght', 700)];

  static const hero = TextStyle(fontFamily: display, fontSize: 66, fontWeight: FontWeight.w700, fontVariations: _w700, height: .9, letterSpacing: -2.97);
  static const screenTitle = TextStyle(fontFamily: display, fontSize: 38, fontWeight: FontWeight.w700, fontVariations: _w700, height: 1, letterSpacing: -1.14);
  static const resultTitle = TextStyle(fontFamily: display, fontSize: 30, fontWeight: FontWeight.w700, fontVariations: _w700, height: 1, letterSpacing: -.6);
  static const sheetTitle = TextStyle(fontFamily: display, fontSize: 26, fontWeight: FontWeight.w700, fontVariations: _w700, height: 1.1, letterSpacing: -.4);
  static const stuckTitle = TextStyle(fontFamily: display, fontSize: 22, fontWeight: FontWeight.w700, fontVariations: _w700, height: 1.15);
  static const title = TextStyle(fontFamily: display, fontSize: 19, fontWeight: FontWeight.w700, fontVariations: _w700);
  static const cardTitle = TextStyle(fontFamily: display, fontSize: 17, fontWeight: FontWeight.w700, fontVariations: _w700);
  static const button = TextStyle(fontFamily: display, fontSize: 16, fontWeight: FontWeight.w700, fontVariations: _w700);
  static const body = TextStyle(fontFamily: display, fontSize: 15, fontWeight: FontWeight.w600, fontVariations: _w600);
  static const monoBody = TextStyle(fontFamily: mono, fontSize: 12, fontWeight: FontWeight.w400, fontVariations: _w400, height: 1.5);
  static const monoButton = TextStyle(fontFamily: mono, fontSize: 13, fontWeight: FontWeight.w600, fontVariations: _w600, letterSpacing: 1.04);
  static const monoButtonBold = TextStyle(fontFamily: mono, fontSize: 13, fontWeight: FontWeight.w700, fontVariations: _w700, letterSpacing: 1.04);
  static const monoSmallButton = TextStyle(fontFamily: mono, fontSize: 11, fontWeight: FontWeight.w600, fontVariations: _w600, letterSpacing: .88);
  static const label = TextStyle(fontFamily: mono, fontSize: 11, fontWeight: FontWeight.w600, fontVariations: _w600, letterSpacing: 1.1);
  static const objective = TextStyle(fontFamily: mono, fontSize: 11, fontWeight: FontWeight.w600, fontVariations: _w600, letterSpacing: .44);
  static const trayLabel = TextStyle(fontFamily: mono, fontSize: 10, fontWeight: FontWeight.w600, fontVariations: _w600, letterSpacing: 1.2);
  static const caption = TextStyle(fontFamily: mono, fontSize: 10, fontWeight: FontWeight.w400, fontVariations: _w400, letterSpacing: 1.2);
  static const coin = TextStyle(fontFamily: mono, fontSize: 13, fontWeight: FontWeight.w600, fontVariations: _w600, fontFeatures: [FontFeature.tabularFigures()]);
  static const plateTag = TextStyle(fontFamily: mono, fontSize: 9, fontWeight: FontWeight.w600, fontVariations: _w600, letterSpacing: .72);
  static const slotTag = TextStyle(fontFamily: mono, fontSize: 8, fontWeight: FontWeight.w600, fontVariations: _w600);
  static const stamp = TextStyle(fontFamily: mono, fontSize: 32, fontWeight: FontWeight.w700, fontVariations: _w700, letterSpacing: 5.12);
  static const statValue = TextStyle(fontFamily: display, fontSize: 24, fontWeight: FontWeight.w700, fontVariations: _w700, fontFeatures: [FontFeature.tabularFigures()]);
  static const reward = TextStyle(fontFamily: display, fontSize: 30, fontWeight: FontWeight.w700, fontVariations: _w700, fontFeatures: [FontFeature.tabularFigures()]);
  static const medium = _w500;
}

abstract final class BpSpace {
  static const s1 = 4.0, s2 = 8.0, s3 = 12.0, s4 = 16.0, s5 = 20.0, s6 = 24.0;
  static const s8 = 32.0, s10 = 40.0, s12 = 48.0;

  /// Side padding: list screens / gameplay.
  static const screen = 24.0, gameplay = 18.0;
}

abstract final class BpSize {
  static const tapMin = 48.0, screwHead = 26.0, screwHit = 44.0, screwHitLarge = 48.0;
  static const trayScrew = 22.0, traySlotH = 56.0;
  static const boardFrame = 324.0, boardPlay = 300.0, boardInset = 12.0, boardMax = 420.0;
  static const cornerMark = 18.0, primaryH = 54.0, iconButton = 48.0, chipH = 36.0;
  static const stroke = 1.5, hairline = 1.0, emphasis = 2.0, stampStroke = 3.0;
  static const plateRadius = 18.0, holeD = 16.0, screwOverlapRadius = 13.0; // level units
  static const hardShadow = 3.0, hardShadowLarge = 4.0;
  static const toggleW = 46.0, toggleH = 26.0, toggleKnob = 17.0;
  static const sheetInset = 12.0, sheetPad = 20.0;

  /// Design frame - 1:1 dp.
  static const frameW = 360.0, frameH = 780.0;
  static const headerTop = 48.0, trayBottom = 100.0, actionsBottom = 34.0;
}

abstract final class BpMotion {
  static const tap = Duration(milliseconds: 90);
  static const feedback = Duration(milliseconds: 160);
  static const unscrew = Duration(milliseconds: 200);
  static const flight = Duration(milliseconds: 280);
  static const slotPop = Duration(milliseconds: 180);
  static const slotPopDelay = Duration(milliseconds: 260);
  static const settleDelay = Duration(milliseconds: 320);
  static const panelRelease = Duration(milliseconds: 420);
  static const panelDelay = Duration(milliseconds: 40);
  static const trayFree = Duration(milliseconds: 220);
  static const trayFreeStagger = Duration(milliseconds: 30);
  static const blockStep = Duration(milliseconds: 40);
  static const blockerHold = Duration(milliseconds: 650);
  static const undo = Duration(milliseconds: 220);
  static const hintTotal = Duration(milliseconds: 1600);
  static const hintRewindStep = Duration(milliseconds: 120);
  static const sheet = Duration(milliseconds: 380);
  static const sheetOut = Duration(milliseconds: 240);
  static const scrim = Duration(milliseconds: 260);
  static const transitionOut = Duration(milliseconds: 180);
  static const transition = Duration(milliseconds: 320);
  static const objective = Duration(milliseconds: 300);
  static const navigation = Duration(milliseconds: 240);
  static const toggle = Duration(milliseconds: 180);
  static const celebration = Duration(milliseconds: 1100);
  static const stuckDelay = Duration(milliseconds: 420);
  static const reduced = Duration(milliseconds: 160);
  static const reducedBoard = Duration(milliseconds: 120);
  static const reducedSlot = Duration(milliseconds: 140);

  static const standardOut = Cubic(.2, .9, .3, 1);
  static const standardIn = Cubic(.4, 0, 1, 1);
  static const spring = Cubic(.34, 1.56, .64, 1);
  static const pop = Cubic(.34, 1.8, .6, 1);
  static const arcX = Cubic(.4, 0, .5, 1);
  static const arcY = Cubic(.35, -1.1, .65, 1); // overshoots upward = the arc
  static const drop = Cubic(.5, -.35, .7, .6); // tiny lift, then fall
  static const sheetCurve = Cubic(.2, .9, .25, 1);
  static const burst = Cubic(.12, .85, .3, 1);
  static const toggleCurve = Cubic(.3, 1.4, .5, 1);
  static const fadeOut = Cubic(.8, 0, 1, 1);
  static const centerLines = Cubic(.2, .8, .2, 1);
}

/// Cosmetic board theme palettes (screen 14). Each: swatch background,
/// four plate fills (PL-01 … PL-04), screw fill, screw line.
abstract final class BpThemePalette {
  static const blueprintBg = Color(0xFF1E4B7E);
  static const blueprintPlates = [Color(0xFF2A5B93), Color(0xFF2E6299), Color(0xFF336AA3), Color(0xFF3A73AD)];
  static const blueprintScrew = Color(0xFF1E4B7E);
  static const blueprintLine = Color(0xFFFFFFFF);

  static const walnutBg = Color(0xFFF2F0EB);
  static const walnutPlates = [Color(0xFFB98660), Color(0xFFC49470), Color(0xFFD9B28A), Color(0xFFE8C89A)];
  static const walnutScrew = Color(0xFFC9A04A);
  static const walnutLine = Color(0xFF5A4320);

  static const oceanBg = Color(0xFFDDEEEE);
  static const oceanPlates = [Color(0xFF2D7A72), Color(0xFF358A82), Color(0xFF3F9E95), Color(0xFF4CB2AA)];
  static const oceanScrew = Color(0xFFBFC6CC);
  static const oceanLine = Color(0xFF34404A);

  static const copperBg = Color(0xFF2A211D);
  static const copperPlates = [Color(0xFF9C5A33), Color(0xFFB36A3E), Color(0xFFCC8556), Color(0xFFE09C6C)];
  static const copperScrew = Color(0xFFF3DCC4);
  static const copperLine = Color(0xFF3B241A);

  static const midnightBg = Color(0xFF15161B);
  static const midnightPlates = [Color(0xFF4A566C), Color(0xFF56627A), Color(0xFFD9645A), Color(0xFFE36E62)];
  static const midnightScrew = Color(0xFFC9CDD3);
  static const midnightLine = Color(0xFF2E3138);

  static const pastelBg = Color(0xFFFCF1EA);
  static const pastelPlates = [Color(0xFFCABDF2), Color(0xFFBCD8F0), Color(0xFFF2C6D6), Color(0xFFA9DFC9)];
  static const pastelScrew = Color(0xFFFFFFFF);
  static const pastelLine = Color(0xFF3D3550);
}
