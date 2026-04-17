// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:swift_field/swift_field.dart';
// import 'package:smart_auth/smart_auth.dart';

// void main() {
//   runApp(
//     MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.white,
//           elevation: 0,
//           title: const Text('SFPinCode Example'),
//           centerTitle: true,
//           titleTextStyle: const TextStyle(
//             fontSize: 22,
//             fontWeight: FontWeight.w600,
//             color: Color.fromRGBO(30, 60, 87, 1),
//           ),
//         ),
//         body: const FractionallySizedBox(
//           widthFactor: 1,
//           // You can also checkout the [SFPincodeBuilderExample]
//           child: SFPincodeExample(),
//         ),
//       ),
//     ),
//   );
// }

// /// This is the basic usage of SFPinCode
// /// For more examples check out the demo directory
// class SFPincodeExample extends StatefulWidget {
//   const SFPincodeExample({super.key});

//   @override
//   State<SFPincodeExample> createState() => _SFPincodeExampleState();
// }

// class _SFPincodeExampleState extends State<SFPincodeExample> {
//   late final SmsRetriever smsRetriever;
//   late final TextEditingController pinController;
//   late final FocusNode focusNode;
//   late final GlobalKey<FormState> formKey;

//   @override
//   void initState() {
//     super.initState();
//     // On web, disable the browser's context menu since this example uses a custom
//     // Flutter-rendered context menu.
//     if (kIsWeb) {
//       BrowserContextMenu.disableContextMenu();
//     }
//     formKey = GlobalKey<FormState>();
//     pinController = TextEditingController();
//     focusNode = FocusNode();

//     /// In case you need an SMS autofill feature
//     // smsRetriever = SmsRetrieverImpl(SmartAuth.instance);
//   }

//   @override
//   void dispose() {
//     if (kIsWeb) {
//       BrowserContextMenu.enableContextMenu();
//     }
//     pinController.dispose();
//     focusNode.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     const focusedBorderColor = Color.fromRGBO(23, 171, 144, 1);
//     const fillColor = Color.fromRGBO(243, 246, 249, 0);
//     const borderColor = Color.fromRGBO(23, 171, 144, 0.4);

//     final defaultPinTheme = SFPinTheme(
//       width: 56,
//       height: 56,
//       textStyle: const TextStyle(
//         fontSize: 22,
//         color: Color.fromRGBO(30, 60, 87, 1),
//       ),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(19),
//         border: Border.all(color: borderColor),
//       ),
//     );

//     /// Optionally you can use form to validate the SFPinCode
//     return Form(
//       key: formKey,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Directionality(
//             // Specify direction if desired
//             textDirection: TextDirection.ltr,
//             child: SFPinCode(
//               // You can pass your own SmsRetriever implementation based on any package
//               // in this example we are using the SmartAuth
//               smsRetriever: smsRetriever,
//               controller: pinController,
//               focusNode: focusNode,
//               defaultSFPinTheme: defaultPinTheme,
//               separatorBuilder: (index) => const SizedBox(width: 8),
//               validator: (value) {
//                 return value == '2222' ? null : 'Pin is incorrect';
//               },
//               hapticFeedbackType: SFHapticFeedbackType.lightImpact,
//               onCompleted: (pin) {
//                 debugPrint('onCompleted: $pin');
//               },
//               onChanged: (value) {
//                 debugPrint('onChanged: $value');
//               },
//               cursor: Column(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Container(
//                     margin: const EdgeInsets.only(bottom: 9),
//                     width: 22,
//                     height: 1,
//                     color: focusedBorderColor,
//                   ),
//                 ],
//               ),
//               focusedSFPinTheme: defaultPinTheme.copyWith(
//                 decoration: defaultPinTheme.decoration!.copyWith(
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: focusedBorderColor),
//                 ),
//               ),
//               submittedSFPinTheme: defaultPinTheme.copyWith(
//                 decoration: defaultPinTheme.decoration!.copyWith(
//                   color: fillColor,
//                   borderRadius: BorderRadius.circular(19),
//                   border: Border.all(color: focusedBorderColor),
//                 ),
//               ),
//               errorSFPinTheme: defaultPinTheme.copyBorderWith(
//                 border: Border.all(color: Colors.redAccent),
//               ),
//             ),
//           ),
//           TextButton(
//             onPressed: () {
//               focusNode.unfocus();
//               formKey.currentState!.validate();
//             },
//             child: const Text('Validate'),
//           ),
//         ],
//       ),
//     );
//   }
// }

