import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_theme.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/platform/method_channel_alarm_scheduler.dart';
import '../data/onboarding_repository.dart';

/// Permission onboarding (PRD FR-5.6): plain-language explanations before
/// any runtime prompts. Skipping is allowed; the M2+ health check
/// re-warns when permissions are missing.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _alarm = MethodChannelAlarmScheduler();
  bool _working = false;

  Future<void> _allow(AppLocalizations s) async {
    setState(() => _working = true);
    try {
      await _alarm.requestNotificationPermission();
      final perms = await _alarm.checkPermissions();
      if (!perms.fullScreenIntent) {
        await _alarm.openFullScreenIntentSettings();
      }
      if (!perms.batteryOptimizationIgnored) {
        await _alarm.requestIgnoreBatteryOptimizations();
      }
      await _finish();
    } finally {
      if (mounted) setState(() => _working = false);
    }
  }

  Future<void> _finish() async {
    await ref.read(onboardingRepositoryProvider).setDone();
    ref.read(onboardingDoneProvider.notifier).complete();
    if (mounted) context.go('/plan');
  }

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;
    final colors = Theme.of(context).extension<AppColors>()!;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Scrollable hero + permission cards; CTAs stay pinned so
              // they remain reachable on small screens / large fonts
              // (DESIGN §10).
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 24),
                      Icon(Icons.wb_twilight, size: 72, color: colors.dawn500),
                      const SizedBox(height: 24),
                      Text(
                        s.onbTitle,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.h1
                            .copyWith(color: AppPalette.sky100),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        s.onbIntro,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: colors.mist200),
                      ),
                      const SizedBox(height: 32),
                      _PermissionCard(
                        icon: Icons.notifications_outlined,
                        title: s.onbNotifTitle,
                        body: s.onbNotifBody,
                        colors: colors,
                      ),
                      const SizedBox(height: 12),
                      _PermissionCard(
                        icon: Icons.lock_open_outlined,
                        title: s.onbFsiTitle,
                        body: s.onbFsiBody,
                        colors: colors,
                      ),
                      const SizedBox(height: 12),
                      _PermissionCard(
                        icon: Icons.battery_charging_full_outlined,
                        title: s.onbBatteryTitle,
                        body: s.onbBatteryBody,
                        colors: colors,
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              FilledButton(
                onPressed: _working ? null : () => _allow(s),
                child: _working
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(s.onbAllow),
              ),
              TextButton(
                onPressed: _working ? null : _finish,
                child: Text(s.onbSkip),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _PermissionCard extends StatelessWidget {
  const _PermissionCard({
    required this.icon,
    required this.title,
    required this.body,
    required this.colors,
  });

  final IconData icon;
  final String title;
  final String body;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: colors.dawn500),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: AppTextStyles.h2.copyWith(
                          color: AppPalette.sky100,
                          fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(
                    body,
                    style: TextStyle(
                        color: colors.mist200
                            .withValues(alpha: 0.85),
                        fontSize: 13),
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
