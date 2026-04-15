import 'dart:math';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

part 'sf_pin_code_state.dart';

part 'utils/sf_enums.dart';

part 'utils/sf_pin_code_constants.dart';

part 'widgets/sf_widgets.dart';

part 'models/sf_pin_theme.dart';

part 'models/sf_models.dart';

part 'models/sf_sms_retriever.dart';

part 'utils/sf_extensions.dart';

part 'widgets/_sf_pin_item.dart';

part 'utils/sf_pin_code_utils_mixin.dart';

part 'widgets/_sf_pin_code_selection_gesture_detector_builder.dart';

/// Flutter package to create easily customizable Pin code input field, that your designers can't even draw in Figma 🤭
///
/// ## Features:
/// - Animated Decoration Switching
/// - Form validation
/// - SMS Autofill on iOS
/// - SMS Autofill on Android
/// - Standard Cursor
/// - Custom Cursor
/// - Cursor Animation
/// - Copy From Clipboard
/// - Ready For Custom Keyboard
/// - Standard Paste option
/// - Obscuring Character
/// - Obscuring Widget
/// - Haptic Feedback
/// - Close Keyboard After Completion
/// - Beautiful [Examples](https://github.com/Tkko/Flutter_SFPinCode/tree/master/example/lib/demo)
class SFPinCode extends StatefulWidget {
  /// Creates a SFPinCode widget
  const SFPinCode({
    this.length = SFPinCodeConstants._defaultLength,
    this.smsRetriever,
    this.defaultSFPinTheme,
    this.focusedSFPinTheme,
    this.submittedSFPinTheme,
    this.followingSFPinTheme,
    this.disabledSFPinTheme,
    this.errorSFPinTheme,
    this.onChanged,
    this.onCompleted,
    this.onSubmitted,
    this.onTap,
    this.onLongPress,
    this.onTapOutside,
    this.onTapUpOutside,
    this.controller,
    this.focusNode,
    this.preFilledWidget,
    this.separatorBuilder,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.pinContentAlignment = Alignment.center,
    this.animationCurve = Curves.easeIn,
    this.animationDuration = SFPinCodeConstants._animationDuration,
    this.pinAnimationType = SFPinAnimationType.scale,
    this.enabled = true,
    this.readOnly = false,
    this.useNativeKeyboard = true,
    this.toolbarEnabled = true,
    this.autofocus = false,
    this.obscureText = false,
    this.showCursor = true,
    this.isCursorAnimationEnabled = true,
    this.enableIMEPersonalizedLearning = false,
    this.enableInteractiveSelection,
    this.enableSuggestions = true,
    this.hapticFeedbackType = SFHapticFeedbackType.disabled,
    this.closeKeyboardWhenCompleted = true,
    this.keyboardType = TextInputType.number,
    this.textCapitalization = TextCapitalization.none,
    this.slideTransitionBeginOffset,
    this.cursor,
    this.keyboardAppearance,
    this.inputFormatters = const [],
    this.textInputAction,
    this.autofillHints = const [
      AutofillHints.oneTimeCode,
    ],
    this.obscuringCharacter = '•',
    this.obscuringWidget,
    this.selectionControls,
    this.restorationId,
    this.onClipboardFound,
    this.onAppPrivateCommand,
    this.mouseCursor,
    this.forceErrorState = false,
    this.showErrorWhenFocused = false,
    this.errorText,
    this.validator,
    this.errorBuilder,
    this.errorTextStyle,
    this.sfPinAutovalidateMode = SFPinAutovalidateMode.onSubmit,
    this.scrollPadding = const EdgeInsets.all(20),
    this.contextMenuBuilder = _defaultContextMenuBuilder,
    super.key,
  })  : assert(obscuringCharacter.length == 1),
        assert(length > 0),
        assert(
          textInputAction != TextInputAction.newline,
          'SFPinCode is not multiline',
        ),
        _builder = null;

