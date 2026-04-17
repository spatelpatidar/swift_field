import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swift_field/swift_field.dart';

void main() {
  final countries = [
    'United States',
    'Canada',
    'United Kingdom',
    'Australia',
    'Germany',
  ].map((c) => SFDropdownItem(value: c, label: c)).toList();

  // Helper — builds the widget inside a fixed-size surface so the overlay
  // has enough room to render all items without clipping.
  Widget buildWidget({
    String? value,
    void Function(String?)? onChanged,
    String? Function(String?)? validator,
    String searchHintText = 'Search...',
    bool enabled = true,
    bool Function(SFDropdownItem<String> item, String query)? filterFn,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: 400,
            child: SFDropdownSearch<String>(
              labelText: 'Country',
              prefixIcon: Icons.public_outlined,
              value: value,
              items: countries,
              onChanged: onChanged ?? (_) {},
              validator: validator,
              searchHintText: searchHintText,
              enabled: enabled,
              filterFn: filterFn,
            ),
          ),
        ),
      ),
    );
  }

  group('SFDropdownSearch', () {
    testWidgets('renders labelText', (tester) async {
      await tester.pumpWidget(buildWidget());
      expect(find.text('Country'), findsOneWidget);
    });

    testWidgets('renders prefixIcon', (tester) async {
      await tester.pumpWidget(buildWidget());
      expect(find.byIcon(Icons.public_outlined), findsOneWidget);
    });

    testWidgets('shows selected value when value is set', (tester) async {
      await tester.pumpWidget(buildWidget(value: 'Canada'));
      expect(find.text('Canada'), findsOneWidget);
    });

    testWidgets('no country label shown when value is null', (tester) async {
      await tester.pumpWidget(buildWidget());
      expect(find.text('United States'), findsNothing);
      expect(find.text('Canada'), findsNothing);
    });

    testWidgets('tapping opens panel with search box', (tester) async {
      await tester.pumpWidget(buildWidget(searchHintText: 'Find country...'));
      await tester.tap(find.byType(InputDecorator));
      await tester.pumpAndSettle();
      expect(find.text('Find country...'), findsOneWidget);
    });

    testWidgets('panel shows items when opened', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.tap(find.byType(InputDecorator));
      await tester.pumpAndSettle();
      // At least the first few items are visible
      expect(find.text('United States'), findsOneWidget);
      expect(find.text('Canada'), findsOneWidget);
    });

    testWidgets('typing in search box filters the list', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.tap(find.byType(InputDecorator));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'can');
      await tester.pump();

      expect(find.text('Canada'), findsOneWidget);
      expect(find.text('United States'), findsNothing);
      expect(find.text('Germany'), findsNothing);
    });

    testWidgets('search with no match shows No results found', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.tap(find.byType(InputDecorator));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'zzz');
      await tester.pump();

      expect(find.text('No results found'), findsOneWidget);
    });

    testWidgets('selecting a filtered item calls onChanged and closes panel',
        (tester) async {
      String? selected;
      await tester.pumpWidget(buildWidget(onChanged: (val) => selected = val));

      await tester.tap(find.byType(InputDecorator));
      await tester.pumpAndSettle();

      // Filter down to one result so it's definitely on screen
      await tester.enterText(find.byType(TextField), 'aus');
      await tester.pump();

      expect(find.text('Australia'), findsOneWidget);
      await tester.tap(find.text('Australia'));
      await tester.pumpAndSettle();

      expect(selected, 'Australia');
      // Panel closed — search box is gone
      expect(find.byType(TextField), findsNothing);
    });

    testWidgets('selected label shown in field after selection',
        (tester) async {
      String? selected;

      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) => MaterialApp(
            home: Scaffold(
              body: Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: 400,
                  child: SFDropdownSearch<String>(
                    labelText: 'Country',
                    value: selected,
                    items: countries,
                    onChanged: (val) => setState(() => selected = val),
                    searchHintText: 'Search...',
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(InputDecorator));
      await tester.pumpAndSettle();

      // Filter to just one visible result to avoid off-screen tap issues
      await tester.enterText(find.byType(TextField), 'ger');
      await tester.pump();

      expect(find.text('Germany'), findsOneWidget);
      await tester.tap(find.text('Germany'));
      await tester.pumpAndSettle();

      // After selection the field should display 'Germany'
      expect(find.text('Germany'), findsOneWidget);
    });

    testWidgets('tapping outside the panel closes it', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 400,
                  child: SFDropdownSearch<String>(
                    labelText: 'Country',
                    items: countries,
                    onChanged: (_) {},
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.tap(find.byType(InputDecorator));
      await tester.pumpAndSettle();
      expect(find.byType(TextField), findsOneWidget);

      // The overlay renders a full-screen GestureDetector as the dismiss layer.
      // Tap it directly — this is more reliable than a hardcoded offset which
      // can fall outside the test viewport (default 800×600).
      await tester.tap(
        find.byType(GestureDetector).first,
        warnIfMissed: false,
      );
      await tester.pumpAndSettle();
      expect(find.byType(TextField), findsNothing);
    });

    testWidgets('custom filterFn is used', (tester) async {
      // Only match items that START with the query
      await tester.pumpWidget(buildWidget(
        filterFn: (item, query) =>
            item.label.toLowerCase().startsWith(query.toLowerCase()),
      ));

      await tester.tap(find.byType(InputDecorator));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'can');
      await tester.pump();

      expect(find.text('Canada'), findsOneWidget);
      expect(find.text('United States'), findsNothing);
    });

    testWidgets('validator shows error when value is null', (tester) async {
      final formKey = GlobalKey<FormState>();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: SFDropdownSearch<String>(
                labelText: 'Country',
                items: countries,
                onChanged: (_) {},
                validator: (val) => val == null ? 'Please select' : null,
              ),
            ),
          ),
        ),
      );
      formKey.currentState!.validate();
      await tester.pump();
      expect(find.text('Please select'), findsOneWidget);
    });

    testWidgets('validator passes when value is set', (tester) async {
      final formKey = GlobalKey<FormState>();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: SFDropdownSearch<String>(
                labelText: 'Country',
                value: 'Canada',
                items: countries,
                onChanged: (_) {},
                validator: (val) => val == null ? 'Please select' : null,
              ),
            ),
          ),
        ),
      );
      final isValid = formKey.currentState!.validate();
      await tester.pump();
      expect(isValid, isTrue);
      expect(find.text('Please select'), findsNothing);
    });

    testWidgets('disabled field — panel does not open on tap', (tester) async {
      await tester.pumpWidget(buildWidget(enabled: false));
      await tester.tap(find.byType(InputDecorator));
      await tester.pumpAndSettle();
      // Search TextField should NOT appear — panel never opened
      expect(find.byType(TextField), findsNothing);
    });
  });
}
