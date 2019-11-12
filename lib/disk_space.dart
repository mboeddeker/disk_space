import 'dart:async';

import 'package:flutter/services.dart';

class DiskSpace {
  static const MethodChannel _channel =
      const MethodChannel('disk_space');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