// /// You, as a developer should implement this interface.
// /// You can use any package to retrieve the SMS code. in this example we are using SmartAuth
// class SmsRetrieverImpl implements SmsRetriever {
//   const SmsRetrieverImpl(this.smartAuth);

//   final SmartAuth smartAuth;

//   @override
//   Future<void> dispose() {
//     return smartAuth.removeUserConsentApiListener();
//   }

//   @override
//   Future<String?> getSmsCode() async {
//     final signature = await smartAuth.getAppSignature();
//     debugPrint('App Signature: $signature');
//     final res = await smartAuth.getSmsWithUserConsentApi();
//     return res.data?.code;
//   }

//   @override
//   bool get listenForMultipleSms => false;
// }

import 'package:flutter/material.dart';
import 'package:swift_field/swift_field.dart';

void main() {
  SFTheme.primaryColor = const Color(0xFF003249);
  SFTheme.borderRadius = 16.0;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SwiftField Example',
      theme: ThemeData(useMaterial3: true),
      home: const ExampleScreen(),
    );
  }
}

class ExampleScreen extends StatefulWidget {
  const ExampleScreen({super.key});
  @override
  State<ExampleScreen> createState() => _ExampleScreenState();
}

class _ExampleScreenState extends State<ExampleScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _bioController = TextEditingController();
  final _idController = TextEditingController(text: 'USR-20240001');

  String? _selectedRole;
  String? _selectedCountry;
  bool _isLoading = false;
  bool _isLoadingGradient = false;
  bool _isLoadingIcon = false;

  final List<String> _roles = ['Admin', 'Editor', 'Viewer', 'Manager'];
  final List<String> _countries = [
    'United States', 'Canada', 'United Kingdom',
    'Australia', 'Germany', 'France', 'Japan', 'India',
    'Brazil', 'South Africa',
  ];

  void _submit() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 4));
    setState(() => _isLoading = false);
  }

  void _submitGradient() async {
    setState(() => _isLoadingGradient = true);
    await Future.delayed(const Duration(seconds: 4));
    setState(() => _isLoadingGradient = false);
  }

  void _submitIcon() async {
    setState(() => _isLoadingIcon = true);
    await Future.delayed(const Duration(seconds: 3));
    setState(() => _isLoadingIcon = false);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _idController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SwiftField Example')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Text Fields ───────────────────────────────────────────────
              const Text('Text Fields', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),

              SFTextField(
                controller: _nameController,
                labelText: 'Full Name',
                prefixIcon: Icons.person_outline,
                validator: (val) => val!.isEmpty ? 'Name is required' : null,
              ),
              const SizedBox(height: 16),

              SFTextField(
                controller: _emailController,
                labelText: 'Email',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: (val) =>
                val!.contains('@') ? null : 'Enter a valid email',
              ),
              const SizedBox(height: 16),

              SFPasswordField(
                controller: _passwordController,
                labelText: 'Password',
                prefixIcon: Icons.person,
                obscuringCharacter: '*',
                validator: (val) =>
                val!.length < 8 ? 'Min 8 characters' : null,
              ),
              const SizedBox(height: 16),

              SFTextField(
                controller: _bioController,
                labelText: 'Bio',
                prefixIcon: Icons.notes_outlined,
                maxLines: 4,
                minLines: 2,
                keyboardType: TextInputType.multiline,
              ),
              const SizedBox(height: 16),

              SFTextField(
                controller: _idController,
                labelText: 'User ID (read-only)',
                prefixIcon: Icons.badge_outlined,
                readOnly: true,
              ),
              const SizedBox(height: 24),

              // ── Dropdowns ─────────────────────────────────────────────────
              const Text('Dropdowns', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),

              SFDropdown<String>(
                labelText: 'Role',
                prefixIcon: Icons.work_outline,
                value: _selectedRole,
                items: _roles
                    .map((r) => SFDropdownItem(value: r, label: r))
                    .toList(),
                onChanged: (val) => setState(() => _selectedRole = val),
                validator: (val) => val == null ? 'Please select a role' : null,
              ),
              const SizedBox(height: 16),

              SFDropdownSearch<String>(
                labelText: 'Country',
                prefixIcon: Icons.public_outlined,
                value: _selectedCountry,
                items: _countries
                    .map((c) => SFDropdownItem(value: c, label: c))
                    .toList(),
                onChanged: (val) => setState(() => _selectedCountry = val),
                searchHintText: 'Search country...',
                validator: (val) =>
                val == null ? 'Please select a country' : null,
              ),
              const SizedBox(height: 32),

              // ── Buttons ───────────────────────────────────────────────────
              const Text('Buttons', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),

              // Solid color — spinner always visible
              SFButton(
                text: 'Submit Form',
                onPressed: _submit,
                isLoading: _isLoading,
              ),
              const SizedBox(height: 12),

              // Gradient button — left to right
              SFButton(
                text: 'Gradient Button',
                onPressed: _submitGradient,
                isLoading: _isLoadingGradient,
                gradient: const LinearGradient(
                  colors: [Color(0xFF003249), Color(0xFF0077B6)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              const SizedBox(height: 12),

              // Gradient button — diagonal multicolor
              SFButton(
                text: 'Multicolor Gradient',
                onPressed: () {},
                gradient: const LinearGradient(
                  colors: [Colors.purple, Colors.pink, Colors.orange],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              const SizedBox(height: 12),

              // Outline style
              SFButton(
                text: 'Cancel',
                onPressed: () {},
                backgroundColor: Colors.white,
                textColor: const Color(0xFF003249),
                borderColor: const Color(0xFF003249),
              ),
              const SizedBox(height: 12),

              // ── compact mode (default) — wraps content ─────────────────
              const Text('Icon Button — Compact (default)',
                  style: TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 8),
              Row(
                children: [
                  SFIconButton(
                    text: 'Add',
                    icon: Icons.add,
                    onPressed: () {},
                  ),
                  const SizedBox(width: 10),
                  SFIconButton(
                    text: 'Export',
                    icon: Icons.download_outlined,
                    onPressed: () {},
                    backgroundColor: Colors.green,
                  ),
                  const SizedBox(width: 10),
                  // Icon only
                  SFIconButton(
                    icon: Icons.refresh,
                    onPressed: () {},
                    backgroundColor: Colors.orange,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ── expanded mode — full width like SFButton ───────────────
              const Text('Icon Button — Expanded (full width)',
                  style: TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 8),
              SFIconButton(
                text: 'Continue',
                isLoading: _isLoadingGradient,
                icon: Icons.arrow_forward,
                onPressed: _submitGradient,
                spinnerStyle: SFSpinnerStyle.ios,
                mode: SFIconButtonMode.expanded,
              ),
              const SizedBox(height: 10),
              SFIconButton(
                text: 'Gradient Expanded',
                icon: Icons.bolt,
                onPressed: () {},
                mode: SFIconButtonMode.expanded,
                gradient: const LinearGradient(
                  colors: [Colors.purple, Colors.pink],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              const SizedBox(height: 16),

              // ── spinner styles ─────────────────────────────────────────
              const Text('Spinner Styles',
                  style: TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 8),
              Row(
                children: [
                  // Android spinner (default)
                  SFIconButton(
                    text: 'Android',
                    icon: Icons.android,
                    onPressed: _submitIcon,
                    isLoading: _isLoadingIcon,
                    spinnerStyle: SFSpinnerStyle.android,
                  ),
                  const SizedBox(width: 10),
                  // iOS spinner
                  SFIconButton(
                    text: 'iOS',
                    icon: Icons.apple,
                    onPressed: _submitIcon,
                    isLoading: _isLoadingIcon,
                    spinnerStyle: SFSpinnerStyle.ios,
                    backgroundColor: Colors.black87,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SFButton(
                text: 'SFButton — Android Spinner',
                onPressed: _submit,
                isLoading: _isLoading,
                spinnerStyle: SFSpinnerStyle.android,
              ),
              const SizedBox(height: 10),
              // Expanded with iOS spinner
              SFButton(
                text: 'SFButton — iOS Spinner',
                onPressed: _submit,
                isLoading: _isLoading,
                spinnerStyle: SFSpinnerStyle.ios,
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}