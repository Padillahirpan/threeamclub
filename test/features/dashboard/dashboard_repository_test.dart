import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:subuhan/core/clock/clock.dart';
import 'package:subuhan/core/db/app_database.dart' as db;
import 'package:subuhan/core/platform/alarm_scheduler.dart';
import 'package:subuhan/core/platform/notification_service.dart';
import 'package:subuhan/core/time/minute_of_day.dart' as t;
import 'package:subuhan/features/dashboard/data/dashboard_repository.dart';
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
  @override
  Future<void> scheduleBedtimeReminder({
    required DateTime at,
    required String title,
    required String body,
  }) async {}

  @override
  Future<void> cancelBedtimeReminder() async {}
}

void main() {
  late db.AppDatabase database;
  late MutableClock clock;
  late PlanRepository plans;
  late MorningRepository mornings;
  late DashboardRepository repo;

  // "Today" for all scenarios: Tuesday 2026-09-29, noon.
  final today = DateTime(2026, 9, 29, 12, 0);

  setUp(() async {
    database = db.AppDatabase.connect(NativeDatabase.memory());
    clock = MutableClock(today);
    plans = PlanRepository(
      database: database,
      alarmScheduler: _FakeAlarmScheduler(),
      notificationService: _FakeNotificationService(),
      clock: clock,
    );
    mornings = MorningRepository(
      database: database,
      alarmScheduler: _FakeAlarmScheduler(),
      notificationService: _FakeNotificationService(),
      clock: clock,
    );
    repo = DashboardRepository(database: database, clock: clock);

    await plans.signPlan(
      const PlanDraftState(
        bedMinute: 21 * 60,
        wakeMinute: 4 * 60,
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

  /// Creates a morning [daysBack] before today with [result] and optional
  /// wake confirmation at 04:0[min]. Promise logs follow the result.
  Future<void> historyDay(int daysBack, String result, {int min = 5}) async {
    final plan = await mornings.activePlan();
    final date = DateTime(today.year, today.month, today.day - daysBack);
    await mornings.armMorningAt(
      DateTime(date.year, date.month, date.day, 4, 0),
      plan!,
    );

    final morning = await (database.select(database.mornings)
          ..where((m) => m.date.equals(t.dateKey(date))))
        .getSingle();

    final now = DateTime(date.year, date.month, date.day, 4, min).toUtc();
    if (result != 'missed') {
      await (database.update(database.mornings)
            ..where((m) => m.id.equals(morning.id)))
          .write(db.MorningsCompanion(
        wakeConfirmedAt: Value(now),
        updatedAt: Value(now),
      ));
    }
    if (result != 'pending') {
      await (database.update(database.mornings)
            ..where((m) => m.id.equals(morning.id)))
          .write(db.MorningsCompanion(
        result: Value(result),
        updatedAt: Value(now),
      ));
    }

    final logs = await (database.select(database.promiseLogs)
          ..where((l) => l.morningId.equals(morning.id)))
        .get();
    for (var i = 0; i < logs.length; i++) {
      final kept = result == 'full' || (result == 'kept' && i == 0);
      await (database.update(database.promiseLogs)
            ..where((l) => l.id.equals(logs[i].id)))
          .write(db.PromiseLogsCompanion(
        status: Value(result == 'missed' || result == 'rest'
            ? 'notFinished'
            : kept
                ? 'kept'
                : 'notFinished'),
        updatedAt: Value(now),
      ));
    }
  }

  test('empty history shows the welcoming state, journey day 1, '
      'tonight card', () async {
    final data = await repo.watchDashboard().first;

    expect(data.hasHistory, isFalse);
    expect(data.streak.current, 0);
    expect(data.streak.journeyDay, 1); // signed today evening
    expect(data.todayResult, 'none');
    // Tonight = the morning signed for tomorrow 04:00.
    expect(data.tonight.wakeAt, DateTime(2026, 9, 30, 4, 0));
    expect(data.tonight.bedMinute, 21 * 60);
    expect(data.tonight.promiseCount, 2);
    expect(data.tonight.isRest, isFalse);
    expect(data.wins.totalMinutesKept, 0);
    expect(data.wins.earliestWakeMinute, isNull);
  });

  test('streak counts kept/full, rest neutral, missed resets; week strip '
      'maps results', () async {
    await historyDay(9, 'missed');
    await historyDay(8, 'kept');
    await historyDay(7, 'kept');
    await historyDay(6, 'kept');
    await historyDay(5, 'rest');
    await historyDay(4, 'kept');
    await historyDay(3, 'full');
    await historyDay(2, 'kept');
    await historyDay(1, 'kept');

    final data = await repo.watchDashboard().first;

    // Current: yesterday kept, 2 kept, 3 full, 4 kept, 5 rest (neutral),
    // 6..8 kept → 7 kept/full after the rest + none broken across it.
    expect(data.streak.current, 7);
    expect(data.streak.best, 7);
    expect(data.streak.nextMilestone, 14);

    // Week strip = last 7 days (Sep 23..29): rest(23)? — Sep 23 is 6 back.
    final keys = [for (final d in data.week) t.dateKey(d.date)];
    expect(keys.first, t.dateKey(DateTime(2026, 9, 23)));
    expect(keys.last, t.dateKey(DateTime(2026, 9, 29)));
    expect(data.week[0].result, 'kept'); // Sep 23 = 6 back
    expect(data.week[1].result, 'rest'); // Sep 24
    expect(data.week[3].result, 'full'); // Sep 26
    expect(data.week[6].result, 'none'); // today, no morning today
  });

  test('wins: kept minutes, earliest wake, most-kept promise', () async {
    await historyDay(2, 'full', min: 12); // both kept: 20+10 min, 04:12
    await historyDay(1, 'kept', min: 7); // first promise only: 20 min, 04:07

    final data = await repo.watchDashboard().first;

    expect(data.wins.totalMinutesKept, 30 + 20);
    expect(data.wins.earliestWakeMinute, 4 * 60 + 7);
    expect(data.wins.mostKeptPromiseTitle, 'Tahajud prayer');
    expect(data.wins.mostKeptCount, 2);
  });

  test('promise rates cover the last 30 days for the active plan',
      () async {
    await historyDay(2, 'full');
    await historyDay(1, 'kept');

    final data = await repo.watchDashboard().first;

    expect(data.rates, hasLength(2));
    final tahajud =
        data.rates.firstWhere((r) => r.title == 'Tahajud prayer');
    expect(tahajud.kept, 2);
    expect(tahajud.total, 2);
    final stretch =
        data.rates.firstWhere((r) => r.title == 'Stretching');
    expect(stretch.kept, 1); // only the full morning
    expect(stretch.total, 2);
  });

  test('missed today with a broken streak requests fresh-start framing',
      () async {
    await historyDay(1, 'missed');

    final data = await repo.watchDashboard().first;
    expect(data.todayResult, 'none'); // today itself has no morning
    expect(data.showFreshStart, isFalse); // only when TODAY missed
  });

  test('full morning today triggers hero + celebration conditions',
      () async {
    // Re-arm today's morning (the signed one is for tomorrow).
    final plan = await mornings.activePlan();
    await mornings.armMorningAt(DateTime(2026, 9, 29, 4, 0), plan!);
    final morning = await (database.select(database.mornings)
          ..where((m) => m.date.equals('2026-09-29')))
        .getSingle();

    final now = DateTime(2026, 9, 29, 4, 9).toUtc();
    await (database.update(database.mornings)
          ..where((m) => m.id.equals(morning.id)))
        .write(db.MorningsCompanion(
      wakeConfirmedAt: Value(now),
      result: const Value('full'),
      updatedAt: Value(now),
    ));
    final logs = await (database.select(database.promiseLogs)
          ..where((l) => l.morningId.equals(morning.id)))
        .get();
    for (final log in logs) {
      await (database.update(database.promiseLogs)
            ..where((l) => l.id.equals(log.id)))
          .write(db.PromiseLogsCompanion(
        status: const Value('kept'),
        updatedAt: Value(now),
      ));
    }

    final data = await repo.watchDashboard().first;
    expect(data.todayResult, 'full');
    expect(data.todayIsFull, isTrue);
    expect(data.todayKept, 2);
    expect(data.todayTotal, 2);
    expect(data.hasHistory, isTrue);
  });

  test('rest tomorrow is reflected in the tonight card', () async {
    await historyDay(1, 'kept');

    // Mark tomorrow's (signed) morning as rest directly.
    final tomorrow = await (database.select(database.mornings)
          ..where((m) => m.date.equals('2026-09-30')))
        .getSingle();
    await (database.update(database.mornings)
          ..where((m) => m.id.equals(tomorrow.id)))
        .write(const db.MorningsCompanion(result: Value('rest')));

    final data = await repo.watchDashboard().first;
    expect(data.tonight.isRest, isTrue);
  });

  group('freshStartLandmark (FR-9.2)', () {
    test('plain weekday → tomorrow', () {
      // Tue 2026-09-29 → Wed is a plain day.
      expect(freshStartLandmark(DateTime(2026, 9, 29)),
          FreshStartLandmark.tomorrow);
    });

    test('Sunday → Monday', () {
      // 2026-09-27 is a Sunday; tomorrow is Monday.
      expect(freshStartLandmark(DateTime(2026, 9, 27)),
          FreshStartLandmark.monday);
    });

    test('last day of month → the 1st', () {
      expect(freshStartLandmark(DateTime(2026, 9, 30)),
          FreshStartLandmark.firstOfMonth);
    });
  });
}
