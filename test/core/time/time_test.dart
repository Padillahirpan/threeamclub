import 'package:flutter_test/flutter_test.dart';
import 'package:subuhan/core/time/minute_of_day.dart' as t;
import 'package:subuhan/core/time/time_budget.dart';

void main() {
  group('sleepDurationMinutes', () {
    test('21:00 → 04:00 is 7h (PRD FR-1.2 acceptance)', () {
      expect(
        t.sleepDurationMinutes(bedMinute: 21 * 60, wakeMinute: 4 * 60),
        420,
      );
    });

    test('crossing midnight', () {
      // 23:30 → 03:15
      expect(
        t.sleepDurationMinutes(bedMinute: 23 * 60 + 30, wakeMinute: 3 * 60 + 15),
        225,
      );
    });

    test('degenerate: same minute yields 0, not a full day', () {
      // bed and wake never coincide in practice (bed is evening, wake 3–5am).
      expect(t.sleepDurationMinutes(bedMinute: 300, wakeMinute: 300), 0);
    });

    test('hint threshold', () {
      expect(
        t.isSleepTooShort(bedMinute: 22 * 60, wakeMinute: 4 * 60), // 6h
        isTrue,
      );
      expect(
        t.isSleepTooShort(bedMinute: 21 * 60, wakeMinute: 4 * 60), // 7h
        isFalse,
      );
    });
  });

  group('nextOccurrence', () {
    test('later today', () {
      final now = DateTime(2026, 9, 28, 20, 0);
      final next = t.nextOccurrence(now: now, minuteOfDay: 4 * 60);
      expect(next, DateTime(2026, 9, 29, 4, 0));
    });

    test('already passed today → tomorrow', () {
      final now = DateTime(2026, 9, 28, 5, 30);
      final next = t.nextOccurrence(now: now, minuteOfDay: 4 * 60);
      expect(next, DateTime(2026, 9, 29, 4, 0));
    });

    test('exactly now → tomorrow (strictly after)', () {
      final now = DateTime(2026, 9, 28, 4, 0, 0);
      final next = t.nextOccurrence(now: now, minuteOfDay: 4 * 60);
      expect(next, DateTime(2026, 9, 29, 4, 0));
    });

    test('just before → today', () {
      final now = DateTime(2026, 9, 28, 3, 59, 59);
      final next = t.nextOccurrence(now: now, minuteOfDay: 4 * 60);
      expect(next, DateTime(2026, 9, 28, 4, 0));
    });
  });

  group('bedtimeReminderBefore', () {
    test('wake 04:00, bed 21:00, lead 30 → previous day 20:30', () {
      final wakeAt = DateTime(2026, 9, 29, 4, 0);
      final reminder = t.bedtimeReminderBefore(
        wakeAt: wakeAt,
        bedMinute: 21 * 60,
        leadMinutes: 30,
      );
      expect(reminder, DateTime(2026, 9, 28, 20, 30));
    });

    test('lead crossing midnight backwards', () {
      final wakeAt = DateTime(2026, 9, 29, 3, 0);
      final reminder = t.bedtimeReminderBefore(
        wakeAt: wakeAt,
        bedMinute: 0, // bed right after midnight
        leadMinutes: 30,
      );
      expect(reminder, DateTime(2026, 9, 27, 23, 30));
    });
  });

  group('formatting', () {
    test('formatMinuteOfDay', () {
      expect(t.formatMinuteOfDay(4 * 60 + 5), '04:05');
      expect(t.formatMinuteOfDay(0), '00:00');
      expect(t.formatMinuteOfDay(23 * 60 + 59), '23:59');
    });

    test('dateKey', () {
      expect(t.dateKey(DateTime(2026, 9, 28)), '2026-09-28');
    });
  });

  group('TimeBudget (PRD FR-2.5 acceptance)', () {
    test('wake 04:30 gives a 90-minute budget', () {
      final budget = computeTimeBudget(
        wakeMinute: 4 * 60 + 30,
        promiseDurationMinutes: const [30, 30, 30],
      );
      expect(budget.budgetMinutes, 90);
      expect(budget.usedMinutes, 90);
      expect(budget.isOver, isFalse);
      expect(budget.finishMinute, 6 * 60);
    });

    test('100 minutes on a 90 budget is over by 10', () {
      final budget = computeTimeBudget(
        wakeMinute: 4 * 60 + 30,
        promiseDurationMinutes: const [60, 40],
      );
      expect(budget.isOver, isTrue);
      expect(budget.overByMinutes, 10); // "Trim 10 min to fit before 6:00"
    });

    test('wake 03:00 gives 180 minutes', () {
      final budget = computeTimeBudget(
        wakeMinute: 3 * 60,
        promiseDurationMinutes: const [],
      );
      expect(budget.budgetMinutes, 180);
    });
  });
}
