part of '../sf_dropdown.dart';

/// The current visual state of a dropdown field.
/// Used to resolve which [SFDropdownTheme] to apply.
enum SFDropdownStateType {
  /// Default closed, unfocused, no value selected.
  idle,

  /// Panel is open (focused state).
  open,

  /// A value is selected and the panel is closed.
  filled,

  /// Field is disabled — [SFDropdown.enabled] = false.
  disabled,

  /// Validation failed — error border + error text shown.
  error,
}

/// Animation played when the dropdown panel opens/closes.
enum SFDropdownAnimation {
  /// No animation — panel appears/disappears instantly.
  none,

  /// Panel fades in/out.
  fade,

  /// Panel slides down on open, slides up on close.
  slide,

  /// Panel scales up from the top on open, scales down on close.
  scale,

  /// Panel bounces in with an elastic overshoot on open.
  bounce,

  /// Panel expands vertically from zero height on open.
  expand,

  /// Panel flips in from top using a 3-D perspective rotation.
  flip,
}
