part of '../sf_button.dart';

/// A button with an optional icon, per-state theming, smooth animated state
/// transitions, haptic feedback, press-scale animation, and gradient support.
///
/// ## Per-state theming
///
/// ```dart
/// final base = SFIconButtonTheme(
///   backgroundColor: Color(0xFF003249),
///   borderRadius: 10,
///   height: 44,
/// );
///
/// SFIconButton(
///   text: 'Export',
///   icon: Icons.download,
///   onPressed: _export,
///   defaultTheme:  base,
///   pressedTheme:  base.copyWith(backgroundColor: Color(0xFF001F30)),
///   loadingTheme:  base.copyWith(backgroundColor: Colors.grey),
///   disabledTheme: base.copyWith(backgroundColor: Colors.grey.shade300),
/// )
/// ```
class SFIconButton extends StatefulWidget {
  const SFIconButton({
    required this.onPressed,
    super.key,

    // ── Per-state themes ───────────────────────────────────────────────────
    this.defaultTheme,
    this.pressedTheme,
    this.hoveredTheme,
    this.loadingTheme,
    this.disabledTheme,

    // ── Quick-style shortcuts ──────────────────────────────────────────────
    this.text,
    this.icon,
    this.isLoading = false,
    this.mode = SFIconButtonMode.compact,
    this.spinnerStyle = SFSpinnerStyle.android,
    this.backgroundColor,
    this.gradient,
    this.textColor = Colors.white,
    this.iconColor,
    this.borderColor,
    this.borderWidth = 1.2,
    this.height = 40,
    this.width,
    this.borderRadius = 10,
    this.iconSize = 16,
    this.fontSize = 15,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.elevation = 0,
    this.textStyle,
    this.spinnerSize = 16,
    this.spinnerStrokeWidth = 2,
    this.gap = 6,

    // ── Icon position ──────────────────────────────────────────────────────
    this.iconPosition = SFIconPosition.start,

    // ── Press scale animation ──────────────────────────────────────────────
    this.animationDuration = const Duration(milliseconds: 150),
    this.animationCurve = Curves.easeInOut,
    this.pressScale = 0.96,

    // ── Haptics ────────────────────────────────────────────────────────────
    this.hapticFeedback = SFButtonHaptic.none,

    // ── Content overrides ─────────────────────────────────────────────────
    this.child,
    this.loadingChild,

    // ── Behaviour ─────────────────────────────────────────────────────────
    this.enabled = true,
    this.onLongPress,
  }) : assert(
  backgroundColor == null || gradient == null,
  'Provide either backgroundColor or gradient, not both.',
  );

  final VoidCallback? onPressed;

  final SFIconButtonTheme? defaultTheme;
  final SFIconButtonTheme? pressedTheme;
  final SFIconButtonTheme? hoveredTheme;
  final SFIconButtonTheme? loadingTheme;
  final SFIconButtonTheme? disabledTheme;

  final String? text;
  final IconData? icon;
  final bool isLoading;
  final SFIconButtonMode mode;
  final SFSpinnerStyle spinnerStyle;
  final Color? backgroundColor;
  final Gradient? gradient;
  final Color textColor;
  final Color? iconColor;
  final Color? borderColor;
  final double borderWidth;
  final double height;
  final double? width;
  final double borderRadius;
  final double iconSize;
  final double fontSize;
  final EdgeInsetsGeometry padding;
  final double elevation;
  final TextStyle? textStyle;
  final double spinnerSize;
  final double spinnerStrokeWidth;
  final double gap;

  final SFIconPosition iconPosition;

  final Duration animationDuration;
  final Curve animationCurve;
  final double pressScale;

  final SFButtonHaptic hapticFeedback;

  final Widget? child;
  final Widget? loadingChild;

  final bool enabled;
  final VoidCallback? onLongPress;

  @override
  State<SFIconButton> createState() => _SFIconButtonState();
}

