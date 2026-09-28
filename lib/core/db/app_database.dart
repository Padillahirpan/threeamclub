import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

/// Local schema, v1 (ARCHITECTURE.md §6).
///
/// Conventions: UUID text ids, `createdAt`/`updatedAt` on every row
/// (keeps a future sync path open), times of day as minutes from
/// midnight, `mornings.date` is the wake date as a local date string.
/// drift stores DateTime columns as UTC epoch (seconds).

@DataClassName('PlanRow')
class Plans extends Table {
  TextColumn get id => text()();
  IntColumn get wakeMinute => integer()();
  IntColumn get bedMinute => integer()();
  TextColumn get whyText => text().nullable()();
  DateTimeColumn get signedAt => dateTime()();
  DateTimeColumn get journeyStartDate => dateTime()();
  IntColumn get journeyLengthDays => integer().withDefault(const Constant(66))();
  BoolColumn get isActive => boolean()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('PreSleepItemRow')
class PreSleepItems extends Table {
  TextColumn get id => text()();
  TextColumn get planId => text().references(Plans, #id)();
  TextColumn get title => text()();
  IntColumn get sortOrder => integer()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('CategoryRow')
class Categories extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get iconKey => text()();
  TextColumn get colorKey => text()();
  BoolColumn get isBuiltIn => boolean().withDefault(const Constant(false))();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('PromiseRow')
class Promises extends Table {
  TextColumn get id => text()();
  TextColumn get planId => text().references(Plans, #id)();
  TextColumn get categoryId => text().references(Categories, #id)();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  IntColumn get durationMin => integer()();
  IntColumn get sortOrder => integer()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('MorningRow')
class Mornings extends Table {
  TextColumn get id => text()();
  TextColumn get date => text().unique()(); // wake date, 'yyyy-MM-dd'
  TextColumn get planId => text().references(Plans, #id)();
  DateTimeColumn get scheduledAt => dateTime()();
  DateTimeColumn get alarmFiredAt => dateTime().nullable()();
  DateTimeColumn get wakeConfirmedAt => dateTime().nullable()();
  TextColumn get result => text().withDefault(const Constant('pending'))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('PromiseLogRow')
class PromiseLogs extends Table {
  TextColumn get id => text()();
  TextColumn get morningId => text().references(Mornings, #id)();
  TextColumn get promiseId => text().references(Promises, #id)();
  TextColumn get status => text().withDefault(const Constant('pending'))();
  DateTimeColumn get startedAt => dateTime().nullable()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  IntColumn get plannedSec => integer()();
  BoolColumn get endedEarly => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('PreSleepLogRow')
class PreSleepLogs extends Table {
  TextColumn get id => text()();
  TextColumn get morningId => text().references(Mornings, #id)();
  TextColumn get itemId => text().references(PreSleepItems, #id)();
  BoolColumn get checked => boolean().withDefault(const Constant(false))();
  DateTimeColumn get checkedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('SettingsRow')
class Settings extends Table {
  TextColumn get id => text()(); // single row: 'default'
  IntColumn get bedtimeLeadMinutes => integer().withDefault(const Constant(30))();
  TextColumn get language => text().withDefault(const Constant('system'))();
  BoolColumn get reduceMotionOverride => boolean().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [
  Plans,
  PreSleepItems,
  Categories,
  Promises,
  Mornings,
  PromiseLogs,
  PreSleepLogs,
  Settings,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_open());

  /// For tests: an in-memory or custom-executor database.
  AppDatabase.connect(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
          await _seedIfNeeded();
        },
      );

  Future<void> _seedIfNeeded() async {
    final categoryRow =
        await customSelect('SELECT COUNT(*) AS c FROM categories').getSingle();
    if (categoryRow.read<int>('c') == 0) {
      final now = DateTime.now().toUtc();
      await batch((b) {
        b.insertAll(categories, [
          for (final c in builtInCategories)
            CategoriesCompanion.insert(
              id: c.id,
              name: c.name,
              iconKey: c.iconKey,
              colorKey: c.colorKey,
              isBuiltIn: const Value(true),
              createdAt: now,
              updatedAt: now,
            ),
        ]);
      });
    }

    final settingsRow =
        await customSelect('SELECT COUNT(*) AS c FROM settings').getSingle();
    if (settingsRow.read<int>('c') == 0) {
      final now = DateTime.now().toUtc();
      await into(settings).insert(
        SettingsCompanion.insert(
          id: 'default',
          createdAt: now,
          updatedAt: now,
        ),
      );
    }
  }
}

LazyDatabase _open() => LazyDatabase(() async {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}${Platform.pathSeparator}subuhan.db');
      return NativeDatabase.createInBackground(file);
    });

/// Built-in categories (PRD FR-2.2, DESIGN.md §8).
/// Fixed ids so seeding and tests are deterministic.
const List<({String id, String name, String iconKey, String colorKey})>
    builtInCategories = [
  (id: 'cat-spiritual', name: 'Spiritual', iconKey: 'spiritual', colorKey: 'dawn'),
  (id: 'cat-mind', name: 'Mind', iconKey: 'mind', colorKey: 'blue'),
  (id: 'cat-body', name: 'Body', iconKey: 'body', colorKey: 'green'),
  (id: 'cat-home', name: 'Home', iconKey: 'home', colorKey: 'teal'),
  (id: 'cat-create', name: 'Create', iconKey: 'create', colorKey: 'purple'),
  (id: 'cat-plan', name: 'Plan', iconKey: 'plan', colorKey: 'gold'),
];

/// Suggestion templates per category (DESIGN.md §8). Prefill only —
/// title, description and duration stay editable (PRD FR-2.3).
const Map<String, List<({String title, int durationMin})>> promiseTemplates = {
  'cat-spiritual': [
    (title: "Du'a on waking", durationMin: 5),
    (title: 'Tahajud prayer', durationMin: 20),
    (title: 'Dzikir', durationMin: 10),
    (title: 'Quran reading', durationMin: 15),
  ],
  'cat-mind': [
    (title: 'Reading', durationMin: 20),
    (title: 'Journaling', durationMin: 10),
    (title: 'Study', durationMin: 30),
  ],
  'cat-body': [
    (title: 'Exercise', durationMin: 30),
    (title: 'Stretching', durationMin: 10),
    (title: 'Walk', durationMin: 20),
  ],
  'cat-home': [
    (title: 'Cooking', durationMin: 30),
    (title: 'Tidy the house', durationMin: 20),
  ],
  'cat-create': [
    (title: 'Hobby', durationMin: 30),
    (title: 'Writing', durationMin: 20),
    (title: 'Side project', durationMin: 45),
  ],
  'cat-plan': [
    (title: 'Plan the day', durationMin: 10),
  ],
};
