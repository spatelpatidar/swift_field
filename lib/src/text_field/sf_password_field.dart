import 'package:flutter/material.dart';
import '../theme/sf_theme.dart';

/// A password text field with a built-in show/hide toggle.
///
/// Manages its own obscure state internally, so you don't need any
/// external `setState` to toggle visibility.
///
/// **Usage:**
/// ```dart
/// SFPasswordField(
///   controller: _passwordController,
///   labelText: 'Password',
///   prefixIcon: Icons.lock,
///   validator: (value) {
///     if (value == null || value.length < 8) return 'Min 8 characters';
///     return null;
///   },
/// )
/// ```
///
/// **Custom icons:**
/// ```dart
/// SFPasswordField(
///   controller: _passwordController,
///   labelText: 'Password',
///   prefixIcon: Icons.lock_outline,
///   visibleIcon: Icons.visibility_outlined,
///   hiddenIcon: Icons.visibility_off_outlined,
/// )
/// ```
class SFPasswordField extends StatefulWidget {
  const SFPasswordField({
    required this.controller,
    required this.labelText,
    super.key,
    this.prefixIcon = Icons.lock_outline,
    this.visibleIcon = Icons.visibility_outlined,
    this.hiddenIcon = Icons.visibility_off_outlined,
    this.validator,
    this.focusNode,
    this.textInputAction,
    this.onFieldSubmitted,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.style,
    this.hintText,
    this.enabled = true,
    this.initiallyObscured = true,
    this.obscuringCharacter = '✲',
  });

  /// Controller for the password field.
  final TextEditingController controller;

  /// Label shown above/inside the field.
  final String labelText;

  /// Optional hint text.
  final String? hintText;

  /// Icon shown on the left side.
  final IconData prefixIcon;

  /// Icon shown when the password IS visible (tap to hide).
  final IconData visibleIcon;

  /// Icon shown when the password IS hidden (tap to reveal).
  final IconData hiddenIcon;

  /// Validation function.
  final String? Function(String?)? validator;

  /// Focus node for programmatic focus.
  final FocusNode? focusNode;

  /// Keyboard action button behavior.
  final TextInputAction? textInputAction;

  /// Called when the user submits the field.
  final void Function(String)? onFieldSubmitted;

  /// Controls when to auto-validate.
  final AutovalidateMode autovalidateMode;

  /// Text style for the input.
  final TextStyle? style;

  /// If false, the field is fully disabled.
  final bool enabled;

  /// Whether the password is hidden on first render. Defaults to true.
  final bool initiallyObscured;

  /// Character used to obscure password text. and Defaults to '✲'. Must be exactly one character.
  final String obscuringCharacter;

  @override
  State<SFPasswordField> createState() => _SFPasswordFieldState();
}

class _SFPasswordFieldState extends State<SFPasswordField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.initiallyObscured;
  }

  void _toggleObscure() {
    setState(() => _obscureText = !_obscureText);
  }

  @override
  Widget build(BuildContext context) {
    final safeObscuringChar = widget.obscuringCharacter.characters.isNotEmpty
        ? widget.obscuringCharacter.characters.first
        : '✲';

    return TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      obscureText: _obscureText,
      obscuringCharacter: safeObscuringChar,
      validator: widget.validator,
      autovalidateMode: widget.autovalidateMode,
      textInputAction: widget.textInputAction,
      onFieldSubmitted: widget.onFieldSubmitted,
      enabled: widget.enabled,
      style: widget.style,
      decoration: SFTheme.buildDecoration(
        labelText: widget.labelText,
        prefixIcon: widget.prefixIcon,
        suffixWidget: IconButton(
          icon: Icon(_obscureText ? widget.hiddenIcon : widget.visibleIcon),
          onPressed: _toggleObscure,
        ),
      ).copyWith(hintText: widget.hintText),
    );
  }
}
