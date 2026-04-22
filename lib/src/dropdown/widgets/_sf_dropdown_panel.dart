part of '../sf_dropdown.dart';


// ─────────────────────────────────────────────────────────────────────────────
// _SFDropdownPanel — the floating overlay panel
// ─────────────────────────────────────────────────────────────────────────────

class _SFDropdownPanel<T> extends StatelessWidget {
  const _SFDropdownPanel({
    required this.isDark,
    required this.filtered,
    required this.currentValue,
    required this.onSelect,
    required this.link,
    required this.animation,
    required this.animationValue,
    this.panelTheme,
    this.searchController,
    this.searchFocus,
    this.searchHintText,
    this.width,
    this.showSearch = false,
    this.noResultsWidget,
    this.itemBuilder,
  });

  final bool isDark;
  final List<SFDropdownItem<T>> filtered;
  final T? currentValue;
  final void Function(SFDropdownItem<T>) onSelect;
  final LayerLink link;
  final SFDropdownAnimation animation;
  final double animationValue; // 0.0–1.0 driven by parent AnimationController
  final SFDropdownPanelTheme? panelTheme;
  final TextEditingController? searchController;
  final FocusNode? searchFocus;
  final String? searchHintText;
  final double? width;
  final bool showSearch;
  final Widget? noResultsWidget;

  /// Builder constructor support — fully custom item widget.
  final Widget Function(BuildContext, SFDropdownItem<T>, bool isSelected)?
      itemBuilder;