class _SFIconButtonState extends State<SFIconButton>
    with SingleTickerProviderStateMixin, _SFButtonHapticMixin {
  bool _isPressed = false;
  bool _isHovered = false;

  late AnimationController _scaleCtrl;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _initAnimation();
  }

  void _initAnimation() {
    _scaleCtrl = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
      value: 0.0, // 0 = rest (maps to begin=1.0 in tween)
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: widget.pressScale).animate(
      CurvedAnimation(parent: _scaleCtrl, curve: widget.animationCurve),
    );
  }

  // ── Sync controller duration if widget is updated ──────────────────────────
  // Prevents stale duration/scale on hot-reload or foldable config changes.
  @override
  void didUpdateWidget(SFIconButton old) {
    super.didUpdateWidget(old);
    if (old.animationDuration != widget.animationDuration) {
      _scaleCtrl.duration = widget.animationDuration;
    }
    if (old.pressScale != widget.pressScale) {
      _scaleAnim = Tween<double>(begin: 1.0, end: widget.pressScale).animate(
        CurvedAnimation(parent: _scaleCtrl, curve: widget.animationCurve),
      );
    }
  }

  @override
  void dispose() {
    _scaleCtrl.dispose();
    super.dispose();
  }

  void _onTapDown(_) {
    if (!widget.enabled || widget.isLoading) return;
    setState(() => _isPressed = true);
    _scaleCtrl.forward();
    triggerHaptic(widget.hapticFeedback);
  }

  void _onTapUp(_) {
    if (!widget.enabled || widget.isLoading) return;
    setState(() => _isPressed = false);
    // FIX: always reverse to 0 so scale is guaranteed to return to 1.0.
    _scaleCtrl.reverse();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _scaleCtrl.reverse();
  }

  void _onHoverChanged(bool hovering) => setState(() => _isHovered = hovering);

  SFIconButtonTheme _resolveTheme() {
    if (!widget.enabled && widget.disabledTheme != null) return widget.disabledTheme!;
    if (widget.isLoading && widget.loadingTheme != null) return widget.loadingTheme!;
    if (_isPressed && widget.pressedTheme != null) return widget.pressedTheme!;
    if (_isHovered && widget.hoveredTheme != null) return widget.hoveredTheme!;
    if (widget.defaultTheme != null) return widget.defaultTheme!;

    return SFIconButtonTheme(
      backgroundColor: widget.backgroundColor,
      gradient:        widget.gradient,
      textColor:       widget.textColor,
      iconColor:       widget.iconColor,
      borderColor:     widget.borderColor,
      borderWidth:     widget.borderWidth,
      height:          widget.height,
      width:           widget.width,
      borderRadius:    widget.borderRadius,
      textStyle:       widget.textStyle,
      elevation:       widget.elevation,
      padding:         widget.padding,
      iconSize:        widget.iconSize,
      gap:             widget.gap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = _resolveTheme();

    final radius            = theme.borderRadius ?? widget.borderRadius;
    final btnHeight         = theme.height ?? widget.height;
    final resolvedElevation = theme.elevation ?? widget.elevation;
    final borderRadius_     = BorderRadius.circular(radius);
    final resolvedIconSize  = theme.iconSize ?? widget.iconSize;
    final resolvedGap       = theme.gap ?? widget.gap;
    final resolvedTextColor = theme.textColor ?? widget.textColor;
    final resolvedIconColor = theme.iconColor ?? widget.iconColor ?? resolvedTextColor;

    final resolvedGradient = theme.gradient ??
        widget.gradient ??
        (widget.backgroundColor == null && theme.backgroundColor == null
            ? SFTheme.gradient
            : null);

    final resolvedColor = resolvedGradient == null
        ? (theme.backgroundColor ?? widget.backgroundColor ?? SFTheme.primaryColor)
        : null;

    final border = theme.borderColor != null
        ? Border.all(color: theme.borderColor!, width: theme.borderWidth ?? widget.borderWidth)
        : (widget.borderColor != null
        ? Border.all(color: widget.borderColor!, width: widget.borderWidth)
        : null);

    final resolvedWidth = widget.mode == SFIconButtonMode.expanded
        ? double.infinity
        : (theme.width ?? widget.width);

    // FIX: single AnimatedBuilder drives Transform.scale directly.
    // Same root cause as SFButton — AnimatedScale outside AnimatedBuilder
    // snapshot _scaleAnim.value at build time and never re-read it during
    // the animation tick, leaving the button frozen at pressed scale.
    return AnimatedBuilder(
      animation: _scaleAnim,
      builder: (context, child) => Transform.scale(
        scale: _scaleAnim.value,
        child: child,
      ),
      child: Opacity(
        opacity: !widget.enabled ? 0.5 : 1.0,
        child: SizedBox(
          height: btnHeight,
          width:  resolvedWidth,
          child: MouseRegion(
            onEnter: (_) => _onHoverChanged(true),
            onExit:  (_) => _onHoverChanged(false),
            child: GestureDetector(
              onTapDown:   _onTapDown,
              onTapUp:     _onTapUp,
              onTapCancel: _onTapCancel,
              child: Material(
                elevation:    resolvedElevation,
                borderRadius: borderRadius_,
                shadowColor:  theme.shadowColor,
                color:        Colors.transparent,
                child: AnimatedContainer(
                  duration:  widget.animationDuration,
                  curve:     widget.animationCurve,
                  decoration: BoxDecoration(
                    borderRadius: borderRadius_,
                    gradient:     resolvedGradient,
                    color:        resolvedColor,
                    border:       border,
                    boxShadow:    theme.boxShadow,
                  ),
                  child: InkWell(
                    onTap: (!widget.enabled || widget.isLoading) ? null : widget.onPressed,
                    onLongPress: (!widget.enabled || widget.isLoading) ? null : widget.onLongPress,
                    borderRadius:   borderRadius_,
                    splashColor:    Colors.white.withValues(alpha: 0.15),
                    highlightColor: Colors.white.withValues(alpha: 0.08),
                    child: Padding(
                      padding: theme.padding ?? widget.padding,
                      child: AnimatedSwitcher(
                        duration: widget.animationDuration,
                        transitionBuilder: (child, anim) =>
                            FadeTransition(opacity: anim, child: child),
                        child: widget.isLoading
                            ? KeyedSubtree(
                          key: const ValueKey('loading'),
                          child: widget.loadingChild ??
                              _SFButtonSpinner(
                                spinnerStyle:       widget.spinnerStyle,
                                spinnerSize:        widget.spinnerSize,
                                spinnerStrokeWidth: widget.spinnerStrokeWidth,
                                color:              resolvedTextColor,
                              ),
                        )
                            : KeyedSubtree(
                          key: const ValueKey('content'),
                          child: widget.child ??
                              _SFIconButtonContent(
                                text:         widget.text,
                                icon:         widget.icon,
                                textStyle:    theme.textStyle ?? widget.textStyle,
                                textColor:    resolvedTextColor,
                                iconColor:    resolvedIconColor,
                                iconSize:     resolvedIconSize,
                                fontSize:     widget.fontSize,
                                gap:          resolvedGap,
                                iconPosition: widget.iconPosition,
                                mode:         widget.mode,
                              ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
// part of '../sf_button.dart';
//
// /// A button with an optional icon, per-state theming, smooth animated state
// /// transitions, haptic feedback, press-scale animation, and gradient support.
// ///
// /// ## Per-state theming (mirrors SFPinCode/SFButton pattern)
// ///
// /// ```dart
// /// final base = SFIconButtonTheme(
// ///   backgroundColor: Color(0xFF003249),
// ///   borderRadius: 10,
// ///   height: 44,
// /// );
// ///
// /// SFIconButton(
// ///   text: 'Export',
// ///   icon: Icons.download,
// ///   onPressed: _export,
// ///   defaultTheme:  base,
// ///   pressedTheme:  base.copyWith(backgroundColor: Color(0xFF001F30)),
// ///   loadingTheme:  base.copyWith(backgroundColor: Colors.grey),
// ///   disabledTheme: base.copyWith(backgroundColor: Colors.grey.shade300),
// /// )
// /// ```
// ///
// /// ## Quick-style (no themes needed)
// ///
// /// ```dart
// /// SFIconButton(text: 'Add', icon: Icons.add, onPressed: _add)
// ///
// /// // Icon on top (column layout)
// /// SFIconButton(
// ///   text: 'Upload',
// ///   icon: Icons.upload,
// ///   onPressed: _upload,
// ///   iconPosition: SFIconPosition.top,
// ///   mode: SFIconButtonMode.expanded,
// /// )
// /// ```
// class SFIconButton extends StatefulWidget {
//   const SFIconButton({
//     required this.onPressed,
//     super.key,
//
//     // ── Per-state themes ───────────────────────────────────────────────────
//     this.defaultTheme,
//     this.pressedTheme,
//     this.hoveredTheme,
//     this.loadingTheme,
//     this.disabledTheme,
//
//     // ── Quick-style shortcuts ──────────────────────────────────────────────
//     this.text,
//     this.icon,
//     this.isLoading = false,
//     this.mode = SFIconButtonMode.compact,
//     this.spinnerStyle = SFSpinnerStyle.android,
//     this.backgroundColor,
//     this.gradient,
//     this.textColor = Colors.white,
//     this.iconColor,
//     this.borderColor,
//     this.borderWidth = 1.2,
//     this.height = 40,
//     this.width,
//     this.borderRadius = 10,
//     this.iconSize = 16,
//     this.fontSize = 15,
//     this.padding = const EdgeInsets.symmetric(horizontal: 16),
//     this.elevation = 0,
//     this.textStyle,
//     this.spinnerSize = 16,
//     this.spinnerStrokeWidth = 2,
//     this.gap = 6,
//
//     // ── Icon position ──────────────────────────────────────────────────────
//     this.iconPosition = SFIconPosition.start,
//
//     // ── State-transition animation ─────────────────────────────────────────
//     this.animationDuration = const Duration(milliseconds: 150),
//     this.animationCurve = Curves.easeInOut,
//
//     // ── Press scale animation ──────────────────────────────────────────────
//     this.pressScale = 0.96,
//
//     // ── Haptics ────────────────────────────────────────────────────────────
//     this.hapticFeedback = SFButtonHaptic.none,
//
//     // ── Content overrides ─────────────────────────────────────────────────
//     this.child,
//     this.loadingChild,
//
//     // ── Behaviour ─────────────────────────────────────────────────────────
//     this.enabled = true,
//     this.onLongPress,
//   }) : assert(
//           backgroundColor == null || gradient == null,
//           'Provide either backgroundColor or gradient, not both.',
//         );
//
//   // Required
//   final VoidCallback? onPressed;
//
//   // Per-state themes
//   final SFIconButtonTheme? defaultTheme;
//   final SFIconButtonTheme? pressedTheme;
//   final SFIconButtonTheme? hoveredTheme;
//   final SFIconButtonTheme? loadingTheme;
//   final SFIconButtonTheme? disabledTheme;
//
//   // Quick-style
//   final String? text;
//   final IconData? icon;
//   final bool isLoading;
//   final SFIconButtonMode mode;
//   final SFSpinnerStyle spinnerStyle;
//   final Color? backgroundColor;
//   final Gradient? gradient;
//   final Color textColor;
//   final Color? iconColor;
//   final Color? borderColor;
//   final double borderWidth;
//   final double height;
//   final double? width;
//   final double borderRadius;
//   final double iconSize;
//   final double fontSize;
//   final EdgeInsetsGeometry padding;
//   final double elevation;
//   final TextStyle? textStyle;
//   final double spinnerSize;
//   final double spinnerStrokeWidth;
//   final double gap;
//
//   // Icon position
//   final SFIconPosition iconPosition;
//
//   // Animation
//   final Duration animationDuration;
//   final Curve animationCurve;
//   final double pressScale;
//
//   // Haptics
//   final SFButtonHaptic hapticFeedback;
//
//   // Content
//   final Widget? child;
//   final Widget? loadingChild;
//
//   // Behaviour
//   final bool enabled;
//   final VoidCallback? onLongPress;
//
//   @override
//   State<SFIconButton> createState() => _SFIconButtonState();
// }
//
// class _SFIconButtonState extends State<SFIconButton>
//     with SingleTickerProviderStateMixin, _SFButtonHapticMixin {
//   bool _isPressed = false;
//   bool _isHovered = false;
//
//   late AnimationController _scaleCtrl;
//   late Animation<double> _scaleAnim;
//
//   @override
//   void initState() {
//     super.initState();
//     _scaleCtrl = AnimationController(
//       vsync: this,
//       duration: widget.animationDuration,
//       value: 1.0,
//     );
//     _scaleAnim = Tween<double>(begin: 1.0, end: widget.pressScale).animate(
//       CurvedAnimation(parent: _scaleCtrl, curve: widget.animationCurve),
//     );
//   }
//
//   @override
//   void dispose() {
//     _scaleCtrl.dispose();
//     super.dispose();
//   }
//
//   void _onTapDown(_) {
//     if (!widget.enabled || widget.isLoading) return;
//     setState(() => _isPressed = true);
//     _scaleCtrl.forward();
//     triggerHaptic(widget.hapticFeedback);
//   }
//
//   void _onTapUp(_) {
//     if (!widget.enabled || widget.isLoading) return;
//     setState(() => _isPressed = false);
//     _scaleCtrl.reverse();
//   }
//
//   void _onTapCancel() {
//     setState(() => _isPressed = false);
//     _scaleCtrl.reverse();
//   }
//
//   void _onHoverChanged(bool hovering) => setState(() => _isHovered = hovering);
//
//   // ── Theme resolution ──────────────────────────────────────────────────────
//
//   SFIconButtonTheme _resolveTheme() {
//     if (!widget.enabled && widget.disabledTheme != null) return widget.disabledTheme!;
//     if (widget.isLoading && widget.loadingTheme != null) return widget.loadingTheme!;
//     if (_isPressed && widget.pressedTheme != null) return widget.pressedTheme!;
//     if (_isHovered && widget.hoveredTheme != null) return widget.hoveredTheme!;
//     if (widget.defaultTheme != null) return widget.defaultTheme!;
//
//     return SFIconButtonTheme(
//       backgroundColor: widget.backgroundColor,
//       gradient: widget.gradient,
//       textColor: widget.textColor,
//       iconColor: widget.iconColor,
//       borderColor: widget.borderColor,
//       borderWidth: widget.borderWidth,
//       height: widget.height,
//       width: widget.width,
//       borderRadius: widget.borderRadius,
//       textStyle: widget.textStyle,
//       elevation: widget.elevation,
//       padding: widget.padding,
//       iconSize: widget.iconSize,
//       gap: widget.gap,
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = _resolveTheme();
//
//     final radius = theme.borderRadius ?? widget.borderRadius;
//     final btnHeight = theme.height ?? widget.height;
//     final resolvedElevation = theme.elevation ?? widget.elevation;
//     final borderRadius_ = BorderRadius.circular(radius);
//     final resolvedIconSize = theme.iconSize ?? widget.iconSize;
//     final resolvedGap = theme.gap ?? widget.gap;
//     final resolvedTextColor = theme.textColor ?? widget.textColor;
//     final resolvedIconColor = theme.iconColor ?? widget.iconColor ?? resolvedTextColor;
//
//     final resolvedGradient = theme.gradient ??
//         widget.gradient ??
//         (widget.backgroundColor == null && theme.backgroundColor == null
//             ? SFTheme.gradient
//             : null);
//
//     final resolvedColor = resolvedGradient == null
//         ? (theme.backgroundColor ?? widget.backgroundColor ?? SFTheme.primaryColor)
//         : null;
//
//     final border = theme.borderColor != null
//         ? Border.all(color: theme.borderColor!, width: theme.borderWidth ?? widget.borderWidth)
//         : (widget.borderColor != null
//             ? Border.all(color: widget.borderColor!, width: widget.borderWidth)
//             : null);
//
//     final resolvedWidth = widget.mode == SFIconButtonMode.expanded
//         ? double.infinity
//         : (theme.width ?? widget.width);
//
//     return AnimatedScale(
//       scale: _scaleAnim.value,
//       duration: widget.animationDuration,
//       child: AnimatedBuilder(
//         animation: _scaleAnim,
//         builder: (_, __) => Opacity(
//           opacity: !widget.enabled ? 0.5 : 1.0,
//           child: SizedBox(
//             height: btnHeight,
//             width: resolvedWidth,
//             child: MouseRegion(
//               onEnter: (_) => _onHoverChanged(true),
//               onExit: (_) => _onHoverChanged(false),
//               child: GestureDetector(
//                 onTapDown: _onTapDown,
//                 onTapUp: _onTapUp,
//                 onTapCancel: _onTapCancel,
//                 child: Material(
//                   elevation: resolvedElevation,
//                   borderRadius: borderRadius_,
//                   shadowColor: theme.shadowColor,
//                   color: Colors.transparent,
//                   child: AnimatedContainer(
//                     duration: widget.animationDuration,
//                     curve: widget.animationCurve,
//                     decoration: BoxDecoration(
//                       borderRadius: borderRadius_,
//                       gradient: resolvedGradient,
//                       color: resolvedColor,
//                       border: border,
//                       boxShadow: theme.boxShadow,
//                     ),
//                     child: InkWell(
//                       onTap: (!widget.enabled || widget.isLoading) ? null : widget.onPressed,
//                       onLongPress: (!widget.enabled || widget.isLoading) ? null : widget.onLongPress,
//                       borderRadius: borderRadius_,
//                       splashColor: Colors.white.withValues(alpha: 0.15),
//                       highlightColor: Colors.white.withValues(alpha: 0.08),
//                       child: Padding(
//                         padding: theme.padding ?? widget.padding,
//                         child: AnimatedSwitcher(
//                           duration: widget.animationDuration,
//                           transitionBuilder: (child, anim) =>
//                               FadeTransition(opacity: anim, child: child),
//                           child: widget.isLoading
//                               ? KeyedSubtree(
//                                   key: const ValueKey('loading'),
//                                   child: widget.loadingChild ??
//                                       _SFButtonSpinner(
//                                         spinnerStyle: widget.spinnerStyle,
//                                         spinnerSize: widget.spinnerSize,
//                                         spinnerStrokeWidth: widget.spinnerStrokeWidth,
//                                         color: resolvedTextColor,
//                                       ),
//                                 )
//                               : KeyedSubtree(
//                                   key: const ValueKey('content'),
//                                   child: widget.child ??
//                                       _SFIconButtonContent(
//                                         text: widget.text,
//                                         icon: widget.icon,
//                                         textStyle: theme.textStyle ?? widget.textStyle,
//                                         textColor: resolvedTextColor,
//                                         iconColor: resolvedIconColor,
//                                         iconSize: resolvedIconSize,
//                                         fontSize: widget.fontSize,
//                                         gap: resolvedGap,
//                                         iconPosition: widget.iconPosition,
//                                         mode: widget.mode,
//                                       ),
//                                 ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
