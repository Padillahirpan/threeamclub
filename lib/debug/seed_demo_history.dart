import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../core/clock/clock.dart';
import '../core/db/app_database.dart' as db;
import '../core/time/minute_of_day.dart' as t;

/// Debug-only demo data. The settings entry that calls this is
/// `kDebugMode`-gated, so it is compiled out of release builds and never
/// reaches the pilot.
///
/// Seeds the last 7 days of closed mornings so the dashboard — streak
/// sun, week strip, wins, promise rates, journey arc — can be checked
/// manually. Dates that already have a morning are skipped, so re-running
/// only fills gaps.
///
/// Pattern (days ago → morning result):
///   7 full · 6 full · 5 full · 4 missed · 3 full · 2 kept · 1 full
/// → streak 3, best 3, next milestone 7, and the week strip shows every
/// variant (kept / full / missed / today-pending).
///
/// Returns the number of mornings inserted.
Future<int> seedDemoHistory({
  required db.AppDatabase database,
  required Clock clock,
  Uuid uuidGen = const Uuid(),
}) async {
  final now = clock.now();

  // Reuse the user's active plan; only a pre-plan database gets the
  // throwaway demo plan below.
  var plan = await (database.select(database.plans)
        ..where((p) => p.isActive.equals(true))
        ..limit(1))
      .get()
      .then((rows) => rows.firstOrNull);

  if (plan == null) {
    final journeyStart = DateTime(now.year, now.month, now.day - 7, 20);
    final planId = uuidGen.v4();
    await database.into(database.plans).insert(
          db.PlansCompanion.insert(
            id: planId,
            wakeMinute: 4 * 60,
            bedMinute: 21 * 60,
            whyText: const Value('To build my morning before the world wakes up'),
            signedAt: journeyStart.toUtc(),
            journeyStartDate: journeyStart.toUtc(),
            isActive: true,
            createdAt: journeyStart.toUtc(),
            updatedAt: journeyStart.toUtc(),
          ),
        );
    const demoPromises = [
      (title: 'Tahajud prayer', categoryId: 'cat-spiritual', minutes: 20),
      (title: 'Exercise', categoryId: 'cat-body', minutes: 30),
      (title: 'Plan the day', categoryId: 'cat-plan', minutes: 10),
    ];
    for (var i = 0; i < demoPromises.length; i++) {
      final p = demoPromises[i];
      await database.into(database.promises).insert(
            db.PromisesCompanion.insert(
              id: uuidGen.v4(),
              planId: planId,
              categoryId: p.categoryId,
              title: p.title,
              durationMin: p.minutes,
              sortOrder: i,
              createdAt: journeyStart.toUtc(),
              updatedAt: journeyStart.toUtc(),
            ),
          );
    }
    plan = await (database.select(database.plans)
          ..where((p) => p.id.equals(planId)))
        .getSingle();
  }
  // Final local: `plan` is reassigned and captured by the transaction
  // closure below, which blocks type promotion.
  final activePlan = plan;

  // Make the journey arc agree with the seeded week: if the plan is
  // younger than the demo history, backdate the journey start.
  final earliestSeeded = DateTime(now.year, now.month, now.day - 7);
  final journeyStartDay = DateTime(
    activePlan.journeyStartDate.year,
    activePlan.journeyStartDate.month,
    activePlan.journeyStartDate.day,
  );
  if (journeyStartDay.isAfter(earliestSeeded)) {
    await (database.update(database.plans)
          ..where((p) => p.id.equals(activePlan.id)))
        .write(db.PlansCompanion(
      journeyStartDate: Value(earliestSeeded.toUtc()),
      updatedAt: Value(now.toUtc()),
    ));
  }

  final promises = await (database.select(database.promises)
        ..where((p) => p.planId.equals(activePlan.id))
        ..orderBy([(p) => OrderingTerm.asc(p.sortOrder)]))
      .get();

  const pattern = <int, String>{
    7: 'full',
    6: 'full',
    5: 'full',
    4: 'missed',
    3: 'full',
    2: 'kept',
    1: 'full',
  };
  final days = pattern.keys.toList()..sort();

  var seeded = 0;
  for (final daysAgo in days) {
    final result = pattern[daysAgo]!;
    final date = DateTime(now.year, now.month, now.day - daysAgo);
    final key = t.dateKey(date);

    final exists = await (database.select(database.mornings)
          ..where((m) => m.date.equals(key))
          ..limit(1))
        .getSingleOrNull();
    if (exists != null) continue;

    final scheduledAt = DateTime(date.year, date.month, date.day,
        activePlan.wakeMinute ~/ 60, activePlan.wakeMinute % 60);
    final closedAt = DateTime(date.year, date.month, date.day, 6); // 06:00
    final firedAt = scheduledAt.add(const Duration(seconds: 30));
    final confirmedAt = result == 'missed'
        ? null
        : scheduledAt.add(const Duration(minutes: 1));

    final morningId = uuidGen.v4();
    await database.transaction(() async {
      await database.into(database.mornings).insert(
            db.MorningsCompanion.insert(
              id: morningId,
              date: key,
              planId: activePlan.id,
              scheduledAt: scheduledAt.toUtc(),
              alarmFiredAt: Value(firedAt.toUtc()),
              wakeConfirmedAt: confirmedAt == null
                  ? const Value.absent()
                  : Value(confirmedAt.toUtc()),
              result: Value(result),
              createdAt: closedAt.toUtc(),
              updatedAt: closedAt.toUtc(),
            ),
          );
      for (var i = 0; i < promises.length; i++) {
        final promise = promises[i];
        // 'kept' day: only the first promise made it; 'missed': none ran.
        final kept = result == 'full' || (result == 'kept' && i == 0);
        final startedAt = result == 'missed'
            ? null
            : scheduledAt.add(Duration(
                minutes: 3 + i * (promise.durationMin + 2)));
        await database.into(database.promiseLogs).insert(
              db.PromiseLogsCompanion.insert(
                id: uuidGen.v4(),
                morningId: morningId,
                promiseId: promise.id,
                status: Value(kept ? 'kept' : 'notFinished'),
                startedAt: startedAt == null
                    ? const Value.absent()
                    : Value(startedAt.toUtc()),
                completedAt: kept && startedAt != null
                    ? Value(startedAt
                        .add(Duration(seconds: promise.durationMin * 60))
                        .toUtc())
                    : const Value.absent(),
                plannedSec: promise.durationMin * 60,
                endedEarly: Value(!kept),
                createdAt: closedAt.toUtc(),
                updatedAt: closedAt.toUtc(),
              ),
            );
      }
    });
    seeded++;
  }
  return seeded;
}
