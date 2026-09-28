package club.threeam.subuhan.alarm

import android.content.Context

/**
 * Single source of truth for the persisted alarm state.
 *
 * Survives process death and is what the BootReceiver uses to
 * re-register the alarm with AlarmManager (ARCHITECTURE.md §10).
 * Only one alarm exists at a time.
 */
object AlarmStore {
    private const val FILE = "alarm_store"

    const val STATE_IDLE = "idle"
    const val STATE_SCHEDULED = "scheduled"
    const val STATE_FIRED = "fired"
    const val STATE_STOPPED = "stopped"

    private const val KEY_ID = "alarm_id"
    private const val KEY_TRIGGER_AT = "trigger_at"
    private const val KEY_TITLE = "title"
    private const val KEY_BODY = "body"
    private const val KEY_STATE = "state"
    private const val KEY_EVENT = "last_event"
    private const val KEY_EVENT_AT = "last_event_at"
    private const val KEY_EVENT_CONSUMED = "last_event_consumed"

    private fun prefs(context: Context) =
        context.applicationContext.getSharedPreferences(FILE, Context.MODE_PRIVATE)

    fun save(context: Context, alarmId: String, triggerAtMillis: Long, title: String, body: String) {
        prefs(context).edit()
            .putString(KEY_ID, alarmId)
            .putLong(KEY_TRIGGER_AT, triggerAtMillis)
            .putString(KEY_TITLE, title)
            .putString(KEY_BODY, body)
            .putString(KEY_STATE, STATE_SCHEDULED)
            .apply()
    }

    fun clearAlarm(context: Context) {
        prefs(context).edit()
            .remove(KEY_ID)
            .remove(KEY_TRIGGER_AT)
            .remove(KEY_TITLE)
            .remove(KEY_BODY)
            .apply()
    }

    fun hasAlarm(context: Context): Boolean = prefs(context).contains(KEY_TRIGGER_AT)

    fun alarmId(context: Context): String? = prefs(context).getString(KEY_ID, null)

    fun triggerAt(context: Context): Long = prefs(context).getLong(KEY_TRIGGER_AT, 0L)

    fun title(context: Context): String? = prefs(context).getString(KEY_TITLE, null)

    fun body(context: Context): String? = prefs(context).getString(KEY_BODY, null)

    fun setState(context: Context, state: String) {
        prefs(context).edit().putString(KEY_STATE, state).apply()
    }

    fun state(context: Context): String = prefs(context).getString(KEY_STATE, STATE_IDLE) ?: STATE_IDLE

    /** Caches an event so a cold-started Dart side can consume it. */
    fun saveLastEvent(context: Context, type: String) {
        prefs(context).edit()
            .putString(KEY_EVENT, type)
            .putLong(KEY_EVENT_AT, System.currentTimeMillis())
            .putBoolean(KEY_EVENT_CONSUMED, false)
            .apply()
    }

    /** Returns the unconsumed cached event (if any) and marks it consumed. */
    fun consumeLastEvent(context: Context): Map<String, Any>? {
        val p = prefs(context)
        val type = p.getString(KEY_EVENT, null) ?: return null
        if (p.getBoolean(KEY_EVENT_CONSUMED, true)) return null
        p.edit().putBoolean(KEY_EVENT_CONSUMED, true).apply()
        return mapOf(
            "type" to type,
            "atMillis" to p.getLong(KEY_EVENT_AT, System.currentTimeMillis()),
        )
    }
}
