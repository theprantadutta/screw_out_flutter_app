import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:screw_out/screens/settings/settings_screen.dart';

import '../helpers/harness.dart';
import '../helpers/screen_harness.dart';

void main() {
  setUpAll(() async {
    await loadAppFonts();
    PackageInfo.setMockInitialValues(appName: 'Screw Out', packageName: 'com.pranta.screwout', version: '1.4.0', buildNumber: '12', buildSignature: '');
  });

  testWidgets('Language row opens the picker and stores the choice', (tester) async {
    useDesignFrame(tester);
    final env = (await tester.runAsync(ScreenEnv.create))!;
    addTearDown(() => tester.runAsync(env.dispose));
    await tester.pumpWidget(env.wrap(const SettingsScreen()));
    await settle(tester);

    expect(env.settings.state.localeCode, 'en');
    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();
    expect(find.text('System default'), findsOneWidget);

    await tester.tap(find.text('System default'));
    await tester.pumpAndSettle();
    expect(env.settings.state.localeCode, isNull);
    expect(find.text('System default'), findsOneWidget, reason: 'the row shows the current choice');

    await tester.tap(find.text('System default'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();
    expect(env.settings.state.localeCode, 'en');
  });
}
