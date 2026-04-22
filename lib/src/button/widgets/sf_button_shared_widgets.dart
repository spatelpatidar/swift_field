part of '../sf_button.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Shared internal widgets used by both SFButton and SFIconButton
// ─────────────────────────────────────────────────────────────────────────────

/// Spinner widget — renders Android or iOS style based on [spinnerStyle].
class _SFButtonSpinner extends StatelessWidget {
  const _SFButtonSpinner({
    required this.spinnerStyle,
    required this.spinnerSize,
    required this.spinnerStrokeWidth,
    required this.color,
  });

  final SFSpinnerStyle spinnerStyle;
  final double spinnerSize;
  final double spinnerStrokeWidth;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: spinnerSize,
      width: spinnerSize,
      child: switch (spinnerStyle) {
        SFSpinnerStyle.android => CircularProgressIndicator(
            strokeWidth: spinnerStrokeWidth,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        SFSpinnerStyle.ios => CupertinoActivityIndicator(
            radius: spinnerSize / 1.5,
            color: color,
          ),
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SFButton content — text with optional prefix/suffix icons (row only)
// ─────────────────────────────────────────────────────────────────────────────

class _SFButtonContent extends StatelessWidget {
  const _SFButtonContent({
    required this.text,
    required this.textColor,
    this.textStyle,
    this.prefixIcon,
    this.suffixIcon,
    this.iconSize = 18,
    this.iconGap = 8,
  });

  final String text;
  final Color textColor;
  final TextStyle? textStyle;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final double iconSize;
  final double iconGap;

  @override
  Widget build(BuildContext context) {
    final style = textStyle ??
        SFTheme.buttonTextStyle ??
        TextStyle(
          fontSize: 16,
          color: textColor,
          fontWeight: FontWeight.w600,
        );

    final hasPrefix = prefixIcon != null;
    final hasSuffix = suffixIcon != null;

    if (!hasPrefix && !hasSuffix) {
      return Text(text, style: style);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (hasPrefix) ...[
          Icon(prefixIcon, size: iconSize, color: textColor),
          SizedBox(width: iconGap),
        ],
        Text(text, style: style),
        if (hasSuffix) ...[
          SizedBox(width: iconGap),
          Icon(suffixIcon, size: iconSize, color: textColor),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SFIconButton content — supports start/end/top/bottom icon positions
// ─────────────────────────────────────────────────────────────────────────────

class _SFIconButtonContent extends StatelessWidget {
  const _SFIconButtonContent({
    required this.textColor,
    required this.iconColor,
    required this.iconSize,
    required this.fontSize,
    required this.gap,
    required this.iconPosition,
    required this.mode,
    this.text,
    this.icon,
    this.textStyle,
  });

  final String? text;
  final IconData? icon;
  final Color textColor;
  final Color iconColor;
  final double iconSize;
  final double fontSize;
  final double gap;
  final SFIconPosition iconPosition;
  final SFIconButtonMode mode;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final hasIcon = icon != null;
    final hasText = text != null;

    final style = textStyle ??
        TextStyle(
          fontSize: fontSize,
          color: textColor,
          fontWeight: FontWeight.w600,
        );

    final iconWidget = hasIcon ? Icon(icon, size: iconSize, color: iconColor) : null;
    final textWidget = hasText ? Text(text!, style: style) : null;

    // ── Column layout: top or bottom ───────────────────────────────────────
    if (iconPosition == SFIconPosition.top || iconPosition == SFIconPosition.bottom) {
      final spacer = SizedBox(height: gap);
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (iconPosition == SFIconPosition.top) ...[
            if (iconWidget != null) iconWidget,
            if (iconWidget != null && textWidget != null) spacer,
            if (textWidget != null) textWidget,
          ] else ...[
            if (textWidget != null) textWidget,
            if (iconWidget != null && textWidget != null) spacer,
            if (iconWidget != null) iconWidget,
          ],
        ],
      );
    }

    // ── Row layout: start or end ────────────────────────────────────────────
    final spacer = SizedBox(width: gap);
    return Row(
      mainAxisSize: mode == SFIconButtonMode.expanded ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (iconPosition == SFIconPosition.start) ...[
          if (iconWidget != null) iconWidget,
          if (iconWidget != null && textWidget != null) spacer,
          if (textWidget != null) textWidget,
        ] else ...[
          if (textWidget != null) textWidget,
          if (iconWidget != null && textWidget != null) spacer,
          if (iconWidget != null) iconWidget,
        ],
      ],
    );
  }
}
