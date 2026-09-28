package club.threeam.subuhan.alarm

import android.content.Context
import io.flutter.plugin.common.EventChannel

/**
 * Bridges native alarm events (receivers, service) to the Dart
 * EventChannel. Events are also cached in [AlarmStore] so they survive
 * process death and reach Dart via `consumeLaunchEvent()` on cold start.
 */
object AlarmEvents {
    @Volatile
    private var sink: EventChannel.EventSink? = null

    fun attach(sink: EventChannel.EventSink?) {
        this.sink = sink
    }

    fun detach() {
        sink = null
    }

    fun emit(context: Context, type: String) {
        AlarmStore.saveLastEvent(context, type)
        val s = sink ?: return
        try {
            s.success(mapOf("type" to type, "atMillis" to System.currentTimeMillis()))
        } catch (_: Exception) {
            // Engine detached; the cached event covers cold starts.
        }
    }
}
