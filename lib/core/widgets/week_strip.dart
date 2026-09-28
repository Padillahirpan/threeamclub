import 'package:flutter/material.dart';

import '../../app/theme/app_theme.dart';

/// One day of the week strip. Pure display data so the widget test needs
/// no database.
class WeekStripDay {
  const WeekStripDay({
    required this.date,
    required this.result, // kept / full / rest / missed / pending / none
    required this.isToday,
  });

  final DateTime date;
  final String result;
  final bool isToday;
}

/// Last-7-days status dots (PRD FR-8.5, DESIGN §7.8 item 5): kept, full,
/// rest, upcoming — **no red, no empty-shaming** (missed renders as a
/// quiet neutral dot).
class WeekStrip extends StatelessWidget {
  const WeekStrip({
    super.key,
    required this.days,
    required this.weekdayLabels,
    required this.semanticLabelFor,
  });

  /// Oldest → newest, exactly 7 entries.
  final List<WeekStripDay> days;

  /// 7 short weekday labels, oldest → newest (localized).
  final List<String> weekdayLabels;

  /// A11y description for one day, e.g. "Tuesday: kept".
  final String Function(WeekStripDay day) semanticLabelFor;

  @override
  Widget build(BuildContext context) {
    assert(days.length == 7, 'WeekStrip expects exactly 7 days');
    assert(weekdayLabels.length == 7);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (var i = 0; i < days.length; i++)
          _DayDot(
            day: days[i],
            label: weekdayLabels[i],
            semanticLabel: semanticLabelFor(days[i]),
          ),
      ],
    );
  }
}

class _DayDot extends StatelessWidget {
  const _DayDot({
    required this.day,
    required this.label,
    required this.semanticLabel,
  });

  final WeekStripDay day;
  final String label;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final (color, filled) = switch (day.result) {
      'full' => (AppPalette.gold400, true),
      'kept' => (AppPalette.success500, true),
      'rest' => (AppPalette.dawn300, true),
      'pending' => (AppPalette.mist200, false), // upcoming: quiet outline
      _ => (AppPalette.mist200.withValues(alpha: 0.35), true), // missed/none
    };

    return Semantics(
      label: semanticLabel,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: day.isToday ? 22 : 18,
            height: day.isToday ? 22 : 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: filled ? color : Colors.transparent,
              border: Border.all(
                color: filled
                    ? color
                    : color.withValues(alpha: day.isToday ? 0.9 : 0.5),
                width: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontFeatures: const [FontFeature.tabularFigures()],
              color: day.isToday
                  ? AppPalette.sky100
                  : AppPalette.mist200.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