  @override
  Widget build(BuildContext context) {
    final pt = panelTheme;

    final bg = pt?.backgroundColor ??
        (isDark ? Colors.grey.shade900 : Colors.white);
    final borderColor =
        pt?.borderColor ?? (isDark ? Colors.white24 : Colors.grey.shade300);
    final radius = pt?.borderRadius ?? _SFDropdownConstants.panelBorderRadius;
    final elevation = pt?.elevation ?? _SFDropdownConstants.panelElevation;
    final maxH = pt?.maxHeight ?? _SFDropdownConstants.defaultMaxHeight;

    Widget panel = Material(
      elevation: elevation,
      borderRadius: BorderRadius.circular(radius),
      color: bg,
      child: Container(
        width: width ?? _inferWidth(context),
        constraints: BoxConstraints(maxHeight: maxH),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(
            color: borderColor,
            width: pt?.borderWidth ?? 1.0,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Optional search box ──────────────────────────────────────
            if (showSearch && searchController != null) ...[
              Padding(
                padding: _SFDropdownConstants.panelPadding,
                child: _SFDropdownSearchBox(
                  controller: searchController!,
                  focusNode: searchFocus,
                  hintText: searchHintText ?? 'Search...',
                  borderRadius:
                      pt?.searchBorderRadius ?? 10,
                ),
              ),
              const Divider(height: 1),
            ],

            // ── Item list ────────────────────────────────────────────────
            Flexible(
              child: filtered.isEmpty
                  ? noResultsWidget ??
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          'No results found',
                          style: pt?.noResultsTextStyle ??
                              TextStyle(color: Colors.grey.shade500),
                          textAlign: TextAlign.center,
                        ),
                      )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      shrinkWrap: true,
                      itemCount: filtered.length,
                      itemBuilder: (ctx, i) {
                        final item = filtered[i];
                        final isSelected = item.value == currentValue;

                        if (itemBuilder != null) {
                          return GestureDetector(
                            onTap: item.enabled
                                ? () => onSelect(item)
                                : null,
                            child: itemBuilder!(ctx, item, isSelected),
                          );
                        }

                        return _SFDropdownItemTile<T>(
                          item: item,
                          isSelected: isSelected,
                          panelTheme: pt,
                          onTap: () => onSelect(item),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );

    // ── Wrap with panel open/close animation ─────────────────────────────
    panel = _wrapAnimation(panel);

    return CompositedTransformFollower(
      link: link,
      showWhenUnlinked: false,
      offset: const Offset(0, 4),
      targetAnchor: Alignment.bottomLeft,
      followerAnchor: Alignment.topLeft,
      child: panel,
    );
  }

  Widget _wrapAnimation(Widget child) {
    switch (animation) {
      case SFDropdownAnimation.none:
        return child;

      case SFDropdownAnimation.fade:
        return Opacity(opacity: animationValue, child: child);

      case SFDropdownAnimation.slide:
        final dy = (1.0 - animationValue) * -0.08;
        return Opacity(
          opacity: animationValue,
          child: FractionalTranslation(
            translation: Offset(0, dy),
            child: child,
          ),
        );

      case SFDropdownAnimation.scale:
        return Opacity(
          opacity: animationValue,
          child: Transform.scale(
            scale: 0.92 + 0.08 * animationValue,
            alignment: Alignment.topCenter,
            child: child,
          ),
        );

      case SFDropdownAnimation.bounce:
        // Elastic overshoot: goes slightly past 1.0 then settles
        final bounced = _elasticOut(animationValue);
        return Opacity(
          opacity: animationValue.clamp(0.0, 1.0),
          child: Transform.scale(
            scale: bounced.clamp(0.0, 1.15),
            alignment: Alignment.topCenter,
            child: child,
          ),
        );

      case SFDropdownAnimation.expand:
        // Clip the panel vertically from 0 → full height
        return Opacity(
          opacity: animationValue,
          child: ClipRect(
            child: Align(
              alignment: Alignment.topCenter,
              heightFactor: animationValue,
              child: child,
            ),
          ),
        );

      case SFDropdownAnimation.flip:
        // 3-D perspective flip from -90° → 0° around the X axis
        final angle = (1.0 - animationValue) * -1.5708; // -π/2 → 0
        return Opacity(
          opacity: animationValue,
          child: Transform(
            alignment: Alignment.topCenter,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001) // perspective
              ..rotateX(angle),
            child: child,
          ),
        );
    }
  }

  /// Elastic-out easing curve used by the bounce animation.
  double _elasticOut(double t) {
    if (t == 0 || t == 1) return t;
    return pow(2, -10 * t) * sin((t * 10 - 0.75) * (2 * 3.141592 / 3)) + 1;
  }

  double _inferWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return screenWidth > 600 ? 560 : screenWidth - 32;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _SFDropdownSearchBox — search field inside the panel
// ─────────────────────────────────────────────────────────────────────────────

class _SFDropdownSearchBox extends StatelessWidget {
  const _SFDropdownSearchBox({
    required this.controller,
    required this.hintText,
    required this.borderRadius,
    this.focusNode,
  });

  final TextEditingController controller;
  final FocusNode? focusNode;
  final String hintText;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: const Icon(Icons.search, size: 20),
        suffixIcon: ValueListenableBuilder(
          valueListenable: controller,
          builder: (_, value, __) => value.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 18),
                  onPressed: controller.clear,
                  splashRadius: 16,
                )
              : const SizedBox.shrink(),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: SFTheme.primaryColor, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        isDense: true,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _SFDropdownItemTile — one row in the panel list
// ─────────────────────────────────────────────────────────────────────────────

class _SFDropdownItemTile<T> extends StatelessWidget {
  const _SFDropdownItemTile({
    required this.item,
    required this.isSelected,
    required this.onTap,
    this.panelTheme,
  });

  final SFDropdownItem<T> item;
  final bool isSelected;
  final VoidCallback onTap;
  final SFDropdownPanelTheme? panelTheme;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pt = panelTheme;

    final selectedBg = pt?.selectedItemColor ??
        SFTheme.primaryColor.withValues(alpha: 0.08);
    final selectedTextColor =
        pt?.selectedItemTextColor ?? SFTheme.primaryColor;

    return InkWell(
      onTap: item.enabled ? onTap : null,
      borderRadius:
          BorderRadius.circular(_SFDropdownConstants.itemBorderRadius),
      child: Container(
        margin: _SFDropdownConstants.itemMargin,
        padding: _SFDropdownConstants.itemPadding,
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(_SFDropdownConstants.itemBorderRadius),
          color: isSelected ? selectedBg : null,
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
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: !item.enabled
                          ? Colors.grey.shade400
                          : isSelected
                              ? selectedTextColor
                              : null,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
            ),
            if (item.trailingIcon != null) item.trailingIcon!,
            if (isSelected)
              Icon(Icons.check, size: 18, color: selectedTextColor),
          ],
        ),
      ),
    );
  }
}
