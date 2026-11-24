import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:screw_out/l10n/app_locales.dart';
import 'package:screw_out/presentation/bloc/game/game_cubit.dart';
import 'package:screw_out/screens/campaign/campaign_screen.dart';
import 'package:screw_out/screens/chapter_complete/chapter_complete_screen.dart';
import 'package:screw_out/screens/chapter_map/chapter_map_screen.dart';
import 'package:screw_out/screens/daily/daily_screen.dart';
import 'package:screw_out/screens/gameplay/gameplay_screen.dart';
import 'package:screw_out/screens/home/home_screen.dart';
import 'package:screw_out/screens/leaderboard/leaderboard_screen.dart';
import 'package:screw_out/screens/settings/language_sheet.dart';
import 'package:screw_out/screens/settings/settings_screen.dart';
import 'package:screw_out/screens/themes/themes_screen.dart';
import 'package:screw_out/services/leaderboard_service.dart';

import '../helpers/harness.dart';
import '../helpers/pseudo_text.dart';
import '../helpers/screen_harness.dart';

/// Translations run up to ~40% longer than English (Russian, German,
/// Turkish). Every key screen is pumped with every string stretched that
/// much ([stretch]), left-to-right and right-to-left (ar), on the 360 dp
/// design frame, and must lay out without an overflow error.
void main() {
  setUpAll(() async {
    await loadAppFonts();
    PackageInfo.setMockInitialValues(
      appName: 'Screw Out',
      packageName: 'com.pranta.screwout',
      version: '1.4.0',
      buildNumber: '12',
      buildSignature: '',
    );
  });

  const ltr = Locale('en');
  const rtl = Locale('ar');

  Future<void> pumpScreen(WidgetTester tester, Widget screen, Locale locale, {Future<ScreenEnv> Function()? env}) async {
    useDesignFrame(tester);
    final e = (await tester.runAsync(env ?? ScreenEnv.create))!;
    addTearDown(() => tester.runAsync(e.dispose));
    await tester.pumpWidget(e.wrap(screen, strings: const PseudoL10nDelegate(), locale: locale));
    await settle(tester);
  }

  for (final locale in [ltr, rtl]) {
    final dir = locale == rtl ? 'RTL' : 'LTR';

    testWidgets('long text, $dir: menu screens lay out without overflow', (tester) async {
      final screens = <String, Widget>{
        'home': HomeScreen(today: DateTime(2026, 10, 15)),
        'campaign': const CampaignScreen(),
        'chapter map': const ChapterMapScreen(chapter: 2),
        'daily': DailyScreen(now: DateTime(2026, 10, 15)),
        'themes': const ThemesScreen(),
        'settings': const SettingsScreen(),
        'leaderboard': LeaderboardScreen(initial: Board.daily, today: DateTime(2026, 10, 16)),
      };
      for (final MapEntry(key: name, value: screen) in screens.entries) {
        await pumpScreen(tester, screen, locale, env: () => ScreenEnv.create(dailyDone: {20261012, 20261013}));
        expect(tester.takeException(), isNull, reason: '$name ($dir)');
        expect(find.byWidget(screen), findsOneWidget, reason: name);
      }
    });

    testWidgets('long text, $dir: chapter complete', (tester) async {
      await pumpScreen(tester, const ChapterCompleteScreen(chapter: 2), locale, env: () => ScreenEnv.create(cleared: 40, mastered: 34));
      await tester.pump(const Duration(seconds: 2));
      expect(tester.takeException(), isNull);
    });

    testWidgets('long text, $dir: language sheet', (tester) async {
      await pumpScreen(tester, const Scaffold(body: Align(alignment: Alignment.bottomCenter, child: LanguageSheet(current: null))), locale);
      expect(tester.takeException(), isNull);
      expect(find.text(stretch('System default')), findsOneWidget);
    });

    group('long text, $dir: gameplay', () {
      Future<GameCubit> pump(WidgetTester tester, [void Function(GameCubit c)? setup]) async {
        useDesignFrame(tester);
        final cubit = GameCubit(level: sampleLevel(24), host: FakeHost());
        await tester.pumpWidget(
          appShell(
            strings: const PseudoL10nDelegate(),
            locale: locale,
            child: BlocProvider.value(
              value: cubit,
              child: GameplayScreen(
                coins: 860,
                adAvailable: true,
                callbacks: GameplayCallbacks(onExit: () {}, onNext: (_) {}, onReplay: () {}, nextLabel: stretch('Next sheet · DWG 025')),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        setup?.call(cubit);
        await tester.pump(const Duration(seconds: 2));
        await tester.pumpAndSettle();
        return cubit;
      }

      testWidgets('HUD', (tester) async {
        await pump(tester);
        expect(tester.takeException(), isNull);
      });

      testWidgets('pause sheet', (tester) async {
        await pump(tester, (c) => c.pause());
        expect(tester.takeException(), isNull);
      });

      testWidgets('stuck sheet', (tester) async {
        await pump(tester, (c) {
          for (final id in ['A-1', 'A-2', 'A-3', 'C-0']) {
            c.tapScrew(id);
          }
        });
        expect(tester.takeException(), isNull);
      });

      testWidgets('out of hints', (tester) async {
        await pump(tester, (c) {
          for (var i = 0; i < 4; i++) {
            c.requestHint();
          }
        });
        expect(tester.takeException(), isNull);
      });

      testWidgets('result card', (tester) async {
        final cubit = await pump(tester, (c) {
          for (final id in c.level.solution!) {
            c.tapScrew(id);
          }
        });
        expect(cubit.state.overlay, GameOverlay.won);
        expect(tester.takeException(), isNull);
      });
    });
  }

  test('stored locale codes round-trip, including script subtags', () {
    for (final code in ['en', 'es', 'pt', 'ar', 'zh_Hant', 'pt_BR']) {
      expect(localeToCode(localeFromCode(code)!), code);
    }
    expect(localeFromCode('zh-hant'), const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'));
    expect(localeFromCode(null), isNull);
    expect(intlLocaleName(localeFromCode('zh_Hant')!), 'zh_TW');
    // Unknown device languages fall back to English, never to whichever
    // translation sorts first.
    expect(resolveAppLocale(null, device: const [Locale('sw')]), const Locale('en'));
    expect(kAppLanguages.length, 14);
    expect(pickableLanguages.first.code, 'en');
  });
}
