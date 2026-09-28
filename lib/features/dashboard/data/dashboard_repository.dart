import 'dart:async';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart' as rx;

import '../../../core/clock/clock.dart';
import '../../../core/db/app_database.dart' as db;
import '../../../core/db/database_provider.dart';
import '../../../core/time/minute_of_day.dart' as t;
import '../../plan/application/phase_providers.dart';
import '../../plan/data/morning_repository.dart';
import '../domain/streak.dart';

/// One dot on the week strip (DESIGN §7.8 item 5).
class WeekDay {
  const WeekDay({
    required this.date,
    required this.result, // kept / full / rest / missed / pending / none
  });

  final DateTime date;
  final String result;
}

/// FR-8.6 wins.
class Wins {
  const Wins({
    required this.totalMinutesKept,
    this.earliestWakeMinute,
    this.mostKeptPromiseTitle,
    this.mostKeptCount = 0,
  });

  /// Total minutes spent on kept promises ("6h 20m on what matters").
  final int totalMinutesKept;

  /// Earliest confirmed wake, minute of day; null when never confirmed.
  final int? earliestWakeMinute;

  /// Promise with the most kept logs in the last 30 days.
  final String? mostKeptPromiseTitle;
  final int mostKeptCount;
}

/// FR-8.7: one promise's 30-day kept rate.
class PromiseRate {
  const PromiseRate({
    required this.promiseId,
    required this.title,
    required this.categoryName,
    required this.iconKey,
    required this.colorKey,
    required this.durationMin,
    required this.kept,
    required this.total,
  });

  final String promiseId;
  final String title;
  final String categoryName;
  final String iconKey;
  final String colorKey;
  final int durationMin;
  final int kept;
  final int total; // mornings in the window where this promise ran

  double get rate => total == 0 ? 0 : kept / total;
}

/// FR-8.x tonight card data.
class TonightInfo {
  const TonightInfo({
    this.wakeAt,
    this.bedMinute,
    this.isRest = false,
    this.promiseCount = 0,
  });

  final DateTime? wakeAt; // next armed wake (local)
  final int? bedMinute;
  final bool isRest; // the upcoming morning is a rest day
  final int promiseCount;
}

/// Everything the dashboard renders, derived live from the DB
/// (ARCHITECTURE.md §9 streakProvider + dashboardStatsProvider).
class DashboardData {
  const DashboardData({
    required this.streak,
    required this.week,
    required this.wins,
    required this.rates,
    required this.tonight,
    required this.todayResult,
    required this.hasHistory,
    required this.todayKept,
    required this.todayTotal,
  });

  final StreakInfo streak;

  /// Last 7 days, oldest first. `none` = no morning that day.
  final List<WeekDay> week;
  final Wins wins;
  final List<PromiseRate> rates;
  final TonightInfo tonight;

  /// Today's morning result ('none' when there is no morning today).
  final String todayResult;

  /// True once any morning has closed — false for the empty state
  /// ("Day 1 starts tonight", FR-8.9).
  final bool hasHistory;

  final int todayKept;
  final int todayTotal;

  bool get todayIsFull => todayResult == 'full';
  bool get todayIsKept => todayResult == 'kept';

  /// FR-9.2: a missed day with the streak at zero offers fresh-start
  /// framing instead of a number.
  bool get showFreshStart =>
      hasHistory && todayResult == 'missed' && streak.current == 0;
}

/// Fresh-start landmark (PRD FR-9.2): the nearest meaningful restart
/// point after a break — tomorrow, Monday, or the 1st of the month.
FreshStartLandmark freshStartLandmark(DateTime today) {
  final tomorrow = today.add(const Duration(days: 1));
  if (tomorrow.day == 1) return FreshStartLandmark.firstOfMonth;
  if (tomorrow.weekday == DateTime.monday) {
    return FreshStartLandmark.monday;
  }
  return FreshStartLandmark.tomorrow;
}

enum FreshStartLandmark { tomorrow, monday, firstOfMonth }

/// Reads everything the dashboard needs as one live stream
/// (FR-8.x; ARCHITECTURE.md §6/§9 — streams via drift `watch()`).
class DashboardRepository {
  DashboardRepository({
    required db.AppDatabase database,
    required Clock clock,
  })  : _db = database,
        _clock = clock;

