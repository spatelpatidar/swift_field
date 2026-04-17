import 'package:flutter/material.dart';
import '../theme/sf_theme.dart';
import 'sf_dropdown.dart';

/// A searchable dropdown where:
/// - The main field shows only the selected value (read-only display)
/// - Tapping opens a custom overlay panel
/// - The search box lives INSIDE the dropdown panel
/// - The user types in the panel search box to filter, then taps an item
///
/// No external packages — built entirely with Flutter's [OverlayPortal],
/// [CompositedTransformTarget], and [CompositedTransformFollower].
///
/// **Basic usage:**
/// ```dart
/// SFDropdownSearch<String>(
///   labelText: 'Country',
///   prefixIcon: Icons.public_outlined,
///   value: _country,
///   items: countries
///       .map((c) => SFDropdownItem(value: c, label: c))
///       .toList(),
///   onChanged: (val) => setState(() => _country = val),
/// )
/// ```
///
/// **Custom filter:**
/// ```dart
/// SFDropdownSearch<Country>(
///   labelText: 'Country',
///   prefixIcon: Icons.public_outlined,
///   value: _country,
///   items: countries
///       .map((c) => SFDropdownItem(value: c, label: c.name))
///       .toList(),
///   onChanged: (val) => setState(() => _country = val),
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
    this.maxDropdownHeight = 280,
  });

  final String labelText;
  final String? hintText;

  /// Placeholder inside the search box in the panel. Default: 'Search...'
  final String searchHintText;

  final T? value;
  final List<SFDropdownItem<T>> items;
  final void Function(T?) onChanged;
  final IconData? prefixIcon;
  final String? Function(T?)? validator;
  final bool enabled;
  final double? width;

  /// Custom filter. Receives [SFDropdownItem] + query. Return true to show item.
  final bool Function(SFDropdownItem<T> item, String query)? filterFn;

  /// Max height of the open dropdown panel. Default: 280.
  final double maxDropdownHeight;

  @override
  State<SFDropdownSearch<T>> createState() => _SFDropdownSearchState<T>();
}

class _SFDropdownSearchState<T> extends State<SFDropdownSearch<T>> {
  T? _currentValue;
  bool _isOpen = false;

  final _overlayController = OverlayPortalController();
  final _link = LayerLink();
  final _searchController = TextEditingController();
  final _searchFocus = FocusNode();

  List<SFDropdownItem<T>> _filtered = [];

