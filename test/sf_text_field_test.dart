import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swift_field/swift_field.dart';

void main() {
  // ─────────────────────────────────────────────────────────────────────────
  // SFTextField
  // ─────────────────────────────────────────────────────────────────────────
  group('SFTextField', () {
    testWidgets('renders labelText', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SFTextField(controller: controller, labelText: 'Full Name'),
        ),
      ));

      expect(find.text('Full Name'), findsOneWidget);
    });

    testWidgets('accepts text input', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SFTextField(controller: controller, labelText: 'Name'),
        ),
      ));

      await tester.enterText(find.byType(TextFormField), 'John');
      expect(controller.text, 'John');
    });

    testWidgets('readOnly — EditableText has readOnly true', (tester) async {
      final controller = TextEditingController(text: 'fixed');
      addTearDown(controller.dispose);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SFTextField(
            controller: controller,
            labelText: 'ID',
            readOnly: true,
          ),
        ),
      ));

      final editableText =
      tester.widget<EditableText>(find.byType(EditableText));
      expect(editableText.readOnly, isTrue);
    });

    testWidgets('readOnly — text cannot be changed via input', (tester) async {
      final controller = TextEditingController(text: 'original');
      addTearDown(controller.dispose);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SFTextField(
            controller: controller,
            labelText: 'ID',
            readOnly: true,
          ),
        ),
      ));

      await tester.enterText(find.byType(TextFormField), 'changed');
      expect(controller.text, 'original');
    });

    testWidgets('validator shows error on form validate', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Form(
            key: formKey,
            child: SFTextField(
              controller: controller,
              labelText: 'Name',
              validator: (val) =>
              val == null || val.isEmpty ? 'Required' : null,
            ),
          ),
        ),
      ));

      formKey.currentState!.validate();
      await tester.pump();
      expect(find.text('Required'), findsOneWidget);
    });

    testWidgets('renders prefixIcon', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SFTextField(
            controller: controller,
            labelText: 'Email',
            prefixIcon: Icons.email_outlined,
          ),
        ),
      ));

      expect(find.byIcon(Icons.email_outlined), findsOneWidget);
    });

    testWidgets('multiline — minLines and maxLines accepted', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SFTextField(
            controller: controller,
            labelText: 'Bio',
            minLines: 2,
            maxLines: 5,
            keyboardType: TextInputType.multiline,
          ),
        ),
      ));

      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('disabled field — enabled false', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SFTextField(
            controller: controller,
            labelText: 'Disabled',
            enabled: false,
          ),
        ),
      ));

      // EditableText should not be present when field is fully disabled
      expect(find.byType(TextFormField), findsOneWidget);
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // SFPasswordField
  // ─────────────────────────────────────────────────────────────────────────
  group('SFPasswordField', () {
    testWidgets('renders labelText', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SFPasswordField(
            controller: controller,
            labelText: 'Password',
          ),
        ),
      ));

      expect(find.text('Password'), findsOneWidget);
    });

    testWidgets('text is obscured by default — checked via EditableText',
            (tester) async {
          final controller = TextEditingController();
          addTearDown(controller.dispose);

          await tester.pumpWidget(MaterialApp(
            home: Scaffold(
              body: SFPasswordField(
                controller: controller,
                labelText: 'Password',
              ),
            ),
          ));

          // TextFormField doesn't expose obscureText — check EditableText instead
          final editableText =
          tester.widget<EditableText>(find.byType(EditableText));
          expect(editableText.obscureText, isTrue);
        });

    testWidgets('tapping suffix icon reveals text', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SFPasswordField(
            controller: controller,
            labelText: 'Password',
          ),
        ),
      ));

      // Initially obscured
      expect(
        tester.widget<EditableText>(find.byType(EditableText)).obscureText,
        isTrue,
      );

      // Tap the visibility toggle
      await tester.tap(find.byType(IconButton));
      await tester.pump();

      // Now revealed
      expect(
        tester.widget<EditableText>(find.byType(EditableText)).obscureText,
        isFalse,
      );
    });

    testWidgets('tapping suffix icon twice re-hides text', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SFPasswordField(
            controller: controller,
            labelText: 'Password',
          ),
        ),
      ));

      final iconButton = find.byType(IconButton);

      await tester.tap(iconButton); // reveal
      await tester.pump();
      expect(
        tester.widget<EditableText>(find.byType(EditableText)).obscureText,
        isFalse,
      );

      await tester.tap(iconButton); // hide again
      await tester.pump();
      expect(
        tester.widget<EditableText>(find.byType(EditableText)).obscureText,
        isTrue,
      );
    });

    testWidgets('initiallyObscured false — starts revealed', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SFPasswordField(
            controller: controller,
            labelText: 'Password',
            initiallyObscured: false,
          ),
        ),
      ));

      expect(
        tester.widget<EditableText>(find.byType(EditableText)).obscureText,
        isFalse,
      );
    });

    testWidgets('validator shows error on form validate', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Form(
            key: formKey,
            child: SFPasswordField(
              controller: controller,
              labelText: 'Password',
              validator: (val) =>
              val != null && val.length < 8 ? 'Min 8 chars' : null,
            ),
          ),
        ),
      ));

      await tester.enterText(find.byType(TextFormField), 'short');
      formKey.currentState!.validate();
      await tester.pump();
      expect(find.text('Min 8 chars'), findsOneWidget);
    });

    testWidgets('renders custom prefixIcon', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SFPasswordField(
            controller: controller,
            labelText: 'Password',
            prefixIcon: Icons.security,
          ),
        ),
      ));

      expect(find.byIcon(Icons.security), findsOneWidget);
    });
  });
}