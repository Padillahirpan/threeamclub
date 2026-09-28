import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/time/day_phase.dart';
import '../../debug/alarm_spike_screen.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/focus/data/timer_repository.dart';
import '../../features/focus/presentation/focus_screen.dart';
import '../../features/focus/presentation/promise_timer_screen.dart';
import '../../features/night/presentation/night_screen.dart';
import '../../features/onboarding/data/onboarding_repository.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/plan/application/phase_providers.dart';
import '../../features/plan/presentation/plan_screen.dart';
import '../../features/promises/presentation/promise_builder_screen.dart';
import '../../features/sign/presentation/sign_screen.dart';
import '../../features/wake/presentation/wake_screen.dart';
import 'routes.dart';

/// Global navigator key so notification taps can route (ARCHITECTURE §13).
final rootNavigatorKey = GlobalKey<NavigatorState>();

/// GoRouter provider (ARCHITECTURE.md §8).
///
/// Redirects are driven by onboarding state, the active timer session and
/// [DayPhase]:
///  1. onboarding first (M1);
///  2. active promise session → locked `/focus/promise/:id` (M3);
///  3. `noPlan` → planning flow;
///  4. `ringing` → /wake (over the lock screen via the native FSI);
///  5. `windDown` → /night, `day`/`done` → /dashboard;
///  6. the user may always reach /dashboard and /settings.
final routerProvider = Provider<GoRouter>((ref) {
  final phaseListenable = _PhaseListenable(ref);
  ref.onDispose(phaseListenable.dispose);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: Routes.plan,
    refreshListenable: phaseListenable,
    redirect: (context, state) {
      final location = state.matchedLocation;

      // Debug spike is always reachable (M0 harness).
      if (location.startsWith(Routes.debugAlarmSpike)) return null;

      final onboardingDone = ref.read(onboardingDoneProvider);
      final isOnboarding = location.startsWith(Routes.onboarding);

      // Onboarding gate — handled fully here so it never falls through to
      // the phase rules (which must not see /onboarding at all).
      if (isOnboarding) {
        // Stay while onboarding is incomplete; leave once it's done.
        return onboardingDone
            ? _homeForPhase(ref.read(dayPhaseProvider))
            : null;
      }
      if (!onboardingDone) return Routes.onboarding;

      // Active promise session → locked timer (ARCHITECTURE.md §8 rule 1).
      // Any navigation away resolves back here until Complete or the
      // safety exit ends the session.
      final session = ref.read(activeTimerSessionProvider).value;
      if (session != null) {
        final timerRoute = '${Routes.focus}/promise/${session.promiseId}';
        return location == timerRoute ? null : timerRoute;
      }

      return _redirectForPhase(ref.read(dayPhaseProvider), location);
    },
    routes: [
      GoRoute(
        path: Routes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: Routes.plan,
        builder: (context, state) => const PlanScreen(),
      ),
      GoRoute(
        path: Routes.planPromises,
        builder: (context, state) => const PromiseBuilderScreen(),
      ),
      GoRoute(
        path: Routes.planSign,
        builder: (context, state) => const SignScreen(),
      ),
      GoRoute(
        path: Routes.night,
        builder: (context, state) => const NightScreen(),
      ),
      GoRoute(
        path: Routes.wake,
        builder: (context, state) => const WakeScreen(),
      ),
      GoRoute(
        path: Routes.focus,
        builder: (context, state) => const FocusScreen(),
      ),
      GoRoute(
        path: '${Routes.focus}/promise/:id',
        builder: (context, state) => PromiseTimerScreen(
          promiseId: state.pathParameters['id'] ?? '',
        ),
      ),
      GoRoute(
        path: Routes.dashboard,
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: Routes.debugAlarmSpike,
        builder: (context, state) => const AlarmSpikeScreen(),
      ),
    ],
  );
});

String _homeForPhase(DayPhase phase) => switch (phase) {
      DayPhase.noPlan => Routes.plan,
      DayPhase.ringing => Routes.wake,
      DayPhase.focus => Routes.focus,
      DayPhase.windDown => Routes.night,
      DayPhase.day || DayPhase.done => Routes.dashboard,
    };

String? _redirectForPhase(DayPhase phase, String location) {
  final home = _homeForPhase(phase);
  final allowed = _allowedRoutes(phase);

  if (location == home || allowed.contains(location)) return null;
  if (phase == DayPhase.focus && location.startsWith('${Routes.focus}/')) {
    return null; // promise timer route
  }
  return home;
}

/// Routes the user may freely navigate to beyond the phase home
/// (ARCHITECTURE.md §8: dashboard link on /night, settings).
Set<String> _allowedRoutes(DayPhase phase) => switch (phase) {
      DayPhase.noPlan => {
          Routes.plan,
          Routes.planPromises,
          Routes.planSign,
        },
      DayPhase.ringing => const {Routes.wake},
      DayPhase.focus => const {Routes.dashboard, Routes.settings},
      DayPhase.windDown => const {Routes.dashboard, Routes.settings},
      DayPhase.day || DayPhase.done => {
          Routes.dashboard,
          Routes.settings,
          // FR-3.4: the night page is the destination right after signing.
          Routes.night,
        },
    };

/// Bridges provider changes to GoRouter's refreshListenable.
class _PhaseListenable extends ChangeNotifier {
  _PhaseListenable(Ref ref) {
    _subs = [
      ref.listen<DayPhase>(dayPhaseProvider, (_, _) => notifyListeners()),
      ref.listen<bool>(onboardingDoneProvider, (_, _) => notifyListeners()),
      ref.listen<AsyncValue<TimerSession?>>(activeTimerSessionProvider,
          (_, _) => notifyListeners()),
    ];
  }

  late final List<ProviderSubscription<dynamic>> _subs;

  @override
  void dispose() {
    for (final sub in _subs) {
      sub.close();
    }
    super.dispose();
  }
}
