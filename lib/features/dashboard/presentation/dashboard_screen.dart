import 'package:flutter/material.dart';

import '../../../app/theme/app_theme.dart';
import '../../../core/l10n/app_localizations.dart';

/// M4 placeholder for the Dashboard (PRD FR-8.x).
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;
    final colors = Theme.of(context).extension<AppColors>()!;
    return Scaffold(
      appBar: AppBar(title: Text(s.dashboardPlaceholderTitle)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.wb_sunny_outlined, size: 64, color: colors.gold400),
              const SizedBox(height: 24),
              Text(
                s.dashboardPlaceholderBody,
                textAlign: TextAlign.center,
                style: TextStyle(color: colors.mist200, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
