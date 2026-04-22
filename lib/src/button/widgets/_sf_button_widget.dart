part of '../sf_button.dart';

/// A full-width button with per-state theming, smooth animated state
/// transitions, haptic feedback, press/hover animations, and gradient support.
///
/// ## Per-state theming
///
/// ```dart
/// final base = SFButtonTheme(
///   backgroundColor: Color(0xFF003249),
///   borderRadius: 14,
///   height: 52,
///   textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
/// );
///
/// SFButton(
///   text: 'Submit',
///   onPressed: _submit,
///   defaultTheme:  base,
///   pressedTheme:  base.copyWith(backgroundColor: Color(0xFF00213A)),
///   loadingTheme:  base.copyWith(backgroundColor: Color(0xFF003249).withOpacity(0.7)),
///   disabledTheme: base.copyWith(backgroundColor: Colors.grey.shade300),
///   hoveredTheme:  base.copyWith(elevation: 4),
/// )
/// ```
class SFButton extends StatefulWidget {
  const SFButton({
    required this.onPressed,
    required this.text,
    super.key,

    // ── Per-state themes ───────────────────────────────────────────────────
    this.defaultTheme,
    this.pressedTheme,
    this.hoveredTheme,
    this.loadingTheme,
    this.disabledTheme,

    // ── Quick-style shortcuts ──────────────────────────────────────────────
    this.isLoading = false,
    this.spinnerStyle = SFSpinnerStyle.android,
    this.backgroundColor,
    this.gradient,
    this.textColor = Colors.white,
    this.borderColor,
    this.borderWidth = 1.2,
    this.height,
    this.borderRadius,
    this.textStyle,
    this.elevation = 0,
    this.width = double.infinity,
    this.padding,
    this.spinnerSize = 20,
    this.spinnerStrokeWidth = 2.5,

    // ── Press scale animation ──────────────────────────────────────────────
    this.animationDuration = const Duration(milliseconds: 150),
    this.animationCurve = Curves.easeInOut,
    this.pressScale = 0.97,

    // ── Haptics ────────────────────────────────────────────────────────────
    this.hapticFeedback = SFButtonHaptic.none,

    // ── Content ────────────────────────────────────────────────────────────
    this.prefixIcon,
    this.suffixIcon,
    this.iconSize = 18.0,
    this.iconGap = 8.0,
    this.child,
    this.loadingChild,

    // ── Behaviour ─────────────────────────────────────────────────────────
    this.enabled = true,
    this.onLongPress,
  }) : assert(
  backgroundColor == null || gradient == null,
  'Provide either backgroundColor or gradient, not both.',
  );

  final String text;
  final VoidCallback? onPressed;

  final SFButtonTheme? defaultTheme;
  final SFButtonTheme? pressedTheme;
  final SFButtonTheme? hoveredTheme;
  final SFButtonTheme? loadingTheme;
  final SFButtonTheme? disabledTheme;

  final bool isLoading;
  final SFSpinnerStyle spinnerStyle;
  final Color? backgroundColor;
  final Gradient? gradient;
  final Color textColor;
  final Color? borderColor;
  final double borderWidth;
  final double? height;
  final double? borderRadius;
  final TextStyle? textStyle;
  final double elevation;
  final double width;
  final EdgeInsetsGeometry? padding;
  final double spinnerSize;
  final double spinnerStrokeWidth;

  final Duration animationDuration;
  final Curve animationCurve;
  final double pressScale;

  final SFButtonHaptic hapticFeedback;

  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final double iconSize;
  final double iconGap;
  final Widget? child;
  final Widget? loadingChild;

  final bool enabled;
  final VoidCallback? onLongPress;

  @override
  State<SFButton> createState() => _SFButtonState();
}

