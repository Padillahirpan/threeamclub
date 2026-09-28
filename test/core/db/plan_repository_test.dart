import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:subuhan/core/clock/clock.dart';
import 'package:subuhan/core/db/app_database.dart' as db;
import 'package:subuhan/core/platform/alarm_scheduler.dart';
import 'package:subuhan/core/platform/notification_service.dart';
import 'package:subuhan/features/plan/data/plan_repository.dart';
import 'package:subuhan/features/plan/domain/plan_draft.dart';

class _FakeAlarmScheduler implements AlarmScheduler {
  final List<AlarmSpec> scheduled = <AlarmSpec>[];
  final List<String> cancelled = <String>[];
  bool ringing = false;

  @override
  Future<void> schedule(AlarmSpec spec) async => scheduled.add(spec);

  @override
  Future<void> cancel(String alarmId) async => cancelled.add(alarmId);

  @override
  Future<AlarmPermissions> checkPermissions() async => throw UnimplementedError();

  @override
  Stream<AlarmEvent> get events => const Stream.empty();

  @override
  Future<void> stopRinging() async {}

  @override
  Future<bool> get isRinging async => ringing;
}

class _FakeNotificationService extends NotificationService {
  DateTime? scheduledAt;

  @override
  Future<void> scheduleBedtimeReminder({
    required DateTime at,
    required String title,
    required String body,
  }) async {
    scheduledAt = at;
  }

  @override
  Future<void> cancelBedtimeReminder() async {}
}

void main() {
  late db.AppDatabase database;
  late _FakeAlarmScheduler alarm;
  late _FakeNotificationService notifications;
  late PlanRepository repository;

  setUp(() {
    database = db.AppDatabase.connect(NativeDatabase.memory());
    alarm = _FakeAlarmScheduler();
    notifications = _FakeNotificationService();
    repository = PlanRepository(
      database: database,
      alarmScheduler: alarm,
      notificationService: notifications,
      clock: FixedClock(DateTime(2026, 9, 28, 20, 0)), // Monday 8pm
    );
  });

  tearDown(() async {
    await database.close();
  });

  PlanDraftState draft() => PlanDraftState(
        bedMinute: 21 * 60,
        wakeMinute: 4 * 60,
        whyText: 'For my family',
        checklist: const [
          ChecklistItemDraft(id: 'c1', title: 'Phone on charge'),
          ChecklistItemDraft(id: 'c2', title: 'Prayer clothes'),
        ],
        promises: const [
          PromiseDraft(
            id: 'p1',
            categoryId: 'cat-spiritual',
            title: 'Tahajud prayer',
            durationMin: 20,
          ),
          PromiseDraft(
            id: 'p2',
            categoryId: 'cat-body',
            title: 'Stretching',
            durationMin: 10,
          ),
        ],
      );

  test('signPlan persists the full plan graph and schedules', () async {
    final signed = await repository.signPlan(
      draft(),
      alarmTitle: '3AM Club',
      alarmBody: 'Good morning.',
      reminderTitle: '3AM Club',
      reminderBody: 'Tonight, you keep your promise.',
    );

    // Alarm scheduled for tomorrow 04:00 (signed at 20:00).
    expect(signed.wakeAt, DateTime(2026, 9, 29, 4, 0));
    expect(alarm.scheduled, hasLength(1));
    expect(alarm.scheduled.single.triggerAtMillis,
        DateTime(2026, 9, 29, 4, 0).millisecondsSinceEpoch);

    // Bedtime reminder: 21:00 − 30 min = 20:30 today (after "now" 20:00).
    expect(notifications.scheduledAt, DateTime(2026, 9, 28, 20, 30));

    // Plan row.
    final plans = await database.select(database.plans).get();
    expect(plans, hasLength(1));
    expect(plans.single.isActive, isTrue);
    expect(plans.single.wakeMinute, 4 * 60);
    expect(plans.single.whyText, 'For my family');
    expect(plans.single.journeyLengthDays, 66);

    // Checklist + promises.
    expect(await database.select(database.preSleepItems).get(), hasLength(2));
    final promises = await database.select(database.promises).get();
    expect(promises.map((p) => p.title), ['Tahajud prayer', 'Stretching']);
    expect(promises.first.sortOrder, 0);

    // Morning for the wake date, with copied promise logs.
    final mornings = await database.select(database.mornings).get();
    expect(mornings, hasLength(1));
    expect(mornings.single.date, '2026-09-29');
    expect(mornings.single.result, 'pending');
    final logs = await database.select(database.promiseLogs).get();
    expect(logs, hasLength(2));
    expect(
      logs.map((l) => l.plannedSec),
      containsAll(<int>[20 * 60, 10 * 60]),
    );
    expect(logs.every((l) => l.status == 'pending'), isTrue);

    expect(await repository.hasActivePlan(), isTrue);
  });

  test('signing again deactivates the previous plan and replaces the alarm',
      () async {
    await repository.signPlan(
      draft(),
      alarmTitle: '3AM Club',
      alarmBody: 'a',
      reminderTitle: 't',
      reminderBody: 'b',
    );
    // One active plan; the first one was deactivated.
    final plans = await database.select(database.plans).get();
    expect(plans, hasLength(1));
    expect(plans.single.isActive, isTrue);

    // Re-sign for the same wake date replaces the morning instead of
    // crashing on the unique date constraint.
    final sameDay = await repository.signPlan(
      draft().copyWith(wakeMinute: 3 * 60), // 03:00, still 2026-09-29
      alarmTitle: '3AM Club',
      alarmBody: 'a',
      reminderTitle: 't',
      reminderBody: 'b',
    );
    expect(sameDay.wakeAt, DateTime(2026, 9, 29, 3, 0));
    expect(alarm.scheduled, hasLength(2));
    expect((await database.select(database.plans).get())
        .where((p) => p.isActive), hasLength(1));
    // Still exactly one morning for 2026-09-29, with fresh logs.
    final mornings = await database.select(database.mornings).get();
    expect(mornings, hasLength(1));
    expect(mornings.single.date, '2026-09-29');
    final logs = await database.select(database.promiseLogs).get();
    expect(logs, hasLength(2));

    // Signing a day later creates a second morning.
    final nextDayRepo = PlanRepository(
      database: database,
      alarmScheduler: alarm,
      notificationService: notifications,
      clock: FixedClock(DateTime(2026, 9, 29, 20, 0)),
    );
    await nextDayRepo.signPlan(
      draft(),
      alarmTitle: '3AM Club',
      alarmBody: 'a',
      reminderTitle: 't',
      reminderBody: 'b',
    );
    expect(await database.select(database.mornings).get(), hasLength(2));
  });

  test('built-in categories are seeded on first open', () async {
    final categories = await database.select(database.categories).get();
    expect(categories, hasLength(6));
    expect(categories.every((c) => c.isBuiltIn), isTrue);
    expect(categories.map((c) => c.name),
        containsAll(['Spiritual', 'Mind', 'Body', 'Home', 'Create', 'Plan']));
  });

  test('default settings row is seeded with a 30-minute lead', () async {
    final settings = await database.select(database.settings).get();
    expect(settings, hasLength(1));
    expect(settings.single.bedtimeLeadMinutes, 30);
  });
}
