part of '../sf_dropdown.dart';

/// A styled dropdown form field with per-state theming, smooth animated
/// border/fill transitions, panel open/close animations, haptic feedback,
/// form validation, and a fully custom item builder.
///
/// ## Per-state theming (mirrors SFPinTheme / SFButtonTheme pattern)
///
/// ```dart
/// final base = SFDropdownTheme(
///   borderColor: Colors.grey.shade400,
///   borderRadius: 12,
///   fillColor: Colors.white,
/// );
///
/// SFDropdown<String>(
///   labelText: 'Role',
///   items: [...],
///   onChanged: (v) => setState(() => _role = v),
///   idleTheme:     base,
///   openTheme:     base.copyWith(borderColor: Colors.blue, borderWidth: 2),
///   filledTheme:   base.copyWith(fillColor: Colors.blue.shade50),
///   disabledTheme: base.copyWith(fillColor: Colors.grey.shade100,
///                                borderColor: Colors.grey.shade300),
///   errorTheme:    base.copyWith(borderColor: Colors.red, borderWidth: 2),
/// )
/// ```
///
/// ## Quick-style (no themes — SFTheme applies automatically)
///
/// ```dart
/// SFDropdown<String>(
///   labelText: 'Role',
///   prefixIcon: Icons.work_outline,
///   value: _selectedRole,
///   items: roles.map((r) => SFDropdownItem(value: r, label: r)).toList(),
///   onChanged: (val) => setState(() => _selectedRole = val),
///   validator: (val) => val == null ? 'Please select a role' : null,
/// )
/// ```
///
/// ## Builder constructor — 100% custom item widget
///
/// ```dart
/// SFDropdown<String>(
///   labelText: 'Status',
///   items: statuses,
///   onChanged: (v) {},
///   itemBuilder: (context, item, isSelected) => MyCustomTile(item, isSelected),
/// )
/// ```
class SFDropdown<T> extends StatefulWidget {
  const SFDropdown({
    required this.labelText,
    required this.items,
    required this.onChanged,
    super.key,
    this.value,
    this.prefixIcon,
    this.validator,
    this.hintText,
    this.enabled = true,
    this.width,

    // ── Per-state themes ─────────────────────────────────────────────────
    this.idleTheme,
    this.openTheme,
    this.filledTheme,
    this.disabledTheme,
    this.errorTheme,

    // ── Panel theme ───────────────────────────────────────────────────────
    this.panelTheme,

    // ── Panel animation ───────────────────────────────────────────────────
    this.panelAnimation = SFDropdownAnimation.slide,
    this.animationDuration = _SFDropdownConstants.animationDuration,

    // ── Haptics ───────────────────────────────────────────────────────────
    this.hapticFeedback = SFDropdownHaptic.none,

    // ── Max panel height ──────────────────────────────────────────────────
    this.maxDropdownHeight,

    // ── Custom widgets ────────────────────────────────────────────────────
    /// Fully custom item widget. Receives item + isSelected flag.
    this.itemBuilder,

    /// Widget shown in the panel when no items match the search.
    this.noResultsWidget,
  });

  final String labelText;
  final String? hintText;
  final T? value;
  final List<SFDropdownItem<T>> items;
  final void Function(T?) onChanged;
  final IconData? prefixIcon;
  final String? Function(T?)? validator;
  final bool enabled;
  final double? width;

  // Per-state field themes
  final SFDropdownTheme? idleTheme;
  final SFDropdownTheme? openTheme;
  final SFDropdownTheme? filledTheme;
  final SFDropdownTheme? disabledTheme;
  final SFDropdownTheme? errorTheme;

  // Panel
  final SFDropdownPanelTheme? panelTheme;
  final SFDropdownAnimation panelAnimation;
  final Duration animationDuration;

  // Haptics
  final SFDropdownHaptic hapticFeedback;

  // Panel height
  final double? maxDropdownHeight;

  // Custom builders
  final Widget Function(BuildContext, SFDropdownItem<T>, bool)? itemBuilder;
  final Widget? noResultsWidget;

  @override
  State<SFDropdown<T>> createState() => _SFDropdownState<T>();
}

