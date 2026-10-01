import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

/// Local notifications for the bedtime reminder (PRD FR-4.1) and later
/// the timer-complete chime. The wake alarm is NOT a notification —
/// it goes through the native alarm channel (ARCHITECTURE.md §13).
class NotificationService {
  NotificationService();

  static final NotificationService instance = NotificationService();

  static const String _bedtimeChannelId = 'bedtime_reminder';
  static const String _timerCompleteChannelId = 'timer_complete';
  static const int bedtimeReminderNotificationId = 4710;
  static const int timerCompleteNotificationId = 4711;

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  /// Idempotent; called from main() before runApp. [onRoute] receives the
  /// payload of a tapped notification (e.g. '/night').
  Future<void> init({void Function(String payload)? onRoute}) async {
    if (_initialized) return;
    tzdata.initializeTimeZones();
    try {
      final timeZoneInfo = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timeZoneInfo.identifier));
    } on Exception {
      // Fall back to UTC; the reminder will still fire close enough.
      tz.setLocalLocation(tz.UTC);
    }

    const bedtimeChannel = AndroidNotificationChannel(
      _bedtimeChannelId,
      'Bedtime reminder',
      description: 'Reminder that starts the wind-down before bed',
      importance: Importance.defaultImportance,
    );
    // Gentle chime at promise-timer completion, also with the screen off
    // (FR-7.5).
    const timerChannel = AndroidNotificationChannel(
      _timerCompleteChannelId,
      'Promise complete',
      description: 'Signals the end of a promise timer',
      importance: Importance.defaultImportance,
    );
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await android?.createNotificationChannel(bedtimeChannel);
    await android?.createNotificationChannel(timerChannel);

    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@drawable/ic_notification'),
      ),
      onDidReceiveNotificationResponse: (response) {
        final payload = response.payload;
        if (payload != null && payload.isNotEmpty) {
          onRoute?.call(payload);
        }
      },
    );
    _initialized = true;
  }

  /// Schedules the bedtime reminder that opens /night (PRD FR-4.1).
  ///
  /// Uses alarmClock scheduling so it lands on time in Doze; the app
  /// declares SET_ALARM_CLOCK for this mode.
  Future<void> scheduleBedtimeReminder({
    required DateTime at,
    required String title,
    required String body,
  }) async {
    await _plugin.zonedSchedule(
      id: bedtimeReminderNotificationId,
      title: title,
      body: body,
      scheduledDate: tz.TZDateTime.from(at, tz.local),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          _bedtimeChannelId,
          'Bedtime reminder',
          category: AndroidNotificationCategory.reminder,
          styleInformation: DefaultStyleInformation(false, false),
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.alarmClock,
      payload: '/night',
    );
  }

  Future<void> cancelBedtimeReminder() =>
      _plugin.cancel(id: bedtimeReminderNotificationId);

  /// Schedules the promise-timer completion notification (FR-7.5). The
  /// channel's default sound is the gentle chime.
  Future<void> scheduleTimerComplete({
    required DateTime at,
    required String title,
    required String body,
    required String payload,
  }) async {
    await _plugin.zonedSchedule(
      id: timerCompleteNotificationId,
      title: title,
      body: body,
      scheduledDate: tz.TZDateTime.from(at, tz.local),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          _timerCompleteChannelId,
          'Promise complete',
          category: AndroidNotificationCategory.progress,
          styleInformation: DefaultStyleInformation(false, false),
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.alarmClock,
      payload: payload,
    );
  }

  Future<void> cancelTimerComplete() =>
      _plugin.cancel(id: timerCompleteNotificationId);
}
