# SFPinCode

A fully customizable Pin / OTP input field for Flutter — built into the `swift_field` package.

Powered by [Pinput](https://github.com/Tkko/Flutter_Pinput) under the hood, renamed and extended for use within `swift_field`.

[![pub.dev](https://img.shields.io/pub/v/swift_field.svg)](https://pub.dev/packages/swift_field)
[![Flutter](https://img.shields.io/badge/Flutter-3.16+-blue.svg)](https://flutter.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

---

## ✨ Features

- **Per-state themes** — default, focused, submitted, following, disabled, error
- **Smooth animated decoration switching** — color, border, shape, size all tween automatically
- **Mixed shapes per state** — circle focused + square submitted, any combination
- **Entry animations** — scale, fade, slide, rotation
- **SMS Autofill** — iOS (OneTimeCode) out of the box, Android via `smsRetriever`
- **Form validation** — `validator`, `errorText`, `forceErrorState`, `errorBuilder`
- **Haptic feedback** — light, medium, heavy, selection click, vibrate
- **Obscure text** — custom `obscuringCharacter` or any `obscuringWidget`
- **Custom cursor** — standard blinking cursor or pass any `Widget`
- **Copy from clipboard** — built-in paste support
- **Custom separator** — any widget between pin boxes via `separatorBuilder`
- **Builder constructor** — `SFPinCode.builder` for 100% custom box widget

---

## 🚀 Installation

SFPinCode is part of `swift_field`. No extra dependency needed.

```yaml
dependencies:
  swift_field: ^0.2.0
```

```dart
import 'package:swift_field/swift_field.dart';
```

---

## 🎨 SFPinTheme

Each state is styled using `SFPinTheme`. Every property is independent per state.

```dart
const SFPinTheme({
  double? width,
  double? height,
  BoxDecoration? decoration,   // full control — color, border, radius, shape, gradient
  TextStyle? textStyle,
  EdgeInsetsGeometry? margin,
  EdgeInsetsGeometry? padding,
  BoxConstraints? constraints,
})
```

### Helper methods

```dart
// Change only decoration properties, keep everything else
theme.copyDecorationWith(
  border: Border.all(color: Colors.blue, width: 2),
  borderRadius: BorderRadius.circular(8),
)

// Change any property including size
theme.copyWith(
  width: 58,
  height: 58,
  decoration: theme.decoration!.copyWith(color: Colors.blue.shade50),
)

// Change only the border
theme.copyBorderWith(border: Border.all(color: Colors.red, width: 2))
```

---

## 🧩 Basic Usage

```dart
SFPinCode(
  length: 6,
  onCompleted: (pin) => print(pin),
)
```

---

## 🖌️ Pinput-style theming

The recommended pattern — create a base theme once, derive all other states from it:

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

final focusedTheme = defaultTheme.copyDecorationWith(
  border: Border.all(color: Color(0xFF72B2EE), width: 2),
  borderRadius: BorderRadius.circular(8),
);

final submittedTheme = defaultTheme.copyWith(
  decoration: defaultTheme.decoration!.copyWith(
    color: Color(0xFFEAEFF3),
  ),
);

SFPinCode(
  length: 6,
  defaultSFPinTheme: defaultTheme,
  focusedSFPinTheme: focusedTheme,
  submittedSFPinTheme: submittedTheme,
  validator: (s) => s == '123456' ? null : 'Incorrect code',
  sfPinAutovalidateMode: SFPinAutovalidateMode.onSubmit,
  showCursor: true,
  onCompleted: (pin) => print(pin),
)
```

---

## 🔵🟥 Mixed shapes per state

Each state can use a completely different `BoxShape` — circle, square, rounded, underline:

```dart
SFPinCode(
  length: 6,

  // Default: plain square
  defaultSFPinTheme: SFPinTheme(
    width: 52, height: 52,
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey.shade300),
    ),
  ),

  // Focused: CIRCLE
  focusedSFPinTheme: SFPinTheme(
    width: 54, height: 54,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(color: Color(0xFF003249), width: 2.5),
    ),
  ),

  // Submitted: filled rounded square
  submittedSFPinTheme: SFPinTheme(
    width: 52, height: 52,
    textStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    decoration: BoxDecoration(
      color: Color(0xFF003249),
      borderRadius: BorderRadius.circular(10),
    ),
  ),

  // Following: dimmed square
  followingSFPinTheme: SFPinTheme(
    width: 52, height: 52,
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey.shade200),
      color: Colors.grey.shade50,
    ),
  ),

  onCompleted: print,
)
```

---

## 📐 All Parameters

### Theme parameters

| Parameter | Type | Description |
|---|---|---|
| `defaultSFPinTheme` | `SFPinTheme?` | Base theme — used for any state not explicitly overridden |
| `focusedSFPinTheme` | `SFPinTheme?` | Box currently receiving input (cursor position) |
| `submittedSFPinTheme` | `SFPinTheme?` | Boxes that already have a digit typed |
| `followingSFPinTheme` | `SFPinTheme?` | Boxes after the cursor (not yet filled) |
| `disabledSFPinTheme` | `SFPinTheme?` | All boxes when `enabled = false` |
| `errorSFPinTheme` | `SFPinTheme?` | All boxes when error state is active |

### Core

| Parameter | Type | Default | Description |
|---|---|---|---|
| `length` | `int` | `4` | Number of pin boxes |
| `onChanged` | `ValueChanged<String>?` | — | Called on every keystroke |
| `onCompleted` | `ValueChanged<String>?` | — | Called when all digits are filled |
| `onSubmitted` | `ValueChanged<String>?` | — | Called on keyboard submit action |
| `onTap` | `VoidCallback?` | — | Called when field is tapped |
| `onLongPress` | `VoidCallback?` | — | Called on long press |
| `controller` | `TextEditingController?` | — | Control value programmatically |
| `focusNode` | `FocusNode?` | — | Control focus programmatically |

### Animation

| Parameter | Type | Default | Description |
|---|---|---|---|
| `pinAnimationType` | `SFPinAnimationType` | `scale` | Entry animation when a digit is typed |
| `animationDuration` | `Duration` | `150ms` | Duration of entry animation |
| `animationCurve` | `Curve` | `Curves.easeIn` | Curve of entry animation |

`SFPinAnimationType` values: `none`, `scale`, `fade`, `slide`, `rotation`

### Behaviour

| Parameter | Type | Default | Description |
|---|---|---|---|
| `enabled` | `bool` | `true` | Enable/disable the field |
| `readOnly` | `bool` | `false` | Read-only mode |
| `autofocus` | `bool` | `false` | Auto-focus on build |
| `closeKeyboardWhenCompleted` | `bool` | `true` | Dismiss keyboard on completion |
| `keyboardType` | `TextInputType` | `number` | Keyboard type |
| `inputFormatters` | `List<TextInputFormatter>` | `[]` | Custom input formatters |
| `autofillHints` | `List<String>?` | `[oneTimeCode]` | Autofill hints (iOS SMS autofill) |
| `toolbarEnabled` | `bool` | `true` | Show paste toolbar |

### Cursor

| Parameter | Type | Default | Description |
|---|---|---|---|
| `showCursor` | `bool` | `true` | Show cursor on focused box |
| `isCursorAnimationEnabled` | `bool` | `true` | Animate cursor blink |
| `cursor` | `Widget?` | — | Custom cursor widget. If null, uses default blinking line |

### Obscure

| Parameter | Type | Default | Description |
|---|---|---|---|
| `obscureText` | `bool` | `false` | Hide typed digits |
| `obscuringCharacter` | `String` | `'•'` | Character shown when `obscureText = true` |
| `obscuringWidget` | `Widget?` | — | Widget shown instead of `obscuringCharacter` |

### Haptics

| Parameter | Type | Default | Description |
|---|---|---|---|
| `hapticFeedbackType` | `SFHapticFeedbackType` | `disabled` | Vibration on each keystroke |

`SFHapticFeedbackType` values: `disabled`, `lightImpact`, `mediumImpact`, `heavyImpact`, `selectionClick`, `vibrate`

### Validation & Error

| Parameter | Type | Default | Description |
|---|---|---|---|
| `validator` | `FormFieldValidator<String>?` | — | Return null for valid, String for error |
| `sfPinAutovalidateMode` | `SFPinAutovalidateMode` | `onSubmit` | When to run validator |
| `errorText` | `String?` | — | Static error text shown below field |
| `errorTextStyle` | `TextStyle?` | — | Style of the error text |
| `errorBuilder` | `SFPinErrorBuilder?` | — | Custom error widget builder |
| `forceErrorState` | `bool` | `false` | Force error theme regardless of validator |
| `showErrorWhenFocused` | `bool` | `false` | Show error even while focused |

`SFPinAutovalidateMode` values: `disabled`, `onSubmit`

### Layout

| Parameter | Type | Default | Description |
|---|---|---|---|
| `mainAxisAlignment` | `MainAxisAlignment` | `center` | Alignment of pin boxes row |
| `crossAxisAlignment` | `CrossAxisAlignment` | `start` | Cross alignment of error widget |
| `pinContentAlignment` | `AlignmentGeometry` | `center` | Alignment of digit inside box |
| `separatorBuilder` | `IndexedWidgetBuilder?` | — | Widget inserted between each pair of boxes |
| `preFilledWidget` | `Widget?` | — | Widget shown in empty boxes |

### SMS Autofill (Android)

| Parameter | Type | Description |
|---|---|---|
| `smsRetriever` | `SmsRetriever?` | Android SMS autofill. Use `smart_auth` package |

---

## 💡 Usage Examples

### Validation with error theme

```dart
SFPinCode(
  length: 4,
  validator: (pin) => pin == '1234' ? null : 'Wrong PIN',
  sfPinAutovalidateMode: SFPinAutovalidateMode.onSubmit,
  errorSFPinTheme: SFPinTheme(
    width: 56, height: 56,
    decoration: BoxDecoration(
      color: Colors.red.shade50,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.red, width: 2),
    ),
  ),
  onCompleted: (pin) => print(pin),
)
```

### Underline style

```dart
final underlineBase = SFPinTheme(
  width: 44, height: 52,
  decoration: BoxDecoration(
    border: Border(bottom: BorderSide(color: Colors.grey.shade300, width: 2)),
  ),
);

