import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Small onboarding flag (shared_preferences is for "small flags only",
/// ARCHITECTURE.md §3).
class OnboardingRepository {
  OnboardingRepository(this._prefs);

  static const String _doneKey = 'onboarding_done';

  final SharedPreferences _prefs;

  bool get isDone => _prefs.getBool(_doneKey) ?? false;

  Future<void> setDone() => _prefs.setBool(_doneKey, true);
}

/// Overridden in main() after prefs are loaded.
final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  throw UnimplementedError(
    'onboardingRepositoryProvider must be overridden in main()',
  );
});

/// Synchronous flag used by the router redirect. Reads the repository in
/// `build()`; main() overrides the repository with a loaded instance
/// before the first frame.
class OnboardingDone extends Notifier<bool> {
  @override
  bool build() {
    try {
      return ref.watch(onboardingRepositoryProvider).isDone;
    } catch (_) {
      // Repository not overridden (e.g. a test scope) → treat as not done.
      return false;
    }
  }

  void complete() => state = true;
}

final onboardingDoneProvider =
    NotifierProvider<OnboardingDone, bool>(OnboardingDone.new);
