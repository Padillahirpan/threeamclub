import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/clock/clock.dart';
import '../../../core/db/app_database.dart' as db;
import '../../../core/db/database_provider.dart';
import '../../plan/data/morning_repository.dart';

/// Current backup file schema version (ARCHITECTURE.md §14 — versioned
/// from day one so future imports can migrate).
const int kExportVersion = 1;

/// Row counts shown before a restore (FR-10.1: validate → preview →
/// replace).
class BackupPreview {
  const BackupPreview({
    required this.exportVersion,
    required this.plans,
    required this.promises,
    required this.mornings,
    required this.promiseLogs,
    required this.exportedAt,
  });

  final int exportVersion;
  final int plans;
  final int promises;
  final int mornings;
  final int promiseLogs;
  final DateTime? exportedAt;
}

/// Thrown for anything that is not a backup this app can read.
class InvalidBackupException implements Exception {
  const InvalidBackupException([this.message]);
  final String? message;
}

/// Export/import of all tables as one versioned JSON document
/// (PRD FR-10.1, ARCHITECTURE.md §14). All data stays on device; the
/// share sheet is the only way data leaves it.
class BackupRepository {
  BackupRepository({
    required db.AppDatabase database,
    required Clock clock,
    required MorningRepository mornings,
  })  : _db = database,
        _clock = clock,
        _mornings = mornings;

  final db.AppDatabase _db;
  final Clock _clock;
  final MorningRepository _mornings;

  /// Serializes every table into one versioned map. `DateTime`s become
  /// epoch milliseconds (UTC) — no string parsing ambiguity.
  Future<Map<String, dynamic>> exportAll() async {
    final plansRows = await _db.select(_db.plans).get();
    final items = await _db.select(_db.preSleepItems).get();
    final categories = await _db.select(_db.categories).get();
    final promises = await _db.select(_db.promises).get();
    final mornings = await _db.select(_db.mornings).get();
    final logs = await _db.select(_db.promiseLogs).get();
    final nightLogs = await _db.select(_db.preSleepLogs).get();
    final settings = await _db.select(_db.settings).get();

    return {
      'exportVersion': kExportVersion,
      'exportedAt': _clock.now().toUtc().millisecondsSinceEpoch,
      'plans': [for (final r in plansRows) _planToJson(r)],
      'preSleepItems': [for (final r in items) _itemToJson(r)],
      'categories': [for (final r in categories) _categoryToJson(r)],
      'promises': [for (final r in promises) _promiseToJson(r)],
      'mornings': [for (final r in mornings) _morningToJson(r)],
      'promiseLogs': [for (final r in logs) _logToJson(r)],
      'preSleepLogs': [for (final r in nightLogs) _nightLogToJson(r)],
      'settings': [for (final r in settings) _settingsToJson(r)],
    };
  }

  /// Validates the document and counts rows for the preview.
  BackupPreview readPreview(Map<String, dynamic> json) {
    final version = json['exportVersion'];
    if (version is! int || version > kExportVersion) {
      throw const InvalidBackupException('Unsupported export version');
    }
    final plans = _table(json, 'plans');
    final promises = _table(json, 'promises');
    final mornings = _table(json, 'mornings');
    final logs = _table(json, 'promiseLogs');

    final exportedRaw = json['exportedAt'];
    return BackupPreview(
      exportVersion: version,
      plans: plans.length,
      promises: promises.length,
      mornings: mornings.length,
      promiseLogs: logs.length,
      exportedAt: exportedRaw is int
          ? DateTime.fromMillisecondsSinceEpoch(exportedRaw, isUtc: true)
          : null,
    );
  }

