import 'package:flutter_test/flutter_test.dart';
import 'package:disk_space_plus/disk_space_plus.dart';
import 'package:disk_space_plus/disk_space_plus_platform_interface.dart';
import 'package:disk_space_plus/disk_space_plus_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockDiskSpacePlusPlatform
    with MockPlatformInterfaceMixin
    implements DiskSpacePlusPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final DiskSpacePlusPlatform initialPlatform = DiskSpacePlusPlatform.instance;

  test('$MethodChannelDiskSpacePlus is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelDiskSpacePlus>());
  });

  test('getPlatformVersion', () async {
    DiskSpacePlus diskSpacePlusPlugin = DiskSpacePlus();
    MockDiskSpacePlusPlatform fakePlatform = MockDiskSpacePlusPlatform();
    DiskSpacePlusPlatform.instance = fakePlatform;

    expect(await diskSpacePlusPlugin.getPlatformVersion(), '42');
  });
}
