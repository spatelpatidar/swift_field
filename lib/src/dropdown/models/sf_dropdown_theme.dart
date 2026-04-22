part of '../sf_dropdown.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SFDropdownTheme
// ─────────────────────────────────────────────────────────────────────────────
//
// Describes the full visual appearance of a dropdown field in ONE state.
// Mirrors SFPinTheme / SFButtonTheme — every property is independent per state.
//
// Usage pattern:
//
//   final base = SFDropdownTheme(
//     borderColor: Colors.grey.shade400,
//     borderRadius: 12,
//     fillColor: Colors.white,
//   );
//
//   SFDropdown(
//     ...
//     idleTheme:     base,
//     openTheme:     base.copyWith(borderColor: Colors.blue, borderWidth: 2),
//     filledTheme:   base.copyWith(fillColor: Colors.blue.shade50),
//     disabledTheme: base.copyWith(fillColor: Colors.grey.shade100,
//                                  borderColor: Colors.grey.shade300),
//     errorTheme:    base.copyWith(borderColor: Colors.red, borderWidth: 2),
//   )
//
// ─────────────────────────────────────────────────────────────────────────────

class SFDropdownTheme {
  const SFDropdownTheme({
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.fillColor,
    this.labelColor,
    this.labelStyle,
    this.valueStyle,
    this.hintStyle,
    this.prefixIconColor,
    this.suffixIconColor,
    this.contentPadding,
    this.boxShadow,
  });

  /// Border color of the field container.
  final Color? borderColor;

  /// Border stroke width. Default 1.0 idle, 2.0 open.
  final double? borderWidth;

  /// Corner radius of the field container.
  final double? borderRadius;

  /// Background fill color of the field.
  final Color? fillColor;

  /// Color of the floating label text.
  final Color? labelColor;

  /// Full style override for the label text.
  final TextStyle? labelStyle;

  /// Style of the selected value text shown in the field.
  final TextStyle? valueStyle;

  /// Style of the hint text shown when nothing is selected.
  final TextStyle? hintStyle;

  /// Color of the prefix icon.
  final Color? prefixIconColor;

  /// Color of the suffix chevron icon.
  final Color? suffixIconColor;

  /// Padding inside the field container.
  final EdgeInsetsGeometry? contentPadding;

  /// Optional box shadow on the field container.
  final List<BoxShadow>? boxShadow;

  // ── copyWith ───────────────────────────────────────────────────────────────

  SFDropdownTheme copyWith({
    Color? borderColor,
    double? borderWidth,
    double? borderRadius,
    Color? fillColor,
    Color? labelColor,
    TextStyle? labelStyle,
    TextStyle? valueStyle,
    TextStyle? hintStyle,
    Color? prefixIconColor,
    Color? suffixIconColor,
    EdgeInsetsGeometry? contentPadding,
    List<BoxShadow>? boxShadow,
  }) {
    return SFDropdownTheme(
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      borderRadius: borderRadius ?? this.borderRadius,
      fillColor: fillColor ?? this.fillColor,
      labelColor: labelColor ?? this.labelColor,
      labelStyle: labelStyle ?? this.labelStyle,
      valueStyle: valueStyle ?? this.valueStyle,
      hintStyle: hintStyle ?? this.hintStyle,
      prefixIconColor: prefixIconColor ?? this.prefixIconColor,
      suffixIconColor: suffixIconColor ?? this.suffixIconColor,
      contentPadding: contentPadding ?? this.contentPadding,
      boxShadow: boxShadow ?? this.boxShadow,
    );
  }

  /// Shortcut: copy only color/border properties.
  SFDropdownTheme copyBorderWith({
    Color? borderColor,
    double? borderWidth,
    double? borderRadius,
  }) {
    return copyWith(
      borderColor: borderColor,
      borderWidth: borderWidth,
      borderRadius: borderRadius,
    );
  }

  /// Merge — fills any null field from [other].
  SFDropdownTheme apply({required SFDropdownTheme other}) {
    return SFDropdownTheme(
      borderColor: borderColor ?? other.borderColor,
      borderWidth: borderWidth ?? other.borderWidth,
      borderRadius: borderRadius ?? other.borderRadius,
      fillColor: fillColor ?? other.fillColor,
      labelColor: labelColor ?? other.labelColor,
      labelStyle: labelStyle ?? other.labelStyle,
      valueStyle: valueStyle ?? other.valueStyle,
      hintStyle: hintStyle ?? other.hintStyle,
      prefixIconColor: prefixIconColor ?? other.prefixIconColor,
      suffixIconColor: suffixIconColor ?? other.suffixIconColor,
      contentPadding: contentPadding ?? other.contentPadding,
      boxShadow: boxShadow ?? other.boxShadow,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SFDropdownPanelTheme — styles the floating panel
// ─────────────────────────────────────────────────────────────────────────────

class SFDropdownPanelTheme {
  const SFDropdownPanelTheme({
    this.backgroundColor,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.elevation,
    this.searchBorderRadius,
    this.selectedItemColor,
    this.selectedItemTextColor,
    this.itemHoverColor,
    this.noResultsTextStyle,
    this.maxHeight,
  });

  /// Background of the floating panel.
  final Color? backgroundColor;

  /// Border color of the floating panel.
  final Color? borderColor;

  final double? borderWidth;

  /// Corner radius of the panel. Default 12.
  final double? borderRadius;

  /// Elevation (shadow depth) of the panel. Default 4.
  final double? elevation;

  /// Border radius of the internal search field. Default 10.
  final double? searchBorderRadius;

  /// Background color of the selected item row.
  final Color? selectedItemColor;

  /// Text color of the selected item label.
  final Color? selectedItemTextColor;

  /// Background color when an item row is hovered/pressed.
  final Color? itemHoverColor;

  /// Style for the "No results found" text.
  final TextStyle? noResultsTextStyle;

  /// Maximum height of the panel before it becomes scrollable.
  final double? maxHeight;

  SFDropdownPanelTheme copyWith({
    Color? backgroundColor,
    Color? borderColor,
    double? borderWidth,
    double? borderRadius,
    double? elevation,
    double? searchBorderRadius,
    Color? selectedItemColor,
    Color? selectedItemTextColor,
    Color? itemHoverColor,
    TextStyle? noResultsTextStyle,
    double? maxHeight,
  }) {
    return SFDropdownPanelTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      borderRadius: borderRadius ?? this.borderRadius,
      elevation: elevation ?? this.elevation,
      searchBorderRadius: searchBorderRadius ?? this.searchBorderRadius,
      selectedItemColor: selectedItemColor ?? this.selectedItemColor,
      selectedItemTextColor: selectedItemTextColor ?? this.selectedItemTextColor,
      itemHoverColor: itemHoverColor ?? this.itemHoverColor,
      noResultsTextStyle: noResultsTextStyle ?? this.noResultsTextStyle,
      maxHeight: maxHeight ?? this.maxHeight,
    );
  }
}
