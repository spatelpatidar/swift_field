part of '../sf_text_field.dart';

/// A fully customizable text form field with per-state theming, smooth
/// animated decoration switching, haptic feedback, and form validation.
///
/// ## Per-state theming (mirrors SFPinCode pattern)
///
/// Define a base theme once and derive other states from it:
///
/// ```dart
/// final base = SFFieldTheme(
///   borderColor: Colors.grey.shade400,
///   borderRadius: 14,
///   fillColor: Colors.white,
/// );
///
/// SFTextField(
///   controller: _ctrl,
///   labelText: 'Email',
///   defaultTheme:  base,
///   focusedTheme:  base.copyWith(borderColor: Colors.blue, borderWidth: 2),
///   filledTheme:   base.copyWith(borderColor: Colors.blue.withOpacity(0.4)),
///   errorTheme:    base.copyWith(borderColor: Colors.red, fillColor: Colors.red.shade50),
///   disabledTheme: base.copyWith(borderColor: Colors.grey.shade200, fillColor: Colors.grey.shade100),
/// )
/// ```
///
/// ## Quick-style (no themes needed — works exactly like before)
///
/// ```dart
/// SFTextField(controller: _ctrl, labelText: 'Name', prefixIcon: Icons.person)
/// ```
///
/// ## Builder constructor
///
/// ```dart
/// SFTextField.builder(
///   controller: _ctrl,
///   labelText: 'Name',
///   builder: (context, isFocused, hasError, isFilled) {
///     return InputDecoration(...); // fully custom decoration
///   },
/// )
/// ```
class SFTextField extends StatefulWidget {
  const SFTextField({
    required this.controller,
    required this.labelText,
    super.key,

    // ── Per-state themes ───────────────────────────────────────────────────
    this.defaultTheme,
    this.focusedTheme,
    this.errorTheme,
    this.disabledTheme,
    this.filledTheme,

    // ── Quick-style shortcuts ──────────────────────────────────────────────
    this.prefixIcon,
    this.suffixIcon,
    this.suffixWidget,
    this.obscureText = false,
    this.hintText,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.style,
    this.decoration,

    // ── Validation ────────────────────────────────────────────────────────
    this.validator,
    this.errorText,
    this.errorBuilder,
    this.forceErrorState = false,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,

    // ── Input behaviour ────────────────────────────────────────────────────
    this.focusNode,
    this.textInputAction,
    this.maxLines,
    this.minLines,
    this.keyboardType,
    this.onFieldSubmitted,
    this.onChanged,
    this.onTap,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.maxLength,

    // ── Animation ─────────────────────────────────────────────────────────
    this.animationDuration = const Duration(milliseconds: 160),
    this.animationCurve = Curves.easeInOut,

    // ── Haptics ────────────────────────────────────────────────────────────
    this.hapticFeedback = SFFieldHaptic.none,
  }) : _builder = null;

  /// Builder constructor — pass a fully custom [InputDecoration] builder.
  ///
  /// ```dart
  /// SFTextField.builder(
  ///   controller: _ctrl,
  ///   labelText: 'Name',
  ///   builder: (context, isFocused, hasError, isFilled) =>
  ///     InputDecoration(
  ///       labelText: 'Name',
  ///       border: OutlineInputBorder(
  ///         borderRadius: BorderRadius.circular(isFocused ? 20 : 12),
  ///         borderSide: BorderSide(
  ///           color: hasError ? Colors.red : isFocused ? Colors.blue : Colors.grey,
  ///         ),
  ///       ),
  ///     ),
  /// )
  /// ```
  const SFTextField.builder({
    required this.controller,
    required this.labelText,
    required InputDecoration Function(
            BuildContext context, bool isFocused, bool hasError, bool isFilled)
        builder,
    super.key,
    this.validator,
    this.errorText,
    this.forceErrorState = false,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.focusNode,
    this.textInputAction,
    this.maxLines,
    this.minLines,
    this.keyboardType,
    this.onFieldSubmitted,
    this.onChanged,
    this.onTap,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.maxLength,
    this.obscureText = false,
    this.hintText,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.style,
    this.animationDuration = const Duration(milliseconds: 160),
    this.animationCurve = Curves.easeInOut,
    this.hapticFeedback = SFFieldHaptic.none,
  })  : _builder = builder,
        defaultTheme = null,
        focusedTheme = null,
        errorTheme = null,
        disabledTheme = null,
        filledTheme = null,
        prefixIcon = null,
        suffixIcon = null,
        suffixWidget = null,
        decoration = null,
        errorBuilder = null;

  // Per-state themes
  final SFFieldTheme? defaultTheme;
  final SFFieldTheme? focusedTheme;
  final SFFieldTheme? errorTheme;
  final SFFieldTheme? disabledTheme;
  final SFFieldTheme? filledTheme;

