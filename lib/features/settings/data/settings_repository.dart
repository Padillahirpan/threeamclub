import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/db/app_database.dart' as db;
import '../../../core/db/database_provider.dart';
import '../../plan/data/morning_repository.dart';

/// Small device-level flags + the bedtime-lead write path
/// (ARCHITECTURE.md §3: shared_preferences for small flags only; the
/// lead itself lives in the settings table).
class SettingsRepository {
  SettingsRepository({
    required db.AppDatabase database,
    required MorningRepository mornings,
  })  : _db = database,
        _mornings = mornings;

  final db.AppDatabase _db;
  final MorningRepository _mornings;

  static const _wakelockKey = 'wakelock_enabled';

  Future<bool> wakelockEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_wakelockKey) ?? true; // default on (§3)
  }

  Future<void> setWakelockEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_wakelockKey, value);
  }

  /// Updates the bedtime-reminder lead; reschedules tonight's reminder so
  /// the change takes effect immediately.
  Future<void> setBedtimeLeadMinutes(int minutes) async {
    final now = DateTime.now().toUtc();
    await (_db.update(_db.settings)..where((s) => s.id.equals('default')))
        .write(db.SettingsCompanion(
      bedtimeLeadMinutes: Value(minutes),
      updatedAt: Value(now),
    ));
    await _mornings.refreshBedtimeReminder();
  }
}

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository(
    database: ref.watch(databaseProvider),
    mornings: ref.watch(morningRepositoryProvider),
  );
});

/// Wakelock preference for the timer screen (default on).
final wakelockEnabledProvider = FutureProvider<bool>((ref) {
  return ref.watch(settingsRepositoryProvider).wakelockEnabled();
});
