import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'permission_plus_linux_method_channel.dart';

abstract class PermissionPlusLinuxPlatform extends PlatformInterface {
  /// Constructs a PermissionPlusLinuxPlatform.
  PermissionPlusLinuxPlatform() : super(token: _token);

  static final Object _token = Object();

  static PermissionPlusLinuxPlatform _instance = MethodChannelPermissionPlusLinux();

  /// The default instance of [PermissionPlusLinuxPlatform] to use.
  ///
  /// Defaults to [MethodChannelPermissionPlusLinux].
  static PermissionPlusLinuxPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [PermissionPlusLinuxPlatform] when
  /// they register themselves.
  static set instance(PermissionPlusLinuxPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
