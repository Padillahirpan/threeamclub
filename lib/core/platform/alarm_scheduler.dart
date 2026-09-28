/// AlarmScheduler contract — ARCHITECTURE.md §10.
///
/// M0 spike scope: native scheduling only. Dart never owns the alarm;
/// the platform implementation schedules via AlarmManager.setAlarmClock()
/// which is exempt from the exact-alarm permission and fires in Doze.
library;

/// One alarm registration. M0 keeps a single alarm at a time
/// (ARCHITECTURE.md §10: "Only one alarm needs to exist at a time").
class AlarmSpec {
  const AlarmSpec({
    required this.alarmId,
    required this.triggerAtMillis,
    this.title = '3AM Club',
    this.body = 'Time to wake up.',
  });

  final String alarmId;
  final int triggerAtMillis;
  final String title;
  final String body;

  Map<String, Object?> toMap() => <String, Object?>{
        'alarmId': alarmId,
        'triggerAtMillis': triggerAtMillis,
        'title': title,
        'body': body,
      };
}

/// Permission / environment snapshot shown in the spike UI.
class AlarmPermissions {
  const AlarmPermissions({
    required this.notifications,
    required this.fullScreenIntent,
    required this.batteryOptimizationIgnored,
    required this.sdkInt,
    required this.manufacturer,
  });

  factory AlarmPermissions.fromMap(Map<Object?, Object?> map) =>
      AlarmPermissions(
        notifications: map['notifications'] == true,
        fullScreenIntent: map['fullScreenIntent'] == true,
        batteryOptimizationIgnored: map['batteryOptimizationIgnored'] == true,
        sdkInt: (map['sdkInt'] as num?)?.toInt() ?? 0,
        manufacturer: (map['manufacturer'] as String?) ?? 'unknown',
      );

  final bool notifications;
  final bool fullScreenIntent;
  final bool batteryOptimizationIgnored;
  final int sdkInt;
  final String manufacturer;

  bool get allCriticalGranted => notifications && fullScreenIntent;
}

/// Events pushed from the native alarm subsystem.
///
/// Types: `scheduled`, `fired`, `stopped`, `rescheduled:<action>`,
/// `passed_while_off:<action>`, `openWake` (full-screen intent launch).
class AlarmEvent {
  const AlarmEvent({required this.type, required this.atMillis});

  factory AlarmEvent.fromMap(Map<Object?, Object?> map) => AlarmEvent(
        type: (map['type'] as String?) ?? 'unknown',
        atMillis: (map['atMillis'] as num?)?.toInt() ??
            DateTime.now().millisecondsSinceEpoch,
      );

  final String type;
  final int atMillis;

  DateTime get at => DateTime.fromMillisecondsSinceEpoch(atMillis);
}

/// The alarm subsystem boundary (ARCHITECTURE.md §10).
abstract interface class AlarmScheduler {
  /// Schedules [spec] as the next alarm, replacing any previous one.
  Future<void> schedule(AlarmSpec spec);

  Future<void> cancel(String alarmId);

  Future<AlarmPermissions> checkPermissions();

  /// Broadcast stream of alarm lifecycle events.
  Stream<AlarmEvent> get events;

  /// Stops the ringing alarm (called after the 5s hold completes).
  Future<void> stopRinging();
}
