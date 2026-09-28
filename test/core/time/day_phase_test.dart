import 'package:flutter_test/flutter_test.dart';
import 'package:subuhan/core/time/day_phase.dart';
import 'package:subuhan/core/time/minute_of_day.dart' as t;

void main() {
  // Reference plan: bed 21:00, wake 04:00, lead 30 min.
  const plan = PhasePlanTimes(bedMinute: 21 * 60, wakeMinute: 4 * 60);

  // Tuesday 2026-09-29 04:00 morning.
  final wakeAt = DateTime(2026, 9, 29, 4, 0);
  final closesAt = DateTime(2026, 9, 29, 6, 0);
  final windDownStart = DateTime(2026, 9, 28, 20, 30);

  PhaseMorningState morning({
    DateTime? alarmFiredAt,
    DateTime? wakeConfirmedAt,
    bool allKept = false,
  }) =>
      PhaseMorningState(
        scheduledAt: wakeAt,
        alarmFiredAt: alarmFiredAt,
        wakeConfirmedAt: wakeConfirmedAt,
        allPromisesKept: allKept,
      );

  group('noPlan', () {
    test('no signed plan', () {
      expect(
        resolveDayPhase(now: DateTime(2026, 9, 28, 15), plan: null),
        DayPhase.noPlan,
      );
    });
  });

  group('windDown (FR-4.x)', () {
    test('evening: from bedtime − lead until the alarm', () {
      expect(
        resolveDayPhase(
          now: windDownStart, // 20:30 exactly
          plan: plan,
          morning: morning(),
        ),
        DayPhase.windDown,
      );
      expect(
        resolveDayPhase(
          now: DateTime(2026, 9, 28, 23, 59),
          plan: plan,
          morning: morning(),
        ),
        DayPhase.windDown,
      );
    });

    test('after midnight, before the alarm', () {
      expect(
        resolveDayPhase(
          now: DateTime(2026, 9, 29, 2, 0),
          plan: plan,
          morning: morning(),
        ),
        DayPhase.windDown,
      );
    });

    test('before bedtime lead → day', () {
      expect(
        resolveDayPhase(
          now: DateTime(2026, 9, 28, 15, 0),
          plan: plan,
          morning: morning(),
        ),
        DayPhase.day,
      );
    });

    test('one minute before wind-down starts → day', () {
      expect(
        resolveDayPhase(
          now: DateTime(2026, 9, 28, 20, 29),
          plan: plan,
          morning: morning(),
        ),
        DayPhase.day,
      );
    });
  });

  group('ringing (FR-5.x)', () {
    test('alarm fired, not confirmed', () {
      expect(
        resolveDayPhase(
          now: DateTime(2026, 9, 29, 4, 0),
          plan: plan,
          morning: morning(alarmFiredAt: DateTime(2026, 9, 29, 4, 0)),
        ),
        DayPhase.ringing,
      );
    });

    test('alarm time reached even without a fired-backfill (cold start)', () {
      expect(
        resolveDayPhase(
          now: DateTime(2026, 9, 29, 4, 10),
          plan: plan,
          morning: morning(),
        ),
        DayPhase.ringing,
      );
    });

    test('late wake window: still ringing at 05:59', () {
      expect(
        resolveDayPhase(
          now: DateTime(2026, 9, 29, 5, 59),
          plan: plan,
          morning: morning(alarmFiredAt: DateTime(2026, 9, 29, 4, 0)),
        ),
        DayPhase.ringing,
      );
    });

    test('06:00 passed → done (morning closed)', () {
      expect(
        resolveDayPhase(
          now: DateTime(2026, 9, 29, 6, 1),
          plan: plan,
          morning: morning(alarmFiredAt: DateTime(2026, 9, 29, 4, 0)),
        ),
        DayPhase.done,
      );
    });
  });

  group('focus (FR-6.x)', () {
    test('wake confirmed, promises remaining', () {
      expect(
        resolveDayPhase(
          now: DateTime(2026, 9, 29, 4, 5),
          plan: plan,
          morning: morning(
            alarmFiredAt: DateTime(2026, 9, 29, 4, 0),
            wakeConfirmedAt: DateTime(2026, 9, 29, 4, 1),
          ),
        ),
        DayPhase.focus,
      );
    });

    test('all promises kept → done before 06:00', () {
      expect(
        resolveDayPhase(
          now: DateTime(2026, 9, 29, 5, 30),
          plan: plan,
          morning: morning(
            wakeConfirmedAt: DateTime(2026, 9, 29, 4, 1),
            allKept: true,
          ),
        ),
        DayPhase.done,
      );
    });

    test('06:00 passed after confirmation → done', () {
      expect(
        resolveDayPhase(
          now: DateTime(2026, 9, 29, 6, 30),
          plan: plan,
          morning: morning(wakeConfirmedAt: DateTime(2026, 9, 29, 4, 1)),
        ),
        DayPhase.done,
      );
    });
  });

  group('day', () {
    test('after the morning closes, before the next wind-down', () {
      expect(
        resolveDayPhase(
          now: DateTime(2026, 9, 29, 12, 0),
          plan: plan,
          // Next morning (Wed) already rolled over.
          morning: PhaseMorningState(
            scheduledAt: DateTime(2026, 9, 30, 4, 0),
          ),
        ),
        DayPhase.day,
      );
    });
  });

  group('morning == null (edge before bootstrap)', () {
    test('evening in wind-down with no morning row yet', () {
      expect(
        resolveDayPhase(now: DateTime(2026, 9, 28, 21, 30), plan: plan),
        DayPhase.windDown,
      );
    });

    test('afternoon with no morning row → day', () {
      expect(
        resolveDayPhase(now: DateTime(2026, 9, 28, 15, 0), plan: plan),
        DayPhase.day,
      );
    });

    test('past the wake time with no morning row → day (bootstrap fixes)', () {
      // No morning row means no alarm was scheduled for this wake; the
      // app-open sync creates the missing morning.
      expect(
        resolveDayPhase(now: DateTime(2026, 9, 29, 4, 30), plan: plan),
        DayPhase.day,
      );
    });
  });

  test('closesAt is 06:00 on the wake date', () {
    expect(morning().closesAt, closesAt);
    expect(t.morningCloseMinute, 6 * 60);
  });
}
