part of '../sf_button.dart';

/// Shared haptic helper used by both [SFButton] and [SFIconButton].
mixin _SFButtonHapticMixin {
  void triggerHaptic(SFButtonHaptic type) {
    switch (type) {
      case SFButtonHaptic.none:
        break;
      case SFButtonHaptic.light:
        HapticFeedback.lightImpact();
      case SFButtonHaptic.medium:
        HapticFeedback.mediumImpact();
      case SFButtonHaptic.heavy:
        HapticFeedback.heavyImpact();
      case SFButtonHaptic.selection:
        HapticFeedback.selectionClick();
    }
  }
}
