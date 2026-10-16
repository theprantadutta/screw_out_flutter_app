import 'package:flutter_test/flutter_test.dart';
import 'package:screw_out/screens/themes/themes_screen.dart';

import '../helpers/harness.dart';
import '../helpers/screen_harness.dart';

void main() {
  setUpAll(loadAppFonts);

  testWidgets('buying a theme shows the sheet cleanly and confirms with a toast', (tester) async {
    useDesignFrame(tester);
    final env = (await tester.runAsync(() => ScreenEnv.create(coins: 1000, themes: const {})))!;
    addTearDown(() => tester.runAsync(env.dispose));
    await tester.pumpWidget(env.wrap(const ThemesScreen()));
    await tester.pump(const Duration(milliseconds: 500));

    await tester.tap(find.text('Walnut Workshop').first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await expectLater(find.byType(ThemesScreen), matchesGoldenFile('../golden/goldens/14-themes-sheet.png'));

    await tester.tap(find.textContaining('BUY'));
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 300)));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Theme unlocked.'), findsOneWidget);
    await tester.pump(const Duration(seconds: 4));
  });
}
