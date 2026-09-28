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
  static const int bedtimeReminderNotificationId = 4710;

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

    const channel = AndroidNotificationChannel(
      _bedtimeChannelId,
      'Bedtime reminder',
      description: 'Reminder that starts the wind-down before bed',
      importance: Importance.defaultImportance,
    );
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await android?.createNotificationChannel(channel);

    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
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
}
