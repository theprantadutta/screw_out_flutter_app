import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:screw_out/screens/settings/sign_out_sheet.dart';

import '../helpers/harness.dart';

class _Opener extends StatefulWidget {
  const _Opener();

  @override
  State<_Opener> createState() => _OpenerState();
}

class _OpenerState extends State<_Opener> {
  bool? result;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: TextButton(
        onPressed: () async {
          final r = await confirmSignOut(context);
          setState(() => result = r);
        },
        child: const Text('open'),
      ),
    ),
  );
}

void main() {
  Future<_OpenerState> open(WidgetTester tester) async {
    useDesignFrame(tester);
    await tester.pumpWidget(appShell(child: const _Opener()));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    return tester.state<_OpenerState>(find.byType(_Opener));
  }

  testWidgets('explains the device is cleared; Stay signed in cancels', (tester) async {
    final state = await open(tester);
    expect(find.text('Sign out?'), findsOneWidget);
    expect(find.textContaining('clears your progress from this device'), findsOneWidget);
    await tester.tap(find.text('Stay signed in'));
    await tester.pumpAndSettle();
    expect(state.result, isFalse);
  });

  testWidgets('Sign out confirms', (tester) async {
    final state = await open(tester);
    await tester.tap(find.text('Sign out'));
    await tester.pumpAndSettle();
    expect(state.result, isTrue);
  });

  testWidgets('dismissing the sheet does not sign out', (tester) async {
    final state = await open(tester);
    await tester.tapAt(const Offset(180, 40)); // the scrim
    await tester.pumpAndSettle();
    expect(state.result, isFalse);
  });
}
