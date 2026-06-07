# permission_plus_linux

The Linux implementation of [`permission_plus`](https://github.com/jagadeeshchoudhary/permission_plus).

## Usage

This package is [endorsed](https://dart.dev/tools/pub/dependencies#endorsed-packages) and will be automatically included when you depend on `permission_plus`. There is no need to add this package to your `pubspec.yaml` directly.

**Users should depend on [`permission_plus`](https://pub.dev/packages/permission_plus) instead of this package.**

## Platform Behavior

On standard (non-sandboxed) Linux desktop applications, there is no system-level permission model like Android or iOS. Apps run as the current user and have full access to resources like the camera, microphone, file system, etc.

Because of this, **all permissions are reported as `granted`** by default.

> **Note:** Sandboxed environments (Flatpak, Snap) do enforce permissions via [xdg-desktop-portal](https://github.com/flatpak/xdg-desktop-portal). Support for xdg-desktop-portal is planned for a future release.

## Supported Permission Types

| Permission Type | Status |
|---|---|
| Camera | ✅ Granted |
| Microphone | ✅ Granted |
| Location | ✅ Granted |
| Location Always | ✅ Granted |
| Location When In Use | ✅ Granted |
| Notifications | ✅ Granted |
| Contacts | ✅ Granted |
| Calendar | ✅ Granted |
| Storage | ✅ Granted |
| Photos | ✅ Granted |
| Bluetooth | ✅ Granted |
| Sensors | ✅ Granted |
| All others | ✅ Granted |

## API Reference

```dart
import 'package:permission_plus/permission_plus.dart';

// Check a permission
final status = await PermissionPlus.checkPermission(PermissionType.camera);

// Request a permission
final result = await PermissionPlus.requestPermission(PermissionType.camera);

// Request multiple permissions
final results = await PermissionPlus.requestPermissions([
  PermissionType.camera,
  PermissionType.microphone,
]);

// Check location accuracy
final accuracy = await PermissionPlus.getLocationAccuracy();
```

## Limitations

- **`openSettings()`** — Returns `false` on Linux. There is no standardized "App Settings" page across Linux desktop environments.
- **`shouldShowRationale()`** — Always returns `false`. This concept does not exist on Linux.
- **`permissionStatusStream()`** — Not implemented. Throws `UnimplementedError`.
- **Sandboxed apps** — Flatpak/Snap portal integration is not yet supported. All permissions return `granted` regardless of sandbox state.

## Building the Example App

The example app can be built inside Docker for cross-compilation:

```bash
# From the project root (permission_plus_linux/)
docker build -f example/Dockerfile -t flutter-linux-builder .

# Build the app
docker run --name flutter-build flutter-linux-builder flutter build linux

# Extract the binary
docker cp flutter-build:/app/example/build/linux/arm64/release/bundle ./linux-build
docker rm flutter-build
```

> Replace `arm64` with `x64` if building on an x86_64 host, or use `--platform linux/amd64` with Docker on Apple Silicon.

## Running Tests

### Dart Unit Tests

```bash
flutter test
```

### C++ Unit Tests

After building the example app, run the native test binary:

```bash
build/linux/arm64/release/plugins/permission_plus_linux/permission_plus_linux_test
```

## Issues

Please file any issues or feature requests at the [issue tracker](https://github.com/jagadeeshchoudhary/permission_plus_linux/issues).
