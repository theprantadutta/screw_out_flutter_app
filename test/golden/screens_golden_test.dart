import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:screw_out/screens/campaign/campaign_screen.dart';
import 'package:screw_out/screens/chapter_complete/chapter_complete_screen.dart';
import 'package:screw_out/screens/chapter_map/chapter_map_screen.dart';
import 'package:screw_out/screens/daily/daily_screen.dart';
import 'package:screw_out/screens/gameplay/gameplay_route.dart';
import 'package:screw_out/screens/home/home_screen.dart';
import 'package:screw_out/screens/settings/settings_screen.dart';
import 'package:screw_out/screens/splash/splash_screen.dart';
import 'package:screw_out/screens/themes/themes_screen.dart';

import '../helpers/harness.dart';
import '../helpers/screen_harness.dart';

void main() {
  setUpAll(() async {
    await loadAppFonts();
    PackageInfo.setMockInitialValues(
      appName: 'Screw Out',
      packageName: 'com.pranta.screwout',
      version: '1.0.0',
      buildNumber: '100',
      buildSignature: '',
    );
  });

  Future<ScreenEnv> pumpScreen(
    WidgetTester tester,
    Widget screen, {
    Future<ScreenEnv> Function()? env,
  }) async {
    useDesignFrame(tester);
    final e = (await tester.runAsync(env ?? ScreenEnv.create))!;
    addTearDown(() => tester.runAsync(e.dispose));
    await tester.pumpWidget(e.wrap(screen));
    await settle(tester);
    return e;
  }

  testWidgets('01 splash', (tester) async {
    await pumpScreen(tester, SplashScreen(ready: Future.value(), autoNavigate: false));
    await tester.pump(const Duration(seconds: 1));
    await expectLater(find.byType(SplashScreen), matchesGoldenFile('goldens/01-splash.png'));
  });

  testWidgets('02 home', (tester) async {
    await pumpScreen(tester, HomeScreen(today: DateTime(2026, 10, 15)));
    await expectLater(find.byType(HomeScreen), matchesGoldenFile('goldens/02-home.png'));
  });

  testWidgets('03 tutorial', (tester) async {
    await pumpScreen(
      tester,
      const GameplayRoute(levelId: 1),
      env: () => ScreenEnv.create(cleared: 0, mastered: 0, tutorialDone: false),
    );
    await tester.pump(const Duration(seconds: 1));
    await settle(tester);
    await expectLater(find.byType(GameplayRoute), matchesGoldenFile('goldens/03-tutorial.png'));
  });

  testWidgets('04 campaign', (tester) async {
    await pumpScreen(tester, const CampaignScreen());
    await expectLater(find.byType(CampaignScreen), matchesGoldenFile('goldens/04-campaign.png'));
  });

  testWidgets('05 chapter map', (tester) async {
    await pumpScreen(tester, const ChapterMapScreen(chapter: 2));
    await expectLater(find.byType(ChapterMapScreen), matchesGoldenFile('goldens/05-chapter-map.png'));
  });

  testWidgets('06 daily', (tester) async {
    await pumpScreen(
      tester,
      DailyScreen(now: DateTime(2026, 10, 15)),
      env: () => ScreenEnv.create(dailyDone: {20261012, 20261013, 20261014}),
    );
    await expectLater(find.byType(DailyScreen), matchesGoldenFile('goldens/06-daily.png'));
  });

  testWidgets('12 chapter complete', (tester) async {
    await pumpScreen(tester, const ChapterCompleteScreen(chapter: 2), env: () => ScreenEnv.create(cleared: 40, mastered: 34));
    await tester.pump(const Duration(seconds: 2));
    await expectLater(find.byType(ChapterCompleteScreen), matchesGoldenFile('goldens/12-chapter-complete.png'));
  });

  testWidgets('14 themes', (tester) async {
    await pumpScreen(tester, const ThemesScreen());
    await expectLater(find.byType(ThemesScreen), matchesGoldenFile('goldens/14-themes.png'));
  });

  testWidgets('15 settings', (tester) async {
    await pumpScreen(tester, const SettingsScreen());
    await expectLater(find.byType(SettingsScreen), matchesGoldenFile('goldens/15-settings.png'));
  });

  testWidgets('text scale 1.3 does not overflow (campaign, home, settings)', (tester) async {
    tester.platformDispatcher.textScaleFactorTestValue = 1.3;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    for (final screen in [const CampaignScreen(), HomeScreen(today: DateTime(2026, 10, 15)), const SettingsScreen(), DailyScreen(now: DateTime(2026, 10, 15))]) {
      await pumpScreen(tester, screen);
      expect(tester.takeException(), isNull, reason: screen.runtimeType.toString());
    }
  });
}
