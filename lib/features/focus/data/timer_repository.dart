import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/clock/clock.dart';
import '../../../core/db/app_database.dart' as db;
import '../../../core/db/database_provider.dart';
import '../../../core/platform/notification_service.dart';
import '../../plan/application/phase_providers.dart';
import '../../plan/data/morning_repository.dart';
import '../../plan/data/plan_repository.dart';

/// One promise timer session — the inProgress (or startable) log joined
/// with its promise and category (FR-7.x).
class TimerSession {
  const TimerSession({
    required this.logId,
    required this.promiseId,
    required this.title,
    this.description,
    required this.categoryName,
    required this.iconKey,
    required this.colorKey,
    required this.plannedSec,
    required this.status,
    this.startedAt,
  });

  final String logId;
  final String promiseId;
  final String title;
  final String? description;
  final String categoryName;
  final String iconKey;
  final String colorKey;
  final int plannedSec;
  final String status; // pending / inProgress / kept / notFinished
  final DateTime? startedAt; // local

  bool get isRunning => status == 'inProgress' && startedAt != null;

  /// Remaining seconds derived from the stored start timestamp — never an
  /// in-memory counter, so it survives kill/restart/backgrounding
  /// (FR-7.4). Clamped at 0: the wall clock moving backwards can never
  /// produce a negative remaining (ARCHITECTURE.md §11).
  int remainingSec(DateTime now) {
    if (!isRunning) return plannedSec;
    final elapsed = now.difference(startedAt!).inSeconds;
    return (plannedSec - elapsed).clamp(0, plannedSec);
  }

  /// Complete is enabled only when the countdown reached zero (FR-7.2).
  bool canComplete(DateTime now) => isRunning && remainingSec(now) <= 0;
}

/// Timer persistence + orchestration (PRD FR-7.x, ARCHITECTURE.md §11).
class TimerRepository {
  TimerRepository({
    required db.AppDatabase database,
    required NotificationService notifications,
    required Clock clock,
    required MorningRepository mornings,
  })  : _db = database,
        _notifications = notifications,
        _clock = clock,
        _mornings = mornings;

  final db.AppDatabase _db;
  final NotificationService _notifications;
  final Clock _clock;
  final MorningRepository _mornings;

  /// Starts the promise's timer (idempotent): if any promise in the
  /// morning is already running, returns that session instead — one
  /// promise at a time (DESIGN §7.6).
  Future<TimerSession?> start({
    required String morningId,
    required String promiseId,
    required String completeTitle,
    required String completeBody,
  }) async {
    final running = await activeSession(morningId);
    if (running != null) return running;

    final log = await _logFor(morningId: morningId, promiseId: promiseId);
    if (log == null || log.status != 'pending') return null;

    final now = _clock.now();
    await (_db.update(_db.promiseLogs)..where((l) => l.id.equals(log.id)))
        .write(db.PromiseLogsCompanion(
      status: const Value('inProgress'),
      startedAt: Value(now.toUtc()),
      updatedAt: Value(now.toUtc()),
    ));

    // Local notification at startedAt + plannedSec so completion is
    // signaled even with the screen off (FR-7.5).
    await _notifications.scheduleTimerComplete(
      at: now.add(Duration(seconds: log.plannedSec)),
      title: completeTitle,
      body: completeBody,
      payload: '/focus/promise/$promiseId',
    );

    return sessionFor(morningId: morningId, promiseId: promiseId);
  }

  /// Marks Kept with timestamp — only allowed once the countdown finished
  /// (FR-7.7). Cancels the completion notification defensively.
  Future<bool> complete(String logId) async {
    final log = await _byId(logId);
    if (log == null || log.status != 'inProgress') return false;
    final startedAt = log.startedAt?.toLocal();
    if (startedAt == null) return false;
    final elapsed = _clock.now().difference(startedAt).inSeconds;
    if (log.plannedSec - elapsed > 0) return false; // not finished yet

    final now = _clock.now();
    await (_db.update(_db.promiseLogs)..where((l) => l.id.equals(log.id)))
        .write(db.PromiseLogsCompanion(
      status: const Value('kept'),
      completedAt: Value(now.toUtc()),
      updatedAt: Value(now.toUtc()),
    ));
    await _notifications.cancelTimerComplete();
    return true;
  }

