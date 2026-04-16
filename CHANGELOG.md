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