import 'package:flutter/services.dart';

import 'alarm_scheduler.dart';

/// Android implementation of [AlarmScheduler] over the
/// `club.threeam.subuhan/alarm` MethodChannel and `.../alarm_events`
/// EventChannel.
class MethodChannelAlarmScheduler implements AlarmScheduler {
  MethodChannelAlarmScheduler({
    MethodChannel channel = const MethodChannel(_channelName),
    EventChannel eventsChannel = const EventChannel(_eventsName),
  })  : _channel = channel,
        _eventsChannel = eventsChannel;

  static const String _channelName = 'club.threeam.subuhan/alarm';
  static const String _eventsName = 'club.threeam.subuhan/alarm_events';

  final MethodChannel _channel;
  final EventChannel _eventsChannel;

  Stream<AlarmEvent>? _events;

  @override
  Future<void> schedule(AlarmSpec spec) async {
    await _channel.invokeMethod<void>('schedule', spec.toMap());
  }

  @override
  Future<void> cancel(String alarmId) async {
    await _channel.invokeMethod<void>('cancel', <String, Object?>{
      'alarmId': alarmId,
    });
  }

  @override
  Future<void> stopRinging() async {
    await _channel.invokeMethod<void>('stopRinging');
  }

  @override
  Future<AlarmPermissions> checkPermissions() async {
    final raw = await _channel.invokeMethod<Object?>('checkPermissions');
    final map = Map<Object?, Object?>.from(raw as Map<Object?, Object?>);
    return AlarmPermissions.fromMap(map);
  }

  @override
  Stream<AlarmEvent> get events =>
      _events ??= _eventsChannel
          .receiveBroadcastStream()
          .map((raw) => AlarmEvent.fromMap(Map<Object?, Object?>.from(raw as Map)));

  // ---- Spike-only extras (not part of the long-term contract) ----

  /// Reads the alarm persisted natively (survives process death and is the
  /// source for boot re-registration). Null when no alarm is stored.
  Future<StoredAlarm?> storedAlarm() async {
    final raw = await _channel.invokeMethod<Object?>('getStoredAlarm');
    if (raw == null) return null;
    final map = _asMap(raw);
    return StoredAlarm(
      alarmId: (map['alarmId'] as String?) ?? '',
      triggerAtMillis: (map['triggerAtMillis'] as num?)?.toInt() ?? 0,
      state: (map['state'] as String?) ?? 'unknown',
    );
  }

  /// Health check fix: idempotently re-registers the stored alarm with
  /// AlarmManager (ARCHITECTURE.md §10 "app-open health check").
  Future<void> rescheduleFromStore() async {
    await _channel.invokeMethod<void>('reschedule');
  }

  /// Cached launch/event delivered when the app cold-starts from the
  /// full-screen intent and the Dart listener wasn't attached yet.
  Future<AlarmEvent?> consumeLaunchEvent() async {
    final raw = await _channel.invokeMethod<Object?>('consumeLaunchEvent');
    if (raw == null) return null;
    return AlarmEvent.fromMap(_asMap(raw));
  }

  static Map<Object?, Object?> _asMap(Object? raw) =>
      Map<Object?, Object?>.from(raw! as Map);

  Future<bool> requestNotificationPermission() async =>
      await _channel.invokeMethod<bool>('requestNotificationPermission') ??
      false;

  Future<void> openFullScreenIntentSettings() async {
    await _channel.invokeMethod<void>('openFullScreenIntentSettings');
  }

  Future<bool> requestIgnoreBatteryOptimizations() async =>
      await _channel.invokeMethod<bool>('requestIgnoreBatteryOptimizations') ??
      false;
}

/// Natively persisted alarm used by the health check.
class StoredAlarm {
  const StoredAlarm({
    required this.alarmId,
    required this.triggerAtMillis,
    required this.state,
  });

  final String alarmId;
  final int triggerAtMillis;
  final String state;

  DateTime get triggerAt => DateTime.fromMillisecondsSinceEpoch(triggerAtMillis);
}
