# permission_plus_linux

The Linux implementation of [`permission_plus`](https://github.com/jagadeeshchoudhary/permission_plus).

## Usage

This package is [endorsed](https://dart.dev/tools/pub/dependencies#endorsed-packages) and will be automatically included when you depend on `permission_plus`. There is no need to add this package to your `pubspec.yaml` directly.

**Users should depend on [`permission_plus`](https://pub.dev/packages/permission_plus) instead of this package.**

## Implementation Details

- Non-sandboxed applications will report permissions as granted, since Linux desktop apps typically have full access.

## Issues

Please file any issues or feature requests at the [issue tracker](https://github.com/jagadeeshchoudhary/permission_plus_linux/issues).
