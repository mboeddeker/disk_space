import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'disk_space_plus_method_channel.dart';

abstract class DiskSpacePlusPlatform extends PlatformInterface {
  /// Constructs a DiskSpacePlusPlatform.
  DiskSpacePlusPlatform() : super(token: _token);

  static final Object _token = Object();

  static DiskSpacePlusPlatform _instance = MethodChannelDiskSpacePlus();

  /// The default instance of [DiskSpacePlusPlatform] to use.
  ///
  /// Defaults to [MethodChannelDiskSpacePlus].
  static DiskSpacePlusPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [DiskSpacePlusPlatform] when
  /// they register themselves.
  static set instance(DiskSpacePlusPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<double?> get getFreeDiskSpace async {
    return null;
  }

  Future<double?> get getTotalDiskSpace async {
    return null;
  }

  Future<double?> getFreeDiskSpaceForPath(String path) async {
    return null;
  }
}
