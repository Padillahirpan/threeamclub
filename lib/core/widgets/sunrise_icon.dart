import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/theme/app_theme.dart';

/// Rising sun for the wake page (DESIGN.md §5 "Sunrise icon"): rises from
/// the horizon over ~3s, then pulses gently (1.0 → 1.04, 2.5s loop) with a
/// soft dawn-glow. Reduce-motion renders the static risen variant.
class SunriseIcon extends StatefulWidget {
  const SunriseIcon({super.key, this.size = 140});

  final double size;

  @override
  State<SunriseIcon> createState() => _SunriseIconState();
}

class _SunriseIconState extends State<SunriseIcon>
    with TickerProviderStateMixin {
  late final AnimationController _rise = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  );
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2500),
  );

  @override
  void initState() {
    super.initState();
    _rise.forward();
    _pulse.repeat(reverse: true);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _rise.stop();
      _pulse.stop();
    }
  }

  @override
  void dispose() {
    _rise.dispose();
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    return AnimatedBuilder(
      animation: Listenable.merge([
        if (!reduceMotion) _rise,
        if (!reduceMotion) _pulse,
      ]),
      builder: (context, _) {
        final rise =
            reduceMotion ? 1.0 : Curves.easeInOut.transform(_rise.value);
        final pulse =
            reduceMotion ? 0.0 : Curves.easeInOut.transform(_pulse.value);
        return CustomPaint(
          size: Size.square(widget.size),
          painter: _SunrisePainter(riseProgress: rise, pulseAmount: pulse),
        );
      },
    );
  }
}

class _SunrisePainter extends CustomPainter {
  _SunrisePainter({required this.riseProgress, required this.pulseAmount});

  /// 0 = fully below the horizon, 1 = risen.
  final double riseProgress;

  /// 0..1 pulse amount (scale 1.0 → 1.04).
  final double pulseAmount;

  static const Color _glowStart = Color(0xFFFF9E6B); // dawn-glow
  static const Color _glowEnd = Color(0xFFFFD8A8);

  @override
  void paint(Canvas canvas, Size size) {
    final horizonY = size.height * 0.72;
    final radius = size.width * 0.22;
    final scale = 1.0 + 0.04 * pulseAmount;

    // Horizon line.
    canvas.drawLine(
      Offset(size.width * 0.06, horizonY),
      Offset(size.width * 0.94, horizonY),
      Paint()
        ..color = AppPalette.mist200.withValues(alpha: 0.35)
        ..strokeWidth = 1.5
        ..strokeCap = StrokeCap.round,
    );

    final center = Offset(
      size.width / 2,
      horizonY + radius + (riseProgress * -(radius * 1.9)),
    );

    // Glow (dawn-glow gradient, grows with rise & pulse).
    final glowRadius = radius * (1.8 + 0.5 * riseProgress + 0.15 * pulseAmount);
    canvas.drawCircle(
      center,
      glowRadius,
      Paint()
        ..shader = RadialGradient(colors: [
          _glowStart.withValues(alpha: 0.55 * riseProgress),
          _glowEnd.withValues(alpha: 0.0),
        ]).createShader(
          Rect.fromCircle(center: center, radius: glowRadius),
        ),
    );

    // Sun disc.
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.scale(scale);
    canvas.drawCircle(
      Offset.zero,
      radius,
      Paint()
        ..shader = RadialGradient(colors: [
          _glowEnd,
          AppPalette.dawn500,
        ]).createShader(
          Rect.fromCircle(center: Offset.zero, radius: radius),
        ),
    );
    canvas.restore();

    // Soft rays once risen.
    if (riseProgress > 0.9) {
      final rayAlpha = (riseProgress - 0.9) / 0.1;
      final rayPaint = Paint()
        ..color = _glowEnd.withValues(alpha: 0.5 * rayAlpha)
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round;
      for (var i = 0; i < 8; i++) {
        final angle = i * math.pi / 4;
        final inner = radius * 1.35;
        final outer = radius * (1.55 + 0.08 * pulseAmount);
        canvas.drawLine(
          center + Offset(math.cos(angle) * inner, math.sin(angle) * inner),
          center + Offset(math.cos(angle) * outer, math.sin(angle) * outer),
          rayPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_SunrisePainter oldDelegate) =>
      oldDelegate.riseProgress != riseProgress ||
      oldDelegate.pulseAmount != pulseAmount;
}
