import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/routes.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/time/minute_of_day.dart' as t;
import '../../../core/widgets/wave_background.dart';
import '../../plan/application/phase_providers.dart';
import '../../plan/data/morning_repository.dart';

/// Night reminder — step 4 (PRD FR-4.x, DESIGN.md §7.4).
///
/// Full-screen night waves on night-950, the evening's pre-sleep checklist
/// (optional ticks), the wake time, and exactly one small dashboard link.
/// The screen dims and pauses the animation after ~2 minutes of
/// inactivity, letting the device sleep (FR-4.4).
class NightScreen extends ConsumerStatefulWidget {
  const NightScreen({super.key});

  @override
  ConsumerState<NightScreen> createState() => _NightScreenState();
}

class _NightScreenState extends ConsumerState<NightScreen> {
  static const _inactivityDelay = Duration(minutes: 2);

  bool _dimmed = false;
  Timer? _inactivityTimer;

  @override
  void initState() {
    super.initState();
    _armInactivity();
  }

  @override
  void dispose() {
    _inactivityTimer?.cancel();
    super.dispose();
  }

  void _armInactivity() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(_inactivityDelay, () {
      if (mounted) setState(() => _dimmed = true);
    });
  }

  void _onActivity() {
    if (_dimmed) {
      setState(() => _dimmed = false);
    }
    _armInactivity();
  }

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;
    final plan = ref.watch(activePlanProvider).value;
    final morning = ref.watch(relevantMorningProvider).value;

    final sleepMinutes = plan == null
        ? 0
        : t.sleepDurationMinutes(
            bedMinute: plan.bedMinute, wakeMinute: plan.wakeMinute);
    final hours = sleepMinutes ~/ 60;
    final minutes = sleepMinutes % 60;
    final sleepChip = minutes == 0
        ? s.sleepDurationChipH(hours)
        : hours == 0
            ? s.sleepDurationChipM(minutes)
            : s.sleepDurationChip(hours, minutes);

    return Scaffold(
      backgroundColor: AppPalette.night950,
      body: Listener(
        // Any touch counts as activity (undim + re-arm).
        onPointerDown: (_) => _onActivity(),
        child: Stack(
          children: [
            WaveBackground(paused: _dimmed),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Spacer(flex: 2),
                    Text(
                      s.nightTitle,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.h1
                          .copyWith(color: AppPalette.sky100),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      s.nightLine,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppPalette.mist200.withValues(alpha: 0.9),
                        fontSize: 15,
                      ),
                    ),
                    const Spacer(),
                    // Wake time (Time Display, DESIGN §3).
                    Text(
                      plan == null ? '--:--' : t.formatMinuteOfDay(plan.wakeMinute),
                      textAlign: TextAlign.center,
                      style: AppTextStyles.timeDisplay
                          .copyWith(color: AppPalette.sky100),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      sleepChip,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppPalette.dawn300),
                    ),
                    const Spacer(),
                    if (plan != null && morning != null) ...[
                      _NightChecklist(planId: plan.id, morningId: morning.id),
                      const SizedBox(height: 16),
                    ],
                    Text(
                      s.chargingLine,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppPalette.mist200.withValues(alpha: 0.7),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // One small, low-emphasis link (FR-4.3) — visually 13px
                    // but a 48px touch target (DESIGN §4).
                    TextButton(
                      onPressed: () => context.go(Routes.dashboard),
                      style: TextButton.styleFrom(
                        minimumSize: const Size(48, 48),
                        foregroundColor: AppPalette.mist200,
                      ),
                      child: Text(
                        s.viewProgress,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
            // Dim overlay after inactivity (FR-4.4).
            Positioned.fill(
              child: IgnorePointer(
                child: AnimatedOpacity(
                  opacity: _dimmed ? 1 : 0,
                  duration: const Duration(milliseconds: 800),
                  child: Container(color: AppPalette.night950.withValues(alpha: 0.92)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NightChecklist extends ConsumerWidget {
  const _NightChecklist({required this.planId, required this.morningId});

  final String planId;
  final String morningId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AppLocalizations.of(context)!;
    final items = ref
            .watch(nightChecklistProvider(
                (planId: planId, morningId: morningId)))
            .value ??
        const <NightChecklistItem>[];

    if (items.isEmpty) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: AppPalette.night900.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          for (final item in items)
            ListTile(
              dense: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16),
              leading: Icon(
                item.checked
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked,
                color: item.checked
                    ? AppPalette.success500
                    : AppPalette.mist200,
              ),
              title: Text(
                item.title,
                style: TextStyle(
                  color: AppPalette.sky100.withValues(
                      alpha: item.checked ? 0.6 : 1.0),
                ),
              ),
              // Ticks are optional and never required (FR-4.2).
              onTap: () => ref
                  .read(morningRepositoryProvider)
                  .setChecklistChecked(
                    morningId: morningId,
                    itemId: item.itemId,
                    checked: !item.checked,
                  ),
            ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              s.checklistOptionalHint,
              style: TextStyle(
                color: AppPalette.mist200.withValues(alpha: 0.5),
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Live checklist for the night screen (drift `watch()`).
final nightChecklistProvider = StreamProvider.autoDispose
    .family<List<NightChecklistItem>, ({String planId, String morningId})>(
  (ref, ids) {
    return ref.watch(morningRepositoryProvider).watchNightChecklist(
          planId: ids.planId,
          morningId: ids.morningId,
        );
  },
);
