import 'minute_of_day.dart' as t;

/// The app's phase by time of day and DB state — decides which page opens
/// (ARCHITECTURE.md §7, PRD §7 "App phase by time of day").
///
/// Pure function; unit-tested with a fake clock.
enum DayPhase { noPlan, day, windDown, ringing, focus, done }

/// Plan timing needed by [resolveDayPhase].
class PhasePlanTimes {
  const PhasePlanTimes({
    required this.bedMinute,
    required this.wakeMinute,
    this.leadMinutes = 30,
  });

  final int bedMinute;
  final int wakeMinute;

  /// Bedtime reminder lead (settings, default 30 min).
  final int leadMinutes;
}

/// Morning state needed by [resolveDayPhase]. All instants are local.
class PhaseMorningState {
  const PhaseMorningState({
    required this.scheduledAt,
    this.alarmFiredAt,
    this.wakeConfirmedAt,
    this.allPromisesKept = false,
    this.isRest = false,
  });

  final DateTime scheduledAt;
  final DateTime? alarmFiredAt;
  final DateTime? wakeConfirmedAt;
  final bool allPromisesKept;

  /// A rest day (PRD FR-9.1): the alarm is cancelled, so the wake window
  /// is a quiet dashboard day — never `ringing`.
  final bool isRest;

  DateTime get closesAt => DateTime(
        scheduledAt.year,
        scheduledAt.month,
        scheduledAt.day,
        t.morningCloseMinute ~/ 60,
        t.morningCloseMinute % 60,
      );
}

/// Resolves the current phase.
///
/// Rules (PRD §7):
/// - `noPlan`   no active signed plan → /plan
/// - `ringing`  alarm time reached (or alarm fired) and wake not confirmed,
///              until 06:00 → /wake
/// - `focus`    wake confirmed, before 06:00, promises remaining → /focus
/// - `done`     all promises kept, or 06:00 passed → /dashboard
/// - `windDown` from bedtime − lead until the alarm → /night
/// - `day`      otherwise → /dashboard
DayPhase resolveDayPhase({
  required DateTime now,
  PhasePlanTimes? plan,
  PhaseMorningState? morning,
}) {
  if (plan == null) return DayPhase.noPlan;

  if (morning != null) {
    final wakeAt = morning.scheduledAt;
    if (now.isAfter(morning.closesAt)) return DayPhase.done;

    if (morning.wakeConfirmedAt != null) {
      return morning.allPromisesKept ? DayPhase.done : DayPhase.focus;
    }
    // A rest morning is already "closed" — its wake window is a normal
    // dashboard day (FR-9.1: no alarm, no ringing).
    if (morning.isRest) return DayPhase.done;
    // The alarm time has been reached (covers the cold-start case where
    // alarmFiredAt has not been backfilled yet) — late wake still allowed
    // until 06:00 (PRD §7 "Late wake").
    if (!now.isBefore(wakeAt) || morning.alarmFiredAt != null) {
      return DayPhase.ringing;
    }
  }

  // Before the alarm: the wind-down window starts at bedtime − lead on the
  // evening before the wake date.
  final wakeDate = morning?.scheduledAt ??
      t.nextOccurrence(now: now, minuteOfDay: plan.wakeMinute);
  final windDownStart = DateTime(wakeDate.year, wakeDate.month, wakeDate.day)
      .subtract(const Duration(days: 1))
      .add(Duration(minutes: plan.bedMinute - plan.leadMinutes));
  final alarmAt = morning?.scheduledAt ??
      DateTime(wakeDate.year, wakeDate.month, wakeDate.day,
          plan.wakeMinute ~/ 60, plan.wakeMinute % 60);

  if (!now.isBefore(windDownStart) && now.isBefore(alarmAt)) {
    return DayPhase.windDown;
  }
  return DayPhase.day;
}
