package de.appgewaltig.disk_space

import android.os.Environment
import android.os.StatFs
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class DiskSpacePlugin: FlutterPlugin, MethodCallHandler {

  private var channel : MethodChannel? = null

  override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(binding.binaryMessenger, "disk_space")
    channel!!.setMethodCallHandler(this)
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel = null
  }

  private fun getFreeDiskSpace(): Double {
    val stat = StatFs(Environment.getExternalStorageDirectory().path)

    val bytesAvailable: Long
    bytesAvailable = if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.JELLY_BEAN_MR2)
      stat.blockSizeLong * stat.availableBlocksLong
    else
      stat.blockSize.toLong() * stat.availableBlocks.toLong()
    return (bytesAvailable / (1024f * 1024f)).toDouble()
  }

  private fun getTotalDiskSpace(): Double {
    val stat = StatFs(Environment.getExternalStorageDirectory().path)

    val bytesAvailable: Long
    bytesAvailable = if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.JELLY_BEAN_MR2)
      stat.blockSizeLong * stat.blockCountLong
    else
      stat.blockSize.toLong() * stat.blockCount.toLong()
    return (bytesAvailable / (1024f * 1024f)).toDouble()
  }


  override fun onMethodCall(call: MethodCall, result: Result) {
    when(call.method) {
      "getFreeDiskSpace" -> result.success(getFreeDiskSpace())
      "getTotalDiskSpace" -> result.success(getTotalDiskSpace())
      else -> result.notImplemented()
    }
  }
}