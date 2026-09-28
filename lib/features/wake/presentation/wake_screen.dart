import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_theme.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/widgets/hold_button.dart';
import '../../../core/widgets/sunrise_icon.dart';
import '../../plan/application/phase_providers.dart';
import '../../plan/data/morning_repository.dart';
import '../../plan/data/plan_repository.dart';

/// Wake — step 5 (PRD FR-5.x, DESIGN.md §7.5).
///
/// Shown while the phase is `ringing` (over the lock screen via the native
/// full-screen intent). Sunrise animation, the user's "why", and a 5s hold
/// that stops the alarm and records the wake. A late wake before 06:00
/// still counts (PRD §7).
class WakeScreen extends ConsumerWidget {
  const WakeScreen({super.key});

  Future<void> _confirmWake(WidgetRef ref) async {
    final morning = ref.read(relevantMorningProvider).value;
    // Stop the ringing alarm first (FR-5.3), then record the wake.
    await ref.read(alarmSchedulerProvider).stopRinging();
    if (morning != null) {
      await ref.read(morningRepositoryProvider).confirmWake(morning.id);
    }
    // The DayPhase change routes to /focus automatically.
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AppLocalizations.of(context)!;
    final plan = ref.watch(activePlanProvider).value;
    final why = (plan?.whyText ?? '').trim();

    return Scaffold(
      backgroundColor: AppPalette.night950,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          // Wake gradient (DESIGN §2).
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppPalette.night900, Color(0xFF3B2A4F)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(),
              const SunriseIcon(size: 140),
              const SizedBox(height: 24),
              Text(
                s.wakeHeadline,
                textAlign: TextAlign.center,
                style: AppTextStyles.wakeHeadline
                    .copyWith(color: AppPalette.sky100),
              ),
              const SizedBox(height: 8),
              Text(
                why.isNotEmpty ? why : s.wakeDefaultLine,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppPalette.mist200.withValues(alpha: 0.9),
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 16),
              const _WakeClock(),
              const Spacer(),
              HoldButton(
                duration: const Duration(seconds: 5),
                label: s.wakeHoldLabel,
                onCompleted: () => _confirmWake(ref),
              ),
              const SizedBox(height: 8),
              // A11y alternative to the hold gesture (DESIGN §10).
              TextButton(
                onPressed: () => _confirmWake(ref),
                child: Text(
                  s.wakeTapAlt,
                  style: const TextStyle(fontSize: 13),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

/// Current time, ticking (tabular figures so digits don't jitter).
class _WakeClock extends StatefulWidget {
  const _WakeClock();

  @override
  State<_WakeClock> createState() => _WakeClockState();
}

class _WakeClockState extends State<_WakeClock> {
  Timer? _timer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hh = _now.hour.toString().padLeft(2, '0');
    final mm = _now.minute.toString().padLeft(2, '0');
    return Text(
      '$hh:$mm',
      style: AppTextStyles.timeDisplay.copyWith(
        color: AppPalette.dawn300,
        fontSize: 42,
      ),
    );
  }
}
