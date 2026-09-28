import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../app/theme/app_theme.dart';

/// The 66-day journey arc (PRD FR-8.3, DESIGN §7.8 item 3): three phases
/// — break the old pattern / build the new one / make it yours — with the
/// current position highlighted.
class JourneyArc extends StatelessWidget {
  const JourneyArc({
    super.key,
    required this.journeyDay,
    this.lengthDays = 66,
    this.phaseLabels = const [],
    this.dayLabel,
  });

  /// 1-based current day (clamped for rendering).
  final int journeyDay;

  final int lengthDays;

  /// Exactly 3 localized labels, current highlighted by [currentPhase].
  final List<String> phaseLabels;

  /// e.g. "Day 12 of 66" shown inside the arc.
  final String? dayLabel;

  int get currentPhase =>
      journeyDay <= 22 ? 0 : journeyDay <= 44 ? 1 : 2;

  @override
  Widget build(BuildContext context) {
    final day = journeyDay.clamp(1, lengthDays);
    final progress = day / lengthDays;

    return Column(
      children: [
        SizedBox(
          height: 92,
          width: double.infinity,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              CustomPaint(
                size: const Size(double.infinity, 92),
                painter: _ArcPainter(
                  progress: progress,
                  phase1End: 22 / lengthDays,
                  phase2End: 44 / lengthDays,
                ),
              ),
              if (dayLabel != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    dayLabel!,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppPalette.mist200,
                      fontFeatures: [FontFeature.tabularFigures()],
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (phaseLabels.length == 3) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              for (var i = 0; i < 3; i++)
                Expanded(
                  child: Text(
                    phaseLabels[i],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.3,
                      color: i == currentPhase
                          ? AppPalette.dawn300
                          : AppPalette.mist200.withValues(alpha: 0.55),
                      fontWeight:
                          i == currentPhase ? FontWeight.w600 : null,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

class _ArcPainter extends CustomPainter {
  _ArcPainter({
    required this.progress,
    required this.phase1End,
    required this.phase2End,
  });

  final double progress;
  final double phase1End;
  final double phase2End;

  static const _startAngle = math.pi; // left
  static const _sweep = math.pi; // 180° to the right

  @override
  void paint(Canvas canvas, Size size) {
    final usableWidth = size.width * 0.86;
    final center = Offset(size.width / 2, size.height * 0.88);
    final radius = usableWidth / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Track.
    canvas.drawArc(
      rect,
      _startAngle,
      _sweep,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round
        ..color = AppPalette.night700,
    );

    // Phase separators (subtle).
    final sepPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = AppPalette.mist200.withValues(alpha: 0.35);
    for (final fraction in [phase1End, phase2End]) {
      final angle = _startAngle + _sweep * fraction;
      canvas.drawLine(
        center +
            Offset(
              math.cos(angle) * (radius - 8),
              math.sin(angle) * (radius - 8),
            ),
        center +
            Offset(
              math.cos(angle) * (radius + 8),
              math.sin(angle) * (radius + 8),
            ),
        sepPaint,
      );
    }

    // Progress: dawn in phase 1, gold as the journey matures.
    final progressColor = progress >= phase2End
        ? AppPalette.gold400
        : progress >= phase1End
            ? AppPalette.dawn500
            : AppPalette.dawn500;
    canvas.drawArc(
      rect,
      _startAngle,
      _sweep * progress,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round
        ..color = progressColor,
    );

    // Position knob.
    final knobAngle = _startAngle + _sweep * progress;
    final knob = Offset(
      center.dx + math.cos(knobAngle) * radius,
      center.dy + math.sin(knobAngle) * radius,
    );
    canvas.drawCircle(
      knob,
      8,
      Paint()..color = AppPalette.sky100,
    );
    canvas.drawCircle(
      knob,
      8,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..color = AppPalette.dawn500,
    );
  }

  @override
  bool shouldRepaint(_ArcPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
