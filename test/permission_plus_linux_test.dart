import 'package:flutter_test/flutter_test.dart';
import 'package:permission_plus_linux/permission_plus_linux.dart';
import 'package:permission_plus_linux/permission_plus_linux_platform_interface.dart';
import 'package:permission_plus_linux/permission_plus_linux_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockPermissionPlusLinuxPlatform
    with MockPlatformInterfaceMixin
    implements PermissionPlusLinuxPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final PermissionPlusLinuxPlatform initialPlatform = PermissionPlusLinuxPlatform.instance;

  test('$MethodChannelPermissionPlusLinux is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelPermissionPlusLinux>());
  });

  test('getPlatformVersion', () async {
    PermissionPlusLinux permissionPlusLinuxPlugin = PermissionPlusLinux();
    MockPermissionPlusLinuxPlatform fakePlatform = MockPermissionPlusLinuxPlatform();
    PermissionPlusLinuxPlatform.instance = fakePlatform;

    expect(await permissionPlusLinuxPlugin.getPlatformVersion(), '42');
  });
}
