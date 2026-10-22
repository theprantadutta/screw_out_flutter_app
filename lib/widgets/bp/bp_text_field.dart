import 'package:flutter/material.dart';

import '../../core/theme/blueprint_tokens.dart';

/// Blueprint text input: mono caption label above a square 1.5 dp outline
/// (drafting yellow while focused, salmon on error), white body text.
class BpTextField extends StatelessWidget {
  const BpTextField({
    super.key,
    required this.controller,
    required this.label,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.obscureText = false,
    this.suffix,
    this.helper,
    this.onSubmitted,
    this.enabled = true,
  });

  final TextEditingController controller;
  final String label;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final bool obscureText;
  final Widget? suffix;
  final String? helper;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;

  static OutlineInputBorder _border(Color c) => OutlineInputBorder(
    borderRadius: BorderRadius.zero,
    borderSide: BorderSide(color: c, width: BpSize.stroke),
  );

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(label, style: BpType.label.copyWith(color: BpColor.textMuted)),
      const SizedBox(height: 6),
      TextFormField(
        controller: controller,
        validator: validator,
        enabled: enabled,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        autofillHints: autofillHints,
        obscureText: obscureText,
        autocorrect: false,
        enableSuggestions: !obscureText && keyboardType != TextInputType.emailAddress,
        onFieldSubmitted: onSubmitted,
        cursorColor: BpColor.action,
        style: BpType.body.copyWith(color: BpColor.line),
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          fillColor: BpColor.ink.withValues(alpha: .35),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          border: _border(BpColor.lineDefault),
          enabledBorder: _border(BpColor.lineDefault),
          disabledBorder: _border(BpColor.divider),
          focusedBorder: _border(BpColor.action),
          errorBorder: _border(BpColor.blocked),
          focusedErrorBorder: _border(BpColor.blocked),
          errorStyle: BpType.monoBody.copyWith(color: BpColor.blocked, height: 1.3),
          errorMaxLines: 3,
          helperText: helper,
          helperStyle: BpType.caption.copyWith(letterSpacing: .4, color: BpColor.textMuted),
          suffixIcon: suffix,
          suffixIconColor: BpColor.lineMuted,
        ),
      ),
    ],
  );
}
