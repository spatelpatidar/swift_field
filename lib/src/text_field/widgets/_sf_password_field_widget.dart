part of '../sf_text_field.dart';

/// A password text form field with per-state theming, smooth animated
/// decoration switching, built-in show/hide toggle, haptic feedback,
/// and form validation.
///
/// ## Per-state theming (mirrors SFPinCode pattern)
///
/// ```dart
/// final base = SFFieldTheme(
///   borderColor: Colors.grey.shade400,
///   borderRadius: 14,
/// );
///
/// SFPasswordField(
///   controller: _ctrl,
///   labelText: 'Password',
///   defaultTheme:  base,
///   focusedTheme:  base.copyWith(borderColor: Colors.blue, borderWidth: 2),
///   filledTheme:   base.copyWith(borderColor: Colors.blue.withOpacity(0.4)),
///   errorTheme:    base.copyWith(borderColor: Colors.red, fillColor: Colors.red.shade50),
///   disabledTheme: base.copyWith(borderColor: Colors.grey.shade200, fillColor: Colors.grey.shade100),
/// )
/// ```
///
/// ## Builder constructor
///
/// ```dart
/// SFPasswordField.builder(
///   controller: _ctrl,
///   labelText: 'Password',
///   builder: (context, isFocused, hasError, isFilled, isObscured, toggleObscure) =>
///     InputDecoration(
///       suffixIcon: IconButton(
///         icon: Icon(isObscured ? Icons.visibility_off : Icons.visibility),
///         onPressed: toggleObscure,
///       ),
///       ...
///     ),
/// )
/// ```
class SFPasswordField extends StatefulWidget {
  const SFPasswordField({
    required this.controller,
    required this.labelText,
    super.key,

    // ── Per-state themes ───────────────────────────────────────────────────
    this.defaultTheme,
    this.focusedTheme,
    this.errorTheme,
    this.disabledTheme,
    this.filledTheme,

    // ── Quick-style ────────────────────────────────────────────────────────
    this.prefixIcon = Icons.lock_outline,
    this.visibleIcon = Icons.visibility_outlined,
    this.hiddenIcon = Icons.visibility_off_outlined,
    this.hintText,
    this.enabled = true,
    this.initiallyObscured = true,
    this.obscuringCharacter = '✲',
    this.style,

    // ── Validation ────────────────────────────────────────────────────────
    this.validator,
    this.errorText,
    this.errorBuilder,
    this.forceErrorState = false,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,

    // ── Input behaviour ────────────────────────────────────────────────────
    this.focusNode,
    this.textInputAction,
    this.onFieldSubmitted,

    // ── Animation ─────────────────────────────────────────────────────────
    this.animationDuration = const Duration(milliseconds: 160),
    this.animationCurve = Curves.easeInOut,

    // ── Haptics ────────────────────────────────────────────────────────────
    this.hapticFeedback = SFFieldHaptic.none,
  }) : _builder = null;

  /// Builder constructor — gives full control over decoration including
  /// the obscure toggle state.
  ///
  /// ```dart
  /// SFPasswordField.builder(
  ///   controller: _ctrl,
  ///   labelText: 'Password',
  ///   builder: (context, isFocused, hasError, isFilled, isObscured, toggle) =>
  ///     InputDecoration(
  ///       suffixIcon: IconButton(
  ///         icon: Icon(isObscured ? Icons.visibility_off : Icons.visibility),
  ///         onPressed: toggle,
  ///       ),
  ///     ),
  /// )
  /// ```
  const SFPasswordField.builder({
    required this.controller,
    required this.labelText,
    required InputDecoration Function(
      BuildContext context,
      bool isFocused,
      bool hasError,
      bool isFilled,
      bool isObscured,
      VoidCallback toggleObscure,
    ) builder,
    super.key,
    this.validator,
    this.errorText,
    this.forceErrorState = false,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.focusNode,
    this.textInputAction,
    this.onFieldSubmitted,
    this.initiallyObscured = true,
    this.obscuringCharacter = '✲',
    this.enabled = true,
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
        prefixIcon = Icons.lock_outline,
        visibleIcon = Icons.visibility_outlined,
        hiddenIcon = Icons.visibility_off_outlined,
        hintText = null,
        errorBuilder = null;

  // Per-state themes
  final SFFieldTheme? defaultTheme;
  final SFFieldTheme? focusedTheme;
  final SFFieldTheme? errorTheme;
  final SFFieldTheme? disabledTheme;
  final SFFieldTheme? filledTheme;

  // Required
  final TextEditingController controller;
  final String labelText;

  // Quick-style
  final IconData prefixIcon;
  final IconData visibleIcon;
  final IconData hiddenIcon;
  final String? hintText;
  final bool enabled;
  final bool initiallyObscured;
  final String obscuringCharacter;
  final TextStyle? style;

  // Validation
  final String? Function(String?)? validator;
  final String? errorText;
  final Widget Function(BuildContext, String?)? errorBuilder;
  final bool forceErrorState;
  final AutovalidateMode autovalidateMode;

  // Input behaviour
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;

  // Animation
  final Duration animationDuration;
  final Curve animationCurve;

  // Haptics
  final SFFieldHaptic hapticFeedback;

  // Internal builder
  final InputDecoration Function(
      BuildContext, bool, bool, bool, bool, VoidCallback)? _builder;

  @override
  State<SFPasswordField> createState() => _SFPasswordFieldState();
}

class _SFPasswordFieldState extends State<SFPasswordField>
    with _SFFieldHapticMixin, _SFFieldThemeResolver {
  late FocusNode _focusNode;
  late bool _obscureText;
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
    _obscureText = widget.initiallyObscured;
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() => _isFocused = _focusNode.hasFocus);
    if (_focusNode.hasFocus) triggerFieldHaptic(widget.hapticFeedback);
  }

  void _toggleObscure() => setState(() => _obscureText = !_obscureText);

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    if (widget.focusNode == null) _focusNode.dispose();
    super.dispose();
  }

  String? get _effectiveError => widget.errorText ?? _validationError;

  @override
  Widget build(BuildContext context) {
    final safeChar = widget.obscuringCharacter.characters.isNotEmpty
        ? widget.obscuringCharacter.characters.first
        : '✲';

    // Builder constructor
    if (widget._builder != null) {
      return _buildRawField(
        safeChar: safeChar,
        decoration: widget._builder!(
          context,
          _isFocused,
          hasError,
          isFilled,
          _obscureText,
          _toggleObscure,
        ),
      );
    }

    final theme = resolveTheme();

    final toggleButton = IconButton(
      icon: Icon(
        _obscureText ? widget.hiddenIcon : widget.visibleIcon,
        color: theme.suffixIconColor,
      ),
      onPressed: _toggleObscure,
    );

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
            safeChar: safeChar,
            decoration: buildThemedDecoration(
              theme: theme,
              labelText: widget.labelText,
              readOnly: false,
              hasError: hasError,
              isFocused: _isFocused,
              hintText: widget.hintText,
              prefixIcon: widget.prefixIcon,
              suffixWidget: toggleButton,
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
    required String safeChar,
    required InputDecoration decoration,
    TextStyle? style,
  }) {
    return TextFormField(
      controller: widget.controller,
      focusNode: _focusNode,
      obscureText: _obscureText,
      obscuringCharacter: safeChar,
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
      autovalidateMode: widget.autovalidateMode,
      textInputAction: widget.textInputAction,
      onFieldSubmitted: widget.onFieldSubmitted,
      enabled: widget.enabled,
      onChanged: (_) => setState(() {}), // rebuild for isFilled
      style: style ?? widget.style,
      decoration: decoration,
    );
  }
}
