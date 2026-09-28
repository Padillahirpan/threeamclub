import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_database.dart';

/// Keep-alive database provider (ARCHITECTURE.md §9).
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});
