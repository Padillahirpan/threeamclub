import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../app/router/routes.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/platform/method_channel_alarm_scheduler.dart';
import '../../../core/time/minute_of_day.dart' as t;
import '../../../core/widgets/journey_arc.dart';
import '../../../core/widgets/milestone_badge.dart';
import '../../../core/widgets/streak_sun.dart';
import '../../../core/widgets/week_strip.dart' as ws;
import '../../plan/application/phase_providers.dart';
import '../../plan/data/morning_repository.dart';
import '../../settings/application/alarm_health.dart';
import '../data/dashboard_repository.dart';
import '../domain/streak.dart';
import 'widgets/celebrations.dart';

/// Dashboard — step 8 (PRD FR-8.x, DESIGN.md §7.8): streak sun, journey,
/// milestones, week strip, wins, promise rates, tonight card, rest day.
class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  bool _burst = false;
  bool _confetti = false;

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;
    final data = ref.watch(dashboardDataProvider).value;

    if (data == null) {
      return Scaffold(
        appBar: AppBar(title: Text(s.dashboardTitle)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // Celebrations (FR-8.8): once per day, reduced-motion aware inside
    // the overlay widgets themselves.
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeCelebrate(data));

    return Scaffold(
      appBar: AppBar(
        title: Text(s.dashboardTitle),
        actions: [
          IconButton(
            tooltip: s.settingsTitle,
            onPressed: () => context.push(Routes.settings),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: [
              const _AlarmHealthCard(),
              if (!data.hasHistory) ...[
                _WelcomeState(s: s),
              ] else ...[
                _HeroCard(data: data, s: s),
                const SizedBox(height: 16),
                _StreakSection(data: data, s: s),
                const SizedBox(height: 16),
                _MilestoneSection(data: data, s: s),
                const SizedBox(height: 16),
                _JourneySection(data: data, s: s),
                const SizedBox(height: 16),
                _WeekSection(data: data, s: s),
                const SizedBox(height: 16),
                _WinsSection(data: data, s: s),
                if (data.rates.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _RatesSection(data: data, s: s),
                ],
              ],
              const SizedBox(height: 16),
              _TonightCard(data: data, s: s),
            ],
          ),
          if (_burst)
            FullMorningBurst(onFinished: () => setState(() => _burst = false)),
          if (_confetti)
            MilestoneConfetti(
                onFinished: () => setState(() => _confetti = false)),
        ],
      ),
    );
  }

  Future<void> _maybeCelebrate(DashboardData data) async {
    if (!mounted) return;
    final prefs = await SharedPreferences.getInstance();
    final day = t.dateKey(DateTime.now());

    if (data.todayIsFull && !(prefs.getBool('celebrated-full-$day') ?? false)) {
      await prefs.setBool('celebrated-full-$day', true);
      if (mounted) setState(() => _burst = true);
      return;
    }

    final milestoneToday = data.todayIsKept || data.todayIsFull;
    if (milestoneToday &&
        kMilestones.contains(data.streak.current) &&
        !(prefs.getBool('celebrated-m${data.streak.current}-$day') ??
            false)) {
      await prefs.setBool(
          'celebrated-m${data.streak.current}-$day', true);
      if (mounted) setState(() => _confetti = true);
    }
  }
}

/// Alarm health warning (M5, ARCHITECTURE.md §10): shown when a critical
/// permission was revoked — gentle wording, one tap to re-request.
class _AlarmHealthCard extends ConsumerStatefulWidget {
  const _AlarmHealthCard();

  @override
  ConsumerState<_AlarmHealthCard> createState() => _AlarmHealthCardState();
}

class _AlarmHealthCardState extends ConsumerState<_AlarmHealthCard> {
  bool _working = false;

