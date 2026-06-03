import 'package:flutter_test/flutter_test.dart';
import 'package:permission_plus_linux/permission_plus_linux.dart';
import 'package:permission_plus_linux/src/generated/permission_plus_api.g.dart';
import 'package:permission_plus_platform_interface/permission_plus_platform_interface.dart';

class FakePermissionPlusHostApi implements PermissionPlusHostApi {
  PermissionStatusMessage checkPermissionResult =
      PermissionStatusMessage.granted;
  PermissionStatusMessage requestPermissionResult =
      PermissionStatusMessage.granted;
  List<PermissionStatusMapEntry> requestPermissionsResult = [];
  bool openSettingsResult = true;
  bool shouldShowRationaleResult = false;
  LocationAccuracyMessage getLocationAccuracyResult =
      LocationAccuracyMessage.precise;
  PermissionStatusMessage requestTemporaryPreciseLocationResult =
      PermissionStatusMessage.granted;

  PermissionTypeMessage? lastCheckPermissionArg;
  PermissionTypeMessage? lastRequestPermissionArg;
  List<PermissionTypeMessage>? lastRequestPermissionsArg;
  PermissionTypeMessage? lastShouldShowRationaleArg;
  String? lastRequestTemporaryPreciseLocationArg;

  @override
  Future<PermissionStatusMessage> checkPermission(
    PermissionTypeMessage permission,
  ) async {
    lastCheckPermissionArg = permission;
    return checkPermissionResult;
  }

  @override
  Future<PermissionStatusMessage> requestPermission(
    PermissionTypeMessage permission,
  ) async {
    lastRequestPermissionArg = permission;
    return requestPermissionResult;
  }

  @override
  Future<List<PermissionStatusMapEntry>> requestPermissions(
    List<PermissionTypeMessage> permissions,
  ) async {
    lastRequestPermissionsArg = permissions;
    return requestPermissionsResult;
  }

  @override
  Future<bool> openSettings() async {
    return openSettingsResult;
  }

  @override
  Future<bool> shouldShowRationale(PermissionTypeMessage permission) async {
    lastShouldShowRationaleArg = permission;
    return shouldShowRationaleResult;
  }

  @override
  Future<LocationAccuracyMessage> getLocationAccuracy() async {
    return getLocationAccuracyResult;
  }

  @override
  Future<PermissionStatusMessage> requestTemporaryPreciseLocation(
    String purposeKey,
  ) async {
    lastRequestTemporaryPreciseLocationArg = purposeKey;
    return requestTemporaryPreciseLocationResult;
  }

  @override
  // ignore: non_constant_identifier_names
  get pigeonVar_binaryMessenger => null;

  @override
  // ignore: non_constant_identifier_names
  String get pigeonVar_messageChannelSuffix => '';
}

void main() {
  group('PermissionPlusLinux', () {
    late PermissionPlusLinux plugin;
    late FakePermissionPlusHostApi fakeApi;

    setUp(() {
      fakeApi = FakePermissionPlusHostApi();
      plugin = PermissionPlusLinux(api: fakeApi);
    });

    test('registerWith sets instance', () {
      PermissionPlusLinux.registerWith();
      expect(PermissionPlusPlatform.instance, isA<PermissionPlusLinux>());
    });

    test('default constructor instantiates api', () {
      final defaultPlugin = PermissionPlusLinux();
      expect(defaultPlugin, isNotNull);
    });

    test('checkPermission', () async {
      fakeApi.checkPermissionResult = PermissionStatusMessage.denied;
      final result = await plugin.checkPermission(PermissionType.camera);
      expect(fakeApi.lastCheckPermissionArg, PermissionTypeMessage.camera);
      expect(result, PermissionStatus.denied);
    });

    test('requestPermission', () async {
      fakeApi.requestPermissionResult = PermissionStatusMessage.granted;
      final result = await plugin.requestPermission(PermissionType.microphone);
      expect(
        fakeApi.lastRequestPermissionArg,
        PermissionTypeMessage.microphone,
      );
      expect(result, PermissionStatus.granted);
    });

    test('requestPermissions', () async {
      fakeApi.requestPermissionsResult = [
        PermissionStatusMapEntry(
          permission: PermissionTypeMessage.camera,
          status: PermissionStatusMessage.granted,
        ),
        PermissionStatusMapEntry(
          permission: PermissionTypeMessage.microphone,
          status: PermissionStatusMessage.denied,
        ),
      ];

      final result = await plugin.requestPermissions([
        PermissionType.camera,
        PermissionType.microphone,
      ]);

      expect(fakeApi.lastRequestPermissionsArg, [
        PermissionTypeMessage.camera,
        PermissionTypeMessage.microphone,
      ]);
      expect(result.length, 2);
      expect(result[PermissionType.camera], PermissionStatus.granted);
      expect(result[PermissionType.microphone], PermissionStatus.denied);
    });

    test('openSettings', () async {
      fakeApi.openSettingsResult = true;
      final result = await plugin.openSettings();
      expect(result, true);
    });

    test('shouldShowRationale', () async {
      fakeApi.shouldShowRationaleResult = true;
      final result = await plugin.shouldShowRationale(PermissionType.camera);
      expect(fakeApi.lastShouldShowRationaleArg, PermissionTypeMessage.camera);
      expect(result, true);
    });

    test('getLocationAccuracy precise', () async {
      fakeApi.getLocationAccuracyResult = LocationAccuracyMessage.precise;
      final result = await plugin.getLocationAccuracy();
      expect(result, LocationAccuracy.precise);
    });

    test('getLocationAccuracy reduced', () async {
      fakeApi.getLocationAccuracyResult = LocationAccuracyMessage.reduced;
      final result = await plugin.getLocationAccuracy();
      expect(result, LocationAccuracy.reduced);
    });

    test('requestTemporaryPreciseLocation', () async {
      fakeApi.requestTemporaryPreciseLocationResult =
          PermissionStatusMessage.granted;
      final result = await plugin.requestTemporaryPreciseLocation(
        purposeKey: 'purpose',
      );
      expect(fakeApi.lastRequestTemporaryPreciseLocationArg, 'purpose');
      expect(result, PermissionStatus.granted);
    });

    test('permissionStatusStream throws UnimplementedError', () {
      expect(
        () => plugin.permissionStatusStream(PermissionType.camera),
        throwsUnimplementedError,
      );
    });

    test('extension mappings coverage', () async {
      // Loop through PermissionType to hit all indices for toPigeon mapping
      for (final type in PermissionType.values) {
        fakeApi.checkPermissionResult = PermissionStatusMessage.notDetermined;
        await plugin.checkPermission(type);
      }

      // Loop through PermissionStatusMessage to hit toPlatform mappings
      for (final status in PermissionStatusMessage.values) {
        fakeApi.checkPermissionResult = status;
        final result = await plugin.checkPermission(PermissionType.camera);
        expect(result.index, status.index);
      }
    });
  });
}
