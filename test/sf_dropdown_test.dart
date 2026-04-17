import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swift_field/swift_field.dart';

void main() {
  final items = ['Apple', 'Banana', 'Cherry']
      .map((e) => SFDropdownItem(value: e, label: e))
      .toList();

  // ─────────────────────────────────────────────────────────────────────────
  // SFDropdown
  // ─────────────────────────────────────────────────────────────────────────
  group('SFDropdown', () {
    testWidgets('renders labelText', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SFDropdown<String>(
              labelText: 'Fruit',
              items: items,
              onChanged: (_) {},
            ),
          ),
        ),
      );
      // DropdownMenu renders the label text in TWO places internally
      // (the floating label + the inner InputDecorator label).
      // Use findsWidgets (≥1) instead of findsOneWidget.
      expect(find.text('Fruit'), findsWidgets);
    });

    testWidgets('shows selected value label', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SFDropdown<String>(
              labelText: 'Fruit',
              value: 'Banana',
              items: items,
              onChanged: (_) {},
            ),
          ),
        ),
      );
      // DropdownMenu shows the selected text in both an EditableText and a
      // label Text widget — at least one is enough to confirm it rendered.
      expect(find.text('Banana'), findsWidgets);
    });

    testWidgets('onChanged is called when an item is selected', (tester) async {
      String? selected;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SFDropdown<String>(
              labelText: 'Fruit',
              items: items,
              onChanged: (val) => selected = val,
            ),
          ),
        ),
      );

      // Open the menu
      await tester.tap(find.byType(DropdownMenu<String>));
      await tester.pumpAndSettle();

      // Tap first visible item
      await tester.tap(find.text('Apple').last);
      await tester.pumpAndSettle();

      expect(selected, 'Apple');
    });

    testWidgets('validator shows error when value is null', (tester) async {
      final formKey = GlobalKey<FormState>();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: SFDropdown<String>(
                labelText: 'Fruit',
                items: items,
                onChanged: (_) {},
                validator: (val) => val == null ? 'Select a fruit' : null,
              ),
            ),
          ),
        ),
      );
      formKey.currentState!.validate();
      await tester.pump();
      expect(find.text('Select a fruit'), findsOneWidget);
    });

    testWidgets('validator passes when value is set', (tester) async {
      final formKey = GlobalKey<FormState>();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: SFDropdown<String>(
                labelText: 'Fruit',
                value: 'Apple',
                items: items,
                onChanged: (_) {},
                validator: (val) => val == null ? 'Select a fruit' : null,
              ),
            ),
          ),
        ),
      );
      final isValid = formKey.currentState!.validate();
      await tester.pump();
      expect(isValid, isTrue);
      expect(find.text('Select a fruit'), findsNothing);
    });

    testWidgets('SFDropdownItem disabled flag — widget renders without error',
        (tester) async {
      final mixedItems = [
        const SFDropdownItem(value: 'A', label: 'Alpha'),
        const SFDropdownItem(value: 'B', label: 'Beta', enabled: false),
      ];
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SFDropdown<String>(
              labelText: 'Letter',
              items: mixedItems,
              onChanged: (_) {},
            ),
          ),
        ),
      );
      // DropdownMenu renders label in two places — use findsWidgets
      expect(find.text('Letter'), findsWidgets);
    });

    testWidgets('disabled field cannot be interacted with', (tester) async {
      String? selected;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SFDropdown<String>(
              labelText: 'Fruit',
              items: items,
              onChanged: (val) => selected = val,
              enabled: false,
            ),
          ),
        ),
      );
      await tester.tap(find.byType(DropdownMenu<String>));
      await tester.pumpAndSettle();
      expect(selected, isNull);
    });

    testWidgets('renders prefix icon', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SFDropdown<String>(
              labelText: 'Fruit',
              prefixIcon: Icons.apple,
              items: items,
              onChanged: (_) {},
            ),
          ),
        ),
      );
      // DropdownMenu renders the leading icon twice internally
      expect(find.byIcon(Icons.apple), findsWidgets);
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // SFDropdownSearch — basic rendering tests only.
  // Full interaction tests are in sf_dropdown_search_test.dart
  // ─────────────────────────────────────────────────────────────────────────
  group('SFDropdownSearch (basic)', () {
    testWidgets('renders labelText', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SFDropdownSearch<String>(
              labelText: 'Country',
              items: items,
              onChanged: (_) {},
            ),
          ),
        ),
      );
      expect(find.text('Country'), findsOneWidget);
    });

    testWidgets('shows selected value label', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SFDropdownSearch<String>(
              labelText: 'Fruit',
              value: 'Cherry',
              items: items,
              onChanged: (_) {},
            ),
          ),
        ),
      );
      expect(find.text('Cherry'), findsOneWidget);
    });

    testWidgets('tapping opens the panel with search box', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SFDropdownSearch<String>(
              labelText: 'Fruit',
              items: items,
              onChanged: (_) {},
              searchHintText: 'Search fruit...',
            ),
          ),
        ),
      );
      await tester.tap(find.byType(InputDecorator));
      await tester.pumpAndSettle();
      expect(find.text('Search fruit...'), findsOneWidget);
    });

    testWidgets('validator shows error when value is null', (tester) async {
      final formKey = GlobalKey<FormState>();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: SFDropdownSearch<String>(
                labelText: 'Fruit',
                items: items,
                onChanged: (_) {},
                validator: (val) => val == null ? 'Required' : null,
              ),
            ),
          ),
        ),
      );
      formKey.currentState!.validate();
      await tester.pump();
      expect(find.text('Required'), findsOneWidget);
    });
  });
}
