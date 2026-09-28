import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/theme/app_theme.dart';

/// How the sun presents (DESIGN §8 `StreakSun`: "Size/glow scale with
/// streak; rest and fresh-start variants").
enum StreakSunVariant {
  /// Active streak — disc grows and glows with the count.
  active,

  /// Rest day — soft, quiet; the streak waits (FR-9.1).
  rest,

  /// Fresh start — a dim sun low on the horizon (FR-9.2).
  freshStart,
}

/// The Streak Sun (PRD FR-8.2, DESIGN §7.8 item 2): grows and glows with
/// the streak. Reduce-motion renders the static variant.
class StreakSun extends StatefulWidget {
  const StreakSun({
    super.key,
    required this.streak,
    this.variant = StreakSunVariant.active,
    this.size = 132,
  });

  final int streak;
  final StreakSunVariant variant;
  final double size;

  @override
  State<StreakSun> createState() => _StreakSunState();
}

class _StreakSunState extends State<StreakSun>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2500),
  );

  @override
  void initState() {
    super.initState();
    if (widget.variant == StreakSunVariant.active) _pulse.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    return AnimatedBuilder(
      animation: _pulse,
      builder: (context, _) {
        final pulse = reduceMotion ? 0.0 : _pulse.value;
        return CustomPaint(
          size: Size.square(widget.size),
          painter: _StreakSunPainter(
            streak: widget.streak,
            variant: widget.variant,
            pulseAmount: pulse,
          ),
        );
      },
    );
  }
}

class _StreakSunPainter extends CustomPainter {
  _StreakSunPainter({
    required this.streak,
    required this.variant,
    required this.pulseAmount,
  });

  final int streak;
  final StreakSunVariant variant;
  final double pulseAmount;

  static const Color _glowStart = Color(0xFFFF9E6B);
  static const Color _glowEnd = Color(0xFFFFD8A8);

  @override
  void paint(Canvas canvas, Size size) {
    // Growth: the first 30 days visibly grow the sun, then it holds
    // (goal-gradient without shaming long gaps).
    final growth = (streak / 30).clamp(0.0, 1.0);
    final center = Offset(size.width / 2, size.height / 2);

    switch (variant) {
      case StreakSunVariant.active:
        final radius = size.width * (0.16 + 0.10 * growth);
        final glowRadius =
            radius * (1.9 + 0.7 * growth + 0.2 * pulseAmount);
        canvas.drawCircle(
          center,
          glowRadius,
          Paint()
            ..shader = RadialGradient(colors: [
              _glowStart
                  .withValues(alpha: 0.35 + 0.3 * growth + 0.1 * pulseAmount),
              AppPalette.gold400.withValues(alpha: 0.12 * growth),
              _glowEnd.withValues(alpha: 0.0),
            ]).createShader(
              Rect.fromCircle(center: center, radius: glowRadius),
            ),
        );
        canvas.drawCircle(
          center,
          radius,
          Paint()
            ..shader = RadialGradient(colors: [
              AppPalette.gold400.withValues(alpha: 0.5 + 0.5 * growth),
              AppPalette.dawn500,
            ]).createShader(
              Rect.fromCircle(center: center, radius: radius),
            ),
        );
        // Rays appear from 3 days on — the first milestone glow.
        if (streak >= 3) {
          final rayPaint = Paint()
            ..color = _glowEnd.withValues(alpha: 0.45 + 0.25 * growth)
            ..strokeWidth = 2
            ..strokeCap = StrokeCap.round;
          for (var i = 0; i < 8; i++) {
            final angle = i * math.pi / 4 + pulseAmount * 0.08;
            final inner = radius * 1.3;
            final outer = radius * (1.5 + 0.06 * pulseAmount);
            canvas.drawLine(
              center +
                  Offset(math.cos(angle) * inner, math.sin(angle) * inner),
              center +
                  Offset(math.cos(angle) * outer, math.sin(angle) * outer),
              rayPaint,
            );
          }
        }
      case StreakSunVariant.rest:
        // Quiet dawn-300 disc, soft ring — rest keeps the streak alive.
        final radius = size.width * 0.2;
        canvas.drawCircle(
          center,
          radius * 1.6,
          Paint()
            ..shader = RadialGradient(colors: [
              AppPalette.dawn300.withValues(alpha: 0.18),
              AppPalette.dawn300.withValues(alpha: 0.0),
            ]).createShader(
              Rect.fromCircle(center: center, radius: radius * 1.6),
            ),
        );
        canvas.drawCircle(
          center,
          radius,
          Paint()..color = AppPalette.dawn300.withValues(alpha: 0.55),
        );
        canvas.drawCircle(
          center,
          radius,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.5
            ..color = AppPalette.dawn300,
        );
      case StreakSunVariant.freshStart:
        // Dim outline sun — a horizon waiting for sunrise.
        final radius = size.width * 0.16;
        canvas.drawCircle(
          center,
          radius,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2
            ..color = AppPalette.mist200.withValues(alpha: 0.6),
        );
        canvas.drawLine(
          Offset(center.dx - radius * 1.5, center.dy + radius * 1.25),
          Offset(center.dx + radius * 1.5, center.dy + radius * 1.25),
          Paint()
            ..color = AppPalette.mist200.withValues(alpha: 0.35)
            ..strokeWidth = 1.5
            ..strokeCap = StrokeCap.round,
        );
    }
  }

  @override
  bool shouldRepaint(_StreakSunPainter oldDelegate) =>
      oldDelegate.streak != streak ||
      oldDelegate.variant != variant ||
      oldDelegate.pulseAmount != pulseAmount;
}
