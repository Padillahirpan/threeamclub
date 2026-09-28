import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:subuhan/core/clock/clock.dart';
import 'package:subuhan/core/db/app_database.dart' as db;
import 'package:subuhan/core/platform/alarm_scheduler.dart';
import 'package:subuhan/core/platform/notification_service.dart';
import 'package:subuhan/features/plan/data/morning_repository.dart';
import 'package:subuhan/features/plan/data/plan_repository.dart';
import 'package:subuhan/features/plan/domain/plan_draft.dart';

class _FakeAlarmScheduler implements AlarmScheduler {
  final List<AlarmSpec> scheduled = <AlarmSpec>[];
  final List<String> cancelled = <String>[];

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
  Future<bool> get isRinging async => false;
}

class _FakeNotificationService extends NotificationService {
  int reminderCancels = 0;

  @override
  Future<void> scheduleBedtimeReminder({
    required DateTime at,
    required String title,
    required String body,
  }) async {}

  @override
  Future<void> cancelBedtimeReminder() async {
    reminderCancels++;
  }

  @override
  Future<void> scheduleTimerComplete({
    required DateTime at,
    required String title,
    required String body,
    required String payload,
  }) async {}

  @override
  Future<void> cancelTimerComplete() async {}
}

void main() {
  late db.AppDatabase database;
  late _FakeAlarmScheduler alarm;
  late _FakeNotificationService notifications;
  late MutableClock clock;
  late PlanRepository plans;
  late MorningRepository repo;

  setUp(() async {
    database = db.AppDatabase.connect(NativeDatabase.memory());
    alarm = _FakeAlarmScheduler();
    notifications = _FakeNotificationService();
    clock = MutableClock(DateTime(2026, 9, 28, 20, 0)); // Mon 8pm
    plans = PlanRepository(
      database: database,
      alarmScheduler: alarm,
      notificationService: notifications,
      clock: clock,
    );
    repo = MorningRepository(
      database: database,
      alarmScheduler: alarm,
      notificationService: notifications,
      clock: clock,
    );

    await plans.signPlan(
      const PlanDraftState(
        bedMinute: 21 * 60,
        wakeMinute: 4 * 60,
        checklist: [
          ChecklistItemDraft(id: 'chk-1', title: 'Phone on charge'),
        ],
        promises: [
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
      ),
      alarmTitle: '3AM Club',
      alarmBody: 'a',
      reminderTitle: 't',
      reminderBody: 'b',
    );
  });

  tearDown(() async {
    await database.close();
  });

  test('markRestDay cancels the alarm, records rest, arms the next day',
      () async {
    // Tuesday 12:00: Monday's alarm never confirmed → closed as missed,
    // rollover arms Wednesday.
    clock.set(DateTime(2026, 9, 29, 12, 0));
    await repo.syncAfterOpen();

    final wednesday = await repo.relevantMorning();
    expect(wednesday!.date, '2026-09-30');
    expect(wednesday.result, 'pending');

    final ok = await repo.markRestDay(wednesday.id);
    expect(ok, isTrue);

    // Rest recorded on the Wednesday morning.
    final rest = await repo.relevantMorning();
    expect(rest!.result, 'rest');

    // The Wednesday alarm was cancelled and the reminder cleared.
    expect(alarm.cancelled, contains('wake-${wednesday.id}'));
    expect(notifications.reminderCancels, greaterThanOrEqualTo(1));

    // The chain continues: Thursday's morning exists and is armed.
    final mornings = await database.select(database.mornings).get();
    expect(mornings.map((m) => m.date), contains('2026-10-01'));
    expect(
      alarm.scheduled.any((spec) =>
          spec.alarmId != 'wake-${wednesday.id}' &&
          DateTime.fromMillisecondsSinceEpoch(spec.triggerAtMillis)
              .isAfter(DateTime(2026, 9, 30, 12, 0))),
      isTrue,
    );
  });

  test('rolling 7-day limit: a second rest day is refused', () async {
    clock.set(DateTime(2026, 9, 29, 12, 0));
    await repo.syncAfterOpen();
    final wednesday = await repo.relevantMorning();
    expect(await repo.markRestDay(wednesday!.id), isTrue);

    // Thursday was armed at rest time; resting again is over the limit.
    final thursday = await (database.select(database.mornings)
          ..where((m) => m.date.equals('2026-10-01')))
        .getSingle();
    expect(await repo.canMarkRestDay(), isFalse);
    expect(await repo.markRestDay(thursday.id), isFalse);
  });

  test('the limit frees up after 7 days', () async {
    clock.set(DateTime(2026, 9, 29, 12, 0));
    await repo.syncAfterOpen();
    await repo.markRestDay((await repo.relevantMorning())!.id);

    // 8 days after the rest date the window has moved on.
    clock.set(DateTime(2026, 10, 8, 12, 0));
    await repo.syncAfterOpen();
    expect(await repo.canMarkRestDay(), isTrue);
  });

  test('an already-fired morning cannot be rested', () async {
    clock.set(DateTime(2026, 9, 29, 12, 0));
    await repo.syncAfterOpen();
    final wednesday = await repo.relevantMorning();

    // Jump to the wake time: the alarm window has arrived.
    clock.set(DateTime(2026, 9, 30, 4, 0));
    await repo.markAlarmFired(wednesday!.id);
    expect(await repo.markRestDay(wednesday.id), isFalse);
  });

  test('syncAfterOpen never re-arms a rest morning', () async {
    clock.set(DateTime(2026, 9, 29, 12, 0));
    await repo.syncAfterOpen();
    final wednesday = await repo.relevantMorning();
    await repo.markRestDay(wednesday!.id);

    final restSchedulesBefore = alarm.scheduled
        .where((spec) => spec.alarmId == 'wake-${wednesday.id}')
        .length;
    // Multiple app opens between rest and the following morning.
    for (final time in [
      DateTime(2026, 9, 30, 8, 0), // rest-day morning
      DateTime(2026, 9, 30, 20, 0), // rest-day evening
    ]) {
      clock.set(time);
      await repo.syncAfterOpen();
    }

    // No new schedule was made for the rest morning after cancellation.
    final restSchedulesAfter = alarm.scheduled
        .where((spec) => spec.alarmId == 'wake-${wednesday.id}')
        .length;
    expect(restSchedulesAfter, restSchedulesBefore);
    // And the currently armed alarm points at the day after the rest.
    expect(alarm.scheduled.last.alarmId, isNot('wake-${wednesday.id}'));
  });

  test('a rest morning stays streak-neutral in computeStreak feed',
      () async {
    clock.set(DateTime(2026, 9, 29, 12, 0));
    await repo.syncAfterOpen();
    final wednesday = await repo.relevantMorning();
    await repo.markRestDay(wednesday!.id);

    final rows = await (database.select(database.mornings)
          ..where((m) => m.date.equals('2026-09-30')))
        .getSingle();
    expect(rows.result, 'rest');
    expect(rows.wakeConfirmedAt, isNull);
  });
}
