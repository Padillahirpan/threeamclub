package club.threeam.subuhan.alarm

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import club.threeam.subuhan.MainActivity

/**
 * Registers the exact wake alarm with the OS.
 *
 * Uses [AlarmManager.setAlarmClock]:
 *  - fires at the precise time even in Doze and battery saver,
 *  - exempt from the SCHEDULE_EXACT_ALARM permission,
 *  - shows the next-alarm icon in the status bar (like a real alarm clock).
 *
 * Title/body for the ringing notification come from [AlarmStore].
 */
class NativeAlarmScheduler(private val context: Context) {

    fun schedule(triggerAtMillis: Long) {
        val am = context.getSystemService(AlarmManager::class.java)

        val show = PendingIntent.getActivity(
            context,
            REQUEST_SHOW,
            Intent(context, MainActivity::class.java)
                .putExtra(EXTRA_ROUTE, ROUTE_WAKE)
                .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP),
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )

        val fire = PendingIntent.getBroadcast(
            context,
            REQUEST_FIRE,
            Intent(context, AlarmFiredReceiver::class.java),
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )

        // AlarmClockInfo's second argument is the "show" intent launched when
        // the user taps the status-bar alarm icon.
        am.setAlarmClock(AlarmManager.AlarmClockInfo(triggerAtMillis, show), fire)
    }

    fun cancel() {
        val am = context.getSystemService(AlarmManager::class.java)
        val fire = PendingIntent.getBroadcast(
            context,
            REQUEST_FIRE,
            Intent(context, AlarmFiredReceiver::class.java),
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )
        am.cancel(fire)
        fire.cancel()
    }

    companion object {
        const val EXTRA_ROUTE = "route"
        const val ROUTE_WAKE = "wake"
        private const val REQUEST_FIRE = 4711
        private const val REQUEST_SHOW = 4712
    }
}
