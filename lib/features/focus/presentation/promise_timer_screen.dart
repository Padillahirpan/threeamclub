import 'package:flutter/material.dart';

import '../../../app/theme/app_theme.dart';
import '../../../core/l10n/app_localizations.dart';

/// M3 placeholder for the locked promise timer (PRD FR-7.x).
/// The locked, persistent countdown arrives in the next milestone.
class PromiseTimerScreen extends StatelessWidget {
  const PromiseTimerScreen({super.key, required this.promiseId});

  final String promiseId;

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(s.focusGreeting)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.timer_outlined,
                  size: 64, color: AppPalette.dawn300),
              const SizedBox(height: 24),
              Text(
                s.focusTimerComing,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppPalette.mist200),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
