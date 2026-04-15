part of '../sf_pin_code.dart';

/// Theme of the individual pin items for following states:
/// default, focused pin, submitted pin, following pin, disabled pin and error pin
class SFPinTheme {
  /// width of each [SFPinCode] field
  final double? width;

  /// height of each [SFPinCode] field
  final double? height;

  /// The style to use for SFPinCode
  /// If null, defaults to the `subhead` text style from the current [Theme].
  final TextStyle? textStyle;

  /// Empty space to surround the [SFPinCode] field container.
  final EdgeInsetsGeometry? margin;

  /// Empty space to inscribe the [SFPinCode] field container.
  /// For example space between border and text
  final EdgeInsetsGeometry? padding;

  /// Additional constraints to apply to the each field container.
  /// properties
  /// ```dart
  ///  this.minWidth = 0.0,
  ///  this.maxWidth = double.infinity,
  ///  this.minHeight = 0.0,
  ///  this.maxHeight = double.infinity,
  ///  ```
  final BoxConstraints? constraints;

  ///  Box decoration of following properties of Pin item
  ///  You can customize every pixel with it
  ///  properties are being animated implicitly when value changes
  ///  ```dart
  ///  this.color,
  ///  this.image,
  ///  this.border,
  ///  this.borderRadius,
  ///  this.boxShadow,
  ///  this.gradient,
  ///  this.backgroundBlendMode,
  ///  this.shape = BoxShape.rectangle,
  ///  ```
  /// The decoration of each [SFPinCode] submitted field
  final BoxDecoration? decoration;

  /// Theme of the individual pin items for following states:
  /// default, focused pin, submitted pin, following pin, disabled pin and error pin
  const SFPinTheme({
    this.width,
    this.height,
    this.margin,
    this.padding,
    this.textStyle,
    this.decoration,
    this.constraints,
  });

  /// Merge two [SFPinTheme] into one
  SFPinTheme apply({required SFPinTheme theme}) {
    return SFPinTheme(
      width: this.width ?? theme.width,
      height: this.height ?? theme.height,
      textStyle: this.textStyle ?? theme.textStyle,
      constraints: this.constraints ?? theme.constraints,
      decoration: this.decoration ?? theme.decoration,
      padding: this.padding ?? theme.padding,
      margin: this.margin ?? theme.margin,
    );
  }

  /// Create a new [SFPinTheme] from the current instance
  SFPinTheme copyWith({
    double? width,
    double? height,
    TextStyle? textStyle,
    BoxConstraints? constraints,
    BoxDecoration? decoration,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
  }) {
    return SFPinTheme(
      width: width ?? this.width,
      height: height ?? this.height,
      textStyle: textStyle ?? this.textStyle,
      constraints: constraints ?? this.constraints,
      decoration: decoration ?? this.decoration,
      padding: padding ?? this.padding,
      margin: margin ?? this.margin,
    );
  }

  /// Create a new [SFPinTheme] from the current instance with new decoration
  SFPinTheme copyDecorationWith({
    Color? color,
    DecorationImage? image,
    BoxBorder? border,
    BorderRadiusGeometry? borderRadius,
    List<BoxShadow>? boxShadow,
    Gradient? gradient,
    BlendMode? backgroundBlendMode,
    BoxShape? shape,
  }) {
    assert(decoration != null);
    return copyWith(
      decoration: decoration?.copyWith(
        color: color,
        image: image,
        border: border,
        borderRadius: borderRadius,
        boxShadow: boxShadow,
        gradient: gradient,
        backgroundBlendMode: backgroundBlendMode,
        shape: shape,
      ),
    );
  }

  /// Create a new [SFPinTheme] from the current instance with new border
  SFPinTheme copyBorderWith({required Border border}) {
    assert(decoration != null);
    return copyWith(
      decoration: decoration?.copyWith(border: border),
    );
  }
}
