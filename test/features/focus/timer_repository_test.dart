import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:subuhan/core/clock/clock.dart';
import 'package:subuhan/core/db/app_database.dart' as db;
import 'package:subuhan/core/platform/alarm_scheduler.dart';
import 'package:subuhan/core/platform/notification_service.dart';
import 'package:subuhan/features/focus/data/timer_repository.dart';
import 'package:subuhan/features/plan/data/morning_repository.dart';
import 'package:subuhan/features/plan/data/plan_repository.dart';
import 'package:subuhan/features/plan/domain/plan_draft.dart';

class _FakeAlarmScheduler implements AlarmScheduler {
  @override
  Future<void> schedule(AlarmSpec spec) async {}

  @override
  Future<void> cancel(String alarmId) async {}

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
  final List<DateTime> timerScheduledAt = <DateTime>[];
  int timerCancels = 0;

  @override
  Future<void> scheduleBedtimeReminder({
    required DateTime at,
    required String title,
    required String body,
  }) async {}

  @override
  Future<void> cancelBedtimeReminder() async {}

  @override
  Future<void> scheduleTimerComplete({
    required DateTime at,
    required String title,
    required String body,
    required String payload,
  }) async {
    timerScheduledAt.add(at);
  }

  @override
  Future<void> cancelTimerComplete() async {
    timerCancels++;
  }
}