  Future<void> _fix(AppLocalizations s) async {
    setState(() => _working = true);
    try {
      final alarm = MethodChannelAlarmScheduler();
      await alarm.requestNotificationPermission();
      final perms = await alarm.checkPermissions();
      if (!perms.fullScreenIntent) {
        await alarm.openFullScreenIntentSettings();
      }
      if (!perms.batteryOptimizationIgnored) {
        await alarm.requestIgnoreBatteryOptimizations();
      }
      await ref.read(alarmHealthProvider.notifier).refresh();
    } finally {
      if (mounted) setState(() => _working = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;
    final perms = ref.watch(alarmHealthProvider);
    if (perms == null || perms.allCriticalGranted) {
      return const SizedBox.shrink();
    }

    return Card(
      color: AppPalette.warn500.withValues(alpha: 0.12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.notifications_off_outlined,
                color: AppPalette.warn500),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s.healthWarnTitle,
                    style: const TextStyle(
                        color: AppPalette.sky100,
                        fontSize: 15,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    s.healthWarnBody,
                    style: const TextStyle(
                        color: AppPalette.mist200,
                        fontSize: 13,
                        height: 1.4),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            _working
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : FilledButton.tonal(
                    onPressed: () => _fix(s),
                    child: Text(s.healthFixNow),
                  ),
          ],
        ),
      ),
    );
  }
}

/// FR-8.9: a welcoming empty state — "Day 1 starts tonight", never a
/// wall of zeros.
class _WelcomeState extends StatelessWidget {
  const _WelcomeState({required this.s});

