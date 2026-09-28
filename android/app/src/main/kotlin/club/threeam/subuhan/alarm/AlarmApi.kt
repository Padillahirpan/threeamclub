package club.threeam.subuhan.alarm

import android.Manifest
import android.app.Activity
import android.app.NotificationManager
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.os.PowerManager
import android.provider.Settings
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/**
 * MethodChannel + EventChannel handler for the M0 alarm spike,
 * implementing the AlarmScheduler contract (ARCHITECTURE.md §10).
 *
 * Channel: club.threeam.subuhan/alarm
 * Events:  club.threeam.subuhan/alarm_events
 */
class AlarmApi(private val context: Context) :
    MethodChannel.MethodCallHandler,
    EventChannel.StreamHandler {

    private val alarms = NativeAlarmScheduler(context)
    private var pendingPermissionResult: MethodChannel.Result? = null

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        AlarmEvents.attach(events)
    }

    override fun onCancel(arguments: Any?) {
        AlarmEvents.detach()
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "schedule" -> schedule(call, result)
            "cancel" -> cancel(result)
            "stopRinging" -> {
                AlarmRingingService.stop(context)
                result.success(true)
            }
            "checkPermissions" -> result.success(permissionMap())
            "requestNotificationPermission" -> requestNotificationPermission(result)
            "openFullScreenIntentSettings" -> openFullScreenIntentSettings(result)
            "requestIgnoreBatteryOptimizations" -> requestIgnoreBatteryOptimizations(result)
            "getStoredAlarm" -> getStoredAlarm(result)
            "reschedule" -> rescheduleFromStore(result)
            "consumeLaunchEvent" -> result.success(AlarmStore.consumeLastEvent(context))
            else -> result.notImplemented()
        }
    }

    private fun schedule(call: MethodCall, result: MethodChannel.Result) {
        val triggerAt = call.argument<Long>("triggerAtMillis")
        if (triggerAt == null) {
            result.error("ARGS", "triggerAtMillis is required", null)
            return
        }
        val alarmId = call.argument<String>("alarmId") ?: "m0-spike"
        val title = call.argument<String>("title") ?: "3AM Club"
        val body = call.argument<String>("body") ?: "Time to wake up."

        // One alarm at a time: replaces any previous registration.
        alarms.cancel()
        AlarmStore.save(context, alarmId, triggerAt, title, body)
        alarms.schedule(triggerAt)
        AlarmEvents.emit(context, "scheduled")
        result.success(true)
    }

    private fun cancel(result: MethodChannel.Result) {
        alarms.cancel()
        AlarmRingingService.stop(context)
        AlarmStore.clearAlarm(context)
        AlarmStore.setState(context, AlarmStore.STATE_IDLE)
        result.success(true)
    }

    private fun permissionMap(): Map<String, Any?> {
        val notificationManager =
            context.getSystemService(NotificationManager::class.java)
        val powerManager = context.getSystemService(PowerManager::class.java)
        val fullScreenIntentGranted = if (Build.VERSION.SDK_INT >= 34) {
            notificationManager.canUseFullScreenIntent()
        } else {
            true
        }
        return mapOf(
            "notifications" to (notificationManager.areNotificationsEnabled()),
            "fullScreenIntent" to fullScreenIntentGranted,
            "batteryOptimizationIgnored" to
                powerManager.isIgnoringBatteryOptimizations(context.packageName),
            "sdkInt" to Build.VERSION.SDK_INT,
            "manufacturer" to Build.MANUFACTURER,
        )
    }

    private fun requestNotificationPermission(result: MethodChannel.Result) {
        val nm = context.getSystemService(NotificationManager::class.java)
        if (nm.areNotificationsEnabled()) {
            result.success(true)
            return
        }
        if (Build.VERSION.SDK_INT >= 33) {
            val activity = context as? Activity
            if (activity == null) {
                result.success(false)
                return
            }
            pendingPermissionResult = result
            activity.requestPermissions(
                arrayOf(Manifest.permission.POST_NOTIFICATIONS),
                REQUEST_POST_NOTIFICATIONS,
            )
        } else {
            result.success(false)
        }
    }

    /** Called by MainActivity when the runtime result arrives. */
    fun onPermissionResult(granted: Boolean) {
        pendingPermissionResult?.success(granted)
        pendingPermissionResult = null
    }

    private fun openFullScreenIntentSettings(result: MethodChannel.Result) {
        if (Build.VERSION.SDK_INT >= 34) {
            val intent = Intent(
                Settings.ACTION_MANAGE_APP_USE_FULL_SCREEN_INTENT,
                Uri.parse("package:${context.packageName}"),
            ).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            context.startActivity(intent)
        }
        result.success(true)
    }

    @Suppress("BatteryLife")
    private fun requestIgnoreBatteryOptimizations(result: MethodChannel.Result) {
        val intent = Intent(
            Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS,
            Uri.parse("package:${context.packageName}"),
        ).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        runCatching { context.startActivity(intent) }
        result.success(true)
    }

    private fun getStoredAlarm(result: MethodChannel.Result) {
        if (!AlarmStore.hasAlarm(context)) {
            result.success(null)
            return
        }
        result.success(
            mapOf(
                "alarmId" to AlarmStore.alarmId(context),
                "triggerAtMillis" to AlarmStore.triggerAt(context),
                "state" to AlarmStore.state(context),
            ),
        )
    }

    /** Health-check fix: idempotent re-registration of the stored alarm. */
    private fun rescheduleFromStore(result: MethodChannel.Result) {
        if (!AlarmStore.hasAlarm(context)) {
            result.success(false)
            return
        }
        alarms.schedule(AlarmStore.triggerAt(context))
        AlarmStore.setState(context, AlarmStore.STATE_SCHEDULED)
        result.success(true)
    }

    companion object {
        const val CHANNEL = "club.threeam.subuhan/alarm"
        const val EVENTS_CHANNEL = "club.threeam.subuhan/alarm_events"
        const val REQUEST_POST_NOTIFICATIONS = 4731
    }
}
