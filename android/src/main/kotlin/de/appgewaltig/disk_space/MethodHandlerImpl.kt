package de.appgewaltig.disk_space

import android.content.Context
import android.os.Environment
import android.os.StatFs
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MethodHandlerImpl(private val context: Context) : MethodChannel.MethodCallHandler {
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when(call.method) {
            "getFreeDiskSpace" -> result.success(getFreeDiskSpace())
            "getTotalDiskSpace" -> result.success(getTotalDiskSpace())
            "getFreeDiskSpaceForPath" -> result.success(getFreeDiskSpaceForPath(call.argument<String>("path")!!))
            else -> result.notImplemented()
        }
    }

    private fun getFreeDiskSpace(): Double {
        val stat = StatFs(getFilesPath())

        val bytesAvailable: Long = if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.JELLY_BEAN_MR2)
            stat.blockSizeLong * stat.availableBlocksLong
        else
            stat.blockSize.toLong() * stat.availableBlocks.toLong()
        return (bytesAvailable / (1024f * 1024f)).toDouble()
    }

    private fun getFreeDiskSpaceForPath(path: String): Double {
        val stat = StatFs(path)

        val bytesAvailable: Long = if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.JELLY_BEAN_MR2)
            stat.blockSizeLong * stat.availableBlocksLong
        else
            stat.blockSize.toLong() * stat.availableBlocks.toLong()
        return (bytesAvailable / (1024f * 1024f)).toDouble()
    }

    private fun getTotalDiskSpace(): Double {
        val stat = StatFs(getFilesPath())

        val bytesAvailable: Long = if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.JELLY_BEAN_MR2)
            stat.blockSizeLong * stat.blockCountLong
        else
            stat.blockSize.toLong() * stat.blockCount.toLong()
        return (bytesAvailable / (1024f * 1024f)).toDouble()
    }

    private fun getFilesPath(): String {
        val state = Environment.getExternalStorageState()

        return if (Environment.MEDIA_MOUNTED == state) {
            // We can read and write the media
            context.getExternalFilesDir(null)?.path.toString()
        } else {
            // Load another directory, probably local memory
            context.filesDir?.path.toString()
        }
    }
}