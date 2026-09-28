import 'package:flutter/material.dart';

import '../../app/theme/app_theme.dart';

/// `MilestoneBadge` states (DESIGN §8): locked / next / earned. Earned
/// uses gold-400; the next milestone is outlined gold to draw the eye;
/// locked stays quiet mist.
enum MilestoneState { locked, next, earned }

/// One milestone chip on the 3/7/14/21/30/44/66 arc (PRD FR-8.4).
class MilestoneBadge extends StatelessWidget {
  const MilestoneBadge({
    super.key,
    required this.days,
    required this.state,
  });

  final int days;
  final MilestoneState state;

  @override
  Widget build(BuildContext context) {
    final (border, background, foreground, icon) = switch (state) {
      MilestoneState.earned => (
          AppPalette.gold400,
          AppPalette.gold400.withValues(alpha: 0.18),
          AppPalette.gold400,
          Icons.wb_sunny,
        ),
      MilestoneState.next => (
          AppPalette.gold400.withValues(alpha: 0.7),
          Colors.transparent,
          AppPalette.dawn300,
          Icons.wb_sunny_outlined,
        ),
      MilestoneState.locked => (
          AppPalette.mist200.withValues(alpha: 0.25),
          Colors.transparent,
          AppPalette.mist200.withValues(alpha: 0.6),
          Icons.lock_outline,
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: border),
        color: background,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: foreground),
          const SizedBox(width: 4),
          Text(
            '$days',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: foreground,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}
