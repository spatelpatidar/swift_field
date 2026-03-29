import 'package:flutter/material.dart';
import '../theme/sf_theme.dart';

/// A fully customizable text form field for SwiftField.
///
/// Wraps [TextFormField] with sensible defaults driven by [SFTheme],
/// while allowing full per-widget override.
///
/// **Basic usage:**
/// ```dart
/// SFTextField(
///   controller: _nameController,
///   labelText: 'Full Name',
///   prefixIcon: Icons.person,
/// )
/// ```
///
/// **Multi-line usage:**
/// ```dart
/// SFTextField(
///   controller: _bioController,
///   labelText: 'Bio',
///   prefixIcon: Icons.notes,
///   maxLines: 5,
///   minLines: 3,
///   keyboardType: TextInputType.multiline,
/// )
/// ```
///
/// **Read-only usage:**
/// ```dart
/// SFTextField(
///   controller: _idController,
///   labelText: 'User ID',
///   prefixIcon: Icons.badge,
///   readOnly: true,
/// )
/// ```
class SFTextField extends StatelessWidget {
  const SFTextField({
    required this.controller, required this.labelText, super.key,
    this.prefixIcon,
    this.suffixIcon,
    this.suffixWidget,
    this.obscureText = false,
    this.validator,
    this.focusNode,
    this.textInputAction,
    this.maxLines,
    this.minLines,
    this.keyboardType,
    this.onFieldSubmitted,
    this.onChanged,
    this.textCapitalization = TextCapitalization.none,
    this.readOnly = false,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.decoration,
    this.style,
    this.hintText,
    this.enabled = true,
    this.autofocus = false,
    this.inputFormatters,
    this.maxLength,
    this.onTap,
  });

  /// Controller for the text field.
  final TextEditingController controller;

  /// Label shown above/inside the field.
  final String labelText;

  /// Optional hint text shown when the field is empty.
  final String? hintText;

  /// Icon shown on the left side of the field.
  final IconData? prefixIcon;

  /// Icon shown on the right side. Ignored if [suffixWidget] is provided.
  final IconData? suffixIcon;

  /// Custom widget for the suffix (e.g. a button, loader).
  final Widget? suffixWidget;

  /// Whether to hide the text (e.g. for passwords).
  final bool obscureText;

  /// Validation function. Return null for valid, error string for invalid.
  final String? Function(String?)? validator;

  /// Focus node for programmatic focus management.
  final FocusNode? focusNode;

  /// The action to use on the keyboard's action button.
  final TextInputAction? textInputAction;

  /// Maximum number of lines the field can grow to.
  final int? maxLines;

  /// Minimum number of lines shown initially. Defaults to 1.
  final int? minLines;

  /// The keyboard type to show (e.g. email, number, multiline).
  final TextInputType? keyboardType;

  /// Called when the user submits the field (taps the action button).
  final void Function(String)? onFieldSubmitted;

  /// Called whenever the text changes.
  final void Function(String)? onChanged;

  /// Text capitalization behavior.
  final TextCapitalization textCapitalization;

  /// If true, the field is not editable and is visually grayed out.
  final bool readOnly;

  /// If false, the field is fully disabled (not interactive).
  final bool enabled;

  /// If true, the field is auto-focused on build.
  final bool autofocus;

  /// Controls when to auto-validate.
  final AutovalidateMode autovalidateMode;

  /// Full override for the field's [InputDecoration]. Replaces all theme defaults.
  final InputDecoration? decoration;

  /// Text style for the input text itself.
  final TextStyle? style;

  /// Input formatters (e.g. for masking, length limiting).
  final List<dynamic>? inputFormatters;

  /// Maximum character count.
  final int? maxLength;

  /// Called when the field is tapped.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText,
      obscuringCharacter: '✲',
      validator: validator,
      autovalidateMode: autovalidateMode,
      textInputAction: readOnly ? TextInputAction.none : textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      onChanged: onChanged,
      textCapitalization: textCapitalization,
      readOnly: readOnly,
      enabled: enabled,
      autofocus: autofocus,
      maxLength: maxLength,
      onTap: onTap,
      style: style,
      decoration: decoration ??
          SFTheme.buildDecoration(
            labelText: labelText,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            suffixWidget: suffixWidget,
            readOnly: readOnly,
          ).copyWith(hintText: hintText),
      maxLines: obscureText ? 1 : maxLines,
      minLines: minLines ?? 1,
      keyboardType: keyboardType,
    );
  }
}