  /// Creates a SFPinCode widget with custom pin item builder
  /// This gives you full control over the pin item widget
  SFPinCode.builder({
    required PinItemWidgetBuilder builder,
    this.smsRetriever,
    this.length = SFPinCodeConstants._defaultLength,
    this.onChanged,
    this.onCompleted,
    this.onSubmitted,
    this.onTap,
    this.onLongPress,
    this.onTapOutside,
    this.onTapUpOutside,
    this.controller,
    this.focusNode,
    this.separatorBuilder,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.enabled = true,
    this.readOnly = false,
    this.useNativeKeyboard = true,
    this.toolbarEnabled = true,
    this.autofocus = false,
    this.enableIMEPersonalizedLearning = false,
    this.enableInteractiveSelection = false,
    this.enableSuggestions = true,
    this.hapticFeedbackType = SFHapticFeedbackType.disabled,
    this.closeKeyboardWhenCompleted = true,
    this.keyboardType = TextInputType.number,
    this.textCapitalization = TextCapitalization.none,
    this.keyboardAppearance,
    this.inputFormatters = const [],
    this.textInputAction,
    this.autofillHints,
    this.selectionControls,
    this.restorationId,
    this.onClipboardFound,
    this.onAppPrivateCommand,
    this.mouseCursor,
    this.forceErrorState = false,
    this.showErrorWhenFocused = false,
    this.validator,
    this.sfPinAutovalidateMode = SFPinAutovalidateMode.onSubmit,
    this.scrollPadding = const EdgeInsets.all(20),
    this.contextMenuBuilder = _defaultContextMenuBuilder,
    super.key,
  })  : assert(length > 0),
        assert(
          textInputAction != TextInputAction.newline,
          'SFPinCode is not multiline',
        ),
        _builder = _PinItemBuilder(
          itemBuilder: builder,
        ),
        defaultSFPinTheme = null,
        focusedSFPinTheme = null,
        submittedSFPinTheme = null,
        followingSFPinTheme = null,
        disabledSFPinTheme = null,
        errorSFPinTheme = null,
        preFilledWidget = null,
        pinContentAlignment = Alignment.center,
        animationCurve = Curves.easeIn,
        animationDuration = SFPinCodeConstants._animationDuration,
        pinAnimationType = SFPinAnimationType.scale,
        obscureText = false,
        showCursor = false,
        isCursorAnimationEnabled = false,
        slideTransitionBeginOffset = null,
        cursor = null,
        obscuringCharacter = '•',
        obscuringWidget = null,
        errorText = null,
        errorBuilder = null,
        errorTextStyle = null;

  /// Theme of the pin in default state
  final SFPinTheme? defaultSFPinTheme;

  /// Theme of the pin in focused state
  final SFPinTheme? focusedSFPinTheme;

  /// Theme of the pin in submitted state
  final SFPinTheme? submittedSFPinTheme;

  /// Theme of the pin in following state
  final SFPinTheme? followingSFPinTheme;

  /// Theme of the pin in disabled state
  final SFPinTheme? disabledSFPinTheme;

  /// Theme of the pin in error state
  final SFPinTheme? errorSFPinTheme;

  /// If true keyboard will be closed
  final bool closeKeyboardWhenCompleted;

  /// Displayed fields count. PIN code length.
  final int length;

  /// By default Android autofill is Disabled, you can enable it by passing [smsRetriever]
  /// SmsRetriever exposes methods to listen for incoming SMS and extract code from it
  /// Recommended package to get sms code on Android is smart_auth https://pub.dev/packages/smart_auth
  final SmsRetriever? smsRetriever;

  /// Fires when user completes pin input
  final ValueChanged<String>? onCompleted;

  /// Called every time input value changes.
  final ValueChanged<String>? onChanged;

  /// See [EditableText.onSubmitted]
  final ValueChanged<String>? onSubmitted;

  /// Called when user clicks on SFPinCode
  final VoidCallback? onTap;

  /// Triggered when a pointer has remained in contact with the SFPinCode at the
  /// same location for a long period of time.
  final VoidCallback? onLongPress;

  /// Used to get, modify SFPinCode value and more.
  /// Don't forget to dispose controller
  /// ``` dart
  ///   @override
  ///   void dispose() {
  ///     controller.dispose();
  ///     super.dispose();
  ///   }
  /// ```
  final TextEditingController? controller;

  /// Defines the keyboard focus for this
  /// To give the keyboard focus to this widget, provide a [focusNode] and then
  /// use the current [FocusScope] to request the focus:
  /// Don't forget to dispose focusNode
  /// ``` dart
  ///   @override
  ///   void dispose() {
  ///     focusNode.dispose();
  ///     super.dispose();
  ///   }
  /// ```
  final FocusNode? focusNode;

  /// Widget that is displayed before field submitted.
  final Widget? preFilledWidget;

  /// Builds a [SFPinCode] separator
  /// If null SizedBox(width: 8) will be used
  final JustIndexedWidgetBuilder? separatorBuilder;

  /// Builds a [SFPinCode] item
  /// If null the default _PinItem will be used
  final _PinItemBuilder? _builder;

  /// Defines how [SFPinCode] fields are being placed inside [Row]
  final MainAxisAlignment mainAxisAlignment;