  final db.AppDatabase _db;
  final Clock _clock;

  Stream<DashboardData> watchDashboard() {
    final mornings = (_db.select(_db.mornings)
          ..orderBy([(m) => OrderingTerm.asc(m.date)]))
        .watch();

    final plan = (_db.select(_db.plans)
          ..where((p) => p.isActive.equals(true))
          ..limit(1))
        .watch()
        .map((rows) => rows.firstOrNull);

    final facts = _db
        .customSelect(
          'SELECT l.id AS log_id, l.morning_id AS morning_id, '
          'l.promise_id AS promise_id, l.status AS status, '
          'l.planned_sec AS planned_sec, p.title AS title, '
          'p.plan_id AS plan_id, p.duration_min AS duration_min, '
          'p.sort_order AS sort_order, '
          'c.name AS category_name, c.icon_key AS icon_key, '
          'c.color_key AS color_key, m.date AS morning_date, '
          'm.result AS morning_result '
          'FROM promise_logs l '
          'JOIN promises p ON p.id = l.promise_id '
          'JOIN categories c ON c.id = p.category_id '
          'JOIN mornings m ON m.id = l.morning_id',
          readsFrom: {
            _db.promiseLogs,
            _db.promises,
            _db.categories,
            _db.mornings,
          },
        )
        .watch();

    return rx.Rx.combineLatest3<List<db.MorningRow>, db.PlanRow?,
        List<QueryRow>, DashboardData>(
      mornings,
      plan,
      facts,
      (m, p, f) => _build(now: _clock.now(), mornings: m, plan: p, facts: f),
    );
  }

