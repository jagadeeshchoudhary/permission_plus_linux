
import 'permission_plus_linux_platform_interface.dart';

class PermissionPlusLinux {
  Future<String?> getPlatformVersion() {
    return PermissionPlusLinuxPlatform.instance.getPlatformVersion();
  }
}
