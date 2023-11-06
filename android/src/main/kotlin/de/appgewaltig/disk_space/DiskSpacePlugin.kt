package de.appgewaltig.disk_space

import android.content.Context
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry

class DiskSpacePlugin: FlutterPlugin {

  companion object {
    private var channel: MethodChannel? = null

    private fun registerChannel(messenger: BinaryMessenger, context: Context) {
      channel = MethodChannel(messenger, "disk_space")
      channel!!.setMethodCallHandler(MethodHandlerImpl(context))
    }
  }

  override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    registerChannel(binding.binaryMessenger, binding.getApplicationContext())
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel = null
  }
}