  /// Replace-strategy restore (ARCHITECTURE.md §14: "start with
  /// replace"): wipes all tables, inserts the backup, then re-arms the
  /// alarm chain from the imported active plan.
  Future<void> importAll(Map<String, dynamic> json) async {
    readPreview(json); // throws on anything unreadable

    await _db.transaction(() async {
      // FK-safe teardown (children first).
      await _db.delete(_db.promiseLogs).go();
      await _db.delete(_db.preSleepLogs).go();
      await _db.delete(_db.mornings).go();
      await _db.delete(_db.promises).go();
      await _db.delete(_db.preSleepItems).go();
      await _db.delete(_db.categories).go();
      await _db.delete(_db.plans).go();
      await _db.delete(_db.settings).go();

      // Restore (parents first).
      for (final row in _table(json, 'categories')) {
        await _db.into(_db.categories).insert(_categoryFromJson(row));
      }
      for (final row in _table(json, 'settings')) {
        await _db.into(_db.settings).insert(_settingsFromJson(row));
      }
      for (final row in _table(json, 'plans')) {
        await _db.into(_db.plans).insert(_planFromJson(row));
      }
      for (final row in _table(json, 'preSleepItems')) {
        await _db.into(_db.preSleepItems).insert(_itemFromJson(row));
      }
      for (final row in _table(json, 'promises')) {
        await _db.into(_db.promises).insert(_promiseFromJson(row));
      }
      for (final row in _table(json, 'mornings')) {
        await _db.into(_db.mornings).insert(_morningFromJson(row));
      }
      for (final row in _table(json, 'promiseLogs')) {
        await _db.into(_db.promiseLogs).insert(_logFromJson(row));
      }
      for (final row in _table(json, 'preSleepLogs')) {
        await _db.into(_db.preSleepLogs).insert(_nightLogFromJson(row));
      }
    });

    // Re-schedule the alarm chain from the restored data (one alarm at
    // a time, ARCHITECTURE.md §10 — scheduling replaces any stale one).
    await _mornings.syncAfterOpen();
  }

  // ---- plans ---------------------------------------------------------------

  Map<String, dynamic> _planToJson(db.PlanRow r) => {
        'id': r.id,
        'wakeMinute': r.wakeMinute,
        'bedMinute': r.bedMinute,
        'whyText': r.whyText,
        'signedAt': r.signedAt.millisecondsSinceEpoch,
        'journeyStartDate': r.journeyStartDate.millisecondsSinceEpoch,
        'journeyLengthDays': r.journeyLengthDays,
        'isActive': r.isActive,
        'createdAt': r.createdAt.millisecondsSinceEpoch,
        'updatedAt': r.updatedAt.millisecondsSinceEpoch,
      };

  db.PlansCompanion _planFromJson(Map<String, dynamic> j) =>
      db.PlansCompanion.insert(
        id: _id(j),
        wakeMinute: j['wakeMinute'] as int,
        bedMinute: j['bedMinute'] as int,
        whyText: Value(j['whyText'] as String?),
        signedAt: _dt(j, 'signedAt'),
        journeyStartDate: _dt(j, 'journeyStartDate'),
        journeyLengthDays:
            Value(j['journeyLengthDays'] as int? ?? 66),
        isActive: j['isActive'] as bool,
        createdAt: _dt(j, 'createdAt'),
        updatedAt: _dt(j, 'updatedAt'),
      );

  // ---- pre-sleep items -----------------------------------------------------

  Map<String, dynamic> _itemToJson(db.PreSleepItemRow r) => {
        'id': r.id,
        'planId': r.planId,
        'title': r.title,
        'sortOrder': r.sortOrder,
        'createdAt': r.createdAt.millisecondsSinceEpoch,
        'updatedAt': r.updatedAt.millisecondsSinceEpoch,
      };

  db.PreSleepItemsCompanion _itemFromJson(Map<String, dynamic> j) =>
      db.PreSleepItemsCompanion.insert(
        id: _id(j),
        planId: j['planId'] as String,
        title: j['title'] as String,
        sortOrder: j['sortOrder'] as int,
        createdAt: _dt(j, 'createdAt'),
        updatedAt: _dt(j, 'updatedAt'),
      );

  // ---- categories ----------------------------------------------------------

