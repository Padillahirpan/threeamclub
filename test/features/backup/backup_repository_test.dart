import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:subuhan/core/clock/clock.dart';
import 'package:subuhan/core/db/app_database.dart' as db;
import 'package:subuhan/core/platform/alarm_scheduler.dart';
import 'package:subuhan/core/platform/notification_service.dart';
import 'package:subuhan/features/backup/data/backup_repository.dart';
import 'package:subuhan/features/plan/data/morning_repository.dart';
import 'package:subuhan/features/plan/data/plan_repository.dart';
import 'package:subuhan/features/plan/domain/plan_draft.dart';

class _FakeAlarmScheduler implements AlarmScheduler {
  final List<AlarmSpec> scheduled = <AlarmSpec>[];

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
  late db.AppDatabase source;
  late BackupRepository backup;
  late MutableClock clock;

  setUp(() async {
    source = db.AppDatabase.connect(NativeDatabase.memory());
    clock = MutableClock(DateTime(2026, 9, 28, 20, 0));
    final alarm = _FakeAlarmScheduler();
    final notifications = _FakeNotificationService();
    final plans = PlanRepository(
      database: source,
      alarmScheduler: alarm,
      notificationService: notifications,
      clock: clock,
    );
    final mornings = MorningRepository(
      database: source,
      alarmScheduler: alarm,
      notificationService: notifications,
      clock: clock,
    );
    backup = BackupRepository(
      database: source,
      clock: clock,
      mornings: mornings,
    );

    // Rich source data: signed plan + one closed morning with a kept log.
    await plans.signPlan(
      const PlanDraftState(
        bedMinute: 21 * 60,
        wakeMinute: 4 * 60,
        whyText: 'For my family',
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
        ],
      ),
      alarmTitle: '3AM Club',
      alarmBody: 'a',
      reminderTitle: 't',
      reminderBody: 'b',
    );

    clock.set(DateTime(2026, 9, 29, 4, 5));
    final morning = await mornings.relevantMorning();
    await mornings.markAlarmFired(morning!.id);
    await mornings.confirmWake(morning.id);
    final log = await (source.select(source.promiseLogs)
          ..where((l) => l.morningId.equals(morning.id)))
        .getSingle();
    await (source.update(source.promiseLogs)
          ..where((l) => l.id.equals(log.id)))
        .write(const db.PromiseLogsCompanion(status: Value('kept')));
    clock.set(DateTime(2026, 9, 29, 6, 1));
    await mornings.closeMorning(morning.id);
  });

  tearDown(() async {
    await source.close();
  });

  test('export → import round trip restores every table', () async {
    final export = await backup.exportAll();
    // Must be a plain-JSON-serializable document.
    final decoded = jsonDecode(jsonEncode(export)) as Map<String, dynamic>;
    expect(decoded, isA<Map<String, dynamic>>());

    final target = db.AppDatabase.connect(NativeDatabase.memory());
    final alarm = _FakeAlarmScheduler();
    final notifications = _FakeNotificationService();
    final targetBackup = BackupRepository(
      database: target,
      clock: clock,
      mornings: MorningRepository(
        database: target,
        alarmScheduler: alarm,
        notificationService: notifications,
        clock: clock,
      ),
    );

    // Target starts with its own seeded categories (replaced on import).
    final preview = targetBackup.readPreview(decoded);
    expect(preview.exportVersion, kExportVersion);
    expect(preview.plans, 1);
    expect(preview.mornings, 1); // Tuesday, closed as kept
    expect(preview.promiseLogs, 1);

    await targetBackup.importAll(decoded);

    // Every table restored — plus the re-armed Wednesday morning that
    // importAll's syncAfterOpen creates for the next alarm.
    final plans = await target.select(target.plans).get();
    expect(plans, hasLength(1));
    expect(plans.single.whyText, 'For my family');
    expect(plans.single.isActive, isTrue);
    expect(plans.single.journeyLengthDays, 66);

    final morningsRows = await target.select(target.mornings).get();
    expect(morningsRows, hasLength(2));
    final closed = morningsRows.firstWhere((m) => m.date == '2026-09-29');
    // 1 promise, 1 kept → "full" per the PRD §7 result rules.
    expect(closed.result, 'full');
    expect(closed.wakeConfirmedAt, isNotNull);

    final logs = await target.select(target.promiseLogs).get();
    expect(logs, hasLength(2));
    expect(logs.where((l) => l.status == 'kept'), isNotEmpty);

    final items = await target.select(target.preSleepItems).get();
    expect(items, hasLength(1));
    expect(items.single.title, 'Phone on charge');

    final settings = await target.select(target.settings).get();
    expect(settings.single.bedtimeLeadMinutes, 30);

    // Import re-arms the alarm chain for the upcoming morning.
    expect(alarm.scheduled, isNotEmpty);

    await target.close();
  });

  test('unsupported future version is refused', () {
    expect(
      () => backup.readPreview({
        'exportVersion': 99,
        'plans': <dynamic>[],
        'promises': <dynamic>[],
        'mornings': <dynamic>[],
        'promiseLogs': <dynamic>[],
      }),
      throwsA(isA<InvalidBackupException>()),
    );
  });

  test('missing tables and non-map rows are refused', () {
    expect(
      () => backup.readPreview({'exportVersion': 1}),
      throwsA(isA<InvalidBackupException>()),
    );
    expect(
      () => backup.readPreview({
        'exportVersion': 1,
        'plans': <dynamic>['not-a-map'],
        'promises': <dynamic>[],
        'mornings': <dynamic>[],
        'promiseLogs': <dynamic>[],
      }),
      throwsA(isA<InvalidBackupException>()),
    );
  });
}
