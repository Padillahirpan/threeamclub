import 'minute_of_day.dart';

/// Time budget rule (PRD FR-2.5): the sum of promise durations must fit
/// between the wake time and 06:00.
class TimeBudget {
  const TimeBudget({
    required this.wakeMinute,
    required this.usedMinutes,
  });

  final int wakeMinute;
  final int usedMinutes;

  int get budgetMinutes => morningCloseMinute - wakeMinute;

  bool get isOver => usedMinutes > budgetMinutes;

  /// Minutes to remove before the plan can be signed.
  int get overByMinutes => isOver ? usedMinutes - budgetMinutes : 0;

  /// Minute-of-day at which the promise list finishes (wake + total).
  /// Only meaningful when within budget.
  int get finishMinute => wakeMinute + usedMinutes;
}

TimeBudget computeTimeBudget({
  required int wakeMinute,
  required Iterable<int> promiseDurationMinutes,
}) =>
    TimeBudget(
      wakeMinute: wakeMinute,
      usedMinutes: promiseDurationMinutes.fold(0, (a, b) => a + b),
    );