  @override
  void initState() {
    super.initState();
    _currentValue = widget.value;
    _filtered = widget.items;
    _searchController.addListener(_onSearch);
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
    // Auto-focus the search box after the overlay renders
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocus.requestFocus();
    });
  }

  void _closePanel() {
    _overlayController.hide();
    _searchFocus.unfocus();
    setState(() => _isOpen = false);
  }

  void _selectItem(SFDropdownItem<T> item) {
    setState(() => _currentValue = item.value);
    widget.onChanged(item.value);
    _closePanel();
  }

  /// Label of the currently selected item, or null.
  String? get _selectedLabel {
    if (_currentValue == null) return null;
    return widget.items
        .where((i) => i.value == _currentValue)
        .firstOrNull
        ?.label;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return FormField<T>(
      initialValue: _currentValue,
      validator: widget.validator != null
          ? (_) => widget.validator!(_currentValue)
          : null,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CompositedTransformTarget(
              link: _link,
              child: OverlayPortal(
                controller: _overlayController,
                overlayChildBuilder: (_) => _buildPanel(context, isDark),
                child: GestureDetector(
                  onTap: _isOpen ? _closePanel : _openPanel,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return InputDecorator(
                        decoration: InputDecoration(
                          labelText: widget.labelText,
                          hintText: widget.hintText,
                          prefixIcon: widget.prefixIcon != null
                              ? Icon(widget.prefixIcon)
                              : null,
                          suffixIcon: AnimatedRotation(
                            turns: _isOpen ? 0.5 : 0,
                            duration: const Duration(milliseconds: 200),
                            child: const Icon(Icons.arrow_drop_down),
                          ),
                          border: SFTheme.defaultBorder,
                          enabledBorder: field.hasError
                              ? OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      SFTheme.borderRadius),
                                  borderSide: BorderSide(
                                      color: theme.colorScheme.error),
                                )
                              : _isOpen
                                  ? SFTheme.focusedBorder
                                  : SFTheme.enabledBorder,
                          focusedBorder: SFTheme.focusedBorder,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 14),
                          filled: !widget.enabled,
                          fillColor: !widget.enabled
                              ? SFTheme.readOnlyFillColor
                              : null,
                        ),
                        isFocused: _isOpen,
                        isEmpty: _selectedLabel == null,
                        child: Text(
                          _selectedLabel ?? '',
                          style: theme.textTheme.bodyLarge,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            // Validation error text
            if (field.errorText != null)
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 6),
                child: Text(
                  field.errorText!,
                  style:
                      TextStyle(color: theme.colorScheme.error, fontSize: 12),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildPanel(BuildContext context, bool isDark) {
    return Stack(
      children: [
        // Tap outside to close
        Positioned.fill(
          child: GestureDetector(
            onTap: _closePanel,
            behavior: HitTestBehavior.translucent,
            child: const SizedBox.expand(),
          ),
        ),

        // The dropdown panel itself
        CompositedTransformFollower(
          link: _link,
          showWhenUnlinked: false,
          offset: const Offset(0, 4),
          targetAnchor: Alignment.bottomLeft,
          followerAnchor: Alignment.topLeft,
          child: _DropdownPanel<T>(
            isDark: isDark,
            searchController: _searchController,
            searchFocus: _searchFocus,
            searchHintText: widget.searchHintText,
            filtered: _filtered,
            currentValue: _currentValue,
            maxHeight: widget.maxDropdownHeight,
            onSelect: _selectItem,
            width: widget.width,
            link: _link,
          ),
        ),
      ],
    );
  }
}

/// The floating dropdown panel with search box + scrollable item list.
class _DropdownPanel<T> extends StatelessWidget {
  const _DropdownPanel({
    required this.isDark,
    required this.searchController,
    required this.searchFocus,
    required this.searchHintText,
    required this.filtered,
    required this.currentValue,
    required this.maxHeight,
    required this.onSelect,
    required this.link,
    this.width,
  });

  final bool isDark;
  final TextEditingController searchController;
  final FocusNode searchFocus;
  final String searchHintText;
  final List<SFDropdownItem<T>> filtered;
  final T? currentValue;
  final double maxHeight;
  final void Function(SFDropdownItem<T>) onSelect;
  final LayerLink link;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(12),
      color: isDark ? Colors.grey.shade900 : Colors.white,
      child: Container(
        width: width ?? _inferWidth(context),
        constraints: BoxConstraints(maxHeight: maxHeight),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? Colors.white24 : Colors.grey.shade300,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Search box inside the panel ──────────────────────────────
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: searchController,
                focusNode: searchFocus,
                decoration: InputDecoration(
                  hintText: searchHintText,
                  prefixIcon: const Icon(Icons.search, size: 20),
                  suffixIcon: ValueListenableBuilder(
                    valueListenable: searchController,
                    builder: (_, value, __) => value.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: searchController.clear,
                            splashRadius: 16,
                          )
                        : const SizedBox.shrink(),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide(color: SFTheme.primaryColor, width: 1.5),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  isDense: true,
                ),
              ),
            ),

            const Divider(height: 1),

            // ── Item list ────────────────────────────────────────────────
            Flexible(
              child: filtered.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        'No results found',
                        style: TextStyle(color: Colors.grey.shade500),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      shrinkWrap: true,
                      itemCount: filtered.length,
                      itemBuilder: (_, index) {
                        final item = filtered[index];
                        final isSelected = item.value == currentValue;

                        return InkWell(
                          onTap: item.enabled ? () => onSelect(item) : null,
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 11),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: isSelected
                                  ? SFTheme.primaryColor.withValues(alpha: 0.08)
                                  : null,
                            ),
                            child: Row(
                              children: [
                                if (item.leadingIcon != null) ...[
                                  item.leadingIcon!,
                                  const SizedBox(width: 10),
                                ],
                                Expanded(
                                  child: item.child ??
                                      Text(
                                        item.label,
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                          color: !item.enabled
                                              ? Colors.grey.shade400
                                              : isSelected
                                                  ? SFTheme.primaryColor
                                                  : null,
                                          fontWeight: isSelected
                                              ? FontWeight.w600
                                              : FontWeight.normal,
                                        ),
                                      ),
                                ),
                                if (item.trailingIcon != null)
                                  item.trailingIcon!,
                                if (isSelected)
                                  Icon(Icons.check,
                                      size: 18, color: SFTheme.primaryColor),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  /// Fall back to the screen width minus some padding if no explicit width given.
  double _inferWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // On wide screens (web/desktop) cap at 600, on mobile use nearly full width
    return screenWidth > 600 ? 560 : screenWidth - 32;
  }
}
