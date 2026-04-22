part of '../sf_text_field.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SFFieldTheme
// ─────────────────────────────────────────────────────────────────────────────
//
// Describes the full visual appearance of [SFTextField] / [SFPasswordField]
// in ONE state. Every property is independent — give each state a completely
// different color, border, radius, fill, label style, text style.
//
// Mirrors SFPinTheme / SFButtonTheme pattern:
//
//   final base = SFFieldTheme(
//     borderColor: Colors.grey.shade400,
//     borderRadius: 14,
//     fillColor: Colors.white,
//   );
//
//   SFTextField(
//     controller: _ctrl,
//     labelText: 'Email',
//     defaultTheme:  base,
//     focusedTheme:  base.copyWith(borderColor: Colors.blue, borderWidth: 2),
//     errorTheme:    base.copyWith(borderColor: Colors.red, fillColor: Colors.red.shade50),
//     disabledTheme: base.copyWith(borderColor: Colors.grey.shade200, fillColor: Colors.grey.shade100),
//     filledTheme:   base.copyWith(borderColor: Colors.blue.withOpacity(0.4)),
//   )
//
// ─────────────────────────────────────────────────────────────────────────────

class SFFieldTheme {
  const SFFieldTheme({
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.fillColor,
    this.labelStyle,
    this.hintStyle,
    this.textStyle,
    this.prefixIconColor,
    this.suffixIconColor,
    this.errorStyle,
    this.contentPadding,
    this.boxShadow,
  });

  /// Border color for this state.
  final Color? borderColor;

  /// Border width for this state. Default 1.5.
  final double? borderWidth;

  /// Corner radius. Defaults to [SFTheme.borderRadius].
  final double? borderRadius;

  /// Background fill color.
  final Color? fillColor;

  /// Label text style.
  final TextStyle? labelStyle;

  /// Hint text style.
  final TextStyle? hintStyle;

  /// Input text style.
  final TextStyle? textStyle;

  /// Prefix icon color override.
  final Color? prefixIconColor;

  /// Suffix icon color override.
  final Color? suffixIconColor;

  /// Error text style override.
  final TextStyle? errorStyle;

  /// Internal content padding override.
  final EdgeInsetsGeometry? contentPadding;

  /// Box shadow applied around the field container.
  final List<BoxShadow>? boxShadow;

  // ── copyWith ───────────────────────────────────────────────────────────────

  SFFieldTheme copyWith({
    Color? borderColor,
    double? borderWidth,
    double? borderRadius,
    Color? fillColor,
    TextStyle? labelStyle,
    TextStyle? hintStyle,
    TextStyle? textStyle,
    Color? prefixIconColor,
    Color? suffixIconColor,
    TextStyle? errorStyle,
    EdgeInsetsGeometry? contentPadding,
    List<BoxShadow>? boxShadow,
  }) {
    return SFFieldTheme(
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      borderRadius: borderRadius ?? this.borderRadius,
      fillColor: fillColor ?? this.fillColor,
      labelStyle: labelStyle ?? this.labelStyle,
      hintStyle: hintStyle ?? this.hintStyle,
      textStyle: textStyle ?? this.textStyle,
      prefixIconColor: prefixIconColor ?? this.prefixIconColor,
      suffixIconColor: suffixIconColor ?? this.suffixIconColor,
      errorStyle: errorStyle ?? this.errorStyle,
      contentPadding: contentPadding ?? this.contentPadding,
      boxShadow: boxShadow ?? this.boxShadow,
    );
  }

  /// Shortcut: copy only border properties.
  SFFieldTheme copyBorderWith({
    Color? borderColor,
    double? borderWidth,
    double? borderRadius,
  }) {
    return copyWith(
      borderColor: borderColor,
      borderWidth: borderWidth,
      borderRadius: borderRadius,
    );
  }

  /// Merge — fills any null field from [other].
  SFFieldTheme apply({required SFFieldTheme other}) {
    return SFFieldTheme(
      borderColor: borderColor ?? other.borderColor,
      borderWidth: borderWidth ?? other.borderWidth,
      borderRadius: borderRadius ?? other.borderRadius,
      fillColor: fillColor ?? other.fillColor,
      labelStyle: labelStyle ?? other.labelStyle,
      hintStyle: hintStyle ?? other.hintStyle,
      textStyle: textStyle ?? other.textStyle,
      prefixIconColor: prefixIconColor ?? other.prefixIconColor,
      suffixIconColor: suffixIconColor ?? other.suffixIconColor,
      errorStyle: errorStyle ?? other.errorStyle,
      contentPadding: contentPadding ?? other.contentPadding,
      boxShadow: boxShadow ?? other.boxShadow,
    );
  }
}