  /// Defines how [SFPinCode] and ([errorText] or [errorBuilder]) are being placed inside [Column]
  final CrossAxisAlignment crossAxisAlignment;

  /// Defines how each [SFPinCode] field are being placed within the container
  final AlignmentGeometry pinContentAlignment;

  /// curve of every [SFPinCode] Animation
  final Curve animationCurve;

  /// Duration of every [SFPinCode] Animation
  final Duration animationDuration;

  /// Animation Type of each [SFPinCode] field
  /// options:
  /// none, scale, fade, slide, rotation
  final SFPinAnimationType pinAnimationType;

  /// Begin Offset of ever [SFPinCode] field when [pinAnimationType] is slide
  final Offset? slideTransitionBeginOffset;

  /// Defines [SFPinCode] state
  final bool enabled;

  /// See [EditableText.readOnly]
  final bool readOnly;

  /// See [EditableText.autofocus]
  final bool autofocus;

  /// Whether to use Native keyboard or custom one
  /// when flag is set to false [SFPinCode] wont be focusable anymore
  /// so you should set value of [SFPinCode]'s [TextEditingController] programmatically
  final bool useNativeKeyboard;

  /// If true, paste button will appear on longPress event
  final bool toolbarEnabled;

  /// Whether show cursor or not
  /// Default cursor '|' or [cursor]
  final bool showCursor;

  /// Whether to enable cursor animation
  final bool isCursorAnimationEnabled;

  /// Whether to enable that the IME update personalized data such as typing history and user dictionary data.
  //
  // This flag only affects Android. On iOS, there is no equivalent flag.
  //
  // Defaults to false. Cannot be null.
  final bool enableIMEPersonalizedLearning;

  /// Whether to enable text selection and interactive features like copy/paste.
  /// When enabled, users can select text, use Ctrl+V to paste, and access context menus.
  ///
  /// This is useful for desktop applications where copy/paste is expected behavior.
  /// On mobile, consider using SMS auto-fill or [onClipboardFound] callback instead.
  ///
  /// Defaults to false for security and UX reasons.
  final bool? enableInteractiveSelection;

  /// If [showCursor] true the focused field will show passed Widget
  final Widget? cursor;

  /// The appearance of the keyboard.
  /// This setting is only honored on iOS devices.
  /// If unset, defaults to [ThemeData.brightness].
  final Brightness? keyboardAppearance;

  /// See [EditableText.inputFormatters]
  final List<TextInputFormatter> inputFormatters;

  /// See [EditableText.keyboardType]
  final TextInputType keyboardType;

  /// Provide any symbol to obscure each [SFPinCode] pin
  /// Recommended ●
  final String obscuringCharacter;

  /// IF [obscureText] is true typed text will be replaced with passed Widget
  final Widget? obscuringWidget;

  /// Whether hide typed pin or not
  final bool obscureText;

  /// See [EditableText.textCapitalization]
  final TextCapitalization textCapitalization;

  /// The type of action button to use for the keyboard.
  ///
  /// Defaults to [TextInputAction.newline] if [keyboardType] is
  /// [TextInputType.multiline] and [TextInputAction.done] otherwise.
  final TextInputAction? textInputAction;

  /// See [EditableText.autofillHints]
  final Iterable<String>? autofillHints;

  /// See [EditableText.enableSuggestions]
  final bool enableSuggestions;

  /// See [EditableText.selectionControls]
  final TextSelectionControls? selectionControls;

  /// See [TextField.restorationId]
  final String? restorationId;

  /// Fires when clipboard has text of SFPinCode's length
  final ValueChanged<String>? onClipboardFound;

  /// Use haptic feedback everytime user types on keyboard
  /// See more details in [HapticFeedback]
  final SFHapticFeedbackType hapticFeedbackType;

  /// See [EditableText.onAppPrivateCommand]
  final AppPrivateCommandCallback? onAppPrivateCommand;

  /// See [EditableText.mouseCursor]
  final MouseCursor? mouseCursor;

  /// If true [errorSFPinTheme] will be applied and [errorText] will be displayed under the SFPinCode
  final bool forceErrorState;

  /// If true, the error will also be displayed in the focused state. Otherwise the error is not displayed in the focused state.
  final bool showErrorWhenFocused;

  /// Text displayed under the SFPinCode if SFPinCode is invalid
  final String? errorText;

  /// Style of error text
  final TextStyle? errorTextStyle;

  /// If [SFPinCode] has error and [errorBuilder] is passed it will be rendered under the SFPinCode
  final SFPinErrorBuilder? errorBuilder;

  /// Return null if pin is valid or any String otherwise
  final FormFieldValidator<String>? validator;

