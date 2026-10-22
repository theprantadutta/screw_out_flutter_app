import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../core/theme/blueprint_tokens.dart';
import '../l10n/app_localizations.dart';
import '../presentation/bloc/auth/auth_cubit.dart';
import 'bp/bp_buttons.dart';
import 'bp/bp_sheet.dart';
import 'bp/bp_text_field.dart';

/// New email accounts need at least this many characters.
const minPasswordLength = 8;

final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

/// Email sign-in / account creation (with "Forgot password?"). Resolves
/// true once signed in; false when the player closed it. Errors stay inline.
Future<bool> showEmailAuthSheet(BuildContext context, {bool create = false}) async {
  final auth = context.read<AuthCubit>();
  final ok = await showModalBottomSheet<bool>(
    context: context,
    backgroundColor: BpColor.transparent,
    barrierColor: BpColor.scrim,
    elevation: 0,
    isScrollControlled: true,
    builder: (_) => EmailAuthSheet(auth: auth, initialCreate: create),
  );
  return ok ?? false;
}

/// Plain words for a Firebase Auth error code.
String emailAuthMessage(AppLocalizations l, String? code) => switch (code) {
  'invalid-email' => l.emailInvalid,
  'wrong-password' ||
  'invalid-credential' ||
  'user-not-found' ||
  'invalid-login-credentials' ||
  'INVALID_LOGIN_CREDENTIALS' => l.authErrWrongCredentials,
  'email-already-in-use' || 'credential-already-in-use' || 'provider-already-linked' => l.authErrEmailInUse,
  'weak-password' || 'password-does-not-meet-requirements' => l.authErrWeakPassword,
  'user-disabled' => l.authErrDisabled,
  'operation-not-allowed' => l.authErrNotEnabled,
  'too-many-requests' => l.authErrTooMany,
  'network-request-failed' => l.authErrNetwork,
  _ => l.authErrGeneric,
};

class EmailAuthSheet extends StatefulWidget {
  const EmailAuthSheet({super.key, required this.auth, this.initialCreate = false});

  final AuthCubit auth;
  final bool initialCreate;

  @override
  State<EmailAuthSheet> createState() => _EmailAuthSheetState();
}

class _EmailAuthSheetState extends State<EmailAuthSheet> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  late bool _create = widget.initialCreate;
  bool _busy = false;
  bool _obscure = true;
  String? _error;
  String? _info;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _setMode(bool create) {
    if (_busy || create == _create) return;
    setState(() {
      _create = create;
      _error = null;
      _info = null;
    });
    _form.currentState?.reset();
  }

  Future<void> _submit() async {
    setState(() {
      _error = null;
      _info = null;
    });
    if (!(_form.currentState?.validate() ?? false)) return;
    final l = AppLocalizations.of(context);
    setState(() => _busy = true);
    final r = await widget.auth.signInWithEmail(email: _email.text.trim(), password: _password.text, create: _create);
    if (!mounted) return;
    if (r.ok) {
      TextInput.finishAutofillContext();
      Navigator.of(context).pop(true);
      return;
    }
    setState(() {
      _busy = false;
      _error = emailAuthMessage(l, r.code);
    });
  }

  Future<void> _reset() async {
    final l = AppLocalizations.of(context);
    final email = _email.text.trim();
    if (!_emailPattern.hasMatch(email)) {
      setState(() {
        _info = null;
        _error = l.forgotNeedsEmail;
      });
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
      _info = null;
    });
    final r = await widget.auth.sendPasswordReset(email);
    if (!mounted) return;
    setState(() {
      _busy = false;
      if (r.ok) {
        _info = l.resetSent(email);
      } else {
        _error = emailAuthMessage(l, r.code);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final inset = MediaQuery.viewInsetsOf(context).bottom;
    Widget tab(String label, bool create) {
      final selected = _create == create;
      return Expanded(
        child: BpOutlineButton(
          height: 40,
          color: selected ? BpColor.action : BpColor.divider,
          textColor: selected ? BpColor.action : BpColor.textMuted,
          onPressed: () => _setMode(create),
          child: Text(label, style: BpType.monoSmallButton),
        ),
      );
    }

    return PopScope(
      canPop: !_busy,
      child: Padding(
        padding: EdgeInsets.only(bottom: inset),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(BpSize.sheetInset, 0, BpSize.sheetInset, 14),
            child: Form(
              key: _form,
              child: BpSheetCard(
                children: [
                  Text(_create ? l.emailCreateTitle : l.emailSignInTitle, style: BpType.stuckTitle.copyWith(color: BpColor.line)),
                  Text(l.emailSheetBody, style: BpType.monoBody.copyWith(color: BpColor.textSecondary, height: 1.5)),
                  Row(children: [tab(l.emailTabSignIn, false), const SizedBox(width: 8), tab(l.emailTabCreate, true)]),
                  AutofillGroup(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        BpTextField(
                          controller: _email,
                          label: l.emailLabel,
                          enabled: !_busy,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          autofillHints: const [AutofillHints.email],
                          validator: (v) {
                            final s = (v ?? '').trim();
                            if (s.isEmpty) return l.emailRequired;
                            if (!_emailPattern.hasMatch(s)) return l.emailInvalid;
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        BpTextField(
                          controller: _password,
                          label: l.passwordLabel,
                          enabled: !_busy,
                          obscureText: _obscure,
                          textInputAction: TextInputAction.done,
                          autofillHints: [_create ? AutofillHints.newPassword : AutofillHints.password],
                          helper: _create ? l.passwordHint(minPasswordLength) : null,
                          onSubmitted: (_) => _submit(),
                          suffix: IconButton(
                            tooltip: _obscure ? l.showPassword : l.hidePassword,
                            onPressed: () => setState(() => _obscure = !_obscure),
                            icon: Icon(_obscure ? Symbols.visibility_sharp : Symbols.visibility_off_sharp, size: 20),
                          ),
                          validator: (v) {
                            final s = v ?? '';
                            if (s.isEmpty) return l.passwordRequired;
                            if (_create && s.length < minPasswordLength) return l.passwordTooShort(minPasswordLength);
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  if (!_create)
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: Semantics(
                        button: true,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: _busy ? null : _reset,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(minHeight: 40),
                            child: Align(
                              widthFactor: 1,
                              alignment: Alignment.centerRight,
                              child: Text(
                                l.forgotPassword,
                                style: BpType.monoBody.copyWith(
                                  color: BpColor.action,
                                  decoration: TextDecoration.underline,
                                  decorationColor: BpColor.action,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (_error != null)
                    Text(_error!, style: BpType.monoBody.copyWith(color: BpColor.blocked, height: 1.4)),
                  if (_info != null)
                    Text(_info!, style: BpType.monoBody.copyWith(color: BpColor.success, height: 1.4)),
                  BpPrimaryButton(
                    onPressed: _busy ? null : _submit,
                    child: Text(
                      _busy ? l.emailWorking : (_create ? l.emailCreateTitle : l.emailSignInTitle),
                      style: BpType.monoButtonBold.copyWith(color: BpColor.ink),
                    ),
                  ),
                  BpOutlineButton(
                    height: 46,
                    onPressed: _busy ? null : () => Navigator.of(context).pop(false),
                    child: Text(l.cancel, style: BpType.monoSmallButton),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
