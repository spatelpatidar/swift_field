# swift_field

[![pub.dev](https://img.shields.io/pub/v/swift_field.svg)](https://pub.dev/packages/app_snackbar)
[![Flutter](https://img.shields.io/badge/Flutter-3.16+-blue.svg)](https://flutter.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

A highly customizable Flutter UI package for building production-grade forms — includes smart text fields, password fields, dropdowns with search, flexible buttons, and a fully customizable PIN / OTP input field.

---

## Screenshots

<table>
  <tr>
    <td><img src="https://raw.githubusercontent.com/spatelpatidar/swift_field/main/screenshots/dropdown_search.png" width="200" alt="dropdown_search"/></td>
    <td><img src="https://raw.githubusercontent.com/spatelpatidar/swift_field/main/screenshots/dropdown.png" width="200" alt="dropdown"/></td>
    <td><img src="https://raw.githubusercontent.com/spatelpatidar/swift_field/main/screenshots/button_with_icon.png" width="200" alt="button_with_icon"/></td>
    <td><img src="https://raw.githubusercontent.com/spatelpatidar/swift_field/main/screenshots/button_gradiant.png" width="200" alt="button_gradient"/></td>
  </tr>
</table>

---

## ✨ Features

| Widget | Description |
|---|---|
| `SFTextField` | Text field with full config — multiline, read-only, hints, formatters |
| `SFPasswordField` | Password field with built-in show/hide toggle |
| `SFDropdown<T>` | Styled dropdown with responsive width |
| `SFDropdownSearch<T>` | Dropdown with built-in search box |
| `SFButton` | Full-width button with loading state and gradient support |
| `SFIconButton` | Compact or expanded icon + label button |
| `SFPinCode` | Fully customizable PIN / OTP input — per-state themes, animations, SMS autofill |
| `SFTheme` | Global theme config for colors, radius, styles |

---

## 🚀 Installation

```yaml
dependencies:
  swift_field: ^0.2.0
```

Then import:

```dart
import 'package:swift_field/swift_field.dart';
```

---

## 🎨 Global Theme

Customize once, applied everywhere:

```dart
void main() {
  SFTheme.primaryColor = Colors.indigo;
  SFTheme.borderRadius = 12.0;
  SFTheme.buttonHeight = 52.0;
  runApp(const MyApp());
}
```

---

## 🧩 Widgets

### SFTextField

```dart
SFTextField(
  controller: _nameController,
  labelText: 'Full Name',
  prefixIcon: Icons.person,
  validator: (val) => val!.isEmpty ? 'Required' : null,
)

// Multi-line
SFTextField(
  controller: _bioController,
  labelText: 'Bio',
  prefixIcon: Icons.notes,
  maxLines: 5,
  minLines: 3,
  keyboardType: TextInputType.multiline,
)

// Read-only
SFTextField(
  controller: _idController,
  labelText: 'User ID',
  prefixIcon: Icons.badge,
  readOnly: true,
)
```

---

### SFPasswordField

```dart
SFPasswordField(
  controller: _passwordController,
  labelText: 'Password',
  prefixIcon: Icons.lock,
  validator: (val) => val!.length < 8 ? 'Min 8 characters' : null,
)
```

Show/hide is managed internally — no `setState` needed.

---

### SFDropdown

```dart
SFDropdown<String>(
  labelText: 'Country',
  prefixIcon: Icons.flag,
  value: _selectedCountry,
  items: ['USA', 'Canada', 'UK']
      .map((c) => SFDropdownItem(value: c, label: c))
      .toList(),
  onChanged: (val) => setState(() => _selectedCountry = val),
  validator: (val) => val == null ? 'Please select' : null,
)

// With leading icons per item
SFDropdown<String>(
  labelText: 'Status',
  prefixIcon: Icons.circle_outlined,
  value: _status,
  items: [
    SFDropdownItem(
      value: 'active',
      label: 'Active',
      leadingIcon: Icon(Icons.circle, color: Colors.green, size: 12),
    ),
    SFDropdownItem(
      value: 'inactive',
      label: 'Inactive',
      leadingIcon: Icon(Icons.circle, color: Colors.grey, size: 12),
    ),
  ],
  onChanged: (val) => setState(() => _status = val),
)
```

---

### SFDropdownSearch

Built-in search — no external package needed. Uses Flutter's native `DropdownMenu` with `enableFilter: true`.

```dart
SFDropdownSearch<String>(
  labelText: 'City',
  prefixIcon: Icons.location_city,
  value: _selectedCity,
  items: cities
      .map((c) => SFDropdownItem(value: c, label: c))
      .toList(),
  onChanged: (val) => setState(() => _selectedCity = val),
  searchHintText: 'Search city...',
)
```

Custom filter function (e.g. search by code AND name):

```dart
SFDropdownSearch<Country>(
  labelText: 'Country',
  prefixIcon: Icons.public,
  value: _country,
  items: countries
      .map((c) => SFDropdownItem(value: c, label: c.name))
      .toList(),
  onChanged: (val) => setState(() => _country = val),
  filterFn: (item, query) =>
      item.label.toLowerCase().contains(query.toLowerCase()) ||
      item.value.code.toLowerCase().contains(query.toLowerCase()),
)
```

---

### SFButton

```dart
SFButton(
  text: 'Submit',
  onPressed: _submit,
)

// With loading
SFButton(
  text: 'Saving...',
  onPressed: _save,
  isLoading: _isSaving,
)

// Gradient
SFButton(
  text: 'Continue',
  onPressed: _next,
  gradient: LinearGradient(
    colors: [Color(0xFF003249), Color(0xFF0077B6)],
  ),
)

// Custom style
SFButton(
  text: 'Delete',
  onPressed: _delete,
  backgroundColor: Colors.red,
  borderRadius: 8,
  height: 52,
)
```

---

### SFIconButton

```dart
SFIconButton(
  text: 'Add',
  icon: Icons.add,
  onPressed: _add,
)

// Icon only
SFIconButton(
  icon: Icons.refresh,
  onPressed: _refresh,
)

// Expanded (full width)
SFIconButton(
  text: 'Continue',
  icon: Icons.arrow_forward,
  onPressed: _next,
  mode: SFIconButtonMode.expanded,
)
```

---

### SFPinCode

A fully customizable PIN / OTP input field with per-state theming, smooth animations, SMS autofill, and more.

> 📖 **Full documentation:** [SF_PIN_CODE_README.md](SF_PIN_CODE_README.md)

```dart
final defaultTheme = SFPinTheme(
  width: 56,
  height: 56,
  textStyle: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Color(0xFF1E3C57),
  ),
  decoration: BoxDecoration(
    border: Border.all(color: Color(0xFFEAEFF3)),
    borderRadius: BorderRadius.circular(20),
  ),
);

SFPinCode(
  length: 6,
  defaultSFPinTheme: defaultTheme,
  focusedSFPinTheme: defaultTheme.copyDecorationWith(
    border: Border.all(color: Color(0xFF72B2EE), width: 2),
    borderRadius: BorderRadius.circular(8),
  ),
  submittedSFPinTheme: defaultTheme.copyWith(
    decoration: defaultTheme.decoration!.copyWith(
      color: Color(0xFFEAEFF3),
    ),
  ),
  validator: (s) => s == '123456' ? null : 'Incorrect code',
  sfPinAutovalidateMode: SFPinAutovalidateMode.onSubmit,
  showCursor: true,
  onCompleted: (pin) => print(pin),
)
```

**Mixed shapes** — circle focused, square submitted:

```dart
SFPinCode(
  length: 6,
  defaultSFPinTheme: SFPinTheme(
    width: 52, height: 52,
    decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
  ),
  focusedSFPinTheme: SFPinTheme(
    width: 54, height: 54,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(color: Colors.blue, width: 2.5),
    ),
  ),
  submittedSFPinTheme: SFPinTheme(
    width: 52, height: 52,
    textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(10)),
  ),
  onCompleted: print,
)
```

---

## 📦 Dependencies

**Zero external dependencies.** SwiftField uses only Flutter's built-in Material 3 widgets:
- `DropdownMenu` (Flutter 3.7+) for dropdowns and search
- `TextFormField`, `FormField`, `ElevatedButton` for everything else
- `SFPinCode` is self-contained — no additional packages required for basic usage

---

## 📄 License

MIT