class _SFDropdownState<T> extends State<SFDropdown<T>>
    with SingleTickerProviderStateMixin {
  T? _currentValue;
  bool _isOpen = false;

  final _overlayController = OverlayPortalController();
  final _link = LayerLink();

  late AnimationController _animCtrl;
  late Animation<double> _animValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.value;
    _animCtrl = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    _animValue = CurvedAnimation(
      parent: _animCtrl,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    );
  }

  @override
  void didUpdateWidget(covariant SFDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      setState(() => _currentValue = widget.value);
    }
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  void _openPanel() {
    if (!widget.enabled) return;
    setState(() => _isOpen = true);
    _overlayController.show();
    _animCtrl.forward(from: 0);
    _triggerHaptic();
  }

  Future<void> _closePanel() async {
    await _animCtrl.reverse();
    _overlayController.hide();
    if (mounted) setState(() => _isOpen = false);
  }

  void _selectItem(SFDropdownItem<T> item) {
    setState(() => _currentValue = item.value);
    widget.onChanged(item.value);
    _closePanel();
  }

  void _triggerHaptic() {
    switch (widget.hapticFeedback) {
      case SFDropdownHaptic.none:
        break;
      case SFDropdownHaptic.light:
        HapticFeedback.lightImpact();
      case SFDropdownHaptic.medium:
        HapticFeedback.mediumImpact();
      case SFDropdownHaptic.heavy:
        HapticFeedback.heavyImpact();
      case SFDropdownHaptic.selection:
        HapticFeedback.selectionClick();
    }
  }

  // ── Theme resolution ─────────────────────────────────────────────────────
  // Priority: disabled > error > open > filled > idle > SFTheme fallback

  SFDropdownTheme _resolveTheme(bool hasError) {
    if (!widget.enabled && widget.disabledTheme != null) {
      return widget.disabledTheme!;
    }
    if (hasError && widget.errorTheme != null) return widget.errorTheme!;
    if (_isOpen && widget.openTheme != null) return widget.openTheme!;
    if (_currentValue != null && widget.filledTheme != null) {
      return widget.filledTheme!;
    }
    if (widget.idleTheme != null) return widget.idleTheme!;
    return const SFDropdownTheme(); // all null → SFTheme defaults apply below
  }

  OutlineInputBorder _border(SFDropdownTheme t, bool hasError) {
    final radius = t.borderRadius ?? SFTheme.borderRadius;

    if (hasError) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide(
          color: t.borderColor ?? Colors.red,
          width: t.borderWidth ?? 1.5,
        ),
      );
    }
    if (_isOpen) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide(
          color: t.borderColor ?? SFTheme.primaryColor,
          width: t.borderWidth ?? 2.0,
        ),
      );
    }
    if (!widget.enabled) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide(
          color: t.borderColor ?? Colors.grey.shade300,
          width: t.borderWidth ?? 1.0,
        ),
      );
    }
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: BorderSide(
        color: t.borderColor ?? Colors.grey.shade400,
        width: t.borderWidth ?? 1.0,
      ),
    );
  }

  String? get _selectedLabel {
    if (_currentValue == null) return null;
    return widget.items
        .where((i) => i.value == _currentValue)
        .firstOrNull
        ?.label;
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    final isDark = appTheme.brightness == Brightness.dark;

    return FormField<T>(
      initialValue: _currentValue,
      validator:
          widget.validator != null ? (_) => widget.validator!(_currentValue) : null,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      builder: (field) {
        final t = _resolveTheme(field.hasError);
        final border = _border(t, field.hasError);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CompositedTransformTarget(
              link: _link,
              child: OverlayPortal(
                controller: _overlayController,
                overlayChildBuilder: (_) => Stack(
                  children: [
                    Positioned.fill(
                      child: GestureDetector(
                        onTap: _closePanel,
                        behavior: HitTestBehavior.translucent,
                        child: const SizedBox.expand(),
                      ),
                    ),
                    AnimatedBuilder(
                      animation: _animValue,
                      builder: (_, __) => _SFDropdownPanel<T>(
                        isDark: isDark,
                        filtered: widget.items,
                        currentValue: _currentValue,
                        onSelect: _selectItem,
                        link: _link,
                        animation: widget.panelAnimation,
                        animationValue: _animValue.value,
                        panelTheme: widget.panelTheme,
                        width: widget.width,
                        showSearch: false,
                        noResultsWidget: widget.noResultsWidget,
                        itemBuilder: widget.itemBuilder,
                      ),
                    ),
                  ],
                ),
                child: GestureDetector(
                  onTap: _isOpen ? _closePanel : _openPanel,
                  child: LayoutBuilder(
                    builder: (ctx, constraints) {
                      // THE SMOOTH PART — AnimatedContainer tweens border & fill
                      return AnimatedContainer(
                        duration: widget.animationDuration,
                        curve: Curves.easeInOut,
                        width: widget.width ?? constraints.maxWidth,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              t.borderRadius ?? SFTheme.borderRadius),
                          color: !widget.enabled
                              ? (t.fillColor ?? SFTheme.readOnlyFillColor)
                              : t.fillColor,
                          boxShadow: t.boxShadow,
                        ),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: widget.labelText,
                            hintText: widget.hintText,
                            labelStyle: t.labelStyle?.copyWith(
                                  color: t.labelColor,
                                ) ??
                                (t.labelColor != null
                                    ? TextStyle(color: t.labelColor)
                                    : null),
                            prefixIcon: widget.prefixIcon != null
                                ? Icon(widget.prefixIcon,
                                    color: t.prefixIconColor)
                                : null,
                            suffixIcon: AnimatedRotation(
                              turns: _isOpen ? 0.5 : 0,
                              duration: widget.animationDuration,
                              child: Icon(Icons.arrow_drop_down,
                                  color: t.suffixIconColor),
                            ),
                            border: border,
                            enabledBorder: border,
                            focusedBorder: border,
                            errorBorder: border,
                            focusedErrorBorder: border,
                            contentPadding: t.contentPadding ??
                                const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 14),
                            filled: !widget.enabled || t.fillColor != null,
                            fillColor: !widget.enabled
                                ? (t.fillColor ?? SFTheme.readOnlyFillColor)
                                : t.fillColor,
                          ),
                          isFocused: _isOpen,
                          isEmpty: _selectedLabel == null,
                          child: Text(
                            _selectedLabel ?? '',
                            style: t.valueStyle ??
                                appTheme.textTheme.bodyLarge,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            // Error text
            if (field.errorText != null)
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 6),
                child: Text(
                  field.errorText!,
                  style: TextStyle(
                      color: appTheme.colorScheme.error, fontSize: 12),
                ),
              ),
          ],
        );
      },
    );
  }
}

/// Haptic feedback type triggered when the dropdown opens.
enum SFDropdownHaptic {
  none,
  light,
  medium,
  heavy,
  selection,
}