  /// Safety exit (FR-7.6): long-press + confirm upstream; marks
  /// "Not finished today" (never "Failed") and returns to Focus.
  Future<void> endEarly(String logId) async {
    final now = _clock.now();
    await (_db.update(_db.promiseLogs)..where((l) => l.id.equals(logId)))
        .write(db.PromiseLogsCompanion(
      status: const Value('notFinished'),
      endedEarly: const Value(true),
      updatedAt: Value(now.toUtc()),
    ));
    await _notifications.cancelTimerComplete();
  }

  /// The running session of this morning, if any (router lock source).
  Future<TimerSession?> activeSession(String morningId) async {
    final rows = await (_sessionsQuery(morningId)
          ..where(_db.promiseLogs.status.equals('inProgress'))
          ..limit(1))
        .get();
    return rows.isEmpty ? null : _map(rows.first);
  }

  /// Live stream of the running session (router lock + resume).
  Stream<TimerSession?> watchActiveSession(String morningId) =>
      (_sessionsQuery(morningId)
            ..where(_db.promiseLogs.status.equals('inProgress'))
            ..limit(1))
          .watch()
          .map((rows) => rows.isEmpty ? null : _map(rows.first));

  /// Live stream of one promise's session (the timer screen).
  Stream<TimerSession?> watchSession({
    required String morningId,
    required String promiseId,
  }) =>
      (_sessionsQuery(morningId)
            ..where(_db.promiseLogs.promiseId.equals(promiseId))
            ..limit(1))
          .watch()
          .map((rows) => rows.isEmpty ? null : _map(rows.first));

  Future<TimerSession?> sessionFor({
    required String morningId,
    required String promiseId,
  }) async {
    final rows = await (_sessionsQuery(morningId)
          ..where(_db.promiseLogs.promiseId.equals(promiseId))
          ..limit(1))
        .get();
    return rows.isEmpty ? null : _map(rows.first);
  }

  // ---- internals -----------------------------------------------------------

  JoinedSelectStatement _sessionsQuery(String morningId) {
    return _db.select(_db.promiseLogs).join([
      innerJoin(_db.promises,
          _db.promises.id.equalsExp(_db.promiseLogs.promiseId)),
      innerJoin(_db.categories,
          _db.categories.id.equalsExp(_db.promises.categoryId)),
    ])
      ..where(_db.promiseLogs.morningId.equals(morningId));
  }

  Future<db.PromiseLogRow?> _logFor({
    required String morningId,
    required String promiseId,
  }) async {
    final rows = await (_db.select(_db.promiseLogs)
          ..where((l) =>
              l.morningId.equals(morningId) & l.promiseId.equals(promiseId))
          ..limit(1))
        .get();
    return rows.firstOrNull;
  }

  Future<db.PromiseLogRow?> _byId(String logId) async {
    final rows = await (_db.select(_db.promiseLogs)
          ..where((l) => l.id.equals(logId))
          ..limit(1))
        .get();
    return rows.firstOrNull;
  }

  TimerSession _map(TypedResult row) {
    final log = row.readTable(_db.promiseLogs);
    final promise = row.readTable(_db.promises);
    final category = row.readTable(_db.categories);
    return TimerSession(
      logId: log.id,
      promiseId: promise.id,
      title: promise.title,
      description: promise.description,
      categoryName: category.name,
      iconKey: category.iconKey,
      colorKey: category.colorKey,
      plannedSec: log.plannedSec,
      status: log.status,
      startedAt: log.startedAt?.toLocal(),
    );
  }

  /// Convenience for the router: the active session of the relevant
  /// morning, or null (morning or session missing).
  Future<TimerSession?> activeSessionForRelevantMorning() async {
    final morning = await _mornings.relevantMorning();
    if (morning == null) return null;
    return activeSession(morning.id);
  }
}

final timerRepositoryProvider = Provider<TimerRepository>((ref) {
  return TimerRepository(
    database: ref.watch(databaseProvider),
    notifications: ref.watch(notificationServiceProvider),
    clock: ref.watch(clockProvider),
    mornings: ref.watch(morningRepositoryProvider),
  );
});

/// Live active session for the router lock — null when no timer runs
/// (ARCHITECTURE.md §8 redirect rule 1).
final activeTimerSessionProvider = StreamProvider<TimerSession?>((ref) {
  final morning = ref.watch(relevantMorningProvider).value;
  if (morning == null) return const Stream.empty();
  return ref.watch(timerRepositoryProvider).watchActiveSession(morning.id);
});
