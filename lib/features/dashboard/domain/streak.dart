/// Streak & journey rules (PRD §7, ARCHITECTURE.md §12).
///
/// Pure Dart over closed mornings; derived, never stored, so there is no
/// separate counter to corrupt.
library;

/// Morning results (PRD §7). `pending` mornings are ignored by the math —
/// today isn't judged before it closes.
enum MorningResult { pending, kept, full, missed, rest }

/// Milestones on the 66-day arc (PRD FR-8.4).
const List<int> kMilestones = [3, 7, 14, 21, 30, 44, 66];

/// 66-day journey phases (PRD §7): days 1–22, 23–44, 45–66.
const int kJourneyPhase1End = 22;
const int kJourneyPhase2End = 44;
const int kJourneyLengthDays = 66;

class StreakInfo {
  const StreakInfo({
    required this.current,
    required this.best,
    required this.nextMilestone,
    required this.journeyDay,
    required this.journeyPhase,
    required this.journeyLengthDays,
  });

  /// Consecutive kept/full mornings. Rest days pause it without adding.
  final int current;

  /// Best run ever.
  final int best;

  /// Next milestone above [current], null after 66.
  final int? nextMilestone;

  /// Day on the journey, 1-based from signing.
  final int journeyDay;

  /// 1 = break the old pattern, 2 = build the new one, 3 = make it yours.
  final int journeyPhase;

  final int journeyLengthDays;

  bool get journeyComplete => journeyDay > journeyLengthDays;
}

/// A closed-or-pending morning as seen by the streak: `date` is the wake
/// date key, `result` one of pending/kept/full/missed/rest.
class StreakMorning {
  const StreakMorning({required this.date, required this.result});

  final String date;
  final String result;
}

/// Computes current/best streak, next milestone and the journey position.
///
/// [mornings] must be ordered ascending by date. `pending` entries are
/// skipped (today's open morning never breaks a streak); `rest` is
/// neutral — it neither extends nor breaks (PRD §7).
StreakInfo computeStreak({
  required List<StreakMorning> mornings,
  required DateTime journeyStart,
  required DateTime today,
  int journeyLengthDays = kJourneyLengthDays,
}) {
  var current = 0;
  // Walk backwards from the latest morning: kept/full extend, rest and
  // pending are neutral (skipped), missed ends the run. `break` inside a
  // switch case would only exit the switch — hence the if-chain.
  for (final m in mornings.reversed) {
    if (m.result == 'kept' || m.result == 'full') {
      current++;
    } else if (m.result == 'missed') {
      break;
    }
  }

  var best = 0;
  var run = 0;
  for (final m in mornings) {
    switch (m.result) {
      case 'kept':
      case 'full':
        run++;
        if (run > best) best = run;
      case 'missed':
        run = 0;
      default:
        break; // rest/pending neither extend nor reset
    }
  }
  if (current > best) best = current;

  final nextMilestone =
      kMilestones.where((m) => m > current).firstOrNull;

  final journeyDay =
      today.difference(DateTime(journeyStart.year, journeyStart.month,
              journeyStart.day))
          .inDays + 1;

  final journeyPhase = journeyDay <= kJourneyPhase1End
      ? 1
      : journeyDay <= kJourneyPhase2End
          ? 2
          : 3;

  return StreakInfo(
    current: current,
    best: best,
    nextMilestone: nextMilestone,
    journeyDay: journeyDay < 1 ? 1 : journeyDay,
    journeyPhase: journeyPhase,
    journeyLengthDays: journeyLengthDays,
  );
}
