import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/app_database.dart' as db;
import '../domain/category.dart';

class DriftCategoryRepository implements CategoryRepository {
  DriftCategoryRepository(this._db);

  final db.AppDatabase _db;

  @override
  Stream<List<Category>> watchAll() {
    final query = _db.select(_db.categories)
      ..where((t) => t.isArchived.equals(false))
      ..orderBy([
        (t) => OrderingTerm(expression: t.isBuiltIn, mode: OrderingMode.desc),
        (t) => OrderingTerm.asc(t.name),
      ]);
    return query.watch().map(
          (rows) => rows.map(categoryFromRow).toList(growable: false),
        );
  }

  @override
  Future<Category> createCustom({
    required String name,
    required String iconKey,
    required String colorKey,
  }) async {
    final id = DateTime.now().microsecondsSinceEpoch.toString();
    final now = DateTime.now().toUtc();
    await _db.into(_db.categories).insert(
          db.CategoriesCompanion.insert(
            id: id,
            name: name,
            iconKey: iconKey,
            colorKey: colorKey,
            createdAt: now,
            updatedAt: now,
          ),
        );
    return Category(
      id: id,
      name: name,
      iconKey: iconKey,
      colorKey: colorKey,
      isBuiltIn: false,
      isArchived: false,
    );
  }

  @override
  Future<void> updateCustom({
    required String id,
    required String name,
    required String iconKey,
    required String colorKey,
  }) async {
    final row = await (_db.select(_db.categories)
          ..where((t) => t.id.equals(id)))
        .getSingle();
    if (row.isBuiltIn) {
      // Built-in categories are not editable (PRD FR-2.2).
      return;
    }
    await (_db.update(_db.categories)..where((t) => t.id.equals(id))).write(
      db.CategoriesCompanion(
        name: Value(name),
        iconKey: Value(iconKey),
        colorKey: Value(colorKey),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }

  @override
  Future<void> archive(String id) async {
    await (_db.update(_db.categories)..where((t) => t.id.equals(id))).write(
      db.CategoriesCompanion(
        isArchived: const Value(true),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }
}

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return DriftCategoryRepository(ref.watch(databaseProvider));
});

/// Live category list for chips and builders (drift `watch()`).
final categoriesProvider = StreamProvider<List<Category>>((ref) {
  return ref.watch(categoryRepositoryProvider).watchAll();
});
