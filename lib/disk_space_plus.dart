import 'disk_space_plus_platform_interface.dart';

class DiskSpacePlus {
  Future<String?> getPlatformVersion() {
    return DiskSpacePlusPlatform.instance.getPlatformVersion();
  }

  Future<double?> get getFreeDiskSpace async {
    return DiskSpacePlusPlatform.instance.getFreeDiskSpace;
  }

  Future<double?> get getTotalDiskSpace async {
    return DiskSpacePlusPlatform.instance.getTotalDiskSpace;
  }

  Future<double?> getFreeDiskSpaceForPath(String path) async {
    return DiskSpacePlusPlatform.instance.getFreeDiskSpaceForPath(path);
  }
}
