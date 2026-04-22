part of '../sf_dropdown.dart';

/// Represents a single item in [SFDropdown] or [SFDropdownSearch].
///
/// ```dart
/// // Simple
/// SFDropdownItem(value: 'admin', label: 'Admin')
///
/// // With leading icon
/// SFDropdownItem(
///   value: 'active',
///   label: 'Active',
///   leadingIcon: Icon(Icons.circle, color: Colors.green, size: 12),
/// )
///
/// // With custom child widget (overrides label text in menu)
/// SFDropdownItem(
///   value: 'premium',
///   label: 'Premium',
///   child: Row(children: [Icon(Icons.star, size: 14), Text(' Premium')]),
/// )
/// ```
class SFDropdownItem<T> {
  const SFDropdownItem({
    required this.value,
    required this.label,
    this.child,
    this.leadingIcon,
    this.trailingIcon,
    this.enabled = true,
  });

  /// The actual value this item represents.
  final T value;

  /// Display text — used for rendering and default search matching.
  final String label;

  /// Custom widget rendered instead of plain [label] text in the list.
  /// If null, [label] is shown as a [Text] widget.
  final Widget? child;

  /// Optional widget shown before the label.
  final Widget? leadingIcon;

  /// Optional widget shown after the label (before the check mark).
  final Widget? trailingIcon;

  /// If false, item appears in the list but cannot be tapped.
  final bool enabled;
}
