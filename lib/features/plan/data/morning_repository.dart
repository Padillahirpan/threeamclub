import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/clock/clock.dart';
import '../../../core/db/app_database.dart' as db;
import '../../../core/db/database_provider.dart';
import '../../../core/platform/alarm_scheduler.dart';
import '../../../core/platform/notification_service.dart';
import '../../../core/time/minute_of_day.dart' as t;
import 'plan_repository.dart';

/// The morning relevant "now": the latest morning dated today or tomorrow
/// (ARCHITECTURE.md §7). Includes promise counts for phase + progress.
class RelevantMorning {
  const RelevantMorning({
    required this.id,
    required this.date,
    required this.scheduledAt,
    this.alarmFiredAt,
    this.wakeConfirmedAt,
    required this.result,
    required this.totalPromises,
    required this.keptPromises,
  });

  final String id;
  final String date;
  final DateTime scheduledAt; // local
  final DateTime? alarmFiredAt; // local
  final DateTime? wakeConfirmedAt; // local
  final String result;
  final int totalPromises;
  final int keptPromises;

  bool get allPromisesKept => totalPromises > 0 && keptPromises == totalPromises;

  DateTime get closesAt => DateTime(
        scheduledAt.year,
        scheduledAt.month,
        scheduledAt.day,
        t.morningCloseMinute ~/ 60,
        t.morningCloseMinute % 60,
      );

  bool get isStale => result == 'pending' && DateTime.now().isAfter(closesAt);
}

/// One row of the focus board: a promise with its log status for a morning.
class MorningPromise {
  const MorningPromise({
    required this.promiseId,
    required this.title,
    this.description,
    required this.durationMin,
    required this.status,
    required this.categoryName,
    required this.iconKey,
    required this.colorKey,
  });

  final String promiseId;
  final String title;
  final String? description;
  final int durationMin;
  final String status; // pending / inProgress / kept / notFinished
  final String categoryName;
  final String iconKey;
  final String colorKey;
}

/// One pre-sleep checklist row with its tick state for a morning.
class NightChecklistItem {
  const NightChecklistItem({
    required this.itemId,
    required this.title,
    required this.checked,
  });

  final String itemId;
  final String title;
  final bool checked;
}

