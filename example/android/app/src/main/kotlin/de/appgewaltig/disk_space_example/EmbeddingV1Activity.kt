package de.appgewaltig.disk_space_example

import android.os.Bundle
import de.appgewaltig.disk_space.DiskSpacePlugin
import io.flutter.app.FlutterActivity


class EmbeddingV1Activity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        DiskSpacePlugin.registerWith(registrarFor("de.appgewaltig.disk_space.DiskSpacePlugin"))
    }
}