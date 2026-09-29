import 'package:drift/drift.dart' show OrderingTerm, Variable;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:subuhan/core/clock/clock.dart';
import 'package:subuhan/core/db/app_database.dart' as db;
import 'package:subuhan/debug/seed_demo_history.dart';
import 'package:subuhan/features/dashboard/domain/streak.dart';

void main() {
  // "Today" for all scenarios: Tuesday 2026-09-29, noon.
  final today = DateTime(2026, 9, 29, 12);

  test('seeds 7 days with the demo pattern and is idempotent', () async {
    final database = db.AppDatabase.connect(NativeDatabase.memory());
    final clock = MutableClock(today);

    final seeded = await seedDemoHistory(database: database, clock: clock);
    expect(seeded, 7);

    final rows = await (database.select(database.mornings)
          ..orderBy([(m) => OrderingTerm.asc(m.date)]))
        .get();
    expect(rows.length, 7);

    final resultByDaysAgo = <int, String>{
      for (final r in rows)
        -DateTime.parse(r.date).difference(DateTime(2026, 9, 29)).inDays:
            r.result,
    };
    expect(resultByDaysAgo[1], 'full');
    expect(resultByDaysAgo[2], 'kept');
    expect(resultByDaysAgo[3], 'full');
    expect(resultByDaysAgo[4], 'missed');
    expect(resultByDaysAgo[5], 'full');
    expect(resultByDaysAgo[6], 'full');
    expect(resultByDaysAgo[7], 'full');

    // Missed day: alarm fired but never confirmed.
    final missed = rows.firstWhere((r) => r.result == 'missed');
    expect(missed.wakeConfirmedAt, isNull);
    expect(missed.alarmFiredAt, isNotNull);

    // Partial day: exactly one of three promises kept.
    final partialLogs = await database.customSelect(
      'SELECT l.status AS status FROM promise_logs l '
      'JOIN mornings m ON m.id = l.morning_id WHERE m.date = ?',
      variables: [Variable.withString('2026-09-27')],
      readsFrom: {database.promiseLogs, database.mornings},
    ).get();
    expect(partialLogs.length, 3);
    expect(
      partialLogs
          .where((r) => r.read<String>('status') == 'kept')
          .length,
      1,
    );

    // Streak math over the seeded week (what the dashboard derives).
    final plan = await (database.select(database.plans)
          ..where((p) => p.isActive.equals(true)))
        .getSingle();
    final journeyStart = DateTime(plan.journeyStartDate.year,
        plan.journeyStartDate.month, plan.journeyStartDate.day);
    final streak = computeStreak(
      mornings: [
        for (final r in rows) StreakMorning(date: r.date, result: r.result),
      ],
      journeyStart: journeyStart,
      today: today,
    );
    expect(streak.current, 3);
    expect(streak.best, 3);
    expect(streak.nextMilestone, 7);
    expect(streak.journeyDay, 8); // journey start backdated 7 days
    expect(journeyStart, DateTime(2026, 9, 22));

    // Re-running only fills gaps: nothing left to seed.
    expect(await seedDemoHistory(database: database, clock: clock), 0);

    await database.close();
  });

  test('reuses an existing active plan and its promises', () async {
    final database = db.AppDatabase.connect(NativeDatabase.memory());
    final clock = MutableClock(today);

    final planId = 'plan-existing';
    await database.into(database.plans).insert(
          db.PlansCompanion.insert(
            id: planId,
            wakeMinute: 3 * 60 + 30,
            bedMinute: 21 * 60,
            signedAt: today.subtract(const Duration(days: 2)).toUtc(),
            journeyStartDate: today.subtract(const Duration(days: 2)).toUtc(),
            isActive: true,
            createdAt: today.toUtc(),
            updatedAt: today.toUtc(),
          ),
        );
    for (var i = 0; i < 2; i++) {
      await database.into(database.promises).insert(
            db.PromisesCompanion.insert(
              id: 'promise-$i',
              planId: planId,
              categoryId: 'cat-mind',
              title: 'Promise $i',
              durationMin: 15,
              sortOrder: i,
              createdAt: today.toUtc(),
              updatedAt: today.toUtc(),
            ),
          );
    }

    expect(await seedDemoHistory(database: database, clock: clock), 7);

    final mornings = await (database.select(database.mornings)
          ..where((m) => m.planId.equals(planId)))
        .get();
    expect(mornings.length, 7);

    final logs = await database.select(database.promiseLogs).get();
    expect(logs.length, 14); // 7 mornings x 2 promises

    // Young plan got its journey start backdated to match the week.
    final plan = await (database.select(database.plans)
          ..where((p) => p.id.equals(planId)))
        .getSingle();
    expect(
      DateTime(plan.journeyStartDate.year, plan.journeyStartDate.month,
          plan.journeyStartDate.day),
      DateTime(2026, 9, 22),
    );

    await database.close();
  });
}
