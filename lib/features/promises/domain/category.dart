import '../../../core/db/app_database.dart';

export '../../../core/db/database_provider.dart' show databaseProvider;

/// Domain entity for a promise category (ARCHITECTURE.md §4: pure Dart).
class Category {
  const Category({
    required this.id,
    required this.name,
    required this.iconKey,
    required this.colorKey,
    required this.isBuiltIn,
    required this.isArchived,
  });

  final String id;
  final String name;
  final String iconKey;
  final String colorKey;
  final bool isBuiltIn;
  final bool isArchived;
}

/// Repository interface (implemented by drift in data/).
abstract class CategoryRepository {
  Stream<List<Category>> watchAll();

  Future<Category> createCustom({
    required String name,
    required String iconKey,
    required String colorKey,
  });

  Future<void> updateCustom({
    required String id,
    required String name,
    required String iconKey,
    required String colorKey,
  });

  Future<void> archive(String id);
}

/// Mapping between drift rows and the domain entity.
Category categoryFromRow(CategoryRow row) => Category(
      id: row.id,
      name: row.name,
      iconKey: row.iconKey,
      colorKey: row.colorKey,
      isBuiltIn: row.isBuiltIn,
      isArchived: row.isArchived,
    );
