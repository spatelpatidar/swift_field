part of '../sf_text_field.dart';

/// Shared haptic helper used by SFTextField and SFPasswordField states.
mixin _SFFieldHapticMixin {
  void triggerFieldHaptic(SFFieldHaptic type) {
    switch (type) {
      case SFFieldHaptic.none:
        break;
      case SFFieldHaptic.light:
        HapticFeedback.lightImpact();
      case SFFieldHaptic.medium:
        HapticFeedback.mediumImpact();
      case SFFieldHaptic.heavy:
        HapticFeedback.heavyImpact();
      case SFFieldHaptic.selection:
        HapticFeedback.selectionClick();
    }
  }
}
