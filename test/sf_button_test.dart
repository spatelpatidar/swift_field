import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swift_field/swift_field.dart';

void main() {
  group('SFButton', () {
    testWidgets('renders label text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SFButton(text: 'Submit', onPressed: () {}),
          ),
        ),
      );
      expect(find.text('Submit'), findsOneWidget);
    });

    testWidgets('calls onPressed when tapped', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SFButton(text: 'Tap', onPressed: () => tapped = true),
          ),
        ),
      );
      await tester.tap(find.text('Tap'));
      expect(tapped, isTrue);
    });

    testWidgets('shows spinner when isLoading is true', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SFButton(
              text: 'Submit',
              onPressed: () {},
              isLoading: true,
            ),
          ),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Submit'), findsNothing);
    });

    testWidgets('does not call onPressed while loading', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SFButton(
              text: 'Submit',
              onPressed: () => tapped = true,
              isLoading: true,
            ),
          ),
        ),
      );
      await tester.tap(find.byType(InkWell));
      expect(tapped, isFalse);
    });

    testWidgets('renders with solid backgroundColor', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SFButton(
              text: 'Delete',
              onPressed: () {},
              backgroundColor: Colors.red,
            ),
          ),
        ),
      );
      expect(find.text('Delete'), findsOneWidget);
    });

    testWidgets('renders with gradient', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SFButton(
              text: 'Gradient',
              onPressed: () {},
              gradient: const LinearGradient(
                colors: [Colors.blue, Colors.purple],
              ),
            ),
          ),
        ),
      );
      final ink = tester.widget<Ink>(find.byType(Ink).first);
      final decoration = ink.decoration as BoxDecoration;
      expect(decoration.gradient, isNotNull);
    });

    testWidgets('shows CupertinoActivityIndicator for ios spinnerStyle',
            (tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: SFButton(
                  text: 'Submit',
                  onPressed: () {},
                  isLoading: true,
                  spinnerStyle: SFSpinnerStyle.ios,
                ),
              ),
            ),
          );
          expect(find.byType(CircularProgressIndicator), findsNothing);
        });

    testWidgets('assert throws when both backgroundColor and gradient set',
            (tester) async {
          expect(
                () => SFButton(
              text: 'Bad',
              onPressed: () {},
              backgroundColor: Colors.red,
              gradient: const LinearGradient(colors: [Colors.blue, Colors.green]),
            ),
            throwsAssertionError,
          );
        });
  });
}