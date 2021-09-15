package de.appgewaltig.disk_space

import android.os.Environment
import android.os.StatFs
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MethodHandlerImpl : MethodChannel.MethodCallHandler {
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when(call.method) {
            "getFreeDiskSpace" -> result.success(getFreeDiskSpace())
            "getTotalDiskSpace" -> result.success(getTotalDiskSpace())
            "getFreeDiskSpaceForPath" -> result.success(getFreeDiskSpaceForPath(call.argument<String>("path")!!))
            else -> result.notImplemented()
        }
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

    private fun getFreeDiskSpaceForPath(path: String): Double {
        val stat = StatFs(path)
    
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
}