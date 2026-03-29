import 'package:flutter/material.dart';

/// Global theme configuration for SwiftField widgets.
///
/// Set once in [//main] before [//runApp], applies to all SF widgets.
///
/// ```dart
/// void main() {
///   SFTheme.primaryColor = Colors.indigo;
///   SFTheme.borderRadius = 12.0;
///   SFTheme.gradient = LinearGradient(
///     colors: [Colors.indigo, Colors.purple],
///     begin: Alignment.centerLeft,
///     end: Alignment.centerRight,
///   );
///   runApp(const MyApp());
/// }
/// ```
class SFTheme {
  SFTheme._();

  /// Primary accent color used for focused borders and buttons.
  static Color primaryColor = const Color(0xFF003249);

  /// Default border radius applied to all widgets.
  static double borderRadius = 16.0;

  /// Default button height.
  static double buttonHeight = 48.0;

  /// Color used for disabled / read-only field backgrounds.
  static Color readOnlyFillColor = const Color(0xFFF5F5F5);

  /// Default label style override. Null uses Flutter's default.
  static TextStyle? labelStyle;

  /// Default button text style override.
  static TextStyle? buttonTextStyle;

  /// Optional global gradient applied to all [//SFButton]s.
  ///
  /// Per-button [//SFButton.gradient] or [//SFButton.backgroundColor] takes
  /// priority over this global setting.
  ///
  /// Example:
  /// ```dart
  /// SFTheme.gradient = LinearGradient(
  ///   colors: [Color(0xFF003249), Color(0xFF0077B6)],
  ///   begin: Alignment.centerLeft,
  ///   end: Alignment.centerRight,
  /// );
  /// ```
  static Gradient? gradient;

  /// Creates an [OutlineInputBorder] using the theme's [borderRadius].
  static OutlineInputBorder get defaultBorder => OutlineInputBorder(
    borderRadius: BorderRadius.circular(borderRadius),
  );

  /// Creates an enabled [OutlineInputBorder] with a grey color.
  static OutlineInputBorder get enabledBorder => OutlineInputBorder(
    borderRadius: BorderRadius.circular(borderRadius),
    borderSide: BorderSide(color: Colors.grey.shade400),
  );

  /// Creates a focused [OutlineInputBorder] using [primaryColor].
  static OutlineInputBorder get focusedBorder => OutlineInputBorder(
    borderRadius: BorderRadius.circular(borderRadius),
    borderSide: BorderSide(color: primaryColor, width: 2),
  );

  /// Creates a standard [InputDecoration] with common properties applied.
  static InputDecoration buildDecoration({
    required String labelText,
    IconData? prefixIcon,
    IconData? suffixIcon,
    Widget? suffixWidget,
    bool readOnly = false,
    EdgeInsetsGeometry contentPadding =
    const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
  }) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: labelStyle,
      border: defaultBorder,
      enabledBorder: enabledBorder,
      focusedBorder: focusedBorder,
      prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
      suffixIcon:
      suffixWidget ?? (suffixIcon != null ? Icon(suffixIcon) : null),
      filled: readOnly,
      fillColor: readOnly ? readOnlyFillColor : null,
      contentPadding: contentPadding,
    );
  }
}