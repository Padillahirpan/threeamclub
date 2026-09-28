import 'package:drift/drift.dart' show Value;
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
  bool ringing = false;

  @override
  Future<void> schedule(AlarmSpec spec) async => scheduled.add(spec);

  @override
  Future<void> cancel(String alarmId) async {}

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
  final List<DateTime> scheduledAt = <DateTime>[];

  @override
  Future<void> scheduleBedtimeReminder({
    required DateTime at,
    required String title,
    required String body,
  }) async {
    scheduledAt.add(at);
  }

  @override
  Future<void> cancelBedtimeReminder() async {}
}

void main() {
  late db.AppDatabase database;
  late _FakeAlarmScheduler alarm;
  late _FakeNotificationService notifications;
  late PlanRepository plans;
  late MutableClock clock;
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

    // Signed plan: bed 21:00, wake 04:00, two promises, one checklist item.
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

  test('confirmWake and markAlarmFired write timestamps', () async {
    final morning = await repo.relevantMorning();
    expect(morning, isNotNull);
    expect(morning!.scheduledAt, DateTime(2026, 9, 29, 4, 0));

    await repo.markAlarmFired(morning.id);
    clock.set(DateTime(2026, 9, 29, 4, 2));
    await repo.confirmWake(morning.id);

    final after = await repo.relevantMorning();
    expect(after!.alarmFiredAt, isNotNull);
    expect(after.wakeConfirmedAt, DateTime(2026, 9, 29, 4, 2));
  });

  test('checklist ticks upsert against the next morning', () async {
    final morning = await repo.relevantMorning();
    final items = await database.select(database.preSleepItems).get();
    expect(items, isNotEmpty);

    await repo.setChecklistChecked(
      morningId: morning!.id,
      itemId: items.first.id,
      checked: true,
    );
    await repo.setChecklistChecked(
      morningId: morning.id,
      itemId: items.first.id,
      checked: false,
    );
    await repo.setChecklistChecked(
      morningId: morning.id,
      itemId: items.first.id,
      checked: true,
    );

    final logs = await database.select(database.preSleepLogs).get();
    expect(logs, hasLength(1));
    expect(logs.single.checked, isTrue);
  });

  test('closeMorning: kept/full/missed rules (PRD §7)', () async {
    final morning = await repo.relevantMorning();
    final logs = await database.select(database.promiseLogs).get();

    // Wake confirmed + both promises kept → full.
    await repo.confirmWake(morning!.id);
    for (final log in logs) {
      await (database.update(database.promiseLogs)
            ..where((l) => l.id.equals(log.id)))
          .write(db.PromiseLogsCompanion(
        status: const Value('kept'),
        updatedAt: Value(clock.now().toUtc()),
      ));
    }
    await repo.closeMorning(morning.id);
    var closed = await repo.relevantMorning();
    expect(closed!.result, 'full');

    // New day: rollover, one promise kept → kept.
    clock.set(DateTime(2026, 9, 29, 6, 30));
    final plan = await repo.activePlan();
    await repo.rollover(plan!);
    final day2 = await repo.relevantMorning();
    expect(day2!.date, '2026-09-30');
    expect(day2.result, 'pending');

    await repo.confirmWake(day2.id);
    final day2Logs = await database.select(database.promiseLogs).get();
    await (database.update(database.promiseLogs)
          ..where((l) => l.id.equals(day2Logs.last.id)))
        .write(db.PromiseLogsCompanion(
      status: const Value('kept'),
      updatedAt: Value(clock.now().toUtc()),
    ));
    await repo.closeMorning(day2.id);
    final closed2 = await repo.relevantMorning();
    expect(closed2!.result, 'kept');
  });

  test('closeMorning: unfinished become notFinished; missed when no wake',
      () async {
    final morning = await repo.relevantMorning();
    await repo.closeMorning(morning!.id);

    final logs = await database.select(database.promiseLogs).get();
    expect(logs.every((l) => l.status == 'notFinished'), isTrue);
    expect(logs.every((l) => l.endedEarly), isTrue);

    final closed = await repo.relevantMorning();
    expect(closed!.result, 'missed'); // wake never confirmed
  });

  test('rollover arms the next alarm and skips existing mornings', () async {
    final plan = await repo.activePlan();
    final before = alarm.scheduled.length;

    await repo.rollover(plan!);
    // Tuesday morning already exists from signing → idempotent re-register
    // of the same alarm (same id, same trigger), no duplicate morning.
    expect(alarm.scheduled.length, before + 1);
    expect(alarm.scheduled.last.triggerAtMillis,
        DateTime(2026, 9, 29, 4, 0).millisecondsSinceEpoch);
    expect((await database.select(database.mornings).get())
        .where((m) => m.date == '2026-09-29'),
        hasLength(1));

    clock.set(DateTime(2026, 9, 29, 6, 5));
    await repo.rollover(plan);
    expect(alarm.scheduled.last.triggerAtMillis,
        DateTime(2026, 9, 30, 4, 0).millisecondsSinceEpoch);

    final mornings = await database.select(database.mornings).get();
    expect(mornings.map((m) => m.date), contains('2026-09-30'));
  });

  test('syncAfterOpen closes stale mornings and opens on wake when ringing',
      () async {
    // Simulate: signed Monday, missed Tuesday (never opened), now Tue 07:00.
    clock.set(DateTime(2026, 9, 29, 7, 0));
    alarm.ringing = false;
    var openOnWake = await repo.syncAfterOpen();

    expect(openOnWake, isFalse);
    final closed = await repo.relevantMorning();
    // Tue closed as missed, Wed armed.
    expect(closed!.date, '2026-09-30');
    final allMornings = await database.select(database.mornings).get();
    expect(allMornings.firstWhere((m) => m.date == '2026-09-29').result,
        'missed');
    expect(alarm.scheduled.last.triggerAtMillis,
        DateTime(2026, 9, 30, 4, 0).millisecondsSinceEpoch);

    // Cold-start ringing: Wed 04:00, native alarm fired while app dead.
    clock.set(DateTime(2026, 9, 30, 4, 3));
    alarm.ringing = true;
    openOnWake = await repo.syncAfterOpen();
    expect(openOnWake, isTrue);
    final ringingMorning = await repo.relevantMorning();
    expect(ringingMorning!.alarmFiredAt, isNotNull);
    expect(ringingMorning.wakeConfirmedAt, isNull);
  });

  test('watchMorningBoard returns promises in plan order with categories',
      () async {
    final morning = await repo.relevantMorning();
    final board = await repo.watchMorningBoard(morning!.id).first;

    expect(board, hasLength(2));
    expect(board[0].title, 'Tahajud prayer');
    expect(board[0].categoryName, 'Spiritual');
    expect(board[0].status, 'pending');
    expect(board[1].title, 'Stretching');
    expect(board[1].durationMin, 10);
  });
}