  // Quick-style
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final Widget? suffixWidget;
  final bool obscureText;
  final String? hintText;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final TextStyle? style;
  final InputDecoration? decoration;

  // Required
  final TextEditingController controller;
  final String labelText;

  // Validation
  final String? Function(String?)? validator;
  final String? errorText;
  final Widget Function(BuildContext, String?)? errorBuilder;
  final bool forceErrorState;
  final AutovalidateMode autovalidateMode;

  // Input behaviour
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final int? maxLines;
  final int? minLines;
  final TextInputType? keyboardType;
  final void Function(String)? onFieldSubmitted;
  final void Function(String)? onChanged;
  final VoidCallback? onTap;
  final TextCapitalization textCapitalization;
  final List<dynamic>? inputFormatters;
  final int? maxLength;

  // Animation
  final Duration animationDuration;
  final Curve animationCurve;

  // Haptics
  final SFFieldHaptic hapticFeedback;

  // Internal builder (null = use themes)
  final InputDecoration Function(
      BuildContext, bool, bool, bool)? _builder;

  @override
  State<SFTextField> createState() => _SFTextFieldState();
}

class _SFTextFieldState extends State<SFTextField>
    with _SFFieldHapticMixin, _SFFieldThemeResolver {
  late FocusNode _focusNode;
  bool _isFocused = false;
  bool _hasError = false;
  String? _validationError;

  // ── _SFFieldThemeResolver overrides ────────────────────────────────────────
  @override SFFieldTheme? get defaultTheme  => widget.defaultTheme;
  @override SFFieldTheme? get focusedTheme  => widget.focusedTheme;
  @override SFFieldTheme? get errorTheme    => widget.errorTheme;
  @override SFFieldTheme? get disabledTheme => widget.disabledTheme;
  @override SFFieldTheme? get filledTheme   => widget.filledTheme;
  @override bool get enabled   => widget.enabled;
  @override bool get hasError  => widget.forceErrorState || widget.errorText != null || _hasError;
  @override bool get isFocused => _isFocused;
  @override bool get isFilled  => widget.controller.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() => _isFocused = _focusNode.hasFocus);
    if (_focusNode.hasFocus) triggerFieldHaptic(widget.hapticFeedback);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    if (widget.focusNode == null) _focusNode.dispose();
    super.dispose();
  }

  String? get _effectiveError => widget.errorText ?? _validationError;

  @override
  Widget build(BuildContext context) {
    // Builder constructor — skip all theme logic
    if (widget._builder != null) {
      return _buildRawField(
        decoration: widget._builder!(context, _isFocused, hasError, isFilled),
      );
    }

    final theme = resolveTheme();

    // AnimatedContainer drives smooth decoration transitions
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: widget.animationDuration,
          curve: widget.animationCurve,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
                theme.borderRadius ?? SFTheme.borderRadius),
            boxShadow: theme.boxShadow,
          ),
          child: _buildRawField(
            decoration: buildThemedDecoration(
              theme: theme,
              labelText: widget.labelText,
              readOnly: widget.readOnly,
              hasError: hasError,
              isFocused: _isFocused,
              hintText: widget.hintText,
              prefixIcon: widget.prefixIcon,
              suffixIcon: widget.suffixIcon,
              suffixWidget: widget.suffixWidget,
              errorText: _effectiveError,
            ),
            style: theme.textStyle ?? widget.style,
          ),
        ),
        if (widget.errorBuilder != null && _effectiveError != null)
          widget.errorBuilder!(context, _effectiveError),
      ],
    );
  }

  Widget _buildRawField({
    required InputDecoration decoration,
    TextStyle? style,
  }) {
    return TextFormField(
      controller: widget.controller,
      focusNode: _focusNode,
      obscureText: widget.obscureText,
      obscuringCharacter: '✲',
      validator: (val) {
        final result = widget.validator?.call(val);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              _validationError = result;
              _hasError = result != null;
            });
          }
        });
        return result;
      },
      autovalidateMode: _toFlutterAutovalidateMode(widget.autovalidateMode),
      textInputAction: widget.readOnly ? TextInputAction.none : widget.textInputAction,
      onFieldSubmitted: widget.onFieldSubmitted,
      onChanged: (val) {
        widget.onChanged?.call(val);
        // Rebuild to update isFilled state
        setState(() {});
      },
      textCapitalization: widget.textCapitalization,
      readOnly: widget.readOnly,
      enabled: widget.enabled,
      autofocus: widget.autofocus,
      maxLength: widget.maxLength,
      onTap: widget.onTap,
      style: style ?? widget.style,
      decoration: decoration,
      maxLines: widget.obscureText ? 1 : widget.maxLines,
      minLines: widget.minLines ?? 1,
      keyboardType: widget.keyboardType,
    );
  }

  AutovalidateMode _toFlutterAutovalidateMode(AutovalidateMode mode) => mode;
}
