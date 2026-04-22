part of '../sf_button.dart';

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
  compact,

  /// Expands to full available width, just like [SFButton].
  expanded,
}

/// Icon position relative to the label text in [SFIconButton].
enum SFIconPosition {
  /// Icon on the left, text on the right (default).
  start,

  /// Icon on the right, text on the left.
  end,

  /// Icon above the text (column layout).
  top,

  /// Icon below the text (column layout).
  bottom,
}

/// Haptic feedback type triggered on button tap.
enum SFButtonHaptic {
  /// No haptic feedback (default).
  none,

  /// Light impact.
  light,

  /// Medium impact.
  medium,

  /// Heavy impact.
  heavy,

  /// Selection click.
  selection,
}
