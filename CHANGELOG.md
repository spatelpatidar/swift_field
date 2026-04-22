## 0.3.0

### Architecture
* All widgets refactored into a clean modular folder structure mirroring the `sf_pin` design pattern
* Each widget family now has independent `models/`, `utils/`, and `widgets/` sub-folders
* All part files use `part of` directives — zero cross-widget coupling

### New Features — `SFButton`
* `SFButtonTheme` — per-state decoration model with `copyWith`, `copyColorWith`, `apply`
  * States: `defaultTheme`, `pressedTheme`, `hoveredTheme`, `loadingTheme`, `disabledTheme`
  * Every state can have a completely different `backgroundColor`, `gradient`, `borderColor`, `borderRadius`, `height`, `textStyle`, `boxShadow`
* **Smooth `AnimatedContainer`** — all decoration properties tween automatically between state changes
* **Press-scale animation** — button scales down on tap for tactile feel (`pressScale`, default `0.97`)
* **`AnimatedSwitcher`** — smooth fade between label and spinner on loading state change
* **Haptic feedback** — `SFButtonHaptic`: `none`, `light`, `medium`, `heavy`, `selection`
* **Hover state** — `hoveredTheme` for desktop/web (`MouseRegion` driven)
* **`prefixIcon` / `suffixIcon`** — optional icons flanking the label text
* **`child` override** — pass any widget as button content
* **`loadingChild` override** — pass any widget shown during loading
* **`onLongPress`** — long press callback
* **`enabled`** flag with automatic `0.5` opacity on disabled state
* Full backward compatibility — all existing `SFButton` params unchanged

### New Features — `SFIconButton`
* `SFIconButtonTheme` — per-state decoration model with `copyWith`, `copyColorWith`, `apply`
  * States: `defaultTheme`, `pressedTheme`, `hoveredTheme`, `loadingTheme`, `disabledTheme`
* **`SFIconPosition`** — `start`, `end`, `top`, `bottom` (column layout for top/bottom)
* **Smooth `AnimatedContainer`** and press-scale animation (same as `SFButton`)
* **`AnimatedSwitcher`** fade between content and spinner
* **Haptic feedback** — same `SFButtonHaptic` enum shared with `SFButton`
* **`child` / `loadingChild`** override widgets
* **`onLongPress`** callback
* **`enabled`** flag with opacity
* Full backward compatibility — all existing `SFIconButton` params unchanged

### New Features — `SFTextField`
* `SFFieldTheme` — per-state decoration model with `copyWith`, `copyBorderWith`, `apply`
  * States: `defaultTheme`, `focusedTheme`, `filledTheme`, `errorTheme`, `disabledTheme`
  * Each state controls: `borderColor`, `borderWidth`, `borderRadius`, `fillColor`, `labelStyle`, `hintStyle`, `textStyle`, `prefixIconColor`, `suffixIconColor`, `errorStyle`, `contentPadding`, `boxShadow`
* **Smooth `AnimatedContainer`** — border color, fill color, shadow tween on state change
* **`errorText`** — static error text shown below field without running validator
* **`forceErrorState`** — force error theme regardless of validator result
* **`errorBuilder`** — fully custom error widget
* **Haptic feedback** — `SFFieldHaptic`: `none`, `light`, `medium`, `heavy`, `selection` (fires on focus)
* **`SFTextField.builder`** constructor — pass a fully custom `InputDecoration` builder receiving `(context, isFocused, hasError, isFilled)`
* `animationDuration` + `animationCurve` — control state transition speed
* Full backward compatibility — all existing `SFTextField` params unchanged

### New Features — `SFPasswordField`
* Same `SFFieldTheme` per-state system as `SFTextField`
* States: `defaultTheme`, `focusedTheme`, `filledTheme`, `errorTheme`, `disabledTheme`
* **Smooth `AnimatedContainer`** decoration transitions
* **`errorText`**, **`forceErrorState`**, **`errorBuilder`**
* **Haptic feedback** on focus
* **`SFPasswordField.builder`** constructor — builder receives `(context, isFocused, hasError, isFilled, isObscured, toggleObscure)` giving full control including the visibility toggle
* Full backward compatibility — all existing `SFPasswordField` params unchanged

---

## 0.2.0

### New Widgets
* `SFPinCode` — fully customizable Pin / OTP input field powered by [Pinput](https://github.com/Tkko/Flutter_Pinput)
  * **Per-state themes** — independent `SFPinTheme` for default, focused, submitted, following, disabled, and error states
  * **Mixed shapes** — each state can use a completely different `BoxDecoration` shape (circle, rounded, square, underline, gradient, or any custom decoration)
  * **Smooth animation** — decoration properties (color, border, border-radius, size) tween automatically between state changes
  * **Entry animations** — `SFPinAnimationType`: `none`, `scale`, `fade`, `slide`, `rotation`
  * **Validation** — `validator`, `errorText`, `forceErrorState`, `errorBuilder`, `sfPinAutovalidateMode`
  * **Haptic feedback** — `SFHapticFeedbackType`: `lightImpact`, `mediumImpact`, `heavyImpact`, `selectionClick`, `vibrate`
  * **Obscure text** — custom `obscuringCharacter` or any `obscuringWidget`
  * **Custom cursor** — standard blinking cursor or pass any `Widget` as `cursor`
  * **SMS Autofill** — iOS OneTimeCode out of the box; Android via `smsRetriever`
  * **Custom separator** — insert any widget between boxes via `separatorBuilder`
  * **Builder constructor** — `SFPinCode.builder` for 100% custom box widget per state
  * **Controller helpers** — `setText`, `append`, `delete`, `clear`
* `SFPinTheme` — per-state decoration model with `copyWith`, `copyDecorationWith`, `copyBorderWith`

---

## 0.1.1

### Enhancements
* `SFSpinnerStyle.ios` — increased `CupertinoActivityIndicator` radius from `spinnerSize / 2` to `spinnerSize / 1.5` for better visibility

---

## 0.1.0

### Breaking Changes
* `SFDropdown` and `SFDropdownSearch` now use `SFDropdownItem` instead of
  Flutter's `DropdownMenuItem` — no external packages required.

### New Features
* `SFButton` — gradient background support via `gradient` parameter
* `SFButton` — spinner style chooser via `SFSpinnerStyle` (`android` / `ios`)
* `SFIconButton` — gradient background support
* `SFIconButton` — layout mode via `SFIconButtonMode` (`compact` / `expanded`)
* `SFIconButton` — loading state with `isLoading` + `SFSpinnerStyle`
* `SFTheme.gradient` — global gradient applied to all buttons
* Removed `dropdown_button2` dependency — zero external dependencies

### Bug Fixes
* Fixed loading spinner invisible on dark buttons (replaced `ElevatedButton`
  with `Material` + `Ink` + `InkWell`)
* Fixed button background going grey during loading state
* Fixed `SFDropdownSearch` `FilterCallback` return type (`List` not `Iterable`)
* Fixed `SFDropdownSearch` search text appearing in main field instead of
  inside the dropdown panel

---

## 0.0.1

* Initial release
* `SFTextField` — configurable text form field
* `SFPasswordField` — password field with built-in show/hide toggle
* `SFDropdown` — styled dropdown
* `SFDropdownSearch` — dropdown with built-in search panel
* `SFButton` — full-width button with loading state
* `SFIconButton` — compact icon + label button
* `SFTheme` — global theme configuration