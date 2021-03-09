package de.appgewaltig.dsik_space

import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

/** DiskSpacePlugin */
class DiskSpacePlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "disk_space")
    channel.setMethodCallHandler(this)
  }

    private fun getFreeDiskSpace(): Double {
    val stat = StatFs(Environment.getExternalStorageDirectory().path)

    var bytesAvailable: Long

    if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.JELLY_BEAN_MR2)
      bytesAvailable = stat.blockSizeLong * stat.availableBlocksLong
    else
      bytesAvailable = stat.blockSize.toLong() * stat.availableBlocks.toLong()
    return (bytesAvailable / (1024f * 1024f)).toDouble()
  }

  private fun getTotalDiskSpace(): Double {
    val stat = StatFs(Environment.getExternalStorageDirectory().path)

    var bytesAvailable: Long

    if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.JELLY_BEAN_MR2)
      bytesAvailable = stat.blockSizeLong * stat.blockCountLong
    else
      bytesAvailable = stat.blockSize.toLong() * stat.blockCount.toLong()
    return (bytesAvailable / (1024f * 1024f)).toDouble()
  }


  override fun onMethodCall(call: MethodCall, result: Result) {
    when(call.method) {
      "getFreeDiskSpace" -> result.success(getFreeDiskSpace())
      "getTotalDiskSpace" -> result.success(getTotalDiskSpace())
      else -> result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
