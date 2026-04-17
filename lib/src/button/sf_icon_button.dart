import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swift_field/swift_field.dart';

/// Spinner style options for [SFButton] and [SFIconButton].
enum SFSpinnerStyle {
  /// Material circular spinner — [CircularProgressIndicator].
  android,

  /// iOS-style activity indicator — [CupertinoActivityIndicator].
  ios,
}

/// Controls how [SFIconButton] sizes itself.
enum SFIconButtonMode {
  /// Sizes to content (icon + label). Default.
  /// The button width wraps its children.
  compact,

  /// Expands to full available width, just like [SFButton].
  /// Use this when you want a consistent full-width button with an icon.
  expanded,
}

/// A button with an optional icon, label, loading state, and gradient support.
///
/// Supports two layout modes via [mode]:
/// - [SFIconButtonMode.compact] — wraps content width (default)
/// - [SFIconButtonMode.expanded] — full width, same as [SFButton]
///
/// Supports two spinner styles via [spinnerStyle]:
/// - [SFSpinnerStyle.android] — [CircularProgressIndicator] (default)
/// - [SFSpinnerStyle.ios] — [CupertinoActivityIndicator]
///
/// **Compact (default) — sizes to content:**
/// ```dart
/// SFIconButton(
///   text: 'Add',
///   icon: Icons.add,
///   onPressed: _add,
/// )
/// ```
///
/// **Expanded — full width like SFButton:**
/// ```dart
/// SFIconButton(
///   text: 'Submit',
///   icon: Icons.send,
///   onPressed: _submit,
///   mode: SFIconButtonMode.expanded,
/// )
/// ```
///
/// **iOS spinner:**
/// ```dart
/// SFIconButton(
///   text: 'Save',
///   icon: Icons.save,
///   onPressed: _save,
///   isLoading: _isSaving,
///   spinnerStyle: SFSpinnerStyle.ios,
/// )
/// ```
///
/// **Gradient:**
/// ```dart
/// SFIconButton(
///   text: 'Export',
///   icon: Icons.download_outlined,
///   onPressed: _export,
///   gradient: LinearGradient(
///     colors: [Colors.green, Colors.teal],
///   ),
/// )
/// ```
class SFIconButton extends StatelessWidget {
  const SFIconButton({
    required this.onPressed,
    super.key,
    this.text,
    this.icon,
    this.isLoading = false,
    this.mode = SFIconButtonMode.compact,
    this.spinnerStyle = SFSpinnerStyle.android,
    this.backgroundColor,
    this.gradient,
    this.textColor = Colors.white,
    this.iconColor,
    this.borderColor,
    this.height = 40,
    this.width,
    this.borderRadius = 10,
    this.iconSize = 16,
    this.fontSize = 15,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.elevation = 0,
    this.textStyle,
    this.spinnerSize = 16,
    this.spinnerStrokeWidth = 2,
    this.gap = 6,
  }) : assert(
          backgroundColor == null || gradient == null,
          'Provide either backgroundColor or gradient, not both.',
        );

  /// Called when tapped. Blocked while [isLoading] is true.
  final VoidCallback onPressed;

  /// Optional label text.
  final String? text;

  /// Optional icon. Hidden while [isLoading] is true.
  final IconData? icon;

  /// If true, replaces icon+label with a spinner.
  final bool isLoading;

  /// Layout mode.
  ///
  /// - [SFIconButtonMode.compact] — wraps content (default)
  /// - [SFIconButtonMode.expanded] — fills available width
  final SFIconButtonMode mode;

  /// Spinner style shown during loading.
  ///
  /// - [SFSpinnerStyle.android] — [CircularProgressIndicator] (default)
  /// - [SFSpinnerStyle.ios] — [CupertinoActivityIndicator]
  final SFSpinnerStyle spinnerStyle;

  /// Solid background color. Mutually exclusive with [gradient].
  final Color? backgroundColor;

  /// Gradient background. Mutually exclusive with [backgroundColor].
  final Gradient? gradient;

  /// Label + icon color. Defaults to white.
  final Color textColor;

  /// Icon color override. Defaults to [textColor].
  final Color? iconColor;

  /// Optional border color.
  final Color? borderColor;

  /// Button height. Default: 40.
  final double height;

  /// Explicit width. Only used in [SFIconButtonMode.compact].
  /// In [SFIconButtonMode.expanded] width is always [double.infinity].
  final double? width;

  /// Corner radius. Default: 10.
  final double borderRadius;

  /// Icon size. Default: 16.
  final double iconSize;

  /// Font size. Default: 15.
  final double fontSize;

  /// Internal padding. Default: horizontal 16.
  final EdgeInsetsGeometry padding;

  /// Drop shadow depth. Default: 0.
  final double elevation;

  /// Custom text style. Overrides [textColor] and [fontSize].
  final TextStyle? textStyle;

  /// Spinner size. Default: 16.
  final double spinnerSize;

  /// Stroke width — only used for [SFSpinnerStyle.android]. Default: 2.
  final double spinnerStrokeWidth;

  /// Gap between icon and label. Default: 6.
  final double gap;

  @override
  Widget build(BuildContext context) {
    final borderRadius_ = BorderRadius.circular(borderRadius);

    final resolvedGradient =
        gradient ?? (backgroundColor == null ? SFTheme.gradient : null);
    final resolvedColor = resolvedGradient == null
        ? (backgroundColor ?? SFTheme.primaryColor)
        : null;

    // expanded mode → full width; compact → wrap content or explicit width
    final resolvedWidth =
        mode == SFIconButtonMode.expanded ? double.infinity : width;

    return SizedBox(
      height: height,
      width: resolvedWidth,
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
            child: Padding(
              padding: padding,
              child: Row(
                // expanded → center content; compact → wrap content
                mainAxisSize: mode == SFIconButtonMode.expanded
                    ? MainAxisSize.max
                    : MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: isLoading ? [_buildSpinner()] : _buildContent(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildContent() {
    final ic = iconColor ?? textColor;
    final hasIcon = icon != null;
    final hasText = text != null;

    return [
      if (hasIcon) ...[
        Icon(icon, size: iconSize, color: ic),
        if (hasText) SizedBox(width: gap),
      ],
      if (hasText)
        Text(
          text!,
          style: textStyle ??
              TextStyle(
                fontSize: fontSize,
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
        ),
    ];
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
}