void main() {
  late db.AppDatabase database;
  late _FakeNotificationService notifications;
  late PlanRepository plans;
  late MorningRepository mornings;
  late MutableClock clock;
  late TimerRepository repo;

  setUp(() async {
    database = db.AppDatabase.connect(NativeDatabase.memory());
    notifications = _FakeNotificationService();
    clock = MutableClock(DateTime(2026, 9, 28, 20, 0)); // Mon 8pm
    plans = PlanRepository(
      database: database,
      alarmScheduler: _FakeAlarmScheduler(),
      notificationService: notifications,
      clock: clock,
    );
    mornings = MorningRepository(
      database: database,
      alarmScheduler: _FakeAlarmScheduler(),
      notificationService: notifications,
      clock: clock,
    );
    repo = TimerRepository(
      database: database,
      notifications: notifications,
      clock: clock,
      mornings: mornings,
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

  // Advance to the focus window so a relevant morning exists.
  Future<RelevantMorning> focusMorning() async {
    clock.set(DateTime(2026, 9, 29, 4, 30));
    final morning = await mornings.relevantMorning();
    expect(morning, isNotNull);
    await mornings.confirmWake(morning!.id);
    return morning;
  }

  /// Real promise ids (signPlan mints UUIDs, not the draft ids).
  Future<List<String>> promiseIds() async {
    final rows = await database.select(database.promises).get();
    rows.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return rows.map((p) => p.id).toList();
  }

  test('start marks inProgress, stamps startedAt and schedules the '
      'completion notification', () async {
    final morning = await focusMorning();
    final ids = await promiseIds();
    clock.set(DateTime(2026, 9, 29, 4, 31));

    final session = await repo.start(
      morningId: morning.id,
      promiseId: ids.first,
      completeTitle: '3AM Club',
      completeBody: 'Tahajud prayer',
    );

    expect(session, isNotNull);
    expect(session!.isRunning, isTrue);
    expect(session.startedAt, DateTime(2026, 9, 29, 4, 31));
    expect(session.plannedSec, 20 * 60);
    expect(notifications.timerScheduledAt.single,
        DateTime(2026, 9, 29, 4, 51)); // start + 20min
  });

  test('start is idempotent: one promise at a time returns the running '
      'session', () async {
    final morning = await focusMorning();
    final ids = await promiseIds();

    final first = await repo.start(
      morningId: morning.id,
      promiseId: ids.first,
      completeTitle: 't',
      completeBody: 'b',
    );
    final second = await repo.start(
      morningId: morning.id,
      promiseId: ids.last, // different promise — must not start
      completeTitle: 't',
      completeBody: 'b',
    );

    expect(second!.promiseId, ids.first);
    expect(second.logId, first!.logId);
    expect(notifications.timerScheduledAt, hasLength(1));
  });

  test('session survives a kill/restart (new repository, same DB)',
      () async {
    final morning = await focusMorning();
    final ids = await promiseIds();
    clock.set(DateTime(2026, 9, 29, 4, 31));
    await repo.start(
      morningId: morning.id,
      promiseId: ids.first,
      completeTitle: 't',
      completeBody: 'b',
    );

    // Simulated restart: fresh repositories over the same database.
    final clock2 = MutableClock(DateTime(2026, 9, 29, 4, 41)); // +10 min
    final repo2 = TimerRepository(
      database: database,
      notifications: notifications,
      clock: clock2,
      mornings: MorningRepository(
        database: database,
        alarmScheduler: _FakeAlarmScheduler(),
        notificationService: notifications,
        clock: clock2,
      ),
    );

    final resumed = await repo2.activeSession(morning.id);
    expect(resumed, isNotNull);
    expect(resumed!.isRunning, isTrue);
    // 20min planned − 10min elapsed — derived from the stored startedAt,
    // never an in-memory counter (FR-7.4).
    expect(resumed.remainingSec(clock2.now()), 10 * 60);
  });

  test('remaining clamps at zero when the wall clock runs past the end',
      () async {
    final morning = await focusMorning();
    final ids = await promiseIds();
    clock.set(DateTime(2026, 9, 29, 4, 31));
    final session = await repo.start(
      morningId: morning.id,
      promiseId: ids.first,
      completeTitle: 't',
      completeBody: 'b',
    );

    // +2 hours past the planned end.
    final late = DateTime(2026, 9, 29, 6, 51);
    expect(session!.remainingSec(late), 0);
    expect(session.canComplete(late), isTrue);
  });

  test('complete is guarded before the countdown finishes', () async {
    final morning = await focusMorning();
    final ids = await promiseIds();
    clock.set(DateTime(2026, 9, 29, 4, 31));
    final session = await repo.start(
      morningId: morning.id,
      promiseId: ids.first,
      completeTitle: 't',
      completeBody: 'b',
    );

    // Halfway through — must be rejected (FR-7.7).
    clock.set(DateTime(2026, 9, 29, 4, 41));
    final early = await repo.complete(session!.logId);
    expect(early, isFalse);

    final stillRunning = await repo.activeSession(morning.id);
    expect(stillRunning!.isRunning, isTrue);

    // After the countdown — accepted.
    clock.set(DateTime(2026, 9, 29, 4, 52));
    final ok = await repo.complete(session.logId);
    expect(ok, isTrue);
    expect(notifications.timerCancels, 1);

    final row = await (database.select(database.promiseLogs)
          ..where((l) => l.id.equals(session.logId)))
        .getSingle();
    expect(row.status, 'kept');
    expect(row.completedAt, isNotNull);
    expect(await repo.activeSession(morning.id), isNull);
  });

  test('endEarly marks notFinished (never Failed) and cancels the '
      'notification', () async {
    final morning = await focusMorning();
    final ids = await promiseIds();
    clock.set(DateTime(2026, 9, 29, 4, 31));
    final session = await repo.start(
      morningId: morning.id,
      promiseId: ids.first,
      completeTitle: 't',
      completeBody: 'b',
    );

    await repo.endEarly(session!.logId);

    final row = await (database.select(database.promiseLogs)
          ..where((l) => l.id.equals(session.logId)))
        .getSingle();
    expect(row.status, 'notFinished');
    expect(row.endedEarly, isTrue);
    expect(notifications.timerCancels, 1);
    expect(await repo.activeSession(morning.id), isNull);
  });

  test('start rejects a promise that is no longer pending', () async {
    final morning = await focusMorning();
    final ids = await promiseIds();
    clock.set(DateTime(2026, 9, 29, 4, 31));
    final session = await repo.start(
      morningId: morning.id,
      promiseId: ids.first,
      completeTitle: 't',
      completeBody: 'b',
    );

    // End early, then try to start the same promise again.
    await repo.endEarly(session!.logId);
    final again = await repo.start(
      morningId: morning.id,
      promiseId: ids.first,
      completeTitle: 't',
      completeBody: 'b',
    );
    expect(again, isNull);
  });
}