/// Everything that happens to a morning: wake confirmation, checklist
/// ticks, the 06:00 close, and the rollover that arms the next day
/// (PRD FR-5.4/5.5, FR-6.5, §7 business rules; ARCHITECTURE.md §6, §12).
class MorningRepository {
  MorningRepository({
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

  // ---- Reads ---------------------------------------------------------------

  Stream<db.PlanRow?> watchActivePlan() {
    final query = (_db.select(_db.plans)
          ..where((p) => p.isActive.equals(true))
          ..limit(1))
        .watch();
    return query.map((rows) => rows.firstOrNull);
  }

  Future<db.PlanRow?> activePlan() async {
    final rows = await (_db.select(_db.plans)
          ..where((p) => p.isActive.equals(true))
          ..limit(1))
        .get();
    return rows.firstOrNull;
  }

  /// Latest morning dated today or tomorrow with promise counts (live via
  /// drift `watch()`; re-subscribed by the provider each phase tick so the
  /// date window rolls over at midnight).
  Stream<RelevantMorning?> watchRelevantMorning() =>
      _relevantMorningQuery().watch().map(_mapFirst);

  Future<RelevantMorning?> relevantMorning() async =>
      _mapFirst(await _relevantMorningQuery().get());

  dynamic _relevantMorningQuery() {
    final now = _clock.now();
    final todayKey = t.dateKey(now);
    final tomorrowKey = t.dateKey(now.add(const Duration(days: 1)));
    return _db.customSelect(
      'SELECT m.id AS id, m.date AS date, m.scheduled_at AS scheduled_at, '
      'm.alarm_fired_at AS alarm_fired_at, '
      'm.wake_confirmed_at AS wake_confirmed_at, m.result AS result, '
      '(SELECT COUNT(*) FROM promise_logs l WHERE l.morning_id = m.id) AS total, '
      "(SELECT COUNT(*) FROM promise_logs l WHERE l.morning_id = m.id "
      "AND l.status = 'kept') AS kept "
      'FROM mornings m '
      'WHERE m.date IN (?, ?) '
      'ORDER BY m.scheduled_at DESC LIMIT 1',
      variables: [Variable.withString(todayKey), Variable.withString(tomorrowKey)],
      readsFrom: {_db.mornings, _db.promiseLogs},
    );
  }

  RelevantMorning? _mapFirst(List<QueryRow> rows) {
    final row = rows.firstOrNull;
    if (row == null) return null;
    return RelevantMorning(
      id: row.read<String>('id'),
      date: row.read<String>('date'),
      scheduledAt: row.read<DateTime>('scheduled_at').toLocal(),
      alarmFiredAt: row.readNullable<DateTime>('alarm_fired_at')?.toLocal(),
      wakeConfirmedAt:
          row.readNullable<DateTime>('wake_confirmed_at')?.toLocal(),
      result: row.read<String>('result'),
      totalPromises: row.read<int>('total'),
      keptPromises: row.readNullable<int>('kept') ?? 0,
    );
  }

  /// Board rows for the focus screen (promise + log + category), in plan
  /// order. Live via drift `watch()`.
  Stream<List<MorningPromise>> watchMorningBoard(String morningId) {
    final query = _db.customSelect(
      'SELECT p.id AS promise_id, p.title AS title, p.description AS description, '
      'p.duration_min AS duration_min, l.status AS status, '
      'c.name AS category_name, c.icon_key AS icon_key, c.color_key AS color_key '
      'FROM promise_logs l '
      'JOIN promises p ON p.id = l.promise_id '
      'JOIN categories c ON c.id = p.category_id '
      'WHERE l.morning_id = ? '
      'ORDER BY p.sort_order ASC',
      variables: [Variable.withString(morningId)],
      readsFrom: {_db.promiseLogs, _db.promises, _db.categories},
    );
    return query.watch().map((rows) => [
          for (final row in rows)
            MorningPromise(
              promiseId: row.read<String>('promise_id'),
              title: row.read<String>('title'),
              description: row.readNullable<String>('description'),
              durationMin: row.read<int>('duration_min'),
              status: row.read<String>('status'),
              categoryName: row.read<String>('category_name'),
              iconKey: row.read<String>('icon_key'),
              colorKey: row.read<String>('color_key'),
            ),
        ]);
  }

  /// Pre-sleep checklist for the night screen with tick state.
  Stream<List<NightChecklistItem>> watchNightChecklist({
    required String planId,
    required String morningId,
  }) {
    final query = _db.customSelect(
      'SELECT i.id AS item_id, i.title AS title, '
      'COALESCE(pl.checked, 0) AS checked '
      'FROM pre_sleep_items i '
      'LEFT JOIN pre_sleep_logs pl ON pl.item_id = i.id AND pl.morning_id = ? '
      'WHERE i.plan_id = ? '
      'ORDER BY i.sort_order ASC',
      variables: [
        Variable.withString(morningId),
        Variable.withString(planId),
      ],
      readsFrom: {_db.preSleepItems, _db.preSleepLogs},
    );
    return query.watch().map((rows) => [
          for (final row in rows)
            NightChecklistItem(
              itemId: row.read<String>('item_id'),
              title: row.read<String>('title'),
              checked: row.read<int>('checked') == 1,
            ),
        ]);
  }

  Future<int> bedtimeLeadMinutes() async {
    final row = await (_db.select(_db.settings)
          ..where((s) => s.id.equals('default')))
        .getSingleOrNull();
    return row?.bedtimeLeadMinutes ?? 30;
  }

  // ---- Writes --------------------------------------------------------------

  /// FR-5.4: record wake confirmed with timestamp.
  Future<void> confirmWake(String morningId) async {
    await (_db.update(_db.mornings)..where((m) => m.id.equals(morningId)))
        .write(db.MorningsCompanion(
      wakeConfirmedAt: Value(_clock.now().toUtc()),
      updatedAt: Value(_clock.now().toUtc()),
    ));
  }

  /// Backfills alarmFiredAt when the native alarm fired while the app was
  /// dead (ARCHITECTURE.md §10 — events are cached natively).
  Future<void> markAlarmFired(String morningId) async {
    final row = await (_db.select(_db.mornings)
          ..where((m) => m.id.equals(morningId)))
        .getSingleOrNull();
    if (row == null || row.alarmFiredAt != null) return;
    await (_db.update(_db.mornings)..where((m) => m.id.equals(morningId)))
        .write(db.MorningsCompanion(
      alarmFiredAt: Value(_clock.now().toUtc()),
      updatedAt: Value(_clock.now().toUtc()),
    ));
  }

  /// FR-4.2: optional checklist ticks, stored against the morning they
  /// belong to (evening of Mon → Tue's morning, PRD §7 day model).
  Future<void> setChecklistChecked({
    required String morningId,
    required String itemId,
    required bool checked,
  }) async {
    final existing = await (_db.select(_db.preSleepLogs)
          ..where((l) =>
              l.morningId.equals(morningId) & l.itemId.equals(itemId)))
        .getSingleOrNull();
    final now = _clock.now().toUtc();
    if (existing == null) {
      await _db.into(_db.preSleepLogs).insert(
            db.PreSleepLogsCompanion.insert(
              id: _uuid.v4(),
              morningId: morningId,
              itemId: itemId,
              checked: Value(checked),
              checkedAt: checked ? Value(now) : const Value.absent(),
              createdAt: now,
              updatedAt: now,
            ),
          );
    } else {
      await (_db.update(_db.preSleepLogs)
            ..where((l) => l.id.equals(existing.id)))
          .write(db.PreSleepLogsCompanion(
        checked: Value(checked),
        checkedAt: checked ? Value(now) : const Value(null),
        updatedAt: Value(now),
      ));
    }
  }

  /// FR-6.5 + PRD §7 morning result: pending/inProgress promises become
  /// "not finished today"; result = full / kept / missed.
  Future<void> closeMorning(String morningId) async {
    final row = await (_db.select(_db.mornings)
          ..where((m) => m.id.equals(morningId)))
        .getSingleOrNull();
    if (row == null || row.result != 'pending') return;
    final now = _clock.now().toUtc();

    await (_db.update(_db.promiseLogs)
          ..where((l) =>
              l.morningId.equals(morningId) &
              l.status.isIn(['pending', 'inProgress'])))
        .write(db.PromiseLogsCompanion(
      status: const Value('notFinished'),
      endedEarly: const Value(true),
      updatedAt: Value(now),
    ));

    final counts = await _db.customSelect(
      'SELECT COUNT(*) AS total, '
      "SUM(CASE WHEN status = 'kept' THEN 1 ELSE 0 END) AS kept "
      'FROM promise_logs WHERE morning_id = ?',
      variables: [Variable.withString(morningId)],
      readsFrom: {_db.promiseLogs},
    ).getSingle();
    final total = counts.read<int>('total');
    final kept = counts.readNullable<int>('kept') ?? 0;

    final String result;
    if (row.wakeConfirmedAt == null) {
      result = 'missed';
    } else if (total > 0 && kept == total) {
      result = 'full';
    } else if (kept > 0) {
      result = 'kept';
    } else {
      result = 'missed';
    }

    await (_db.update(_db.mornings)..where((m) => m.id.equals(morningId)))
        .write(db.MorningsCompanion(
      result: Value(result),
      updatedAt: Value(now),
    ));
  }

  /// Arms the next morning: creates the morning + copied promise logs,
  /// schedules the native alarm and the bedtime reminder
  /// (ARCHITECTURE.md §10 — one alarm exists at a time).
  Future<void> rollover(db.PlanRow plan) async {
    final wakeAt =
        t.nextOccurrence(now: _clock.now(), minuteOfDay: plan.wakeMinute);
    final key = t.dateKey(wakeAt);

    final existing = await (_db.select(_db.mornings)
          ..where((m) => m.date.equals(key)))
        .getSingleOrNull();
    if (existing != null) {
      await _ensureScheduled(existing, plan);
      return;
    }

    final morningId = _uuid.v4();
    final now = _clock.now().toUtc();
    final promises = await (_db.select(_db.promises)
          ..where((p) => p.planId.equals(plan.id))
          ..orderBy([(p) => OrderingTerm.asc(p.sortOrder)]))
        .get();

    await _db.transaction(() async {
      await _db.into(_db.mornings).insert(
            db.MorningsCompanion.insert(
              id: morningId,
              date: key,
              planId: plan.id,
              scheduledAt: wakeAt.toUtc(),
              createdAt: now,
              updatedAt: now,
            ),
          );
      for (final promise in promises) {
        await _db.into(_db.promiseLogs).insert(
              db.PromiseLogsCompanion.insert(
                id: _uuid.v4(),
                morningId: morningId,
                promiseId: promise.id,
                plannedSec: promise.durationMin * 60,
                createdAt: now,
                updatedAt: now,
              ),
            );
      }
    });

    await _alarm.schedule(AlarmSpec(
      alarmId: 'wake-$morningId',
      triggerAtMillis: wakeAt.millisecondsSinceEpoch,
      title: '3AM Club',
      body: plan.whyText ?? '',
    ));

    await _scheduleBedtimeReminder(
      plan: plan,
      wakeAt: wakeAt,
      body: plan.whyText,
    );
  }

  Future<void> _ensureScheduled(db.MorningRow morning, db.PlanRow plan) async {
    if (!morning.scheduledAt.toLocal().isAfter(_clock.now()) ||
        morning.wakeConfirmedAt != null) {
      return;
    }
    await _alarm.schedule(AlarmSpec(
      alarmId: 'wake-${morning.id}',
      triggerAtMillis: morning.scheduledAt.millisecondsSinceEpoch,
      title: '3AM Club',
      body: plan.whyText ?? '',
    ));
    await _scheduleBedtimeReminder(
      plan: plan,
      wakeAt: morning.scheduledAt.toLocal(),
      body: plan.whyText,
    );
  }

  Future<void> _scheduleBedtimeReminder({
    required db.PlanRow plan,
    required DateTime wakeAt,
    String? body,
  }) async {
    final lead = await bedtimeLeadMinutes();
    final reminderAt = t.bedtimeReminderBefore(
      wakeAt: wakeAt,
      bedMinute: plan.bedMinute,
      leadMinutes: lead,
    );
    if (!reminderAt.isAfter(_clock.now())) {
      await _notifications.cancelBedtimeReminder();
      return;
    }
    await _notifications.scheduleBedtimeReminder(
      at: reminderAt,
      title: '3AM Club',
      body: body ?? '',
    );
  }

  /// Closes a stale pending morning if its 06:00 has passed. Returns true
  /// when a close happened (caller may want to re-read state).
  Future<bool> closeIfStale(RelevantMorning? morning) async {
    if (morning == null || !morning.isStale) return false;
    await closeMorning(morning.id);
    final plan = await activePlan();
    if (plan != null) {
      // Arm the next morning so the alarm chain never dies.
      await rollover(plan);
    }
    return true;
  }

  /// App-open catch-up (ARCHITECTURE.md §10 health check + M3 stale-morning
  /// groundwork): close stale mornings, arm the upcoming one, re-register
  /// the alarm, and detect a cold-start ringing alarm.
  ///
  /// Returns true when the app should open on the wake page.
  Future<bool> syncAfterOpen() async {
    final plan = await activePlan();
    if (plan == null) return false;
    final now = _clock.now();

    // Close any pending morning whose 06:00 has passed.
    final pending = await (_db.select(_db.mornings)
          ..where((m) => m.result.equals('pending')))
        .get();
    for (final row in pending) {
      final closesAt = DateTime(
        row.scheduledAt.toLocal().year,
        row.scheduledAt.toLocal().month,
        row.scheduledAt.toLocal().day,
        t.morningCloseMinute ~/ 60,
      );
      if (now.isAfter(closesAt)) {
        await closeMorning(row.id);
      }
    }

    // Ensure an upcoming morning exists and is armed. (After closing a
    // stale morning its row still matches the {today, tomorrow} window, so
    // the test is "scheduled in the future", not "row exists".)
    final relevant = await relevantMorning();
    if (relevant == null || !relevant.scheduledAt.isAfter(now)) {
      await rollover(plan);
    } else if (relevant.wakeConfirmedAt == null) {
      await _ensureScheduled(
        await (_db.select(_db.mornings)
              ..where((m) => m.id.equals(relevant.id)))
            .getSingle(),
        plan,
      );
    }

    // Cold-start wake: the native alarm fired while the app was dead.
    if (await _alarm.isRinging) {
      final m = await relevantMorning();
      if (m != null) {
        if (m.alarmFiredAt == null) {
          await markAlarmFired(m.id);
        }
        if (m.wakeConfirmedAt == null && now.isBefore(m.closesAt)) {
          return true; // open on /wake
        }
      }
    }
    return false;
  }
}

final morningRepositoryProvider = Provider<MorningRepository>((ref) {
  return MorningRepository(
    database: ref.watch(databaseProvider),
    alarmScheduler: ref.watch(alarmSchedulerProvider),
    notificationService: ref.watch(notificationServiceProvider),
    clock: ref.watch(clockProvider),
  );
});