  /// Return null if pin is valid or any String otherwise
  final SFPinAutovalidateMode sfPinAutovalidateMode;

  /// When this widget receives focus and is not completely visible (for example scrolled partially
  /// off the screen or overlapped by the keyboard)
  /// then it will attempt to make itself visible by scrolling a surrounding [Scrollable], if one is present.
  /// This value controls how far from the edges of a [Scrollable] the TextField will be positioned after the scroll.
  final EdgeInsets scrollPadding;

  /// {@macro flutter.widgets.EditableText.contextMenuBuilder}
  ///
  /// If not provided, will build a default menu based on the platform.
  ///
  /// See also:
  ///
  ///  * [AdaptiveTextSelectionToolbar], which is built by default.
  final EditableTextContextMenuBuilder? contextMenuBuilder;

  /// A callback to be invoked when a tap is detected outside of this [TapRegion]
  /// The [PointerDownEvent] passed to the function is the event that caused the
  /// notification. If this region is part of a group
  /// then it's possible that the event may be outside of this immediate region,
  /// although it will be within the region of one of the group members.
  /// This is useful if you want to un-focus the [SFPinCode] when user taps outside of it
  final TapRegionCallback? onTapOutside;

  /// Called for each tap up that occurs outside of the [TextFieldTapRegion]
  /// group when the text field is focused.
  ///
  /// This is useful if you want to un-focus the [SFPinCode] when user taps outside of it,
  /// but not when user scrolls outside of it :
  /// ```dart
  /// onTapOutside: (event) => tapPosition = event.position,
  /// onTapUpOutside: (event) {
  ///   if (event.position == tapPosition) _focusNode.unfocus();
  ///   tapPosition = null;
  /// },
  /// ```
  ///
  /// See also: [EditableText.onTapUpOutside].
  final TapRegionUpCallback? onTapUpOutside;

  static Widget _defaultContextMenuBuilder(
    BuildContext context,
    EditableTextState editableTextState,
  ) {
    return AdaptiveTextSelectionToolbar.editableText(
      editableTextState: editableTextState,
    );
  }