  final AppLocalizations s;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const StreakSun(streak: 0, variant: StreakSunVariant.freshStart),
            const SizedBox(height: 16),
            Text(
              s.dashEmptyTitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.h2.copyWith(color: AppPalette.sky100),
            ),
            const SizedBox(height: 8),
            Text(
              s.dashEmptyBody,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: AppPalette.mist200, fontSize: 14, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}

/// FR-8.1: today's result + encouraging copy (never guilt).
class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.data, required this.s});

  final DashboardData data;
  final AppLocalizations s;

  @override
  Widget build(BuildContext context) {
    final (headline, caption) = switch (data.todayResult) {
      'full' => (s.focusAllKept, s.dashCount(data.todayKept, data.todayTotal)),
      'kept' => (s.dashHeroKept, s.dashCount(data.todayKept, data.todayTotal)),
      'rest' => (s.dashHeroRest, ''),
      'missed' => (
          s.dashHeroMissed,
          switch (freshStartLandmark(DateTime.now())) {
            FreshStartLandmark.tomorrow => s.dashFreshTomorrow,
            FreshStartLandmark.monday => s.dashFreshMonday,
            FreshStartLandmark.firstOfMonth => s.dashFreshFirst,
          },
        ),
      _ => data.tonight.wakeAt != null
          ? (
              s.dashForward(t.formatMinuteOfDay(
                  data.tonight.wakeAt!.hour * 60 + data.tonight.wakeAt!.minute)),
              ''
            )
          : (s.dashEmptyTitle, ''),
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              headline,
              style: AppTextStyles.h2.copyWith(
                color: data.todayIsFull ? AppPalette.gold400 : AppPalette.sky100,
              ),
            ),
            if (caption.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                caption,
                style: const TextStyle(
                  color: AppPalette.mist200,
                  fontSize: 14,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// FR-8.2: the Streak Sun with current + best.
class _StreakSection extends StatelessWidget {
  const _StreakSection({required this.data, required this.s});

  final DashboardData data;
  final AppLocalizations s;

  @override
  Widget build(BuildContext context) {
    final variant = switch (data.todayResult) {
      'rest' => StreakSunVariant.rest,
      _ when data.showFreshStart => StreakSunVariant.freshStart,
      _ => StreakSunVariant.active,
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                StreakSun(streak: data.streak.current, variant: variant),
                if (variant == StreakSunVariant.active)
                  Text(
                    '${data.streak.current}',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                      color: AppPalette.ink900,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s.streakCurrentLabel,
                    style: const TextStyle(
                        color: AppPalette.mist200, fontSize: 13),
                  ),
                  Text(
                    data.streak.current == 1
                        ? s.streakDayOne
                        : s.streakDays(data.streak.current),
                    style: AppTextStyles.h2.copyWith(
                      color: AppPalette.sky100,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${s.streakBestLabel}: '
                    '${s.streakDays(data.streak.best)}',
                    style: const TextStyle(
                      color: AppPalette.mist200,
                      fontSize: 13,
                      fontFeatures: [FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// FR-8.4: next milestone progress + the badge arc.
class _MilestoneSection extends StatelessWidget {
  const _MilestoneSection({required this.data, required this.s});

  final DashboardData data;
  final AppLocalizations s;

  @override
  Widget build(BuildContext context) {
    final next = data.streak.nextMilestone;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (next != null) ...[
              Text(
                next - data.streak.current == 1
                    ? s.milestoneNextDay(next)
                    : s.milestoneNextDays(next - data.streak.current, next),
                style: const TextStyle(
                  color: AppPalette.dawn300,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: data.streak.current / next,
                  minHeight: 6,
                  backgroundColor: AppPalette.night900,
                  valueColor:
                      const AlwaysStoppedAnimation(AppPalette.gold400),
                ),
              ),
              const SizedBox(height: 16),
            ] else
              ...[
                Text(
                  s.focusAllKept,
                  style: const TextStyle(
                    color: AppPalette.gold400,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
              ],
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final m in kMilestones)
                  MilestoneBadge(
                    days: m,
                    state: m <= data.streak.current
                        ? MilestoneState.earned
                        : m == next
                            ? MilestoneState.next
                            : MilestoneState.locked,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// FR-8.3: the 66-day journey with three phases.
class _JourneySection extends StatelessWidget {
  const _JourneySection({required this.data, required this.s});

  final DashboardData data;
  final AppLocalizations s;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            JourneyArc(
              journeyDay: data.streak.journeyDay,
              lengthDays: data.streak.journeyLengthDays,
              phaseLabels: [
                s.journeyPhase1,
                s.journeyPhase2,
                s.journeyPhase3,
              ],
              dayLabel: s.journeyDayLabel(
                  data.streak.journeyDay, data.streak.journeyLengthDays),
            ),
          ],
        ),
      ),
    );
  }
}

/// FR-8.5: last 7 days, no red.
class _WeekSection extends StatelessWidget {
  const _WeekSection({required this.data, required this.s});

  final DashboardData data;
  final AppLocalizations s;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final now = DateTime.now();
    final days = [
      for (final d in data.week)
        ws.WeekStripDay(
          date: d.date,
          result: d.result,
          isToday: t.dateKey(d.date) == t.dateKey(now),
        ),
    ];
    final labels = [
      for (final d in days)
        DateFormat.E(locale).format(d.date).substring(0, 1),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              s.weekTitle,
              style: const TextStyle(
                  color: AppPalette.mist200, fontSize: 13),
            ),
            const SizedBox(height: 16),
            ws.WeekStrip(
              days: days,
              weekdayLabels: labels,
              semanticLabelFor: (day) {
                final weekday = DateFormat.E(locale).format(day.date);
                final status = switch (day.result) {
                  'full' => s.weekDotFull,
                  'kept' => s.weekDotKept,
                  'rest' => s.weekDotRest,
                  'pending' => s.weekDotUpcoming,
                  'missed' => s.weekDotMissed,
                  _ => s.weekDotNone,
                };
                return '$weekday: $status';
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// FR-8.6: wins — minutes, earliest wake, most-kept promise.
class _WinsSection extends StatelessWidget {
  const _WinsSection({required this.data, required this.s});

  final DashboardData data;
  final AppLocalizations s;

  @override
  Widget build(BuildContext context) {
    final minutes = data.wins.totalMinutesKept;
    final minutesValue = minutes >= 60
        ? s.winsMinutesHm(minutes ~/ 60, minutes % 60)
        : s.winsMinutesM(minutes);
    final earliest = data.wins.earliestWakeMinute == null
        ? '—'
        : t.formatMinuteOfDay(data.wins.earliestWakeMinute!);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(s.winsTitle,
                style: const TextStyle(
                    color: AppPalette.mist200, fontSize: 13)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _StatTile(
                    label: s.winsMinutesLabel,
                    value: minutesValue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatTile(
                    label: s.winsEarliestLabel,
                    value: earliest,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatTile(
                    label: s.winsMostKeptLabel,
                    value: data.wins.mostKeptPromiseTitle ?? '—',
                    small: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value, this.small});

  final String label;
  final String value;
  final bool? small;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          maxLines: small == true ? 2 : 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: small == true ? 15 : 18,
            fontWeight: FontWeight.w600,
            color: AppPalette.gold400,
            fontFeatures: const [FontFeature.tabularFigures()],
            height: 1.3,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: AppPalette.mist200,
            fontSize: 12,
            height: 1.3,
          ),
        ),
      ],
    );
  }
}

/// FR-8.7: per-promise kept rate over the last 30 days.
class _RatesSection extends StatelessWidget {
  const _RatesSection({required this.data, required this.s});

  final DashboardData data;
  final AppLocalizations s;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(s.promiseRatesTitle,
                style: const TextStyle(
                    color: AppPalette.mist200, fontSize: 13)),
            const SizedBox(height: 8),
            for (final rate in data.rates)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            rate.title,
                            style: const TextStyle(
                                color: AppPalette.sky100, fontSize: 15),
                          ),
                        ),
                        Text(
                          s.rateCaption(rate.kept, rate.total),
                          style: const TextStyle(
                            color: AppPalette.mist200,
                            fontSize: 13,
                            fontFeatures: [FontFeature.tabularFigures()],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: LinearProgressIndicator(
                        value: rate.rate,
                        minHeight: 4,
                        backgroundColor: AppPalette.night900,
                        valueColor: const AlwaysStoppedAnimation(
                            AppPalette.success500),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Tonight card (DESIGN §7.8 item 8) + the rest-day action (FR-9.1).
class _TonightCard extends ConsumerWidget {
  const _TonightCard({required this.data, required this.s});

  final DashboardData data;
  final AppLocalizations s;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final morning = ref.watch(relevantMorningProvider).value;
    final canRest = ref.watch(canMarkRestDayProvider).value ?? false;
    final upcoming =
        morning != null && morning.result == 'pending' && morning.scheduledAt.isAfter(DateTime.now());

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    s.tonightTitle,
                    style: AppTextStyles.h2
                        .copyWith(color: AppPalette.sky100),
                  ),
                ),
                if (data.tonight.isRest)
                  Chip(
                    label: Text(s.restActive),
                    visualDensity: VisualDensity.compact,
                  ),
              ],
            ),
            const SizedBox(height: 12),
            if (data.tonight.wakeAt != null)
              _TonightRow(
                label: s.tonightWake,
                value: t.formatMinuteOfDay(data.tonight.wakeAt!.hour * 60 +
                    data.tonight.wakeAt!.minute),
              ),
            if (data.tonight.bedMinute != null)
              _TonightRow(
                label: s.tonightBed,
                value: t.formatMinuteOfDay(data.tonight.bedMinute!),
              ),
            if (data.tonight.promiseCount > 0)
              _TonightRow(
                label: s.promisesTitle,
                value: s.tonightPromises(data.tonight.promiseCount),
              ),
            // Rest day (FR-9.1): 1 per rolling 7 days, upcoming only.
            if (upcoming && !data.tonight.isRest) ...[
              const SizedBox(height: 8),
              canRest
                  ? Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: () => _confirmRest(context, ref, morning),
                        icon: const Icon(Icons.bedtime_outlined, size: 18),
                        label: Text(
                          s.restAction,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        s.restUsed,
                        style: TextStyle(
                          color:
                              AppPalette.mist200.withValues(alpha: 0.7),
                          fontSize: 12,
                        ),
                      ),
                    ),
              ],
          ],
        ),
      ),
    );
  }

  Future<void> _confirmRest(
      BuildContext context, WidgetRef ref, RelevantMorning morning) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(s.restConfirmTitle),
        content: Text(s.restConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(s.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(s.confirm),
          ),
        ],
      ),
    );
    if (confirmed ?? false) {
      await ref
          .read(morningRepositoryProvider)
          .markRestDay(morning.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(s.restActive)),
        );
      }
    }
  }
}

class _TonightRow extends StatelessWidget {
  const _TonightRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(label,
                style: const TextStyle(
                    color: AppPalette.mist200, fontSize: 14)),
          ),
          Text(
            value,
            style: const TextStyle(
              color: AppPalette.sky100,
              fontSize: 14,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}
