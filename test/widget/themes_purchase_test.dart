import 'package:flutter_test/flutter_test.dart';
import 'package:screw_out/screens/themes/themes_screen.dart';

import '../helpers/fake_auth.dart';
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

  testWidgets('store: the All themes card and a pack button buy the right products', (tester) async {
    useDesignFrame(tester);
    final store = RecordingPurchases();
    final env = (await tester.runAsync(() => ScreenEnv.create(auth: FakeAuth(signedIn: true), themes: const {})))!;
    env.purchases = store;
    addTearDown(() => tester.runAsync(env.dispose));
    await tester.pumpWidget(env.wrap(const ThemesScreen()));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('All themes'), findsOneWidget);
    await tester.tap(find.text(r'BUY · $0.99'));
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 100)));
    await tester.pump();
    expect(store.bought, ['themes_bundle']);
    await tester.pump(const Duration(seconds: 4));

    await tester.tap(find.text('Walnut Workshop').first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.tap(find.text(r'OR BUY · $0.99'));
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 100)));
    await tester.pump();
    expect(store.bought, ['themes_bundle', 'theme_pack_workshop']);
    await tester.pump(const Duration(seconds: 4));
  });

  testWidgets('store: Pro sees no theme store buttons', (tester) async {
    useDesignFrame(tester);
    final env = (await tester.runAsync(() => ScreenEnv.create(pro: true, themes: const {})))!;
    env.purchases = RecordingPurchases();
    addTearDown(() => tester.runAsync(env.dispose));
    await tester.pumpWidget(env.wrap(const ThemesScreen()));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('All themes'), findsNothing);
  });
}
