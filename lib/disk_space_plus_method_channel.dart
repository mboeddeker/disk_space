import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'disk_space_plus_platform_interface.dart';

/// An implementation of [DiskSpacePlusPlatform] that uses method channels.
class MethodChannelDiskSpacePlus extends DiskSpacePlusPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('disk_space_plus');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }

  @override
  Future<double?> get getFreeDiskSpace async {
    final double? freeDiskSpace = await methodChannel.invokeMethod(
      'getFreeDiskSpace',
    );
    return freeDiskSpace;
  }

  @override
  Future<double?> get getTotalDiskSpace async {
    final double? totalDiskSpace = await methodChannel.invokeMethod(
      'getTotalDiskSpace',
    );
    return totalDiskSpace;
  }

  @override
  Future<double?> getFreeDiskSpaceForPath(String path) async {
    if (!Directory(path).existsSync()) {
      throw Exception("Specified path does not exist");
    }
    final double? freeDiskSpace = await methodChannel.invokeMethod(
      'getFreeDiskSpaceForPath',
      {"path": path},
    );
    return freeDiskSpace;
  }
}
