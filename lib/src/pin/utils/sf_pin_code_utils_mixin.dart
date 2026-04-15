part of '../sf_pin_code.dart';

mixin _SFPinCodeUtilsMixin {
  void _maybeUseHaptic(SFHapticFeedbackType hapticFeedbackType) {
    switch (hapticFeedbackType) {
      case SFHapticFeedbackType.disabled:
        break;
      case SFHapticFeedbackType.lightImpact:
        HapticFeedback.lightImpact();
        break;
      case SFHapticFeedbackType.mediumImpact:
        HapticFeedback.mediumImpact();
        break;
      case SFHapticFeedbackType.heavyImpact:
        HapticFeedback.heavyImpact();
        break;
      case SFHapticFeedbackType.selectionClick:
        HapticFeedback.selectionClick();
        break;
      case SFHapticFeedbackType.vibrate:
        HapticFeedback.vibrate();
        break;
    }
  }

  Future<String> _getClipboardOrEmpty() async {
    final ClipboardData? clipboardData = await Clipboard.getData('text/plain');
    return clipboardData?.text ?? '';
  }
}