class _SFButtonState extends State<SFButton>
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
  // Prevents stale duration on hot-reload or config changes (e.g. foldable).
  @override
  void didUpdateWidget(SFButton old) {
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

  SFButtonTheme _resolveTheme() {
    if (!widget.enabled && widget.disabledTheme != null) return widget.disabledTheme!;
    if (widget.isLoading && widget.loadingTheme != null) return widget.loadingTheme!;
    if (_isPressed && widget.pressedTheme != null) return widget.pressedTheme!;
    if (_isHovered && widget.hoveredTheme != null) return widget.hoveredTheme!;
    if (widget.defaultTheme != null) return widget.defaultTheme!;

    return SFButtonTheme(
      backgroundColor: widget.backgroundColor,
      gradient: widget.gradient,
      textColor: widget.textColor,
      borderColor: widget.borderColor,
      borderWidth: widget.borderWidth,
      height: widget.height,
      width: widget.width,
      borderRadius: widget.borderRadius,
      textStyle: widget.textStyle,
      elevation: widget.elevation,
      padding: widget.padding,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = _resolveTheme();

    final radius            = theme.borderRadius ?? widget.borderRadius ?? 12.0;
    final btnHeight         = theme.height ?? widget.height ?? SFTheme.buttonHeight;
    final btnWidth          = theme.width ?? widget.width;
    final resolvedElevation = theme.elevation ?? widget.elevation;
    final borderRadius_     = BorderRadius.circular(radius);
    final resolvedTextColor = theme.textColor ?? widget.textColor;

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

    // FIX: single AnimatedBuilder drives Transform.scale directly.
    // The old pattern (AnimatedScale wrapping AnimatedBuilder) read
    // _scaleAnim.value once at build time for AnimatedScale — so the outer
    // widget never got animation updates, leaving the button visually stuck
    // in its pressed scale on fast taps or when the finger is held down.
    return AnimatedBuilder(
      animation: _scaleAnim,
      builder: (context, child) => Transform.scale(
        scale: _scaleAnim.value,
        child: child,
      ),
      child: Opacity(
        opacity: !widget.enabled ? 0.5 : 1.0,
        child: SizedBox(
          width: btnWidth,
          height: btnHeight,
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
                    borderRadius:    borderRadius_,
                    splashColor:     Colors.white.withValues(alpha: 0.15),
                    highlightColor:  Colors.white.withValues(alpha: 0.08),
                    child: Container(
                      alignment: Alignment.center,
                      padding: theme.padding ??
                          widget.padding ??
                          const EdgeInsets.symmetric(horizontal: 16),
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
                              _SFButtonContent(
                                text:       widget.text,
                                textStyle:  theme.textStyle ?? widget.textStyle,
                                textColor:  resolvedTextColor,
                                prefixIcon: widget.prefixIcon,
                                suffixIcon: widget.suffixIcon,
                                iconSize:   widget.iconSize,
                                iconGap:    widget.iconGap,
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
// /// A full-width button with per-state theming, smooth animated state
// /// transitions, haptic feedback, press/hover animations, and gradient support.
// ///
// /// ## Per-state theming (mirrors SFPinCode pattern)
// ///
// /// Define a base theme once and derive other states from it:
// ///
// /// ```dart
// /// final base = SFButtonTheme(
// ///   backgroundColor: Color(0xFF003249),
// ///   borderRadius: 14,
// ///   height: 52,
// ///   textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
// /// );
// ///
// /// SFButton(
// ///   text: 'Submit',
// ///   onPressed: _submit,
// ///   defaultTheme: base,
// ///   pressedTheme:  base.copyWith(backgroundColor: Color(0xFF00213A)),
// ///   loadingTheme:  base.copyWith(backgroundColor: Color(0xFF003249).withOpacity(0.7)),
// ///   disabledTheme: base.copyWith(backgroundColor: Colors.grey.shade300),
// ///   hoveredTheme:  base.copyWith(elevation: 4),
// /// )
// /// ```
// ///
// /// ## Quick-style (no themes needed)
// ///
// /// ```dart
// /// SFButton(text: 'Submit',  onPressed: _submit)
// /// SFButton(text: 'Cancel',  onPressed: _cancel,
// ///   backgroundColor: Colors.white,
// ///   textColor: Color(0xFF003249),
// ///   borderColor: Color(0xFF003249))
// /// SFButton(text: 'Gradient', onPressed: _next,
// ///   gradient: LinearGradient(colors: [Colors.blue, Colors.purple]))
// /// ```
// class SFButton extends StatefulWidget {
//   const SFButton({
//     required this.onPressed,
//     required this.text,
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
//     this.isLoading = false,
//     this.spinnerStyle = SFSpinnerStyle.android,
//     this.backgroundColor,
//     this.gradient,
//     this.textColor = Colors.white,
//     this.borderColor,
//     this.borderWidth = 1.2,
//     this.height,
//     this.borderRadius,
//     this.textStyle,
//     this.elevation = 0,
//     this.width = double.infinity,
//     this.padding,
//     this.spinnerSize = 20,
//     this.spinnerStrokeWidth = 2.5,
//
//     // ── State-transition animation ─────────────────────────────────────────
//     this.animationDuration = const Duration(milliseconds: 150),
//     this.animationCurve = Curves.easeInOut,
//
//     // ── Press scale animation ──────────────────────────────────────────────
//     this.pressScale = 0.97,
//
//     // ── Haptics ────────────────────────────────────────────────────────────
//     this.hapticFeedback = SFButtonHaptic.none,
//
//     // ── Content ────────────────────────────────────────────────────────────
//     this.prefixIcon,
//     this.suffixIcon,
//     this.iconSize = 18.0,
//     this.iconGap = 8.0,
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
//   final String text;
//   final VoidCallback? onPressed;
//
//   // Per-state themes
//   final SFButtonTheme? defaultTheme;
//   final SFButtonTheme? pressedTheme;
//   final SFButtonTheme? hoveredTheme;
//   final SFButtonTheme? loadingTheme;
//   final SFButtonTheme? disabledTheme;
//
//   // Quick-style
//   final bool isLoading;
//   final SFSpinnerStyle spinnerStyle;
//   final Color? backgroundColor;
//   final Gradient? gradient;
//   final Color textColor;
//   final Color? borderColor;
//   final double borderWidth;
//   final double? height;
//   final double? borderRadius;
//   final TextStyle? textStyle;
//   final double elevation;
//   final double width;
//   final EdgeInsetsGeometry? padding;
//   final double spinnerSize;
//   final double spinnerStrokeWidth;
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
//   final IconData? prefixIcon;
//   final IconData? suffixIcon;
//   final double iconSize;
//   final double iconGap;
//   final Widget? child;
//   final Widget? loadingChild;
//
//   // Behaviour
//   final bool enabled;
//   final VoidCallback? onLongPress;
//
//   @override
//   State<SFButton> createState() => _SFButtonState();
// }
//
// class _SFButtonState extends State<SFButton>
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
//   // Priority: disabled > loading > pressed > hovered > default > quick-style
//
//   SFButtonTheme _resolveTheme() {
//     if (!widget.enabled && widget.disabledTheme != null) return widget.disabledTheme!;
//     if (widget.isLoading && widget.loadingTheme != null) return widget.loadingTheme!;
//     if (_isPressed && widget.pressedTheme != null) return widget.pressedTheme!;
//     if (_isHovered && widget.hoveredTheme != null) return widget.hoveredTheme!;
//     if (widget.defaultTheme != null) return widget.defaultTheme!;
//
//     return SFButtonTheme(
//       backgroundColor: widget.backgroundColor,
//       gradient: widget.gradient,
//       textColor: widget.textColor,
//       borderColor: widget.borderColor,
//       borderWidth: widget.borderWidth,
//       height: widget.height,
//       width: widget.width,
//       borderRadius: widget.borderRadius,
//       textStyle: widget.textStyle,
//       elevation: widget.elevation,
//       padding: widget.padding,
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = _resolveTheme();
//
//     final radius = theme.borderRadius ?? widget.borderRadius ?? 12.0;
//     final btnHeight = theme.height ?? widget.height ?? SFTheme.buttonHeight;
//     final btnWidth = theme.width ?? widget.width;
//     final resolvedElevation = theme.elevation ?? widget.elevation;
//     final borderRadius_ = BorderRadius.circular(radius);
//     final resolvedTextColor = theme.textColor ?? widget.textColor;
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
//     return AnimatedScale(
//       scale: _scaleAnim.value,
//       duration: widget.animationDuration,
//       child: AnimatedBuilder(
//         animation: _scaleAnim,
//         builder: (_, __) => Opacity(
//           opacity: !widget.enabled ? 0.5 : 1.0,
//           child: SizedBox(
//             width: btnWidth,
//             height: btnHeight,
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
//                       child: Container(
//                         alignment: Alignment.center,
//                         padding: theme.padding ??
//                             widget.padding ??
//                             const EdgeInsets.symmetric(horizontal: 16),
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
//                                       _SFButtonContent(
//                                         text: widget.text,
//                                         textStyle: theme.textStyle ?? widget.textStyle,
//                                         textColor: resolvedTextColor,
//                                         prefixIcon: widget.prefixIcon,
//                                         suffixIcon: widget.suffixIcon,
//                                         iconSize: widget.iconSize,
//                                         iconGap: widget.iconGap,
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
