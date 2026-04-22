part of '../sf_text_field.dart';

// ─────────────────────────────────────────────────────────────────────────────
// _SFFieldThemeResolver
// ─────────────────────────────────────────────────────────────────────────────
//
// Shared logic used by both SFTextField and SFPasswordField states.
// Resolves which SFFieldTheme to use for the current state, then builds the
// InputDecoration with AnimatedContainer-compatible BoxDecoration underneath.
//
// State priority (mirrors SFPinCode):
//   disabled > error > focused > filled > default > SFTheme fallback
// ─────────────────────────────────────────────────────────────────────────────

mixin _SFFieldThemeResolver {
  // Subclasses provide these
  SFFieldTheme? get defaultTheme;
  SFFieldTheme? get focusedTheme;
  SFFieldTheme? get errorTheme;
  SFFieldTheme? get disabledTheme;
  SFFieldTheme? get filledTheme;

  bool get enabled;
  bool get hasError;
  bool get isFocused;
  bool get isFilled;

  /// Resolves the correct [SFFieldTheme] for the current state.
  SFFieldTheme resolveTheme() {
    if (!enabled && disabledTheme != null) return disabledTheme!;
    if (hasError && errorTheme != null) return errorTheme!;
    if (isFocused && focusedTheme != null) return focusedTheme!;
    if (isFilled && filledTheme != null) return filledTheme!;
    if (defaultTheme != null) return defaultTheme!;
    return const SFFieldTheme(); // all-null → use SFTheme fallbacks
  }

  /// Builds an [InputDecoration] driven by the resolved [SFFieldTheme].
  /// Smooth state transitions happen because the caller wraps the field
  /// in an [AnimatedContainer] that tweens the outer box decoration.
  InputDecoration buildThemedDecoration({
    required SFFieldTheme theme,
    required String labelText,
    required bool readOnly,
    required bool hasError,
    required bool isFocused,
    String? hintText,
    IconData? prefixIcon,
    IconData? suffixIcon,
    Widget? suffixWidget,
    String? errorText,
    TextStyle? errorTextStyle,
    EdgeInsetsGeometry? contentPadding,
  }) {
    final radius = theme.borderRadius ?? SFTheme.borderRadius;

    // Border color resolution
    final Color borderColor;
    final double borderWidth = theme.borderWidth ?? 1.5;

    if (!enabled) {
      borderColor = theme.borderColor ?? Colors.grey.shade300;
    } else if (hasError) {
      borderColor = theme.borderColor ?? Colors.red;
    } else if (isFocused) {
      borderColor = theme.borderColor ?? SFTheme.primaryColor;
    } else {
      borderColor = theme.borderColor ?? Colors.grey.shade400;
    }

    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: BorderSide(color: borderColor, width: borderWidth),
    );

    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      labelStyle: theme.labelStyle ?? SFTheme.labelStyle,
      hintStyle: theme.hintStyle,
      errorText: errorText,
      errorStyle: theme.errorStyle ??
          const TextStyle(fontSize: 12, color: Colors.red),
      border: border,
      enabledBorder: border,
      focusedBorder: border,
      disabledBorder: border,
      errorBorder: border,
      focusedErrorBorder: border,
      filled: theme.fillColor != null || readOnly,
      fillColor: theme.fillColor ??
          (readOnly ? SFTheme.readOnlyFillColor : null),
      contentPadding: theme.contentPadding ??
          contentPadding ??
          const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      prefixIcon: prefixIcon != null
          ? Icon(prefixIcon, color: theme.prefixIconColor)
          : null,
      suffixIcon: suffixWidget ??
          (suffixIcon != null
              ? Icon(suffixIcon, color: theme.suffixIconColor)
              : null),
    );
  }
}
