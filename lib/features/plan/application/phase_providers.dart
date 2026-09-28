import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/clock/clock.dart';
import '../../../core/db/app_database.dart' as db;
import '../../../core/time/day_phase.dart';
import '../data/morning_repository.dart';
import '../data/plan_repository.dart';

/// Time-based re-evaluation for [dayPhaseProvider] (ARCHITECTURE.md §7):
/// ticks every 30s and on app resume. Minute precision is enough — alarm
/// transitions are event-driven.
class PhaseTick extends Notifier<int> {
  Timer? _timer;

  @override
  int build() {
    _timer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (state >= 0) state++;
    });
    ref.onDispose(() {
      _timer?.cancel();
      _timer = null;
    });
    return 0;
  }

  /// Called on app resume (WidgetsBindingObserver).
  void bump() => state++;
}

final phaseTickProvider = NotifierProvider<PhaseTick, int>(PhaseTick.new);

/// Active signed plan (stream; live).
final activePlanProvider = StreamProvider<db.PlanRow?>((ref) {
  return ref.watch(morningRepositoryProvider).watchActivePlan();
});

/// Bedtime reminder lead (settings; read once, rarely changes).
final bedtimeLeadProvider = FutureProvider<int>((ref) {
  return ref.watch(morningRepositoryProvider).bedtimeLeadMinutes();
});

/// The morning relevant now — today's or tomorrow's (live). Re-created on
/// each phase tick so the {today, tomorrow} date window rolls at midnight.
final relevantMorningProvider = StreamProvider<RelevantMorning?>((ref) {
  ref.watch(phaseTickProvider);
  return ref.watch(morningRepositoryProvider).watchRelevantMorning();
});

/// The app phase (ARCHITECTURE.md §7). Watches the clock tick, the plan,
/// the relevant morning and the bedtime lead.
final dayPhaseProvider = Provider<DayPhase>((ref) {
  ref.watch(phaseTickProvider);
  final plan = ref.watch(activePlanProvider).value;
  final morning = ref.watch(relevantMorningProvider).value;
  final lead = ref.watch(bedtimeLeadProvider).value ?? 30;

  return resolveDayPhase(
    now: ref.watch(clockProvider).now(),
    plan: plan == null
        ? null
        : PhasePlanTimes(
            bedMinute: plan.bedMinute,
            wakeMinute: plan.wakeMinute,
            leadMinutes: lead,
          ),
    morning: morning == null
        ? null
        : PhaseMorningState(
            scheduledAt: morning.scheduledAt,
            alarmFiredAt: morning.alarmFiredAt,
            wakeConfirmedAt: morning.wakeConfirmedAt,
            allPromisesKept: morning.allPromisesKept,
          ),
  );
});

/// Whether the native alarm is currently ringing (event-driven).
class AlarmRinging extends Notifier<bool> {
  @override
  bool build() => false;

  void set(bool value) => state = value;
}

final alarmRingingProvider =
    NotifierProvider<AlarmRinging, bool>(AlarmRinging.new);

/// Subscribes to native alarm events and keeps the app in sync:
/// backfills `alarmFiredAt`, mirrors the ringing state.
/// Warmed by the router so it lives for the whole app session.
final alarmEventProcessorProvider = Provider<void>((ref) {
  final repo = ref.watch(morningRepositoryProvider);
  final sub = ref.watch(alarmSchedulerProvider).events.listen(
    (event) async {
      switch (event.type) {
        case 'fired':
        case 'openWake':
          ref.read(alarmRingingProvider.notifier).set(true);
          final morning = await repo.relevantMorning();
          if (morning != null) {
            await repo.markAlarmFired(morning.id);
          }
        case 'stopped':
          ref.read(alarmRingingProvider.notifier).set(false);
        default:
          break; // rescheduled:*, passed_while_off:*, gaveup
      }
    },
    onError: (Object _) {
      // Channel errors must never take the app down (e.g. in tests).
    },
  );
  ref.onDispose(sub.cancel);
});
