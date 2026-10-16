import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:screw_out/presentation/bloc/game/game_cubit.dart';
import 'package:screw_out/router/app_router.dart';
import 'package:screw_out/router/routes.dart';
import 'package:screw_out/screens/campaign/campaign_screen.dart';
import 'package:screw_out/screens/chapter_map/chapter_map_screen.dart';
import 'package:screw_out/screens/gameplay/gameplay_screen.dart';
import 'package:screw_out/screens/gameplay/widgets/tutorial_overlay.dart';

import '../helpers/harness.dart';
import '../helpers/screen_harness.dart';

void main() {
  setUpAll(loadAppFonts);

  Future<void> idle(WidgetTester tester, [int ms = 600]) async {
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 60)));
    await tester.pump(Duration(milliseconds: ms));
    await tester.pump(const Duration(milliseconds: 50));
  }

  testWidgets('home → campaign → chapter map → play; next sheet swaps in place', (tester) async {
    useDesignFrame(tester);
    final env = (await tester.runAsync(ScreenEnv.create))!;
    addTearDown(() => tester.runAsync(env.dispose));
    final router = createAppRouter(ready: Future.value(), initialLocation: AppRoutes.home);
    await tester.pumpWidget(env.wrap(const SizedBox(), router: router));
    await idle(tester);

    await tester.tap(find.text('SHEETS'));
    await idle(tester);
    expect(find.byType(CampaignScreen), findsOneWidget);

    await tester.tap(find.descendant(of: find.byType(CampaignScreen), matching: find.text('Layer by Layer')));
    await idle(tester);
    expect(find.byType(ChapterMapScreen), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('Play DWG 024'));
    await idle(tester);
    expect(find.byType(GameplayScreen), findsOneWidget);
    expect(find.text('Hidden Bracket'), findsWidgets);

    // Solve it through the cubit, then take "Next sheet".
    final cubit = tester.element(find.byType(GameplayScreen)).read<GameCubit>();
    for (final id in cubit.level.solution!) {
      cubit.tapScrew(id);
    }
    await idle(tester, 2000);
    await idle(tester, 1500);
    expect(cubit.state.overlay, GameOverlay.won);
    await tester.tap(find.textContaining('Next sheet'));
    await idle(tester, 800);
    await idle(tester, 800);
    expect(find.text('DWG 025'), findsOneWidget);
    expect(env.progressCubit.state.isCleared(24), isTrue);
  });

  testWidgets('locked sheet redirects to the current one', (tester) async {
    useDesignFrame(tester);
    final env = (await tester.runAsync(ScreenEnv.create))!;
    addTearDown(() => tester.runAsync(env.dispose));
    final router = createAppRouter(ready: Future.value(), initialLocation: AppRoutes.playPath(60));
    await tester.pumpWidget(env.wrap(const SizedBox(), router: router));
    await idle(tester);
    await idle(tester);
    expect(find.text('DWG 024'), findsOneWidget);
  });

  testWidgets('tutorial: only the spotlit screw is tappable; first tap ends it for good', (tester) async {
    useDesignFrame(tester);
    final env = (await tester.runAsync(() => ScreenEnv.create(cleared: 0, mastered: 0, tutorialDone: false)))!;
    addTearDown(() => tester.runAsync(env.dispose));
    final router = createAppRouter(ready: Future.value(), initialLocation: AppRoutes.playPath(1));
    await tester.pumpWidget(env.wrap(const SizedBox(), router: router));
    await idle(tester);
    await idle(tester);
    expect(find.byType(TutorialOverlay), findsOneWidget);
    final cubit = tester.element(find.byType(GameplayScreen)).read<GameCubit>();

    // A tap on the scrim (top-left of the board) does nothing.
    await tester.tapAt(const Offset(40, 300));
    await idle(tester);
    expect(cubit.state.moves, 0);

    // A tap in the spotlight lands on the screw.
    await tester.tapAt(tester.getCenter(find.byKey(const ValueKey('screw-T-0'))));
    await idle(tester, 1500);
    expect(cubit.state.moves, 1);
    expect(find.byType(TutorialOverlay), findsNothing);
    expect(env.settings.state.tutorialDone, isTrue);
  });
}
