import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/platform/alarm_scheduler.dart';
import '../../plan/data/plan_repository.dart' show alarmSchedulerProvider;

/// Alarm health check (PRD M5, ARCHITECTURE.md §10): on app open (and
/// resume) the app verifies the critical alarm permissions —
/// notifications + full-screen intent — and warns when they were revoked.
///
/// The alarm itself is re-armed by `syncAfterOpen`/`rollover`; this
/// provider covers the "user revoked a permission in system settings"
/// case that scheduling alone cannot detect.
class AlarmHealth extends Notifier<AlarmPermissions?> {
  @override
  AlarmPermissions? build() => null;

  /// Re-reads the permission snapshot. Channel errors (e.g. tests) leave
  /// the state as-is — health checks must never crash the app.
  Future<void> refresh() async {
    try {
      state = await ref.read(alarmSchedulerProvider).checkPermissions();
    } catch (_) {
      // Unavailable in this environment (tests, channel not ready).
    }
  }
}

final alarmHealthProvider = NotifierProvider<AlarmHealth, AlarmPermissions?>(
  AlarmHealth.new,
);
