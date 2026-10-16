package com.pranta.screwout

import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.provider.Settings
import androidx.core.view.WindowCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    // Explicit edge-to-edge opt-in on every Android version (what Play
    // Console's edge-to-edge check looks for). The push channel is created
    // natively so a push arriving before Dart initialises is never dropped
    // (createNotificationChannel is idempotent).
    override fun onCreate(savedInstanceState: Bundle?) {
        WindowCompat.enableEdgeToEdge(window)
        super.onCreate(savedInstanceState)
        createNotificationChannel()
    }

    // Never let the launch Intent choose Flutter's initial route: FCM copies
    // data keys onto the Intent as extras, and a key named "route" would
    // become go_router's initial location. Deep links use data.nav_route.
    override fun getInitialRoute(): String? = null

    // Opens this app's system notification settings (a permanently denied
    // POST_NOTIFICATIONS can only be re-enabled there).
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "screw_out/notification_settings")
            .setMethodCallHandler { call, result ->
                if (call.method == "open") {
                    val intent = Intent(Settings.ACTION_APP_NOTIFICATION_SETTINGS).apply {
                        putExtra(Settings.EXTRA_APP_PACKAGE, packageName)
                        addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                    }
                    startActivity(intent)
                    result.success(true)
                } else {
                    result.notImplemented()
                }
            }
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                getString(R.string.default_notification_channel_id),
                getString(R.string.default_notification_channel_name),
                NotificationManager.IMPORTANCE_HIGH,
            ).apply {
                description = getString(R.string.default_notification_channel_desc)
                enableVibration(true)
            }
            (getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager)
                .createNotificationChannel(channel)
        }
    }
}
