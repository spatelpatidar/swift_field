part of '../sf_button.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SFIconButtonTheme
// ─────────────────────────────────────────────────────────────────────────────
//
// Describes the full visual appearance of [SFIconButton] in ONE state.
// Same pattern as SFButtonTheme — fully independent per state.
//
// Example:
//   final base = SFIconButtonTheme(
//     backgroundColor: Color(0xFF003249),
//     borderRadius: 10,
//     height: 44,
//   );
//
//   SFIconButton(
//     text: 'Export',
//     icon: Icons.download,
//     onPressed: _export,
//     defaultTheme: base,
//     pressedTheme:  base.copyWith(backgroundColor: Color(0xFF001F30)),
//     loadingTheme:  base.copyWith(backgroundColor: Colors.grey),
//     disabledTheme: base.copyWith(backgroundColor: Colors.grey.shade300),
//   )
// ─────────────────────────────────────────────────────────────────────────────

class SFIconButtonTheme {
  const SFIconButtonTheme({
    this.backgroundColor,
    this.gradient,
    this.textColor,
    this.iconColor,
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
    this.iconSize,
    this.gap,
  }) : assert(
          backgroundColor == null || gradient == null,
          'Provide either backgroundColor or gradient, not both.',
        );

  final Color? backgroundColor;
  final Gradient? gradient;
  final Color? textColor;

  /// Icon color override. Falls back to [textColor] when null.
  final Color? iconColor;
  final Color? borderColor;
  final double? borderWidth;
  final double? height;
  final double? width;
  final double? borderRadius;
  final TextStyle? textStyle;
  final double? elevation;
  final EdgeInsetsGeometry? padding;
  final Color? shadowColor;
  final List<BoxShadow>? boxShadow;

  /// Icon size override for this state.
  final double? iconSize;

  /// Gap between icon and label for this state.
  final double? gap;

  // ── copyWith ───────────────────────────────────────────────────────────────

  SFIconButtonTheme copyWith({
    Color? backgroundColor,
    Gradient? gradient,
    Color? textColor,
    Color? iconColor,
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
    double? iconSize,
    double? gap,
  }) {
    return SFIconButtonTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      gradient: gradient ?? this.gradient,
      textColor: textColor ?? this.textColor,
      iconColor: iconColor ?? this.iconColor,
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
      iconSize: iconSize ?? this.iconSize,
      gap: gap ?? this.gap,
    );
  }

  /// Shortcut: copy only color/gradient/border.
  SFIconButtonTheme copyColorWith({
    Color? backgroundColor,
    Gradient? gradient,
    Color? textColor,
    Color? iconColor,
    Color? borderColor,
  }) {
    return copyWith(
      backgroundColor: backgroundColor,
      gradient: gradient,
      textColor: textColor,
      iconColor: iconColor,
      borderColor: borderColor,
    );
  }

  /// Merge — fills any null field from [other].
  SFIconButtonTheme apply({required SFIconButtonTheme other}) {
    return SFIconButtonTheme(
      backgroundColor: backgroundColor ?? other.backgroundColor,
      gradient: gradient ?? other.gradient,
      textColor: textColor ?? other.textColor,
      iconColor: iconColor ?? other.iconColor,
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
      iconSize: iconSize ?? other.iconSize,
      gap: gap ?? other.gap,
    );
  }
}