  DashboardData _build({
    required DateTime now,
    required List<db.MorningRow> mornings,
    required db.PlanRow? plan,
    required List<QueryRow> facts,
  }) {
    final todayKey = t.dateKey(now);
    final byDate = {for (final m in mornings) m.date: m};
    final today = byDate[todayKey];

    // Streak (FR-8.2–8.4): derived, never stored (ARCHITECTURE.md §12).
    final streak = computeStreak(
      mornings: [
        for (final m in mornings) StreakMorning(date: m.date, result: m.result),
      ],
      journeyStart: plan?.journeyStartDate.toLocal() ?? now,
      today: now,
    );

    // Week strip (FR-8.5): last 7 days, no red ever (missed → neutral).
    final week = <WeekDay>[];
    for (var i = 6; i >= 0; i--) {
      final day = DateTime(now.year, now.month, now.day - i);
      final key = t.dateKey(day);
      final m = byDate[key];
      week.add(WeekDay(
        date: day,
        result: m?.result ?? 'none',
      ));
    }

    // Wins (FR-8.6).
    final keptFacts = facts.where((f) => f.read<String>('status') == 'kept');
    final totalMinutesKept =
        keptFacts.fold<int>(0, (sum, f) => sum + f.read<int>('planned_sec')) ~/
            60;

    var earliestWakeMinute = -1;
    for (final m in mornings) {
      final at = m.wakeConfirmedAt?.toLocal();
      if (at == null) continue;
      final minute = at.hour * 60 + at.minute;
      if (earliestWakeMinute < 0 || minute < earliestWakeMinute) {
        earliestWakeMinute = minute;
      }
    }

    final cutoff30 =
        t.dateKey(DateTime(now.year, now.month, now.day - 29));
    final kept30 = keptFacts.where(
        (f) => f.read<String>('morning_date').compareTo(cutoff30) >= 0);

    // Most-kept promise in the window (ties → plan order).
    final mostKept = <String, int>{
      for (final f in kept30) f.read<String>('title'): 0,
    };
    for (final f in kept30) {
      final title = f.read<String>('title');
      mostKept[title] = (mostKept[title] ?? 0) + 1;
    }
    final bestEntry = mostKept.entries.isEmpty
        ? null
        : mostKept.entries.reduce((a, b) => a.value >= b.value ? a : b);

    // Promise rates (FR-8.7): active plan only, last 30 days, counted
    // over closed mornings — an upcoming or rest morning never counts
    // against the rate (no empty-shaming, DESIGN §7.8 item 7).
    final rates = <PromiseRate>[];
    if (plan != null) {
      final rows = [
        for (final f in facts)
          if (f.read<String>('plan_id') == plan.id &&
              f.read<String>('morning_date').compareTo(cutoff30) >= 0 &&
              f.read<String>('morning_result') != 'pending' &&
              f.read<String>('morning_result') != 'rest')
            f,
      ]..sort((a, b) =>
          a.read<int>('sort_order').compareTo(b.read<int>('sort_order')));

      final grouped = <String, List<QueryRow>>{};
      for (final f in rows) {
        grouped.putIfAbsent(f.read<String>('promise_id'), () => []).add(f);
      }
      for (final entry in grouped.entries) {
        final logs = entry.value;
        rates.add(PromiseRate(
          promiseId: entry.key,
          title: logs.first.read<String>('title'),
          categoryName: logs.first.read<String>('category_name'),
          iconKey: logs.first.read<String>('icon_key'),
          colorKey: logs.first.read<String>('color_key'),
          durationMin: logs.first.read<int>('duration_min'),
          kept: logs.where((l) => l.read<String>('status') == 'kept').length,
          total: logs.length,
        ));
      }
    }

    // Tonight card (DESIGN §7.8 item 8): the next armed morning dated
    // today or tomorrow (a rest morning counts — shown as a rest chip).
    final tomorrowKey = t.dateKey(now.add(const Duration(days: 1)));
    db.MorningRow? next;
    for (final m in mornings) {
      if (m.date != todayKey && m.date != tomorrowKey) continue;
      if (!m.scheduledAt.toLocal().isAfter(now)) continue;
      if (m.result != 'pending' && m.result != 'rest') continue;
      if (next == null || m.scheduledAt.isAfter(next.scheduledAt)) {
        next = m;
      }
    }
    final tonight = TonightInfo(
      wakeAt: next?.scheduledAt.toLocal(),
      bedMinute: plan?.bedMinute,
      isRest: next?.result == 'rest',
      promiseCount: next == null
          ? 0
          : facts
              .where((f) => f.read<String>('morning_id') == next!.id)
              .length,
    );

    return DashboardData(
      streak: streak,
      week: week,
      wins: Wins(
        totalMinutesKept: totalMinutesKept,
        earliestWakeMinute:
            earliestWakeMinute < 0 ? null : earliestWakeMinute,
        mostKeptPromiseTitle: bestEntry?.key,
        mostKeptCount: bestEntry?.value ?? 0,
      ),
      rates: rates,
      tonight: tonight,
      todayResult: today?.result ?? 'none',
      hasHistory: mornings.any((m) => m.result != 'pending'),
      todayKept: today == null
          ? 0
          : facts
              .where((f) =>
                  f.read<String>('morning_id') == today.id &&
                  f.read<String>('status') == 'kept')
              .length,
      todayTotal: today == null
          ? 0
          : facts.where((f) => f.read<String>('morning_id') == today.id).length,
    );
  }
}

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepository(
    database: ref.watch(databaseProvider),
    clock: ref.watch(clockProvider),
  );
});

/// FR-8.x dashboard feed (live; re-subscribed each phase tick so "today"
/// rolls over at midnight, like `relevantMorningProvider`).
final dashboardDataProvider = StreamProvider<DashboardData>((ref) {
  ref.watch(phaseTickProvider);
  return ref.watch(dashboardRepositoryProvider).watchDashboard();
});

/// ARCHITECTURE.md §9 `streakProvider` — cached view of the streak.
final streakProvider = Provider<StreakInfo?>((ref) {
  return ref.watch(dashboardDataProvider).value?.streak;
});

/// Whether the upcoming morning may be marked as a rest day
/// (FR-9.1 rolling-7-day limit; re-checked on DB changes).
final canMarkRestDayProvider = StreamProvider<bool>((ref) {
  ref.watch(dashboardDataProvider);
  return ref
      .watch(morningRepositoryProvider)
      .canMarkRestDay()
      .asStream();
});
