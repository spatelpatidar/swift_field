part of '../sf_dropdown.dart';

/// A searchable dropdown with per-state theming, smooth panel animation,
/// haptic feedback, form validation, and custom item/no-results builders.
///
/// The main field shows only the selected value (read-only display).
/// Tapping opens a floating panel. The search box lives inside the panel.
///
/// ## Per-state theming
///
/// ```dart
/// final base = SFDropdownTheme(
///   borderColor: Colors.grey.shade400,
///   borderRadius: 12,
/// );
///
/// SFDropdownSearch<String>(
///   labelText: 'Country',
///   items: [...],
///   onChanged: (v) {},
///   idleTheme:   base,
///   openTheme:   base.copyWith(borderColor: Colors.blue, borderWidth: 2),
///   filledTheme: base.copyWith(fillColor: Colors.blue.shade50),
///   errorTheme:  base.copyWith(borderColor: Colors.red),
/// )
/// ```
///
/// ## Quick-style
///
/// ```dart
/// SFDropdownSearch<String>(
///   labelText: 'Country',
///   prefixIcon: Icons.public_outlined,
///   value: _country,
///   items: countries.map((c) => SFDropdownItem(value: c, label: c)).toList(),
///   onChanged: (val) => setState(() => _country = val),
///   searchHintText: 'Search country...',
///   validator: (val) => val == null ? 'Please select' : null,
/// )
/// ```
///
/// ## Custom filter
///
/// ```dart
/// SFDropdownSearch<Country>(
///   ...
///   filterFn: (item, query) =>
///       item.label.toLowerCase().contains(query.toLowerCase()) ||
///       item.value.code.toLowerCase().contains(query.toLowerCase()),
/// )
/// ```
class SFDropdownSearch<T> extends StatefulWidget {
  const SFDropdownSearch({
    required this.labelText,
    required this.items,
    required this.onChanged,
    super.key,
    this.value,
    this.prefixIcon,
    this.validator,
    this.hintText,
    this.searchHintText = 'Search...',
    this.enabled = true,
    this.width,
    this.filterFn,
    this.maxDropdownHeight,

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

    // ── Custom builders ────────────────────────────────────────────────────
    this.itemBuilder,
    this.noResultsWidget,
  });

  final String labelText;
  final String? hintText;
  final String searchHintText;
  final T? value;
  final List<SFDropdownItem<T>> items;
  final void Function(T?) onChanged;
  final IconData? prefixIcon;
  final String? Function(T?)? validator;
  final bool enabled;
  final double? width;
  final bool Function(SFDropdownItem<T>, String)? filterFn;
  final double? maxDropdownHeight;

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

  // Custom builders
  final Widget Function(BuildContext, SFDropdownItem<T>, bool)? itemBuilder;
  final Widget? noResultsWidget;

  @override
  State<SFDropdownSearch<T>> createState() => _SFDropdownSearchState<T>();
}

class _SFDropdownSearchState<T> extends State<SFDropdownSearch<T>>
    with SingleTickerProviderStateMixin {
  T? _currentValue;
  bool _isOpen = false;

  final _overlayController = OverlayPortalController();
  final _link = LayerLink();
  final _searchController = TextEditingController();
  final _searchFocus = FocusNode();

  List<SFDropdownItem<T>> _filtered = [];

  late AnimationController _animCtrl;
  late Animation<double> _animValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.value;
    _filtered = widget.items;
    _searchController.addListener(_onSearch);

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
  void didUpdateWidget(covariant SFDropdownSearch<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      setState(() => _currentValue = widget.value);
    }
    if (oldWidget.items != widget.items) {
      _filtered = widget.items;
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearch);
    _searchController.dispose();
    _searchFocus.dispose();
    _animCtrl.dispose();
    super.dispose();
  }

  void _onSearch() {
    final query = _searchController.text;
    setState(() {
      _filtered = query.isEmpty
          ? widget.items
          : widget.items.where((item) {
              if (widget.filterFn != null) return widget.filterFn!(item, query);
              return item.label.toLowerCase().contains(query.toLowerCase());
            }).toList();
    });
  }

  void _openPanel() {
    if (!widget.enabled) return;
    setState(() {
      _isOpen = true;
      _filtered = widget.items;
      _searchController.clear();
    });
    _overlayController.show();
    _animCtrl.forward(from: 0);
    _triggerHaptic();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocus.requestFocus();
    });
  }

  Future<void> _closePanel() async {
    await _animCtrl.reverse();
    _overlayController.hide();
    _searchFocus.unfocus();
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

  SFDropdownTheme _resolveTheme(bool hasError) {
    if (!widget.enabled && widget.disabledTheme != null) return widget.disabledTheme!;
    if (hasError && widget.errorTheme != null) return widget.errorTheme!;
    if (_isOpen && widget.openTheme != null) return widget.openTheme!;
    if (_currentValue != null && widget.filledTheme != null) return widget.filledTheme!;
    if (widget.idleTheme != null) return widget.idleTheme!;
    return const SFDropdownTheme();
  }

  OutlineInputBorder _border(SFDropdownTheme t, bool hasError) {
    final radius = t.borderRadius ?? SFTheme.borderRadius;
    if (hasError) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide(
            color: t.borderColor ?? Colors.red, width: t.borderWidth ?? 1.5),
      );
    }
    if (_isOpen) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide(
            color: t.borderColor ?? SFTheme.primaryColor,
            width: t.borderWidth ?? 2.0),
      );
    }
    if (!widget.enabled) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide(
            color: t.borderColor ?? Colors.grey.shade300,
            width: t.borderWidth ?? 1.0),
      );
    }
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: BorderSide(
          color: t.borderColor ?? Colors.grey.shade400,
          width: t.borderWidth ?? 1.0),
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
                        filtered: _filtered,
                        currentValue: _currentValue,
                        onSelect: _selectItem,
                        link: _link,
                        animation: widget.panelAnimation,
                        animationValue: _animValue.value,
                        panelTheme: widget.panelTheme,
                        searchController: _searchController,
                        searchFocus: _searchFocus,
                        searchHintText: widget.searchHintText,
                        width: widget.width,
                        showSearch: true,
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
                            style: t.valueStyle ?? appTheme.textTheme.bodyLarge,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

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
