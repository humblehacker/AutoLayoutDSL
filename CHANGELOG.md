# AutoLayoutDSL CHANGELOG

## 1.0.0 2014.05.13

- Make relating size and location constraints a compile-time error
- Eliminate need to specify `()` on constraint attributes (e.g. `View(_someView).left` instead
  of `View(_someView).left()`.
- Eliminate need to wrap `UIView`s in `View()` (e.g. `_someView.left` instead of `View(_someView).left`.

## 0.2.1 2014.05.01

- Moved HHMainView into Classes for pod distribution

## 0.2.0 2014.04.29

- Compile-time check for accidental use of `operator=` when defining constraints
- Added convenience methods to print constraints in nearly the format the were defined
- Fix `-[NSLayout remove]` category method
- Update pods to latest versions
- Fix compile warnings, especially on 64-bit builds
- Add examples to project (now `pod try AutoLayoutDSL` does something)
- Add `HHKeyboardProxyView` - use to layout views around keyboard show/hide

## 0.1.1 2014.03.14

- Update to BlocksKit 2.0
- Require iOS 6.0+

## 0.1.0 2013.07.23

Initial release.

