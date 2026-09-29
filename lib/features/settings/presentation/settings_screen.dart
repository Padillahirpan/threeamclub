import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/routes.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../plan/application/phase_providers.dart';
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
            onTap: () => context.go(Routes.settingsBackup),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.battery_saver_outlined),
            title: Text(s.settingsBattery,
                style: const TextStyle(color: AppPalette.sky100)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.go(Routes.settingsBattery),
          ),
        ],
      ),
    );
  }
}
