import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/theme/app_theme.dart';

/// Countdown wave (DESIGN.md §5 "Timer wave", §8 `TimerWave`): the fill
/// level equals elapsed/total and rises smoothly; the surface ripples
/// slowly on an independent loop. Level updates come from rebuilds (once
/// per second); the ripple never blocks. Reduce-motion renders a static
/// fill. `focus-wave` = dawn-500 @ 35% on night-700 (DESIGN §2).
class TimerWave extends StatefulWidget {
  const TimerWave({super.key, required this.progress, this.child});

  /// 0..1 — elapsed fraction; the wave fills upward.
  final double progress;

  final Widget? child;

  @override
  State<TimerWave> createState() => _TimerWaveState();
}

class _TimerWaveState extends State<TimerWave>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ripple = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 16),
  );

  @override
  void initState() {
    super.initState();
    _maybeStart();
  }

  @override
  void didUpdateWidget(TimerWave oldWidget) {
    super.didUpdateWidget(oldWidget);
    _maybeStart();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _maybeStart();
  }

  void _maybeStart() {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    if (reduceMotion) {
      _ripple.stop();
    } else if (!_ripple.isAnimating) {
      _ripple.repeat();
    }
  }

  @override
  void dispose() {
    _ripple.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    return CustomPaint(
      painter: _TimerWavePainter(
        progress: widget.progress.clamp(0.0, 1.0),
        ripple: reduceMotion ? null : _ripple,
      ),
      child: widget.child,
    );
  }
}

class _TimerWavePainter extends CustomPainter {
  _TimerWavePainter({required this.progress, required this.ripple})
      : super(repaint: ripple);

  final double progress;
  final Animation<double>? ripple;

  static const Color _fill = Color(0x59F4A261); // dawn-500 @ 35%
  static const Color _fillTop = Color(0x2EFBC89A); // dawn-300 @ 18%

  @override
  void paint(Canvas canvas, Size size) {
    // Base: night-900 → night-700 (timer page gradient, DESIGN §2).
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppPalette.night900, AppPalette.night700],
        ).createShader(Offset.zero & size),
    );

    final fillHeight = size.height * progress;
    if (fillHeight <= 0) return;

    final t = ripple?.value ?? 0.0;
    final surfaceY = size.height - fillHeight;

    // Two drifting sine crests for the surface ripple.
    Path surface(int layer) {
      final amplitude = layer == 0 ? 6.0 : 4.0;
      final phase = t * 2 * math.pi * (layer == 0 ? 1.0 : 1.4) + layer * 2.1;
      final path = Path()..moveTo(0, surfaceY);
      for (var x = 0.0; x <= size.width; x += 8) {
        final normalized = x / size.width;
        path.lineTo(
          x,
          surfaceY +
              math.sin(normalized * 2 * math.pi * 1.1 + phase) * amplitude,
        );
      }
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.close();
      return path;
    }

    canvas.drawPath(surface(1), Paint()..color = _fillTop);
    canvas.drawPath(surface(0), Paint()..color = _fill);
  }

  @override
  bool shouldRepaint(_TimerWavePainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.ripple != ripple;
}
