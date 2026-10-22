import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:screw_out/presentation/bloc/auth/auth_cubit.dart';
import 'package:screw_out/screens/settings/delete_account_sheet.dart';

import '../helpers/harness.dart';

/// Opens the sheet from a button and records what it resolved to.
class _Opener extends StatefulWidget {
  const _Opener({required this.isPro, required this.delete, this.needsPassword = false});

  final bool isPro;
  final bool needsPassword;
  final Future<AccountDeletion> Function(String? password) delete;

  @override
  State<_Opener> createState() => _OpenerState();
}

class _OpenerState extends State<_Opener> {
  AccountDeletion? result;
  bool closed = false;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: TextButton(
        onPressed: () async {
          final r = await showDeleteAccountSheet(
            context,
            isPro: widget.isPro,
            delete: widget.delete,
            needsPassword: widget.needsPassword,
          );
          setState(() {
            result = r;
            closed = true;
          });
        },
        child: const Text('open'),
      ),
    ),
  );
}

void main() {
  Future<_OpenerState> open(
    WidgetTester tester, {
    required bool isPro,
    required Future<AccountDeletion> Function(String? password) delete,
    bool needsPassword = false,
  }) async {
    useDesignFrame(tester);
    await tester.pumpWidget(appShell(child: _Opener(isPro: isPro, delete: delete, needsPassword: needsPassword)));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    return tester.state<_OpenerState>(find.byType(_Opener));
  }

  testWidgets('explains the deletion; Keep my account deletes nothing', (tester) async {
    var calls = 0;
    final state = await open(tester, isPro: false, delete: (_) async {
      calls++;
      return AccountDeletion.deleted;
    });
    expect(find.text('Delete your account?'), findsOneWidget);
    expect(find.text('Manage subscription'), findsNothing, reason: 'no Pro, no billing warning');

    await tester.tap(find.text('Keep my account'));
    await tester.pumpAndSettle();
    expect(calls, 0);
    expect(state.closed, isTrue);
    expect(state.result, isNull);
  });

  testWidgets('Pro players are warned that deleting does not cancel billing', (tester) async {
    await open(tester, isPro: true, delete: (_) async => AccountDeletion.deleted);
    expect(find.textContaining('does not cancel it'), findsOneWidget);
    expect(find.text('Manage subscription'), findsOneWidget);
  });

  testWidgets('confirming deletes and returns the outcome', (tester) async {
    final state = await open(tester, isPro: false, delete: (_) async => AccountDeletion.deletedProStillBilled);
    await tester.tap(find.text('Delete my account'));
    await tester.pumpAndSettle();
    expect(state.result, AccountDeletion.deletedProStillBilled);
  });

  testWidgets('backing out of the Apple re-confirmation keeps the sheet open', (tester) async {
    final state = await open(tester, isPro: false, delete: (_) async => AccountDeletion.cancelled);
    await tester.tap(find.text('Delete my account'));
    await tester.pumpAndSettle();
    expect(state.closed, isFalse);
    expect(find.text('Delete your account?'), findsOneWidget);
  });

  testWidgets('email accounts re-confirm with their password before deleting', (tester) async {
    final passwords = <String?>[];
    final state = await open(
      tester,
      isPro: false,
      needsPassword: true,
      delete: (password) async {
        passwords.add(password);
        return password == 'right-one' ? AccountDeletion.deleted : AccountDeletion.wrongPassword;
      },
    );
    expect(find.text("Enter your password to confirm it's you."), findsOneWidget);

    await tester.tap(find.text('Delete my account'));
    await tester.pumpAndSettle();
    expect(passwords, isEmpty, reason: 'an empty password never reaches Firebase');
    expect(find.text('Enter your password.'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField), 'wrong');
    await tester.tap(find.text('Delete my account'));
    await tester.pumpAndSettle();
    expect(find.text("That password doesn't match this account."), findsOneWidget);
    expect(state.closed, isFalse);

    await tester.enterText(find.byType(TextFormField), 'right-one');
    await tester.tap(find.text('Delete my account'));
    await tester.pumpAndSettle();
    expect(passwords, ['wrong', 'right-one']);
    expect(state.result, AccountDeletion.deleted);
  });
}
