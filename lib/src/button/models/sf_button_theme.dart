part of '../sf_button.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SFButtonTheme
// ─────────────────────────────────────────────────────────────────────────────
//
// Describes the full visual appearance of [SFButton] in ONE state.
// Every property is independent — give each state a completely different
// color, gradient, border, radius, size, text style.
//
// Mirrors SFPinTheme's pattern:
//
//   final base = SFButtonTheme(
//     backgroundColor: Colors.indigo,
//     borderRadius: 12,
//     textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//   );
//
//   final pressed  = base.copyWith(backgroundColor: Colors.indigo.shade900);
//   final loading  = base.copyWith(backgroundColor: Colors.indigo.shade300);
//   final disabled = base.copyWith(backgroundColor: Colors.grey.shade300);
//
// ─────────────────────────────────────────────────────────────────────────────

class SFButtonTheme {
  const SFButtonTheme({
    this.backgroundColor,
    this.gradient,
    this.textColor,
    this.borderColor,
    this.borderWidth,
    this.height,
    this.width,
    this.borderRadius,
    this.textStyle,
    this.elevation,
    this.padding,
    this.shadowColor,
    this.boxShadow,
  }) : assert(
          backgroundColor == null || gradient == null,
          'Provide either backgroundColor or gradient, not both.',
        );

  /// Solid background color. Mutually exclusive with [gradient].
  final Color? backgroundColor;

  /// Gradient background. Mutually exclusive with [backgroundColor].
  final Gradient? gradient;

  /// Text and spinner color.
  final Color? textColor;

  /// Border color. Null = no border.
  final Color? borderColor;

  /// Border width. Defaults to 1.2 when [borderColor] is set.
  final double? borderWidth;

  /// Button height.
  final double? height;

  /// Button width.
  final double? width;

  /// Corner radius.
  final double? borderRadius;

  /// Text style for the label.
  final TextStyle? textStyle;

  /// Drop shadow depth.
  final double? elevation;

  /// Internal padding.
  final EdgeInsetsGeometry? padding;

  /// Shadow color for elevation.
  final Color? shadowColor;

  /// Custom box shadows — overrides [elevation].
  final List<BoxShadow>? boxShadow;

  // ── copyWith ───────────────────────────────────────────────────────────────

  SFButtonTheme copyWith({
    Color? backgroundColor,
    Gradient? gradient,
    Color? textColor,
    Color? borderColor,
    double? borderWidth,
    double? height,
    double? width,
    double? borderRadius,
    TextStyle? textStyle,
    double? elevation,
    EdgeInsetsGeometry? padding,
    Color? shadowColor,
    List<BoxShadow>? boxShadow,
  }) {
    return SFButtonTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      gradient: gradient ?? this.gradient,
      textColor: textColor ?? this.textColor,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      height: height ?? this.height,
      width: width ?? this.width,
      borderRadius: borderRadius ?? this.borderRadius,
      textStyle: textStyle ?? this.textStyle,
      elevation: elevation ?? this.elevation,
      padding: padding ?? this.padding,
      shadowColor: shadowColor ?? this.shadowColor,
      boxShadow: boxShadow ?? this.boxShadow,
    );
  }

  /// Shortcut: copy only color/gradient/border without touching size or style.
  SFButtonTheme copyColorWith({
    Color? backgroundColor,
    Gradient? gradient,
    Color? textColor,
    Color? borderColor,
  }) {
    return copyWith(
      backgroundColor: backgroundColor,
      gradient: gradient,
      textColor: textColor,
      borderColor: borderColor,
    );
  }

  /// Merge — fills any null field from [other].
  SFButtonTheme apply({required SFButtonTheme other}) {
    return SFButtonTheme(
      backgroundColor: backgroundColor ?? other.backgroundColor,
      gradient: gradient ?? other.gradient,
      textColor: textColor ?? other.textColor,
      borderColor: borderColor ?? other.borderColor,
      borderWidth: borderWidth ?? other.borderWidth,
      height: height ?? other.height,
      width: width ?? other.width,
      borderRadius: borderRadius ?? other.borderRadius,
      textStyle: textStyle ?? other.textStyle,
      elevation: elevation ?? other.elevation,
      padding: padding ?? other.padding,
      shadowColor: shadowColor ?? other.shadowColor,
      boxShadow: boxShadow ?? other.boxShadow,
    );
  }
}
