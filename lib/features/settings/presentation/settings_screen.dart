import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/routes.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/clock/clock.dart';
import '../../../core/db/database_provider.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../debug/seed_demo_history.dart';
import '../../plan/application/phase_providers.dart';
import '../../plan/data/morning_repository.dart';
import '../data/settings_repository.dart';

/// Settings (M4): wakelock toggle, bedtime-reminder lead, backup entry.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static const _leadChoices = [15, 30, 45, 60];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AppLocalizations.of(context)!;
    final wakelock = ref.watch(wakelockEnabledProvider).value ?? true;
    final lead = ref.watch(bedtimeLeadProvider).value ?? 30;
    final repo = ref.watch(settingsRepositoryProvider);

    return Scaffold(
      appBar: AppBar(title: Text(s.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        children: [
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(s.settingsWakelock,
                style: const TextStyle(color: AppPalette.sky100)),
            value: wakelock,
            onChanged: (v) async {
              await repo.setWakelockEnabled(v);
              ref.invalidate(wakelockEnabledProvider);
            },
          ),
          const SizedBox(height: 8),
          Text(
            s.settingsLead,
            style: const TextStyle(color: AppPalette.mist200, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              for (final minutes in _leadChoices)
                ChoiceChip(
                  label: Text(s.minutesShort(minutes)),
                  selected: lead == minutes,
                  onSelected: (_) async {
                    await repo.setBedtimeLeadMinutes(minutes);
                    ref.invalidate(bedtimeLeadProvider);
                  },
                ),
            ],
          ),
          const SizedBox(height: 24),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.backup_outlined),
            title: Text(s.settingsBackup,
                style: const TextStyle(color: AppPalette.sky100)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(Routes.settingsBackup),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.battery_saver_outlined),
            title: Text(s.settingsBattery,
                style: const TextStyle(color: AppPalette.sky100)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(Routes.settingsBattery),
          ),
          if (kDebugMode) ...[
            const SizedBox(height: 24),
            const Divider(height: 1),
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.science_outlined),
              title: const Text('Seed 7-day demo history',
                  style: TextStyle(color: AppPalette.mist200)),
              subtitle: const Text('Debug only — fills missing past days'),
              onTap: () => _seedDemoHistory(context, ref),
            ),
          ],
        ],
      ),
    );
  }

  /// Debug-only: seeds closed mornings for the last 7 days so the
  /// dashboard can be checked manually. Compiled out of release builds.
  Future<void> _seedDemoHistory(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Seed demo history?'),
        content: const Text(
          'Adds closed mornings for the last 7 days (days that already '
          'exist are skipped). Intended for a test install, not real data.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Seed'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    final clock = ref.read(clockProvider);
    final seeded = await seedDemoHistory(
      database: ref.read(databaseProvider),
      clock: clock,
    );

    // Arm tonight's morning if none is pending, so the dashboard
    // "tonight" card has something to show.
    final repo = ref.read(morningRepositoryProvider);
    final relevant = await repo.relevantMorning();
    if (relevant == null || !relevant.scheduledAt.isAfter(clock.now())) {
      final plan = await repo.activePlan();
      if (plan != null) await repo.rollover(plan);
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Seeded $seeded demo day(s)')),
      );
    }
  }
}
