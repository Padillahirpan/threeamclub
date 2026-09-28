import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../app/theme/app_theme.dart';
import '../time/minute_of_day.dart' as t;

/// Large, one-hand friendly wheel picker (DESIGN.md §8 `TimeWheelPicker`).
///
/// Minutes step in 5-minute increments. For the wake time the range is
/// constrained to [minMinute, maxMinute] (03:00–05:00, PRD FR-1.1).
Future<int?> showTimeWheelPicker(
  BuildContext context, {
  required String confirmLabel,
  required String cancelLabel,
  int initialMinute = 0,
  int minMinute = 0,
  int maxMinute = t.minutesPerDay - 5,
}) {
  assert(minMinute <= maxMinute);
  initialMinute = initialMinute.clamp(minMinute, maxMinute);

  return showDialog<int>(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: _TimeWheelPickerDialog(
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        initialMinute: initialMinute,
        minMinute: minMinute,
        maxMinute: maxMinute,
      ),
    ),
  );
}

class _TimeWheelPickerDialog extends StatefulWidget {
  const _TimeWheelPickerDialog({
    required this.confirmLabel,
    required this.cancelLabel,
    required this.initialMinute,
    required this.minMinute,
    required this.maxMinute,
  });

  final String confirmLabel;
  final String cancelLabel;
  final int initialMinute;
  final int minMinute;
  final int maxMinute;

  @override
  State<_TimeWheelPickerDialog> createState() => _TimeWheelPickerDialogState();
}

class _TimeWheelPickerDialogState extends State<_TimeWheelPickerDialog> {
  late int _minute = widget.initialMinute;

  late final List<int> _hours = List<int>.generate(
    widget.maxMinute ~/ 60 - widget.minMinute ~/ 60 + 1,
    (i) => widget.minMinute ~/ 60 + i,
  );

  List<int> _minutesFor(int hour) {
    final first = hour == widget.minMinute ~/ 60 ? widget.minMinute % 60 : 0;
    final last = hour == widget.maxMinute ~/ 60 ? widget.maxMinute % 60 : 55;
    return [
      for (var m = first; m <= last; m += 5) m,
    ];
  }

  int get _hour => _minute ~/ 60;
  int get _minuteOfHour => _minute % 60;

  void _setHour(int hour) {
    final minutes = _minutesFor(hour);
    final m = _minuteOfHour.clamp(minutes.first, minutes.last);
    setState(() => _minute = hour * 60 + m);
  }

  void _setMinute(int m) => setState(() => _minute = _hour * 60 + m);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final minutes = _minutesFor(_hour);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 180,
            child: Row(
              children: [
                Expanded(
                  child: _Wheel(
                    labels: [
                      for (final h in _hours)
                        h.toString().padLeft(2, '0'),
                    ],
                    selectedIndex: _hours.indexOf(_hour),
                    onChanged: (i) => _setHour(_hours[i]),
                    textColor: colors.sky100,
                  ),
                ),
                const Text(':', style: TextStyle(fontSize: 24)),
                Expanded(
                  child: _Wheel(
                    labels: [
                      for (final m in minutes)
                        m.toString().padLeft(2, '0'),
                    ],
                    selectedIndex: math.max(0, minutes.indexOf(_minuteOfHour)),
                    onChanged: (i) => _setMinute(minutes[i]),
                    textColor: colors.sky100,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(widget.cancelLabel),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(_minute),
                child: Text(widget.confirmLabel),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Wheel extends StatelessWidget {
  const _Wheel({
    required this.labels,
    required this.selectedIndex,
    required this.onChanged,
    required this.textColor,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return CupertinoPicker(
      scrollController: FixedExtentScrollController(
        initialItem: selectedIndex.clamp(0, labels.length - 1),
      ),
      itemExtent: 44,
      selectionOverlay: CupertinoPickerDefaultSelectionOverlay(
        background: textColor.withValues(alpha: 0.06),
      ),
      onSelectedItemChanged: onChanged,
      children: [
        for (final label in labels)
          Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w300,
                color: textColor,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
      ],
    );
  }
}
