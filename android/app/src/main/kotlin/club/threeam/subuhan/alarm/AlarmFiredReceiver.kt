package club.threeam.subuhan.alarm

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

/**
 * Fired by AlarmManager at the wake time. Starts the ringing foreground
 * service (sound ramp + vibration + full-screen intent notification).
 *
 * Starting a foreground service here is allowed: alarms set via
 * setAlarmClock are exempt from background service start restrictions.
 */
class AlarmFiredReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent) {
        AlarmStore.setState(context, AlarmStore.STATE_FIRED)
        AlarmEvents.emit(context, "fired")
        context.startForegroundService(
            Intent(context, AlarmRingingService::class.java),
        )
    }
}
