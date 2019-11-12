package de.appgewaltig.disk_space

import android.os.Environment
import android.os.StatFs
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

class DiskSpacePlugin: MethodCallHandler {
  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val channel = MethodChannel(registrar.messenger(), "disk_space")
      channel.setMethodCallHandler(DiskSpacePlugin())
    }
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
}
