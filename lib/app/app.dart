import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/clock/clock.dart';
import '../core/l10n/app_localizations.dart';
import '../features/plan/application/phase_providers.dart';
import '../features/plan/data/morning_repository.dart';
import '../features/settings/application/alarm_health.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

/// Root widget: theme, localizations (id + en), router, and the app-level
/// phase side effects (resume re-evaluation, stale-morning close).
class SubuhanApp extends ConsumerStatefulWidget {
  const SubuhanApp({super.key});

  @override
  ConsumerState<SubuhanApp> createState() => _SubuhanAppState();
}

class _SubuhanAppState extends ConsumerState<SubuhanApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // dayPhaseProvider re-evaluates on app resume (ARCHITECTURE.md §7)…
    if (state == AppLifecycleState.resumed) {
      ref.read(phaseTickProvider.notifier).bump();
      // …and the alarm health check re-runs (permissions may have been
      // revoked in system settings while the app was backgrounded).
      ref.read(alarmHealthProvider.notifier).refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Close a stale morning the moment its 06:00 passes while the app is
    // open, then arm the next one (FR-6.5 + alarm chain).
    ref.listen(relevantMorningProvider, (_, next) {
      final morning = next.value;
      if (morning != null &&
          morning.isStaleAt(ref.read(clockProvider).now())) {
        ref.read(morningRepositoryProvider).closeIfStale(morning);
      }
    });

    final isDev = const String.fromEnvironment('appFlavor') == 'dev';
    return MaterialApp.router(
      title: isDev ? '3AM Club Dev' : '3AM Club',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: ref.watch(routerProvider),
    );
  }
}
