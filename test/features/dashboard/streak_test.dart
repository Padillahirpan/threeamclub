import 'package:flutter_test/flutter_test.dart';
import 'package:subuhan/features/dashboard/domain/streak.dart';

void main() {
  DateTime d(int day) => DateTime(2026, 9, day);
  DateTime dateOf(StreakMorning m) => DateTime.parse(m.date);

  // Helpers keep the table readable.
  List<StreakMorning> ms(List<String> results) => [
        for (var i = 0; i < results.length; i++)
          StreakMorning(
            date:
                '${d(1 + i).year}-${(d(1 + i).month).toString().padLeft(2, '0')}-${(d(1 + i).day).toString().padLeft(2, '0')}',
            result: results[i],
          ),
      ];

  group('current streak', () {
    test('consecutive kept/full count; full counts like kept', () {
      final info = computeStreak(
        mornings: ms(['missed', 'kept', 'full', 'kept']),
        journeyStart: d(1),
        today: d(4),
      );
      expect(info.current, 3);
    });

    test('missed resets; only the run after the last miss counts', () {
      final info = computeStreak(
        mornings: ms(['kept', 'kept', 'missed', 'kept']),
        journeyStart: d(1),
        today: d(4),
      );
      expect(info.current, 1);
      expect(info.best, 2);
    });

    test('rest is neutral — neither extends nor breaks', () {
      final info = computeStreak(
        mornings: ms(['kept', 'rest', 'kept']),
        journeyStart: d(1),
        today: d(3),
      );
      expect(info.current, 2);
    });

    test('trailing rest keeps the streak alive', () {
      final info = computeStreak(
        mornings: ms(['kept', 'kept', 'rest']),
        journeyStart: d(1),
        today: d(3),
      );
      expect(info.current, 2);
    });

    test('pending (today, not closed) never breaks a streak', () {
      final info = computeStreak(
        mornings: ms(['kept', 'kept', 'pending']),
        journeyStart: d(1),
        today: d(3),
      );
      expect(info.current, 2);
    });

    test('all missed → 0', () {
      final info = computeStreak(
        mornings: ms(['missed', 'missed']),
        journeyStart: d(1),
        today: d(2),
      );
      expect(info.current, 0);
      expect(info.best, 0);
    });
  });

  group('best streak', () {
    test('longest run anywhere in history', () {
      final info = computeStreak(
        mornings: ms([
          'kept', 'kept', 'kept', 'kept', 'missed', 'kept', 'kept',
        ]),
        journeyStart: d(1),
        today: d(7),
      );
      expect(info.current, 2);
      expect(info.best, 4);
    });

    test('rest does not interrupt a run for best either', () {
      final info = computeStreak(
        mornings: ms(['kept', 'rest', 'kept', 'kept']),
        journeyStart: d(1),
        today: d(4),
      );
      expect(info.best, 3);
    });
  });

  group('milestones (FR-8.4)', () {
    test('empty history → next is 3', () {
      final info = computeStreak(
        mornings: const [],
        journeyStart: d(1),
        today: d(1),
      );
      expect(info.current, 0);
      expect(info.nextMilestone, 3);
    });

    test('2 kept → next is 3 ("2 days to your 3-day sun")', () {
      final info = computeStreak(
        mornings: ms(['kept', 'kept']),
        journeyStart: d(1),
        today: d(2),
      );
      expect(info.nextMilestone, 3);
    });

    test('exactly 7 → next is 14; 66 → none', () {
      final seven = computeStreak(
        mornings: ms(List.filled(7, 'kept')),
        journeyStart: d(1),
        today: d(7),
      );
      expect(seven.nextMilestone, 14);

      final sixtySix = computeStreak(
        mornings: ms(List.filled(66, 'kept')),
        journeyStart: d(1),
        today: d(66),
      );
      expect(sixtySix.current, 66);
      expect(sixtySix.nextMilestone, isNull);
    });
  });

  group('66-day journey (PRD §7)', () {
    test('day 1 is phase 1', () {
      final info = computeStreak(
        mornings: const [],
        journeyStart: d(1),
        today: d(1),
      );
      expect(info.journeyDay, 1);
      expect(info.journeyPhase, 1);
      expect(info.journeyComplete, isFalse);
    });

    test('day 22 phase 1, day 23 phase 2, day 44 phase 2, day 45 phase 3',
        () {
      int phaseFor(int day) => computeStreak(
            mornings: const [],
            journeyStart: d(1),
            today: d(day),
          ).journeyPhase;

      expect(phaseFor(22), 1);
      expect(phaseFor(23), 2);
      expect(phaseFor(44), 2);
      expect(phaseFor(45), 3);
      expect(phaseFor(66), 3);
    });

    test('day 67 → journey complete (renew/continue decision, post-MVP)',
        () {
      final info = computeStreak(
        mornings: const [],
        journeyStart: d(1),
        today: d(67),
      );
      expect(info.journeyDay, 67);
      expect(info.journeyComplete, isTrue);
    });

    test('signing later today still shows day 1 (same-day floor)', () {
      final info = computeStreak(
        mornings: const [],
        journeyStart: DateTime(2026, 9, 28, 20),
        today: DateTime(2026, 9, 28, 23),
      );
      expect(info.journeyDay, 1);
    });
  });

  test('dateOf parses morning date keys', () {
    expect(dateOf(const StreakMorning(date: '2026-09-28', result: 'kept')),
        DateTime(2026, 9, 28));
  });
}