  Map<String, dynamic> _categoryToJson(db.CategoryRow r) => {
        'id': r.id,
        'name': r.name,
        'iconKey': r.iconKey,
        'colorKey': r.colorKey,
        'isBuiltIn': r.isBuiltIn,
        'isArchived': r.isArchived,
        'createdAt': r.createdAt.millisecondsSinceEpoch,
        'updatedAt': r.updatedAt.millisecondsSinceEpoch,
      };

  db.CategoriesCompanion _categoryFromJson(Map<String, dynamic> j) =>
      db.CategoriesCompanion.insert(
        id: _id(j),
        name: j['name'] as String,
        iconKey: j['iconKey'] as String,
        colorKey: j['colorKey'] as String,
        isBuiltIn: Value(j['isBuiltIn'] as bool? ?? false),
        isArchived: Value(j['isArchived'] as bool? ?? false),
        createdAt: _dt(j, 'createdAt'),
        updatedAt: _dt(j, 'updatedAt'),
      );

  // ---- promises ------------------------------------------------------------

  Map<String, dynamic> _promiseToJson(db.PromiseRow r) => {
        'id': r.id,
        'planId': r.planId,
        'categoryId': r.categoryId,
        'title': r.title,
        'description': r.description,
        'durationMin': r.durationMin,
        'sortOrder': r.sortOrder,
        'createdAt': r.createdAt.millisecondsSinceEpoch,
        'updatedAt': r.updatedAt.millisecondsSinceEpoch,
      };

  db.PromisesCompanion _promiseFromJson(Map<String, dynamic> j) =>
      db.PromisesCompanion.insert(
        id: _id(j),
        planId: j['planId'] as String,
        categoryId: j['categoryId'] as String,
        title: j['title'] as String,
        description: Value(j['description'] as String?),
        durationMin: j['durationMin'] as int,
        sortOrder: j['sortOrder'] as int,
        createdAt: _dt(j, 'createdAt'),
        updatedAt: _dt(j, 'updatedAt'),
      );

  // ---- mornings ------------------------------------------------------------

  Map<String, dynamic> _morningToJson(db.MorningRow r) => {
        'id': r.id,
        'date': r.date,
        'planId': r.planId,
        'scheduledAt': r.scheduledAt.millisecondsSinceEpoch,
        'alarmFiredAt': r.alarmFiredAt?.millisecondsSinceEpoch,
        'wakeConfirmedAt': r.wakeConfirmedAt?.millisecondsSinceEpoch,
        'result': r.result,
        'createdAt': r.createdAt.millisecondsSinceEpoch,
        'updatedAt': r.updatedAt.millisecondsSinceEpoch,
      };

  db.MorningsCompanion _morningFromJson(Map<String, dynamic> j) =>
      db.MorningsCompanion.insert(
        id: _id(j),
        date: j['date'] as String,
        planId: j['planId'] as String,
        scheduledAt: _dt(j, 'scheduledAt'),
        alarmFiredAt: _dtNullable(j, 'alarmFiredAt'),
        wakeConfirmedAt: _dtNullable(j, 'wakeConfirmedAt'),
        result: Value(j['result'] as String? ?? 'pending'),
        createdAt: _dt(j, 'createdAt'),
        updatedAt: _dt(j, 'updatedAt'),
      );

  // ---- promise logs --------------------------------------------------------

  Map<String, dynamic> _logToJson(db.PromiseLogRow r) => {
        'id': r.id,
        'morningId': r.morningId,
        'promiseId': r.promiseId,
        'status': r.status,
        'startedAt': r.startedAt?.millisecondsSinceEpoch,
        'completedAt': r.completedAt?.millisecondsSinceEpoch,
        'plannedSec': r.plannedSec,
        'endedEarly': r.endedEarly,
        'createdAt': r.createdAt.millisecondsSinceEpoch,
        'updatedAt': r.updatedAt.millisecondsSinceEpoch,
      };

