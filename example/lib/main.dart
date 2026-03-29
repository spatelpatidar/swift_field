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
                    icon: Icons.save_outlined,
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