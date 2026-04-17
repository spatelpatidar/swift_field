import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../theme/sf_theme.dart';
import 'sf_icon_button.dart'; // re-uses SFSpinnerStyle enum

/// A full-width button with loading state, gradient support, and reliable
/// spinner visibility.
///
/// Built with [InkWell] + [Ink] instead of [ElevatedButton] so that:
/// - Gradient backgrounds are fully supported
/// - The loading spinner is always visible (no Material disabled-state override)
/// - The button never goes "grey" during loading
///
/// **Basic usage:**
/// ```dart
/// SFButton(
///   text: 'Submit',
///   onPressed: _handleSubmit,
/// )
/// ```
///
/// **Loading state:**
/// ```dart
/// SFButton(
///   text: 'Save',
///   onPressed: _save,
///   isLoading: _isSaving,
/// )
/// ```
///
/// **iOS spinner:**
/// ```dart
/// SFButton(
///   text: 'Save',
///   onPressed: _save,
///   isLoading: _isSaving,
///   spinnerStyle: SFSpinnerStyle.ios,
/// )
/// ```
///
/// **Gradient background:**
/// ```dart
/// SFButton(
///   text: 'Continue',
///   onPressed: _next,
///   gradient: LinearGradient(
///     colors: [Color(0xFF003249), Color(0xFF0077B6)],
///   ),
/// )
/// ```
///
/// **Solid custom color:**
/// ```dart
/// SFButton(
///   text: 'Delete',
///   onPressed: _delete,
///   backgroundColor: Colors.red,
///   height: 56,
///   borderRadius: 8,
/// )
/// ```
class SFButton extends StatelessWidget {
  const SFButton({
    required this.onPressed,
    required this.text,
    super.key,
    this.isLoading = false,
    this.spinnerStyle = SFSpinnerStyle.android,
    this.backgroundColor,
    this.gradient,
    this.textColor = Colors.white,
    this.borderColor,
    this.height,
    this.borderRadius,
    this.textStyle,
    this.elevation = 0,
    this.width = double.infinity,
    this.padding,
    this.spinnerSize = 20,
    this.spinnerStrokeWidth = 2.5,
  }) : assert(
          backgroundColor == null || gradient == null,
          'Provide either backgroundColor or gradient, not both.',
        );

  /// The button label text.
  final String text;

  /// Called when tapped. Blocked (not disabled) while [isLoading] is true.
  final VoidCallback onPressed;

  /// If true, shows spinner instead of label.
  final bool isLoading;

  /// Spinner style shown during loading.
  ///
  /// - [SFSpinnerStyle.android] — [CircularProgressIndicator] (default)
  /// - [SFSpinnerStyle.ios] — [CupertinoActivityIndicator]
  final SFSpinnerStyle spinnerStyle;

  /// Solid background color. Mutually exclusive with [gradient].
  /// Defaults to [SFTheme.primaryColor] when both are null.
  final Color? backgroundColor;

  /// Gradient background. Mutually exclusive with [backgroundColor].
  final Gradient? gradient;

  /// Text / spinner color. Defaults to white.
  final Color textColor;

  /// Optional border color.
  final Color? borderColor;

  /// Button height. Defaults to [SFTheme.buttonHeight].
  final double? height;

  /// Corner radius. Defaults to 12.
  final double? borderRadius;

  /// Custom text style.
  final TextStyle? textStyle;

  /// Drop shadow depth. Default 0 (flat).
  final double elevation;

  /// Button width. Defaults to full width.
  final double width;

  /// Internal padding override.
  final EdgeInsetsGeometry? padding;

  /// Size of the loading spinner. Default 20.
  final double spinnerSize;

  /// Stroke width — only used for [SFSpinnerStyle.android]. Default 2.5.
  final double spinnerStrokeWidth;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? 12.0;
    final btnHeight = height ?? SFTheme.buttonHeight;
    final borderRadius_ = BorderRadius.circular(radius);

    final resolvedGradient =
        gradient ?? (backgroundColor == null ? SFTheme.gradient : null);
    final resolvedColor = resolvedGradient == null
        ? (backgroundColor ?? SFTheme.primaryColor)
        : null;

    return SizedBox(
      width: width,
      height: btnHeight,
      child: Material(
        elevation: elevation,
        borderRadius: borderRadius_,
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: borderRadius_,
            gradient: resolvedGradient,
            color: resolvedColor,
            border: borderColor != null
                ? Border.all(color: borderColor!, width: 1.2)
                : null,
          ),
          child: InkWell(
            onTap: isLoading ? null : onPressed,
            borderRadius: borderRadius_,
            splashColor: Colors.white.withValues(alpha: 0.15),
            highlightColor: Colors.white.withValues(alpha: 0.08),
            child: Container(
              alignment: Alignment.center,
              padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
              child: isLoading ? _buildSpinner() : _buildLabel(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSpinner() {
    return SizedBox(
      height: spinnerSize,
      width: spinnerSize,
      child: switch (spinnerStyle) {
        SFSpinnerStyle.android => CircularProgressIndicator(
            strokeWidth: spinnerStrokeWidth,
            valueColor: AlwaysStoppedAnimation<Color>(textColor),
          ),
        SFSpinnerStyle.ios => CupertinoActivityIndicator(
            radius: spinnerSize / 1.5,
            color: textColor,
          ),
      },
    );
  }

  Widget _buildLabel() {
    return Text(
      text,
      style: textStyle ??
          SFTheme.buttonTextStyle ??
          TextStyle(
            fontSize: 16,
            color: textColor,
            fontWeight: FontWeight.w600,
          ),
    );
  }
}
