import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/routes.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/l10n/app_localizations.dart';
import '../application/alarm_health.dart';

/// OEM battery-management guidance (PRD M5, DESIGN.md §10 help): plain
/// steps + manufacturer-specific hints, since most missed alarms on
/// Android come from OEM battery savers killing the app.
class BatteryHelpScreen extends ConsumerWidget {
  const BatteryHelpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AppLocalizations.of(context)!;
    final brand = (ref.watch(alarmHealthProvider)?.manufacturer ?? '')
        .toLowerCase();

    final brandText = switch (brand) {
      'samsung' => s.batteryBrandSamsung,
      'xiaomi' || 'poco' => s.batteryBrandXiaomi,
      'oppo' || 'realme' || 'oneplus' => s.batteryBrandOppo,
      'vivo' || 'iqoo' => s.batteryBrandVivo,
      'huawei' || 'honor' => s.batteryBrandHuawei,
      _ => s.batteryBrandGeneric,
    };
    final brandLabel = brand.isEmpty ? null : brand[0].toUpperCase() + brand.substring(1);

    return Scaffold(
      appBar: AppBar(title: Text(s.batteryHelpTitle)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            s.batteryHelpIntro,
            style: const TextStyle(
                color: AppPalette.mist200, fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: 20),
          _Step(index: 1, text: s.batteryStepAutoStart),
          const SizedBox(height: 12),
          _Step(index: 2, text: s.batteryStepUnrestricted),
          const SizedBox(height: 12),
          _Step(index: 3, text: s.batteryStepPin),
          if (brandLabel != null) ...[
            const SizedBox(height: 24),
            Text(
              s.batteryForBrand(brandLabel),
              style: AppTextStyles.h2.copyWith(color: AppPalette.sky100),
            ),
            const SizedBox(height: 8),
            Text(
              brandText,
              style: const TextStyle(
                  color: AppPalette.mist200, fontSize: 14, height: 1.5),
            ),
          ],
          const SizedBox(height: 32),
          FilledButton(
            onPressed: () => context.go(Routes.settings),
            child: Text(s.batteryDone),
          ),
        ],
      ),
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({required this.index, required this.text});

  final int index;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppPalette.night700,
          ),
          child: Text(
            '$index',
            style: const TextStyle(
              color: AppPalette.dawn300,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
                color: AppPalette.sky300, fontSize: 14, height: 1.5),
          ),
        ),
      ],
    );
  }
}