  db.PromiseLogsCompanion _logFromJson(Map<String, dynamic> j) =>
      db.PromiseLogsCompanion.insert(
        id: _id(j),
        morningId: j['morningId'] as String,
        promiseId: j['promiseId'] as String,
        status: Value(j['status'] as String? ?? 'pending'),
        startedAt: _dtNullable(j, 'startedAt'),
        completedAt: _dtNullable(j, 'completedAt'),
        plannedSec: j['plannedSec'] as int,
        endedEarly: Value(j['endedEarly'] as bool? ?? false),
        createdAt: _dt(j, 'createdAt'),
        updatedAt: _dt(j, 'updatedAt'),
      );

  // ---- pre-sleep logs ------------------------------------------------------

  Map<String, dynamic> _nightLogToJson(db.PreSleepLogRow r) => {
        'id': r.id,
        'morningId': r.morningId,
        'itemId': r.itemId,
        'checked': r.checked,
        'checkedAt': r.checkedAt?.millisecondsSinceEpoch,
        'createdAt': r.createdAt.millisecondsSinceEpoch,
        'updatedAt': r.updatedAt.millisecondsSinceEpoch,
      };

  db.PreSleepLogsCompanion _nightLogFromJson(Map<String, dynamic> j) =>
      db.PreSleepLogsCompanion.insert(
        id: _id(j),
        morningId: j['morningId'] as String,
        itemId: j['itemId'] as String,
        checked: Value(j['checked'] as bool? ?? false),
        checkedAt: _dtNullable(j, 'checkedAt'),
        createdAt: _dt(j, 'createdAt'),
        updatedAt: _dt(j, 'updatedAt'),
      );

  // ---- settings ------------------------------------------------------------

  Map<String, dynamic> _settingsToJson(db.SettingsRow r) => {
        'id': r.id,
        'bedtimeLeadMinutes': r.bedtimeLeadMinutes,
        'language': r.language,
        'reduceMotionOverride': r.reduceMotionOverride,
        'createdAt': r.createdAt.millisecondsSinceEpoch,
        'updatedAt': r.updatedAt.millisecondsSinceEpoch,
      };

  db.SettingsCompanion _settingsFromJson(Map<String, dynamic> j) =>
      db.SettingsCompanion.insert(
        id: _id(j),
        bedtimeLeadMinutes:
            Value(j['bedtimeLeadMinutes'] as int? ?? 30),
        language: Value(j['language'] as String? ?? 'system'),
        reduceMotionOverride:
            Value(j['reduceMotionOverride'] as bool?),
        createdAt: _dt(j, 'createdAt'),
        updatedAt: _dt(j, 'updatedAt'),
      );

  // ---- helpers -------------------------------------------------------------

  List<Map<String, dynamic>> _table(Map<String, dynamic> json, String key) {
    final raw = json[key];
    if (raw is! List) {
      throw InvalidBackupException('Missing table: $key');
    }
    return [
      for (final row in raw)
        if (row is Map<String, dynamic>)
          row
        else
          throw InvalidBackupException('Bad row in $key'),
    ];
  }

  String _id(Map<String, dynamic> j) {
    final id = j['id'];
    if (id is! String || id.isEmpty) {
      throw const InvalidBackupException('Row without id');
    }
    return id;
  }

  DateTime _dt(Map<String, dynamic> j, String key) {
    final v = j[key];
    if (v is! int) {
      throw InvalidBackupException('Bad timestamp: $key');
    }
    return DateTime.fromMillisecondsSinceEpoch(v, isUtc: true);
  }

  Value<DateTime> _dtNullable(Map<String, dynamic> j, String key) {
    final v = j[key];
    return v is int
        ? Value(DateTime.fromMillisecondsSinceEpoch(v, isUtc: true))
        : const Value.absent();
  }
}

final backupRepositoryProvider = Provider<BackupRepository>((ref) {
  return BackupRepository(
    database: ref.watch(databaseProvider),
    clock: ref.watch(clockProvider),
    mornings: ref.watch(morningRepositoryProvider),
  );
});
