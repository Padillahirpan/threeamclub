import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'app/router/app_router.dart';
import 'core/platform/notification_service.dart';
import 'features/onboarding/data/onboarding_repository.dart';
import 'features/plan/application/phase_providers.dart';
import 'features/plan/data/morning_repository.dart';
import 'features/settings/application/alarm_health.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load small flags before the first frame so router redirects are sync.
  final prefs = await SharedPreferences.getInstance();
  final onboarding = OnboardingRepository(prefs);

  // Local notifications + timezone (bedtime reminder, FR-4.1). Taps on the
  // bedtime notification open /night (payload route, ARCHITECTURE §13).
  // Failures must not block the app from opening.
  await NotificationService.instance.init(
    onRoute: (payload) {
      final context = rootNavigatorKey.currentContext;
      if (context != null && context.mounted) {
        // Deep link: the router's phase redirects validate the target.
        GoRouter.of(context).go(payload);
      }
    },
  );

  final container = ProviderContainer(
    overrides: [
      onboardingRepositoryProvider.overrideWithValue(onboarding),
    ],
  );

  // App-open sync (ARCHITECTURE.md §10 health check): close stale
  // mornings, arm the upcoming alarm, and detect a cold-start ringing
  // alarm so the app opens straight onto the wake page.
  final shouldOpenOnWake = await container
      .read(morningRepositoryProvider)
      .syncAfterOpen();
  if (shouldOpenOnWake) {
    container.read(alarmRingingProvider.notifier).set(true);
  }

  // Health check (M5): verify critical alarm permissions on open —
  // revoked permissions surface a warning card on the dashboard.
  await container.read(alarmHealthProvider.notifier).refresh();

  // Keep the alarm event processor alive for the whole session.
  container.read(alarmEventProcessorProvider);

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const SubuhanApp(),
    ),
  );
}
