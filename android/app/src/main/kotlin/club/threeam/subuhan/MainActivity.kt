package club.threeam.subuhan

import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import android.view.WindowManager
import club.threeam.subuhan.alarm.AlarmApi
import club.threeam.subuhan.alarm.AlarmEvents
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private lateinit var alarmApi: AlarmApi

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Show the wake screen over the lock screen when launched by the
        // full-screen intent (ARCHITECTURE.md §10).
        if (Build.VERSION.SDK_INT >= 27) {
            setShowWhenLocked(true)
            setTurnScreenOn(true)
        } else {
            @Suppress("DEPRECATION")
            window.addFlags(
                WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or
                    WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON,
            )
        }
        handleLaunchIntent(intent)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        alarmApi = AlarmApi(this)
        MethodChannel(flutterEngine.dartExecutor, AlarmApi.CHANNEL)
            .setMethodCallHandler(alarmApi)
        EventChannel(flutterEngine.dartExecutor, AlarmApi.EVENTS_CHANNEL)
            .setStreamHandler(alarmApi)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        handleLaunchIntent(intent)
    }

    private fun handleLaunchIntent(intent: Intent?) {
        if (intent?.getStringExtra("route") == "wake") {
            AlarmEvents.emit(this, "openWake")
        }
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray,
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == AlarmApi.REQUEST_POST_NOTIFICATIONS) {
            val granted = grantResults.isNotEmpty() &&
                grantResults[0] == PackageManager.PERMISSION_GRANTED
            if (::alarmApi.isInitialized) {
                alarmApi.onPermissionResult(granted)
            }
        }
    }
}
