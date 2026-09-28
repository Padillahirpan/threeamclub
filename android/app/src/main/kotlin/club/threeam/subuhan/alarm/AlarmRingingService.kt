package club.threeam.subuhan.alarm

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.content.pm.ServiceInfo
import android.media.AudioAttributes
import android.media.MediaPlayer
import android.media.RingtoneManager
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.os.PowerManager
import android.os.VibrationEffect
import android.os.Vibrator
import android.os.VibratorManager
import android.provider.Settings
import club.threeam.subuhan.MainActivity

/**
 * Foreground service that rings the alarm:
 *  - plays the default alarm sound in a ~30s volume ramp (FR-5.2),
 *  - vibrates with alarm usage,
 *  - posts a CATEGORY_ALARM notification with a full-screen intent that
 *    shows the wake screen over the lock screen (FR-5.1, ARCHITECTURE §10),
 *  - holds a partial wake lock so the CPU keeps playing.
 *
 * The alarm stops when the user completes the 5s hold (stopRinging) or
 * uses the notification's "Stop alarm" action (a11y alternative).
 */
class AlarmRingingService : Service() {

    private var player: MediaPlayer? = null
    private var vibrator: Vibrator? = null
    private var wakeLock: PowerManager.WakeLock? = null
    private val handler = Handler(Looper.getMainLooper())
    private var rampStep = 0
    private var rampRunnable: Runnable? = null
    private var ringCycle = 0
    private var cycleRunnable: Runnable? = null
    private var gapRunnable: Runnable? = null

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onCreate() {
        super.onCreate()
        createChannel()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        if (intent?.action == ACTION_STOP) {
            stopAlarm(emitEvent = true)
            stopSelf()
            return START_NOT_STICKY
        }

        val notification = buildNotification()
        if (Build.VERSION.SDK_INT >= 29) {
            startForeground(NOTIFICATION_ID, notification, ServiceInfo.FOREGROUND_SERVICE_TYPE_MEDIA_PLAYBACK)
        } else {
            startForeground(NOTIFICATION_ID, notification)
        }

        holdWake()
        ringCycle = 0
        startRingingCycle()
        AlarmRingingServiceHolder.running = true
        return START_STICKY
    }

    // Re-ring policy (PRD §12 proposal): ring 10 minutes, then re-fire
    // every 5 minutes, up to 3 ring cycles total. After the last cycle the
    // alarm gives up (the morning is still confirmable until 06:00).
    private fun startRingingCycle() {
        gapRunnable = null
        startAudioRamp()
        startVibration()
        val endCycle = Runnable { endRingCycle() }
        cycleRunnable = endCycle
        handler.postDelayed(endCycle, RING_WINDOW_MS)
    }

    private fun endRingCycle() {
        cycleRunnable = null
        stopSoundAndVibration()
        ringCycle++
        if (ringCycle >= MAX_RING_CYCLES) {
            AlarmStore.setState(this, AlarmStore.STATE_STOPPED)
            AlarmEvents.emit(this, "gaveup")
            stopSelf()
            return
        }
        val restart = Runnable { startRingingCycle() }
        gapRunnable = restart
        handler.postDelayed(restart, RING_GAP_MS)
    }

    private fun stopSoundAndVibration() {
        rampRunnable?.let { handler.removeCallbacks(it) }
        rampRunnable = null
        rampStep = 0
        try {
            player?.let {
                if (it.isPlaying) it.stop()
                it.release()
            }
        } catch (_: Exception) {
            // Already released.
        }
        player = null
        vibrator?.cancel()
        vibrator = null
    }

    private fun createChannel() {
        val manager = getSystemService(NotificationManager::class.java)
        val channel = NotificationChannel(
            CHANNEL_ID,
            "Alarm ringing",
            NotificationManager.IMPORTANCE_HIGH,
        ).apply {
            // Sound/vibration are handled by this service (ramped), so the
            // channel itself must be silent to avoid doubling.
            setSound(null, null)
            enableVibration(false)
            setShowBadge(false)
        }
        manager.createNotificationChannel(channel)
    }

    private fun buildNotification(): Notification {
        val wakeIntent = PendingIntent.getActivity(
            this,
            REQUEST_WAKE,
            Intent(this, MainActivity::class.java)
                .putExtra(NativeAlarmScheduler.EXTRA_ROUTE, NativeAlarmScheduler.ROUTE_WAKE)
                .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP),
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )

        val stopIntent = PendingIntent.getService(
            this,
            REQUEST_STOP,
            Intent(this, AlarmRingingService::class.java).setAction(ACTION_STOP),
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )

