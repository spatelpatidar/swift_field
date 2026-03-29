import 'package:flutter/material.dart';
import 'package:swift_field/swift_field.dart';

/// A styled dropdown form field built entirely on Flutter's native [DropdownMenu].
///
/// No external dependencies — uses the Material 3 [DropdownMenu] widget
/// introduced in Flutter 3.7+.
///
/// Automatically fills available width, supports validation, dark mode,
/// and custom prefix icons.
///
/// **Basic usage:**
/// ```dart
/// SFDropdown<String>(
///   labelText: 'Role',
///   prefixIcon: Icons.work_outline,
///   value: _selectedRole,
///   items: ['Admin', 'Editor', 'Viewer']
///       .map((r) => SFDropdownItem(value: r, label: r))
///       .toList(),
///   onChanged: (val) => setState(() => _selectedRole = val),
/// )
/// ```
///
/// **With validation:**
/// ```dart
/// SFDropdown<String>(
///   labelText: 'Country',
///   prefixIcon: Icons.flag_outlined,
///   value: _country,
///   items: countries
///       .map((c) => SFDropdownItem(value: c, label: c))
///       .toList(),
///   onChanged: (val) => setState(() => _country = val),
///   validator: (val) => val == null ? 'Please select a country' : null,
/// )
/// ```
///
/// **With custom item widgets:**
/// ```dart
/// SFDropdown<String>(
///   labelText: 'Status',
///   value: _status,
///   items: [
///     SFDropdownItem(
///       value: 'active',
///       label: 'Active',
///       leadingIcon: Icon(Icons.circle, color: Colors.green, size: 12),
///     ),
///   ],
///   onChanged: (val) => setState(() => _status = val),
/// )
/// ```
class SFDropdown<T> extends StatefulWidget {
  const SFDropdown({
    required this.labelText, required this.items, required this.onChanged, super.key,
    this.value,
    this.prefixIcon,
    this.validator,
    this.hintText,
    this.enabled = true,
    this.width,
  });

  /// Label shown above/inside the field.
  final String labelText;

  /// Optional hint shown when no value is selected.
  final String? hintText;

  /// Currently selected value. Must match one of the [items] values.
  final T? value;

  /// List of dropdown items. Use [SFDropdownItem] to build them.
  final List<SFDropdownItem<T>> items;

  /// Called when the user selects an item.
  final void Function(T?) onChanged;

  /// Icon shown on the left side of the field.
  final IconData? prefixIcon;

  /// Validation function. Return null for valid, error string for invalid.
  final String? Function(T?)? validator;

  /// If false, the field is fully disabled.
  final bool enabled;

  /// Explicit width. Defaults to full available width via [LayoutBuilder].
  final double? width;

  @override
  State<SFDropdown<T>> createState() => _SFDropdownState<T>();
}

class _SFDropdownState<T> extends State<SFDropdown<T>> {
  T? _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.value;
  }

  @override
  void didUpdateWidget(covariant SFDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      setState(() => _currentValue = widget.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return FormField<T>(
      initialValue: _currentValue,
      validator:
          widget.validator != null ? (_) => widget.validator!(_currentValue) : null,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                return DropdownMenu<T>(
                  width: widget.width ?? constraints.maxWidth,
                  enabled: widget.enabled,
                  initialSelection: _currentValue,
                  label: Text(widget.labelText),
                  hintText: widget.hintText,
                  leadingIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
                  inputDecorationTheme: InputDecorationTheme(
                    border: SFTheme.defaultBorder,
                    enabledBorder: field.hasError
                        ? OutlineInputBorder(
                            borderRadius: BorderRadius.circular(SFTheme.borderRadius),
                            borderSide: BorderSide(color: theme.colorScheme.error),
                          )
                        : SFTheme.enabledBorder,
                    focusedBorder: SFTheme.focusedBorder,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    filled: !widget.enabled,
                    fillColor: !widget.enabled ? SFTheme.readOnlyFillColor : null,
                  ),
                  menuStyle: MenuStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      isDark ? Colors.grey.shade900 : Colors.white,
                    ),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: isDark ? Colors.white24 : Colors.grey.shade300,
                        ),
                      ),
                    ),
                    maximumSize:
                        const WidgetStatePropertyAll(Size(double.infinity, 300)),
                  ),
                  dropdownMenuEntries: widget.items
                      .map((item) => DropdownMenuEntry<T>(
                            value: item.value,
                            label: item.label,
                            enabled: item.enabled,
                            leadingIcon: item.leadingIcon,
                            trailingIcon: item.trailingIcon,
                            labelWidget: item.child,
                          ))
                      .toList(),
                  onSelected: (val) {
                    setState(() => _currentValue = val);
                    field.didChange(val);
                    widget.onChanged(val);
                  },
                );
              },
            ),
            if (field.errorText != null)
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 6),
                child: Text(
                  field.errorText!,
                  style: TextStyle(color: theme.colorScheme.error, fontSize: 12),
                ),
              ),
          ],
        );
      },
    );
  }
}

/// Represents a single item in [SFDropdown] or [SFDropdownSearch].
///
/// ```dart
/// SFDropdownItem(value: 'admin', label: 'Admin')
///
/// // With leading icon
/// SFDropdownItem(
///   value: 'active',
///   label: 'Active',
///   leadingIcon: Icon(Icons.circle, color: Colors.green, size: 12),
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

  /// Display text — used for rendering and as the default search match string.
  final String label;

  /// Custom widget rendered instead of plain [label] text in the menu.
  final Widget? child;

  /// Optional icon shown before the label in the menu list.
  final Widget? leadingIcon;

  /// Optional icon shown after the label in the menu list.
  final Widget? trailingIcon;

  /// If false, this item appears in the list but cannot be selected.
  final bool enabled;
}