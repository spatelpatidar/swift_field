part of '../sf_text_field.dart';

/// Controls when [SFTextField] / [SFPasswordField] runs its validator.
enum SFFieldAutovalidateMode {
  /// Never auto-validates. Call validate() manually via a Form key.
  disabled,

  /// Validates every time the value changes.
  always,

  /// Validates only after the first submit attempt.
  onUserInteraction,
}

/// Haptic feedback triggered when the field gains focus.
enum SFFieldHaptic {
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