  @override
  State<SFPinCode> createState() => _SFPinCodeState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<SFPinTheme>(
        'defaultSFPinTheme',
        defaultSFPinTheme,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<SFPinTheme>(
        'focusedSFPinTheme',
        focusedSFPinTheme,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<bool>(
        'enableInteractiveSelection',
        enableInteractiveSelection,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<SFPinTheme>(
        'submittedSFPinTheme',
        submittedSFPinTheme,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<SFPinTheme>(
        'followingSFPinTheme',
        followingSFPinTheme,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<SFPinTheme>(
        'disabledSFPinTheme',
        disabledSFPinTheme,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<SFPinTheme>(
        'errorSFPinTheme',
        errorSFPinTheme,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<TextEditingController>(
        'controller',
        controller,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<FocusNode>(
        'focusNode',
        focusNode,
        defaultValue: null,
      ),
    );
    properties
        .add(DiagnosticsProperty<bool>('enabled', enabled, defaultValue: true));
    properties.add(
      DiagnosticsProperty<bool>(
        'closeKeyboardWhenCompleted',
        closeKeyboardWhenCompleted,
        defaultValue: true,
      ),
    );
    properties.add(
      DiagnosticsProperty<TextInputType>(
        'keyboardType',
        keyboardType,
        defaultValue: TextInputType.number,
      ),
    );
    properties.add(
      DiagnosticsProperty<int>(
        'length',
        length,
        defaultValue: SFPinCodeConstants._defaultLength,
      ),
    );
    properties.add(
      DiagnosticsProperty<ValueChanged<String>?>(
        'onCompleted',
        onCompleted,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<ValueChanged<String>?>(
        'onChanged',
        onChanged,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<ValueChanged<String>?>(
        'onClipboardFound',
        onClipboardFound,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<VoidCallback?>('onTap', onTap, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty<VoidCallback?>(
        'onLongPress',
        onLongPress,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<Widget?>(
        'preFilledWidget',
        preFilledWidget,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<Widget?>('cursor', cursor, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty<JustIndexedWidgetBuilder?>(
        'separatorBuilder',
        separatorBuilder,
        defaultValue: SFPinCodeConstants._defaultSeparator,
      ),
    );
    properties.add(
      DiagnosticsProperty<_PinItemBuilder>(
        '_builder',
        _builder,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<Widget?>(
        'obscuringWidget',
        obscuringWidget,
        defaultValue: null,
      ),
    );

    properties.add(
      DiagnosticsProperty<MainAxisAlignment>(
        'mainAxisAlignment',
        mainAxisAlignment,
        defaultValue: MainAxisAlignment.center,
      ),
    );
    properties.add(
      DiagnosticsProperty<AlignmentGeometry>(
        'pinContentAlignment',
        pinContentAlignment,
        defaultValue: Alignment.center,
      ),
    );
    properties.add(
      DiagnosticsProperty<Curve>(
        'animationCurve',
        animationCurve,
        defaultValue: Curves.easeIn,
      ),
    );
    properties.add(
      DiagnosticsProperty<Duration>(
        'animationDuration',
        animationDuration,
        defaultValue: SFPinCodeConstants._animationDuration,
      ),
    );
    properties.add(
      DiagnosticsProperty<SFPinAnimationType>(
        'pinAnimationType',
        pinAnimationType,
        defaultValue: SFPinAnimationType.scale,
      ),
    );
    properties.add(
      DiagnosticsProperty<Offset?>(
        'slideTransitionBeginOffset',
        slideTransitionBeginOffset,
        defaultValue: null,
      ),
    );
    properties
        .add(DiagnosticsProperty<bool>('enabled', enabled, defaultValue: true));
    properties.add(
      DiagnosticsProperty<bool>('readOnly', readOnly, defaultValue: false),
    );
    properties.add(
      DiagnosticsProperty<bool>(
        'obscureText',
        obscureText,
        defaultValue: false,
      ),
    );
    properties.add(
      DiagnosticsProperty<bool>('autofocus', autofocus, defaultValue: false),
    );
    properties.add(
      DiagnosticsProperty<bool>(
        'useNativeKeyboard',
        useNativeKeyboard,
        defaultValue: false,
      ),
    );
    properties.add(
      DiagnosticsProperty<bool>(
        'toolbarEnabled',
        toolbarEnabled,
        defaultValue: true,
      ),
    );
    properties.add(
      DiagnosticsProperty<bool>(
        'showCursor',
        showCursor,
        defaultValue: true,
      ),
    );
    properties.add(
      DiagnosticsProperty<String>(
        'obscuringCharacter',
        obscuringCharacter,
        defaultValue: '•',
      ),
    );
    properties.add(
      DiagnosticsProperty<bool>(
        'obscureText',
        obscureText,
        defaultValue: false,
      ),
    );
    properties.add(
      DiagnosticsProperty<bool>(
        'enableSuggestions',
        enableSuggestions,
        defaultValue: true,
      ),
    );
    properties.add(
      DiagnosticsProperty<List<TextInputFormatter>>(
        'inputFormatters',
        inputFormatters,
        defaultValue: const <TextInputFormatter>[],
      ),
    );
    properties.add(
      EnumProperty<TextInputAction>(
        'textInputAction',
        textInputAction,
        defaultValue: TextInputAction.done,
      ),
    );
    properties.add(
      EnumProperty<TextCapitalization>(
        'textCapitalization',
        textCapitalization,
        defaultValue: TextCapitalization.none,
      ),
    );
    properties.add(
      DiagnosticsProperty<Brightness>(
        'keyboardAppearance',
        keyboardAppearance,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<TextInputType>(
        'keyboardType',
        keyboardType,
        defaultValue: TextInputType.number,
      ),
    );
    properties.add(
      DiagnosticsProperty<Iterable<String>?>(
        'autofillHints',
        autofillHints,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<TextSelectionControls?>(
        'selectionControls',
        selectionControls,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<String?>(
        'restorationId',
        restorationId,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<AppPrivateCommandCallback?>(
        'onAppPrivateCommand',
        onAppPrivateCommand,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<MouseCursor?>(
        'mouseCursor',
        mouseCursor,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<TextStyle?>(
        'errorTextStyle',
        errorTextStyle,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<SFPinErrorBuilder?>(
        'errorBuilder',
        errorBuilder,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<FormFieldValidator<String>?>(
        'validator',
        validator,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<SFPinAutovalidateMode>(
        'sfPinAutovalidateMode',
        sfPinAutovalidateMode,
        defaultValue: SFPinAutovalidateMode.onSubmit,
      ),
    );
    properties.add(
      DiagnosticsProperty<SFHapticFeedbackType>(
        'hapticFeedbackType',
        hapticFeedbackType,
        defaultValue: SFHapticFeedbackType.disabled,
      ),
    );
    properties.add(
      DiagnosticsProperty<EditableTextContextMenuBuilder?>(
        'contextMenuBuilder',
        contextMenuBuilder,
        defaultValue: _defaultContextMenuBuilder,
      ),
    );
  }
}
