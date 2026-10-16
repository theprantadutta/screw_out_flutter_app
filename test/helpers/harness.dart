import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:screw_out/game/domain/level.dart';
import 'package:screw_out/game/engine/engine.dart';
import 'package:screw_out/l10n/app_localizations.dart';
import 'package:screw_out/presentation/bloc/game/game_host.dart';
import 'package:screw_out/presentation/bloc/settings/settings_cubit.dart';

/// Loads the real bundled fonts so goldens look like the device.
Future<void> loadAppFonts() async {
  Future<void> load(String family, List<String> files) async {
    final loader = FontLoader(family);
    for (final f in files) {
      loader.addFont(Future.value(ByteData.sublistView(File(f).readAsBytesSync())));
    }
    await loader.load();
  }

  await load('SpaceGrotesk', ['assets/fonts/SpaceGrotesk-Variable.ttf']);
  await load('JetBrainsMono', ['assets/fonts/JetBrainsMono-Variable.ttf']);
  final config = jsonDecode(File('.dart_tool/package_config.json').readAsStringSync()) as Map;
  final pkg = (config['packages'] as List).cast<Map>().firstWhere((p) => p['name'] == 'material_symbols_icons');
  final root = Uri.parse(pkg['rootUri'] as String).toFilePath();
  await load('packages/material_symbols_icons/MaterialSymbolsSharp', ['$root/lib/fonts/MaterialSymbolsSharp.ttf']);
}

List<Level> sampleLevels() {
  final json = jsonDecode(File('test/fixtures/sample-levels.json').readAsStringSync()) as Map<String, Object?>;
  return [for (final l in json['levels']! as List) Level.fromJson((l as Map).cast())];
}

Level sampleLevel(int id) => sampleLevels().firstWhere((l) => l.id == id);

/// Design frame 360×780 at 2× (matches design/screens/*.png).
void useDesignFrame(WidgetTester tester) {
  tester.view.physicalSize = const Size(720, 1560);
  tester.view.devicePixelRatio = 2;
  tester.view.padding = const FakeViewPadding(top: 76, bottom: 40);
  tester.view.viewPadding = const FakeViewPadding(top: 76, bottom: 40);
  addTearDown(tester.view.reset);
}

Widget appShell({required Widget child, SettingsCubit? settings}) => BlocProvider<SettingsCubit>(
  create: (_) => settings ?? SettingsCubit(MemorySettingsStore()),
  child: MaterialApp(
    debugShowCheckedModeBanner: false,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    home: child,
  ),
);

class FakeHost implements GameHost {
  FakeHost({this.isPro = false, this.coins = 860, this.adAvailable = true});

  @override
  bool isPro;
  @override
  int coins;
  bool adAvailable;
  final saved = <SavedGame>[];
  final completed = <LevelResult>[];
  final events = <String>[];

  @override
  Future<void> saveProgress(SavedGame game) async => saved.add(game);

  @override
  Future<void> clearProgress(int levelId) async {}

  @override
  Future<LevelReward> completeLevel(LevelResult result) async {
    completed.add(result);
    final before = coins;
    coins += 25;
    return LevelReward(coins: 25, balanceBefore: before, balanceAfter: coins, firstClear: true);
  }

  @override
  Future<bool> spendCoins(int amount, {required String reason}) async {
    if (coins < amount) return false;
    coins -= amount;
    return true;
  }

  @override
  Future<bool> showRewardedAd({required String placement}) async => adAvailable;

  @override
  bool get rewardedAdAvailable => adAvailable;

  @override
  void track(String event, [Map<String, Object?> params = const {}]) => events.add(event);
}
