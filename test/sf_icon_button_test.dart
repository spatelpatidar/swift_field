import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swift_field/swift_field.dart';

void main() {
  group('SFIconButton', () {
    testWidgets('renders label text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SFIconButton(text: 'Add', onPressed: () {}),
          ),
        ),
      );
      expect(find.text('Add'), findsOneWidget);
    });

    testWidgets('renders icon', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SFIconButton(icon: Icons.add, onPressed: () {}),
          ),
        ),
      );
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('calls onPressed when tapped', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SFIconButton(
              text: 'Tap',
              onPressed: () => tapped = true,
            ),
          ),
        ),
      );
      await tester.tap(find.text('Tap'));
      expect(tapped, isTrue);
    });

    testWidgets('shows spinner and hides content when isLoading', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SFIconButton(
              text: 'Save',
              icon: Icons.save,
              onPressed: () {},
              isLoading: true,
            ),
          ),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Save'), findsNothing);
      expect(find.byIcon(Icons.save), findsNothing);
    });

    testWidgets('compact mode — SizedBox has no explicit full width',
            (tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: Row(
                  children: [
                    SFIconButton(
                      text: 'Compact',
                      onPressed: () {},
                      mode: SFIconButtonMode.compact,
                    ),
                  ],
                ),
              ),
            ),
          );
          expect(find.text('Compact'), findsOneWidget);
        });

    testWidgets('expanded mode — SizedBox uses double.infinity width',
            (tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: SFIconButton(
                  text: 'Expanded',
                  onPressed: () {},
                  mode: SFIconButtonMode.expanded,
                ),
              ),
            ),
          );
          final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).first);
          expect(sizedBox.width, double.infinity);
        });

    testWidgets('renders with gradient', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SFIconButton(
              text: 'Gradient',
              onPressed: () {},
              gradient: const LinearGradient(
                colors: [Colors.green, Colors.teal],
              ),
            ),
          ),
        ),
      );
      final ink = tester.widget<Ink>(find.byType(Ink).first);
      final decoration = ink.decoration as BoxDecoration;
      expect(decoration.gradient, isNotNull);
    });
  });
}