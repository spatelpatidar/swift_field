part of '../sf_pin_code.dart';

/// The constant values for SFPinCode
class SFPinCodeConstants {
  const SFPinCodeConstants._();

  /// The default value [SFPinCode.animationDuration]
  static const _animationDuration = Duration(milliseconds: 180);

  /// The default value [SFPinCode.length]
  static const _defaultLength = 4;

  static const _defaultSeparator = SizedBox(width: 8);

  /// The hidden text under the SFPinCode
  static const _hiddenTextStyle =
      TextStyle(fontSize: 1, height: 1, color: Colors.transparent);

  ///
  static const _defaultPinFillColor = Color.fromRGBO(222, 231, 240, .57);
  static const _defaultSFPinCodeDecoration = BoxDecoration(
    color: _defaultPinFillColor,
    borderRadius: BorderRadius.all(Radius.circular(8)),
  );

  /// The default value [SFPinCode.defaultSFPinTheme]
  static const _defaultSFPinTheme = SFPinTheme(
    width: 56,
    height: 60,
    textStyle: TextStyle(),
    decoration: _defaultSFPinCodeDecoration,
  );
}
