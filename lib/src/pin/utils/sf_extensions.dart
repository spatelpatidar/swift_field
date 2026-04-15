part of '../sf_pin_code.dart';

/// Helper methods for SFPinCode to easily set, delete, append the value programmatically
/// ``` dart
/// final controller = TextEditingController();
///
/// controller.setText('1234');
///
/// SFPinCode(
///   controller: controller,
/// );
/// ```
///
extension SFPinCodeControllerExt on TextEditingController {
  /// The length of the SFPinCode value
  int get length => this.text.length;

  /// Sets SFPinCode value
  void setText(String pin) {
    this.text = pin;
    this.moveCursorToEnd();
  }

  /// Deletes the last character of SFPinCode value
  void delete() {
    if (text.isEmpty) return;
    final pin = this.text.substring(0, this.length - 1);
    this.text = pin;
    this.moveCursorToEnd();
  }

  /// Appends character at the end of the SFPinCode
  void append(String s, int maxLength) {
    if (this.length == maxLength) return;
    this.text = '${this.text}$s';
    this.moveCursorToEnd();
  }

  /// Moves cursor at the end
  void moveCursorToEnd() {
    this.selection = TextSelection.collapsed(offset: this.length);
  }
}
