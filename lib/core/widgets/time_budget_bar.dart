import 'package:flutter/material.dart';

import '../../app/theme/app_theme.dart';

/// Segmented time-budget bar (PRD FR-2.5, DESIGN.md §7.2/§8).
///
/// Fills from the wake time toward 06:00, one segment per promise colored
/// by its category. When over budget the bar turns warn-500; the caller
/// shows the "Trim N min" message.
class TimeBudgetBar extends StatelessWidget {
  const TimeBudgetBar({
    super.key,
    required this.wakeMinute,
    required this.segments,
    required this.label,
    this.overBudget = false,
    this.height = 14,
  });

  final int wakeMinute;
  final List<BudgetSegment> segments;
  final String label;
  final bool overBudget;
  final double height;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final warn = overBudget;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: warn ? colors.warn500 : colors.mist200,
            fontSize: 13,
            fontWeight: warn ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: height,
          width: double.infinity,
          child: CustomPaint(
            painter: _BudgetPainter(
              segments: segments,
              budgetMinutes: 6 * 60 - wakeMinute,
              trackColor: colors.mist200.withValues(alpha: 0.15),
              warnColor: colors.warn500,
              radius: height / 2,
            ),
          ),
        ),
      ],
    );
  }
}

class BudgetSegment {
  const BudgetSegment({required this.minutes, required this.color});

  final int minutes;
  final Color color;
}

class _BudgetPainter extends CustomPainter {
  _BudgetPainter({
    required this.segments,
    required this.budgetMinutes,
    required this.trackColor,
    required this.warnColor,
    required this.radius,
  });

  final List<BudgetSegment> segments;
  final int budgetMinutes;
  final Color trackColor;
  final Color warnColor;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final total = segments.fold<int>(0, (a, s) => a + s.minutes);
    final over = total > budgetMinutes;

    final track = Paint()..color = trackColor;
    canvas.drawRRect(
      RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(radius)),
      track,
    );

    var dx = 0.0;
    for (final segment in segments) {
      final available = budgetMinutes - (dx / size.width * budgetMinutes);
      final minutes = segment.minutes.clamp(0, available.round());
      if (minutes <= 0) break;
      final width = size.width * minutes / budgetMinutes;
      final rect = Rect.fromLTWH(dx, 0, width, size.height);
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(radius)),
        Paint()..color = segment.color,
      );
      dx += width;
    }

    if (over) {
      // Over-budget marker: warn-500 edge on the right (DESIGN.md §7.2).
      final edge = Rect.fromLTWH(size.width - 4, 0, 4, size.height);
      canvas.drawRRect(
        RRect.fromRectAndRadius(edge, Radius.circular(2)),
        Paint()..color = warnColor,
      );
    }
  }

  @override
  bool shouldRepaint(_BudgetPainter oldDelegate) =>
      oldDelegate.segments != segments ||
      oldDelegate.budgetMinutes != budgetMinutes;
}
