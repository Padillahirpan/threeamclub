/// Pure minute-of-day helpers (ARCHITECTURE.md §5 `core/time/`).
///
/// Times of day are minutes from midnight; instants are DateTime.
/// All functions are pure and unit-tested.
library;

const int minutesPerDay = 24 * 60;

/// Wake window: user-chosen between 03:00 and 05:00 (PRD FR-1.1).
const int wakeWindowStart = 3 * 60;
const int wakeWindowEnd = 5 * 60;

/// The morning closes at 06:00 (PRD §7).
const int morningCloseMinute = 6 * 60;

/// Below this, the sleep hint appears (PRD FR-1.2: "about 7 hours").
const int sleepHintThresholdMinutes = 7 * 60;

/// Sleep duration from bedtime to wake time, across midnight.
/// 21:00 → 04:00 is 7h (420 min).
int sleepDurationMinutes({
  required int bedMinute,
  required int wakeMinute,
}) =>
    (wakeMinute - bedMinute + minutesPerDay) % minutesPerDay;

bool isSleepTooShort({
  required int bedMinute,
  required int wakeMinute,
}) =>
    sleepDurationMinutes(bedMinute: bedMinute, wakeMinute: wakeMinute) <
        sleepHintThresholdMinutes;

/// Next DateTime at [minuteOfDay] strictly after [now] —
/// today if still ahead, otherwise tomorrow.
DateTime nextOccurrence({required DateTime now, required int minuteOfDay}) {
  final candidate = DateTime(
    now.year,
    now.month,
    now.day,
    minuteOfDay ~/ 60,
    minuteOfDay % 60,
  );
  return candidate.isAfter(now)
      ? candidate
      : candidate.add(const Duration(days: 1));
}

/// The bedtime reminder for the evening before [wakeAt]:
/// wake date − 1 day at [bedMinute] − [leadMinutes].
DateTime bedtimeReminderBefore({
  required DateTime wakeAt,
  required int bedMinute,
  required int leadMinutes,
}) {
  final eveningBefore = DateTime(wakeAt.year, wakeAt.month, wakeAt.day)
      .subtract(const Duration(days: 1));
  final atBedtime = DateTime(
    eveningBefore.year,
    eveningBefore.month,
    eveningBefore.day,
    bedMinute ~/ 60,
    bedMinute % 60,
  );
  return atBedtime.subtract(Duration(minutes: leadMinutes));
}

/// "21:05" — used for plan display; wake/night use the big time display.
String formatMinuteOfDay(int minuteOfDay) {
  assert(minuteOfDay >= 0 && minuteOfDay < minutesPerDay);
  final h = (minuteOfDay ~/ 60).toString().padLeft(2, '0');
  final m = (minuteOfDay % 60).toString().padLeft(2, '0');
  return '$h:$m';
}

/// Local date string "2026-09-28" — the `mornings.date` key
/// (ARCHITECTURE.md §6).
String dateKey(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-'
    '${date.month.toString().padLeft(2, '0')}-'
    '${date.day.toString().padLeft(2, '0')}';
