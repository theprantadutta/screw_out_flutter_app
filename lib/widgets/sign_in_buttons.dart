import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/theme/blueprint_tokens.dart';
import '../l10n/app_localizations.dart';
import '../presentation/bloc/auth/auth_cubit.dart';
import 'bp/bp_buttons.dart';
import 'email_auth_sheet.dart';

/// Apple sign-in is offered on Apple platforms, and there wherever Google is
/// (App Store Guideline 4.8).
bool get offersAppleSignIn => defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.macOS;

/// Every way in: Google, Apple (iOS / macOS) and email. [onResult] gets
/// whether a sign-in the player started succeeded; closing the email sheet
/// reports nothing. Disabled while a sign-in is running.
class SignInButtons extends StatelessWidget {
  const SignInButtons({super.key, required this.onResult, this.height = 50, this.primaryGoogle = false});

  final ValueChanged<bool> onResult;
  final double height;

  /// Google as the yellow primary button (boards, purchase sheet).
  final bool primaryGoogle;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cubit = context.read<AuthCubit>();
    final busy = context.select<AuthCubit, bool>((c) => c.state.status == AuthStatus.loading);
    final outlineText = BpType.body.copyWith(fontSize: 14, color: BpColor.line);

    Future<void> run(Future<bool> Function() f) async => onResult(await f());

    Future<void> email() async {
      if (await showEmailAuthSheet(context)) onResult(true);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (primaryGoogle)
          BpPrimaryButton(
            height: height,
            onPressed: busy ? null : () => run(cubit.signInWithGoogle),
            child: Text(l.signInGoogle),
          )
        else
          BpOutlineButton(
            height: height,
            onPressed: busy ? null : () => run(cubit.signInWithGoogle),
            child: Text(l.signInGoogle, style: outlineText),
          ),
        if (offersAppleSignIn) ...[
          const SizedBox(height: 8),
          BpOutlineButton(
            height: height,
            onPressed: busy ? null : () => run(cubit.signInWithApple),
            child: Text(l.signInApple, style: outlineText),
          ),
        ],
        const SizedBox(height: 8),
        BpOutlineButton(
          height: height,
          onPressed: busy ? null : email,
          child: Text(l.signInEmail, style: outlineText),
        ),
      ],
    );
  }
}
