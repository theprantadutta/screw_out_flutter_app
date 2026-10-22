import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:screw_out/presentation/bloc/auth/auth_cubit.dart';
import 'package:screw_out/screens/settings/settings_screen.dart';
import 'package:screw_out/services/ports.dart';
import 'package:screw_out/widgets/bp/bp_buttons.dart';
import 'package:screw_out/widgets/email_auth_sheet.dart';
import 'package:screw_out/widgets/purchase_gate.dart';

import '../helpers/fake_auth.dart';
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

  Future<(FakeAuth, RecordingPurchases)> pumpSettings(WidgetTester tester, {bool signedIn = false}) async {
    useDesignFrame(tester);
    final auth = FakeAuth(signedIn: signedIn);
    final store = RecordingPurchases();
    final env = (await tester.runAsync(() => ScreenEnv.create(auth: auth)))!;
    env.purchases = store;
    addTearDown(() => tester.runAsync(env.dispose));
    await tester.pumpWidget(env.wrap(const SettingsScreen()));
    await settle(tester);
    return (auth, store);
  }

  /// The settings list builds lazily: scroll [target] into view first.
  Future<void> reveal(WidgetTester tester, Finder target) async {
    await tester.scrollUntilVisible(target, 200, scrollable: find.byType(Scrollable).first);
    await tester.pumpAndSettle();
  }

  Future<void> tapRemoveAds(WidgetTester tester) async {
    await reveal(tester, find.text('Remove ads'));
    await tester.tap(find.text('Remove ads'));
    await tester.pumpAndSettle();
  }

  /// Lets queued toasts run out so no timers are left pending.
  Future<void> drainToasts(WidgetTester tester) async {
    for (var i = 0; i < 4; i++) {
      await tester.pump(const Duration(seconds: 4));
    }
  }

  testWidgets('a guest tapping a purchase gets the sign-in sheet, not the store', (tester) async {
    final (_, store) = await pumpSettings(tester);
    await tapRemoveAds(tester);

    expect(find.byType(PurchaseSignInSheet), findsOneWidget);
    expect(find.textContaining('Create an account or sign in to buy'), findsOneWidget);
    expect(find.descendant(of: find.byType(PurchaseSignInSheet), matching: find.text('Sign in with Google')), findsOneWidget);
    expect(find.descendant(of: find.byType(PurchaseSignInSheet), matching: find.text('Continue with email')), findsOneWidget);
    expect(store.bought, isEmpty);

    await tester.tap(find.text('NOT NOW'));
    await tester.pumpAndSettle();
    expect(find.byType(PurchaseSignInSheet), findsNothing);
    expect(store.bought, isEmpty, reason: 'cancel returns quietly');
  });

  testWidgets('signing in from the sheet continues the purchase that was tapped', (tester) async {
    final (auth, store) = await pumpSettings(tester);
    await tapRemoveAds(tester);
    await tester.tap(find.descendant(of: find.byType(PurchaseSignInSheet), matching: find.text('Sign in with Google')));
    await tester.pumpAndSettle();

    expect(auth.current.isGuest, isFalse);
    expect(find.byType(PurchaseSignInSheet), findsNothing);
    expect(store.bought, [Products.removeAds]);
    await drainToasts(tester);
  });

  testWidgets('email sign-in from the purchase sheet also continues the purchase', (tester) async {
    final (auth, store) = await pumpSettings(tester);
    await tapRemoveAds(tester);
    await tester.tap(find.descendant(of: find.byType(PurchaseSignInSheet), matching: find.text('Continue with email')));
    await tester.pumpAndSettle();
    expect(find.byType(EmailAuthSheet), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(0), 'buyer@example.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'hunter22');
    await tester.tap(find.descendant(of: find.byType(EmailAuthSheet), matching: find.text('Sign in')).last);
    await tester.pumpAndSettle();

    expect(auth.emailCalls.single, (email: 'buyer@example.com', password: 'hunter22', create: false));
    expect(find.byType(EmailAuthSheet), findsNothing);
    expect(find.byType(PurchaseSignInSheet), findsNothing);
    expect(store.bought, [Products.removeAds]);
    await drainToasts(tester);
  });

  testWidgets('a guest tapping Restore is asked to sign in first', (tester) async {
    final (_, store) = await pumpSettings(tester);
    await reveal(tester, find.text('RESTORE'));
    await tester.tap(find.text('RESTORE'));
    await tester.pumpAndSettle();
    expect(find.byType(PurchaseSignInSheet), findsOneWidget);
    await tester.tap(find.text('NOT NOW'));
    await tester.pumpAndSettle();
    expect(store.restores, 0);
  });

  testWidgets('a signed-in player goes straight to the store', (tester) async {
    final (_, store) = await pumpSettings(tester, signedIn: true);
    await tapRemoveAds(tester);
    expect(find.byType(PurchaseSignInSheet), findsNothing);
    expect(store.bought, [Products.removeAds]);
    await drainToasts(tester);
  });

  group('email sheet', () {
    Future<FakeAuth> openSheet(WidgetTester tester, {bool create = false}) async {
      useDesignFrame(tester);
      final auth = FakeAuth();
      final env = (await tester.runAsync(() => ScreenEnv.create(auth: auth)))!;
      addTearDown(() => tester.runAsync(env.dispose));
      await tester.pumpWidget(
        env.wrap(
          Scaffold(
            body: Builder(
              builder: (context) => Center(
                child: TextButton(onPressed: () => showEmailAuthSheet(context, create: create), child: const Text('open')),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      return auth;
    }

    testWidgets('validates before calling Firebase', (tester) async {
      final auth = await openSheet(tester, create: true);
      await tester.enterText(find.byType(TextFormField).at(0), 'not-an-email');
      await tester.enterText(find.byType(TextFormField).at(1), 'short');
      await tester.tap(find.descendant(of: find.byType(BpPrimaryButton), matching: find.text('Create account')));
      await tester.pumpAndSettle();
      expect(find.text("That email address doesn't look right."), findsOneWidget);
      expect(find.text('Use at least 8 characters.'), findsOneWidget);
      expect(auth.emailCalls, isEmpty);
    });

    testWidgets('shows a friendly message for a wrong password and stays open', (tester) async {
      final auth = await openSheet(tester);
      auth.emailResult = const EmailAuthResult.failure('invalid-credential');
      await tester.enterText(find.byType(TextFormField).at(0), 'a@b.co');
      await tester.enterText(find.byType(TextFormField).at(1), 'nope');
      await tester.tap(find.descendant(of: find.byType(BpPrimaryButton), matching: find.text('Sign in')));
      await tester.pumpAndSettle();
      expect(find.text('Wrong email or password.'), findsOneWidget);
      expect(find.byType(EmailAuthSheet), findsOneWidget);
    });

    testWidgets('Forgot password sends a reset to the typed address', (tester) async {
      final auth = await openSheet(tester);
      await tester.tap(find.text('Forgot password?'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Enter your email above'), findsOneWidget);
      expect(auth.resetCalls, isEmpty);

      await tester.enterText(find.byType(TextFormField).at(0), 'me@example.com');
      await tester.tap(find.text('Forgot password?'));
      await tester.pumpAndSettle();
      expect(auth.resetCalls, ['me@example.com']);
      expect(find.textContaining('a reset link is on its way'), findsOneWidget);
    });
  });
}
