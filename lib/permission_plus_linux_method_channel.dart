import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'permission_plus_linux_platform_interface.dart';

/// An implementation of [PermissionPlusLinuxPlatform] that uses method channels.
class MethodChannelPermissionPlusLinux extends PermissionPlusLinuxPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('permission_plus_linux');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }
}
