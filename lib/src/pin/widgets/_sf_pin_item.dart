part of '../sf_pin_code.dart';

class _PinItem extends StatelessWidget {
  final _SFPinCodeState state;
  final int index;

  const _PinItem({
    required this.state,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final pinTheme = _pinTheme(index);

    return Flexible(
      child: AnimatedContainer(
        height: pinTheme.height,
        width: pinTheme.width,
        constraints: pinTheme.constraints,
        padding: pinTheme.padding,
        margin: pinTheme.margin,
        decoration: pinTheme.decoration,
        alignment: state.widget.pinContentAlignment,
        duration: state.widget.animationDuration,
        curve: state.widget.animationCurve,
        child: AnimatedSwitcher(
          switchInCurve: state.widget.animationCurve,
          switchOutCurve: state.widget.animationCurve,
          duration: state.widget.animationDuration,
          transitionBuilder: _getTransition,
          child: _buildFieldContent(index, pinTheme),
        ),
      ),
    );
  }

  SFPinTheme _pinTheme(int index) {
    final pintState = state._getState(index);
    switch (pintState) {
      case PinItemStateType.initial:
        return _getDefaultSFPinTheme();
      case PinItemStateType.focused:
        return _pinThemeOrDefault(state.widget.focusedSFPinTheme);
      case PinItemStateType.submitted:
        return _pinThemeOrDefault(state.widget.submittedSFPinTheme);
      case PinItemStateType.following:
        return _pinThemeOrDefault(state.widget.followingSFPinTheme);
      case PinItemStateType.disabled:
        return _pinThemeOrDefault(state.widget.disabledSFPinTheme);
      case PinItemStateType.error:
        return _pinThemeOrDefault(state.widget.errorSFPinTheme);
    }
  }

  SFPinTheme _getDefaultSFPinTheme() =>
      state.widget.defaultSFPinTheme ?? SFPinCodeConstants._defaultSFPinTheme;

  SFPinTheme _pinThemeOrDefault(SFPinTheme? theme) =>
      theme ?? _getDefaultSFPinTheme();

  Widget _buildFieldContent(int index, SFPinTheme pinTheme) {
    final pin = state.pin;
    final key = ValueKey<String>(index < pin.length ? pin[index] : '');
    final isSubmittedPin = index < pin.length;

    if (isSubmittedPin) {
      if (state.widget.obscureText && state.widget.obscuringWidget != null) {
        return SizedBox(key: key, child: state.widget.obscuringWidget);
      }

      return Text(
        state.widget.obscureText ? state.widget.obscuringCharacter : pin[index],
        key: key,
        style: pinTheme.textStyle,
      );
    }

    final isActiveField = index == pin.length;
    final focused =
        state._effectiveFocusNode.hasFocus || !state.widget.useNativeKeyboard;
    final shouldShowCursor =
        state.widget.showCursor && state.isEnabled && isActiveField && focused;

    if (shouldShowCursor) {
      return _buildCursor(pinTheme);
    }

    if (state.widget.preFilledWidget != null) {
      return SizedBox(key: key, child: state.widget.preFilledWidget);
    }

    return Text('', key: key, style: pinTheme.textStyle);
  }

  Widget _buildCursor(SFPinTheme pinTheme) {
    if (state.widget.isCursorAnimationEnabled) {
      return _SFPinCodeAnimatedCursor(
        textStyle: pinTheme.textStyle,
        cursor: state.widget.cursor,
      );
    }

    return _SFPinCodeCursor(
      textStyle: pinTheme.textStyle,
      cursor: state.widget.cursor,
    );
  }

  Widget _getTransition(Widget child, Animation<double> animation) {
    if (child is _SFPinCodeAnimatedCursor) {
      return child;
    }

    switch (state.widget.pinAnimationType) {
      case SFPinAnimationType.none:
        return child;
      case SFPinAnimationType.fade:
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      case SFPinAnimationType.scale:
        return ScaleTransition(
          scale: animation,
          child: child,
        );
      case SFPinAnimationType.slide:
        return SlideTransition(
          position: Tween<Offset>(
            begin:
                state.widget.slideTransitionBeginOffset ?? const Offset(0.8, 0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      case SFPinAnimationType.rotation:
        return RotationTransition(
          turns: animation,
          child: child,
        );
    }
  }
}