SFPinCode(
  length: 6,
  defaultSFPinTheme: underlineBase,
  focusedSFPinTheme: underlineBase.copyBorderWith(
    border: Border(bottom: BorderSide(color: Colors.blue, width: 2.5)),
  ),
  submittedSFPinTheme: underlineBase.copyBorderWith(
    border: Border(bottom: BorderSide(color: Colors.blue, width: 2)),
  ),
  onCompleted: print,
)
```

### Gradient decoration

```dart
SFPinCode(
  length: 6,
  defaultSFPinTheme: SFPinTheme(
    width: 48, height: 48,
    textStyle: TextStyle(
      fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white,
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      gradient: LinearGradient(
        colors: [Color(0xFF003249), Color(0xFF0077B6)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
  ),
  onCompleted: print,
)
```

### Obscured PIN with custom widget

```dart
SFPinCode(
  length: 4,
  obscureText: true,
  obscuringWidget: Icon(Icons.circle, size: 12, color: Color(0xFF003249)),
  onCompleted: print,
)
```

### Custom separator

```dart
SFPinCode(
  length: 6,
  separatorBuilder: (index) => index == 2
      ? Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Text('—', style: TextStyle(fontSize: 20, color: Colors.grey)),
        )
      : SizedBox(width: 6),
  onCompleted: print,
)
```

### Custom cursor widget

```dart
SFPinCode(
  length: 6,
  showCursor: true,
  cursor: Container(
    width: 2,
    height: 24,
    color: Colors.blue,
  ),
  onCompleted: print,
)
```

### Controller

```dart
final controller = TextEditingController();

// Set value programmatically
controller.setText('1234');

// Append a digit (custom keyboard)
controller.append('5', 6);

// Delete last digit
controller.delete();

// Clear all
controller.clear();

SFPinCode(
  length: 6,
  controller: controller,
  onCompleted: print,
)
```

### Focus

```dart
final focusNode = FocusNode();

// Focus the field
focusNode.requestFocus();

// Unfocus
focusNode.unfocus();

SFPinCode(
  length: 6,
  focusNode: focusNode,
  onCompleted: print,
)
```

### Android SMS Autofill (via smart_auth)

```dart
// pubspec.yaml
// dependencies:
//   smart_auth: ^2.0.0

final smsRetriever = SmsRetrieverImpl(SmartAuth());

SFPinCode(
  length: 6,
  smsRetriever: smsRetriever,
  onCompleted: print,
)
```

### Form integration

```dart
final formKey = GlobalKey<FormState>();

Form(
  key: formKey,
  child: SFPinCode(
    length: 6,
    validator: (pin) => pin!.length == 6 ? null : 'Enter all 6 digits',
    sfPinAutovalidateMode: SFPinAutovalidateMode.onSubmit,
    onCompleted: (pin) {
      if (formKey.currentState!.validate()) {
        // proceed
      }
    },
  ),
)
```

### Builder — 100% custom box

```dart
SFPinCode.builder(
  length: 4,
  builder: (context, states) {
    final isFocused = states.contains(WidgetState.focused);
    final isSubmitted = states.contains(WidgetState.selected);
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      width: isFocused ? 64 : 56,
      height: isFocused ? 64 : 56,
      decoration: BoxDecoration(
        color: isSubmitted ? Colors.blue : Colors.white,
        borderRadius: BorderRadius.circular(isFocused ? 20 : 12),
        border: Border.all(
          color: isFocused ? Colors.blue : Colors.grey.shade300,
          width: isFocused ? 2.5 : 1.5,
        ),
        boxShadow: isFocused
            ? [BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 8)]
            : null,
      ),
    );
  },
  onCompleted: print,
)
```

---

## 📦 Credits

SFPinCode is based on [Pinput](https://github.com/Tkko/Flutter_Pinput) by [Tornike Gogberashvili](https://github.com/Tkko), licensed under MIT.