        return Notification.Builder(this, CHANNEL_ID)
            .setSmallIcon(android.R.drawable.ic_lock_idle_alarm)
            .setContentTitle(AlarmStore.title(this) ?: "3AM Club")
            .setContentText(AlarmStore.body(this) ?: "Time to wake up.")
            .setCategory(Notification.CATEGORY_ALARM)
            .setVisibility(Notification.VISIBILITY_PUBLIC)
            .setOngoing(true)
            .setContentIntent(wakeIntent)
            .setFullScreenIntent(wakeIntent, true)
            .addAction(Notification.Action.Builder(null, "Stop alarm", stopIntent).build())
            .build()
    }

    private fun holdWake() {
        if (wakeLock?.isHeld == true) return
        val pm = getSystemService(PowerManager::class.java)
        wakeLock = pm.newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, "subuhan:alarm_ringing").apply {
            setReferenceCounted(false)
            acquire(WAKE_LOCK_TIMEOUT_MS)
        }
    }

    private fun startAudioRamp() {
        if (player != null) return
        val uri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM)
            ?: RingtoneManager.getDefaultUri(RingtoneManager.TYPE_RINGTONE)
            ?: Settings.System.DEFAULT_ALARM_ALERT_URI

        player = MediaPlayer().apply {
            setDataSource(this@AlarmRingingService, uri)
            setAudioAttributes(
                AudioAttributes.Builder()
                    .setUsage(AudioAttributes.USAGE_ALARM)
                    .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                    .build(),
            )
            isLooping = true
            setVolume(0f, 0f)
            setOnErrorListener { _, _, _ ->
                // Media error: fall into the re-ring cadence instead of
                // ringing silently forever.
                endRingCycle()
                true
            }
            setOnPreparedListener { it.start() }
            prepareAsync()
        }

        // Gradual ramp: 0 -> full over ~30 seconds (FR-5.2).
        rampStep = 0
        val runnable = object : Runnable {
            override fun run() {
                rampStep++
                val volume = (rampStep.toFloat() / TOTAL_RAMP_STEPS).coerceAtMost(1f)
                player?.setVolume(volume, volume)
                if (rampStep < TOTAL_RAMP_STEPS) {
                    handler.postDelayed(this, RAMP_STEP_MS)
                }
            }
        }
        rampRunnable = runnable
        handler.postDelayed(runnable, RAMP_STEP_MS)
    }

    @Suppress("DEPRECATION")
    private fun startVibration() {
        if (vibrator?.hasVibrator() == true) return
        val v = if (Build.VERSION.SDK_INT >= 31) {
            (getSystemService(VIBRATOR_MANAGER_SERVICE) as VibratorManager).defaultVibrator
        } else {
            getSystemService(VIBRATOR_SERVICE) as Vibrator
        }
        vibrator = v
        val effect = VibrationEffect.createWaveform(longArrayOf(0, 1000, 1000), 0)
        if (Build.VERSION.SDK_INT >= 31) {
            v.vibrate(
                effect,
                android.os.VibrationAttributes.createForUsage(
                    android.os.VibrationAttributes.USAGE_ALARM,
                ),
            )
        } else {
            v.vibrate(effect)
        }
    }

    private fun stopAlarm(emitEvent: Boolean) {
        cycleRunnable?.let { handler.removeCallbacks(it) }
        cycleRunnable = null
        gapRunnable?.let { handler.removeCallbacks(it) }
        gapRunnable = null
        stopSoundAndVibration()
        if (wakeLock?.isHeld == true) wakeLock?.release()
        wakeLock = null
        AlarmStore.setState(this, AlarmStore.STATE_STOPPED)
        if (emitEvent) AlarmEvents.emit(this, "stopped")
    }

    override fun onDestroy() {
        AlarmRingingServiceHolder.running = false
        stopAlarm(emitEvent = false)
        super.onDestroy()
    }

    companion object {
        const val CHANNEL_ID = "alarm_ringing"
        const val NOTIFICATION_ID = 4700
        const val ACTION_STOP = "club.threeam.subuhan.alarm.STOP"
        private const val REQUEST_WAKE = 4721
        private const val REQUEST_STOP = 4722
        private const val RAMP_STEP_MS = 500L
        private const val RAMP_SECONDS = 30
        private const val TOTAL_RAMP_STEPS = (RAMP_SECONDS * 1000 / RAMP_STEP_MS).toInt()
        private const val WAKE_LOCK_TIMEOUT_MS = 10 * 60 * 1000L

        // Re-ring policy (PRD §12 proposal): 10 min ring → 5 min gap, ×3.
        private const val RING_WINDOW_MS = 10 * 60 * 1000L
        private const val RING_GAP_MS = 5 * 60 * 1000L
        private const val MAX_RING_CYCLES = 3

        /** Stops the ringing alarm from the Dart side (after the 5s hold). */
        fun stop(context: Context) {
            val intent = Intent(context, AlarmRingingService::class.java)
                .setAction(ACTION_STOP)
            if (AlarmRingingServiceHolder.running) {
                context.startService(intent)
            } else {
                // Service not running (e.g. killed): just record the state.
                AlarmStore.setState(context, AlarmStore.STATE_STOPPED)
                AlarmEvents.emit(context, "stopped")
            }
        }
    }
}

/** Simple static running flag so [AlarmRingingService.stop] can avoid
 *  starting the service just to stop it. */
object AlarmRingingServiceHolder {
    @Volatile
    var running: Boolean = false
}
