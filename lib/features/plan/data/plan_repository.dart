import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/clock/clock.dart';
import '../../../core/db/app_database.dart' as db;
import '../../../core/db/database_provider.dart';
import '../../../core/platform/alarm_scheduler.dart';
import '../../../core/platform/method_channel_alarm_scheduler.dart';
import '../../../core/platform/notification_service.dart';
import '../../../core/time/minute_of_day.dart';
import '../domain/plan_draft.dart';

/// Result of signing: when the alarm will ring (local time).
class SignedPlan {
  const SignedPlan({required this.wakeAt, required this.planId});

  final DateTime wakeAt;
  final String planId;
}

/// Persists a signed plan and schedules its alarm + bedtime reminder
/// (PRD FR-3.4). Localization-free: notification copy is passed in by
/// the caller so this layer stays pure-data.
class PlanRepository {
  PlanRepository({
    required db.AppDatabase database,
    required AlarmScheduler alarmScheduler,
    required NotificationService notificationService,
    required Clock clock,
    Uuid uuidGen = const Uuid(),
  })  : _db = database,
        _alarm = alarmScheduler,
        _notifications = notificationService,
        _clock = clock,
        _uuid = uuidGen;

  final db.AppDatabase _db;
  final AlarmScheduler _alarm;
  final NotificationService _notifications;
  final Clock _clock;
  final Uuid _uuid;

  Future<SignedPlan> signPlan(
    PlanDraftState draft, {
    required String alarmTitle,
    required String alarmBody,
    required String reminderTitle,
    required String reminderBody,
  }) async {
    final now = _clock.now();
    final wakeAt = nextOccurrence(now: now, minuteOfDay: draft.wakeMinute);
    final planId = _uuid.v4();
    final morningId = _uuid.v4();
    final utcNow = now.toUtc();

    await _db.transaction(() async {
      // Deactivate previous plans — one active plan at a time.
      await (_db.update(_db.plans)..where((t) => t.isActive.equals(true)))
          .write(const db.PlansCompanion(isActive: Value(false)));

      await _db.into(_db.plans).insert(
            db.PlansCompanion.insert(
              id: planId,
              wakeMinute: draft.wakeMinute,
              bedMinute: draft.bedMinute,
              whyText: Value(
                  draft.whyText.isEmpty ? null : draft.whyText),
              signedAt: utcNow,
              journeyStartDate: utcNow, // journey starts at signing (PRD §7)
              isActive: true,
              createdAt: utcNow,
              updatedAt: utcNow,
            ),
          );

      for (var i = 0; i < draft.checklist.length; i++) {
        final item = draft.checklist[i];
        await _db.into(_db.preSleepItems).insert(
              db.PreSleepItemsCompanion.insert(
                id: _uuid.v4(),
                planId: planId,
                title: item.title,
                sortOrder: i,
                createdAt: utcNow,
                updatedAt: utcNow,
              ),
            );
      }

      // Morning for the wake date; promises are copied into promise_logs so
      // editing the plan later never rewrites history (ARCHITECTURE.md §6).
      // Re-signing for the same wake date replaces that morning's data.
      final existingMorning = await (_db.select(_db.mornings)
            ..where((t) => t.date.equals(dateKey(wakeAt))))
          .getSingleOrNull();
      if (existingMorning != null) {
        await (_db.delete(_db.promiseLogs)
              ..where((t) => t.morningId.equals(existingMorning.id)))
            .go();
        await (_db.delete(_db.preSleepLogs)
              ..where((t) => t.morningId.equals(existingMorning.id)))
            .go();
        await (_db.delete(_db.mornings)
              ..where((t) => t.id.equals(existingMorning.id)))
            .go();
      }
      await _db.into(_db.mornings).insert(
            db.MorningsCompanion.insert(
              id: morningId,
              date: dateKey(wakeAt),
              planId: planId,
              scheduledAt: wakeAt.toUtc(),
              createdAt: utcNow,
              updatedAt: utcNow,
            ),
          );

      for (var i = 0; i < draft.promises.length; i++) {
        final promise = draft.promises[i];
        final promiseId = _uuid.v4();
        await _db.into(_db.promises).insert(
              db.PromisesCompanion.insert(
                id: promiseId,
                planId: planId,
                categoryId: promise.categoryId,
                title: promise.title,
                description: Value(promise.description),
                durationMin: promise.durationMin,
                sortOrder: i,
                createdAt: utcNow,
                updatedAt: utcNow,
              ),
            );
        await _db.into(_db.promiseLogs).insert(
              db.PromiseLogsCompanion.insert(
                id: _uuid.v4(),
                morningId: morningId,
                promiseId: promiseId,
                plannedSec: promise.durationMin * 60,
                createdAt: utcNow,
                updatedAt: utcNow,
              ),
            );
      }
    });

    // Native wake alarm — the one alarm that exists at a time
    // (ARCHITECTURE.md §10).
    await _alarm.schedule(AlarmSpec(
      alarmId: 'wake-$morningId',
      triggerAtMillis: wakeAt.millisecondsSinceEpoch,
      title: alarmTitle,
      body: alarmBody,
    ));

    // Bedtime reminder (bedtime − lead) for the evening before the wake.
    final lead = await bedtimeLeadMinutes();
    final reminderAt = bedtimeReminderBefore(
      wakeAt: wakeAt,
      bedMinute: draft.bedMinute,
      leadMinutes: lead,
    );
    if (reminderAt.isAfter(now)) {
      await _notifications.scheduleBedtimeReminder(
        at: reminderAt,
        title: reminderTitle,
        body: reminderBody,
      );
    } else {
      await _notifications.cancelBedtimeReminder();
    }

    return SignedPlan(wakeAt: wakeAt, planId: planId);
  }

  Future<int> bedtimeLeadMinutes() async {
    final row = await (_db.select(_db.settings)
          ..where((t) => t.id.equals('default')))
        .getSingleOrNull();
    return row?.bedtimeLeadMinutes ?? 30;
  }

  Future<bool> hasActivePlan() async {
    final rows = await (_db.select(_db.plans)
          ..where((t) => t.isActive.equals(true)))
        .get();
    return rows.isNotEmpty;
  }
}

final alarmSchedulerProvider = Provider<AlarmScheduler>((ref) {
  return MethodChannelAlarmScheduler();
});

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService.instance;
});

final planRepositoryProvider = Provider<PlanRepository>((ref) {
  return PlanRepository(
    database: ref.watch(databaseProvider),
    alarmScheduler: ref.watch(alarmSchedulerProvider),
    notificationService: ref.watch(notificationServiceProvider),
    clock: ref.watch(clockProvider),
  );
});
