import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swift_field/swift_field.dart';

void main() {
  group('SFTheme', () {
    tearDown(() {
      // Reset to defaults after each test
      SFTheme.primaryColor = const Color(0xFF003249);
      SFTheme.borderRadius = 16.0;
      SFTheme.buttonHeight = 48.0;
      SFTheme.readOnlyFillColor = const Color(0xFFF5F5F5);
      SFTheme.labelStyle = null;
      SFTheme.buttonTextStyle = null;
      SFTheme.gradient = null;
    });

    test('default primaryColor is 0xFF003249', () {
      expect(SFTheme.primaryColor, const Color(0xFF003249));
    });

    test('default borderRadius is 16.0', () {
      expect(SFTheme.borderRadius, 16.0);
    });

    test('default buttonHeight is 48.0', () {
      expect(SFTheme.buttonHeight, 48.0);
    });

    test('default gradient is null', () {
      expect(SFTheme.gradient, isNull);
    });

    test('primaryColor can be changed globally', () {
      SFTheme.primaryColor = Colors.indigo;
      expect(SFTheme.primaryColor, Colors.indigo);
    });

    test('borderRadius can be changed globally', () {
      SFTheme.borderRadius = 8.0;
      expect(SFTheme.borderRadius, 8.0);
    });

    test('gradient can be set globally', () {
      const gradient = LinearGradient(colors: [Colors.blue, Colors.purple]);
      SFTheme.gradient = gradient;
      expect(SFTheme.gradient, gradient);
    });

    test('defaultBorder uses current borderRadius', () {
      SFTheme.borderRadius = 10.0;
      final border = SFTheme.defaultBorder;
      expect(
        border.borderRadius,
        BorderRadius.circular(10.0),
      );
    });

    test('focusedBorder uses current primaryColor', () {
      SFTheme.primaryColor = Colors.red;
      final border = SFTheme.focusedBorder;
      expect(border.borderSide.color, Colors.red);
    });

    test('buildDecoration returns correct labelText', () {
      final dec = SFTheme.buildDecoration(labelText: 'Test Label');
      expect(dec.labelText, 'Test Label');
    });

    test('buildDecoration fills background when readOnly', () {
      final dec = SFTheme.buildDecoration(labelText: 'ID', readOnly: true);
      expect(dec.filled, isTrue);
      expect(dec.fillColor, SFTheme.readOnlyFillColor);
    });
  });
}
