import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';

/// Full-morning celebration (DESIGN §5): the sun bursts into gold
/// particles, max 1.5s. Reduce-motion replaces particles with a simple
/// gold flash. Fires [onFinished] when done.
class FullMorningBurst extends StatefulWidget {
  const FullMorningBurst({super.key, required this.onFinished});

  final VoidCallback onFinished;

  @override
  State<FullMorningBurst> createState() => _FullMorningBurstState();
}

class _FullMorningBurstState extends State<FullMorningBurst>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  );

  @override
  void initState() {
    super.initState();
    _controller.forward();
    _controller.addStatusListener(_onStatus);
  }

  void _onStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) widget.onFinished();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final t = _controller.value;
          return CustomPaint(
            size: Size.infinite,
            painter: reduceMotion
                ? _FlashPainter(t)
                : _BurstPainter(t, seed: 7),
          );
        },
      ),
    );
  }
}

/// Milestone celebration (DESIGN §5): a larger confetti-like glow,
/// max 2s. Reduce-motion: gold glow fade only.
class MilestoneConfetti extends StatefulWidget {
  const MilestoneConfetti({super.key, required this.onFinished});

  final VoidCallback onFinished;

  @override
  State<MilestoneConfetti> createState() => _MilestoneConfettiState();
}

class _MilestoneConfettiState extends State<MilestoneConfetti>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2000),
  );

  @override
  void initState() {
    super.initState();
    _controller.forward();
    _controller.addStatusListener(_onStatus);
  }

  void _onStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) widget.onFinished();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final t = _controller.value;
          return CustomPaint(
            size: Size.infinite,
            painter: reduceMotion
                ? _FlashPainter(t, gold: true)
                : _ConfettiPainter(t, seed: 11),
          );
        },
      ),
    );
  }
}

/// The sun bursting into gold particles (t 0..1).
class _BurstPainter extends CustomPainter {
  _BurstPainter(this.t, {required this.seed});

  final double t;
  final int seed;

  static const List<Color> _colors = [
    AppPalette.gold400,
    Color(0xFFFFD8A8),
    AppPalette.dawn500,
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Center sun: scales up and fades into particles.
    final sunR = size.shortestSide * 0.08 * (1 + 0.8 * t);
    canvas.drawCircle(
      center,
      sunR,
      Paint()
        ..shader = RadialGradient(colors: [
          AppPalette.gold400.withValues(alpha: (1 - t)),
          AppPalette.dawn500.withValues(alpha: (1 - t) * 0.6),
        ]).createShader(Rect.fromCircle(center: center, radius: sunR)),
    );

    final random = math.Random(seed);
    for (var i = 0; i < 28; i++) {
      final angle = random.nextDouble() * 2 * math.pi;
      final speed = 0.35 + random.nextDouble() * 0.65;
      final distance =
          size.shortestSide * 0.12 + speed * size.shortestSide * 0.38 * t;
      final position = center +
          Offset(math.cos(angle) * distance, math.sin(angle) * distance);
      final alpha = (1 - t) * (0.9 - 0.3 * speed);
      final radius = 2.5 + random.nextDouble() * 3.5 * (1 - t * 0.5);
      canvas.drawCircle(
        position,
        radius,
        Paint()..color = _colors[i % _colors.length].withValues(alpha: alpha),
      );
    }
  }

  @override
  bool shouldRepaint(_BurstPainter oldDelegate) => oldDelegate.t != t;
}

/// Falling confetti with a soft glow (t 0..1).
class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter(this.t, {required this.seed});

  final double t;
  final int seed;

  static const List<Color> _colors = [
    AppPalette.gold400,
    AppPalette.dawn500,
    AppPalette.success500,
    Color(0xFFFFD8A8),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    // Achievement halo behind the confetti (gold-glow @25%).
    final halo = Rect.fromCircle(
      center: Offset(size.width / 2, size.height * 0.45),
      radius: size.shortestSide * 0.42,
    );
    canvas.drawCircle(
      halo.center,
      halo.shortestSide / 2,
      Paint()
        ..shader = RadialGradient(colors: [
          AppPalette.gold400.withValues(alpha: 0.25 * (1 - t * 0.6)),
          AppPalette.gold400.withValues(alpha: 0.0),
        ]).createShader(halo),
    );

    final random = math.Random(seed);
    for (var i = 0; i < 36; i++) {
      final x = random.nextDouble() * size.width;
      final fallSpeed = 0.5 + random.nextDouble() * 0.5;
      final y = (random.nextDouble() * 0.2 + t * fallSpeed) * size.height;
      final alpha = (1 - t) * (0.7 + random.nextDouble() * 0.3);
      final w = 3.0 + random.nextDouble() * 3;
      final rotation = random.nextDouble() * math.pi;
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(rotation);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset.zero, width: w * 2, height: w),
          Radius.circular(w / 2),
        ),
        Paint()..color = _colors[i % _colors.length].withValues(alpha: alpha),
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter oldDelegate) => oldDelegate.t != t;
}

/// Reduce-motion fallback: a single soft gold flash that fades.
class _FlashPainter extends CustomPainter {
  _FlashPainter(this.t, {this.gold = false});

  final double t;
  final bool gold;

  @override
  void paint(Canvas canvas, Size size) {
    final alpha = (1 - t) * 0.45;
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..color = (gold ? AppPalette.gold400 : AppPalette.dawn500)
            .withValues(alpha: alpha),
    );
  }

  @override
  bool shouldRepaint(_FlashPainter oldDelegate) => oldDelegate.t != t;
}
