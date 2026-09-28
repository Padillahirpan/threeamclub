package club.threeam.subuhan.alarm

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.Intent.ACTION_BOOT_COMPLETED
import android.content.Intent.ACTION_MY_PACKAGE_REPLACED
import android.content.Intent.ACTION_TIME_CHANGED
import android.content.Intent.ACTION_TIMEZONE_CHANGED

/**
 * Re-registers the stored alarm after reboot, manual time change,
 * timezone change, or app update (ARCHITECTURE.md §10).
 */
class BootReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent) {
        val action = intent.action ?: return
        if (action !in HANDLED_ACTIONS) return
        if (!AlarmStore.hasAlarm(context)) return

        val triggerAt = AlarmStore.triggerAt(context)
        val now = System.currentTimeMillis()

        if (triggerAt > now + REREGISTER_MARGIN_MS) {
            NativeAlarmScheduler(context).schedule(triggerAt)
            AlarmStore.setState(context, AlarmStore.STATE_SCHEDULED)
            AlarmEvents.emit(context, "rescheduled:$action")
        } else {
            // The alarm time passed while the device was off / time shifted
            // backwards: clear it so the app-open health check can recover.
            AlarmStore.clearAlarm(context)
            AlarmStore.setState(context, AlarmStore.STATE_IDLE)
            AlarmEvents.emit(context, "passed_while_off:$action")
        }
    }

    companion object {
        private val HANDLED_ACTIONS = setOf(
            ACTION_BOOT_COMPLETED,
            ACTION_TIME_CHANGED,
            ACTION_TIMEZONE_CHANGED,
            ACTION_MY_PACKAGE_REPLACED,
        )
        private const val REREGISTER_MARGIN_MS = 5_000L
    }
}
