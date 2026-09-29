import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/theme/app_theme.dart';
import 'capped_frame_animation.dart';

/// Three layered sine waves drifting slowly (DESIGN.md §5 "Night waves",
/// §8 `WaveBackground`): 14–22s cycles at different speeds, amplitude
/// 8–16px. Reduce-motion renders a static gradient instead. Pauses when
/// [paused] (night screen dims after inactivity, FR-4.4).
class WaveBackground extends StatefulWidget {
  const WaveBackground({super.key, this.paused = false, this.child});

  final bool paused;
  final Widget? child;

  @override
  State<WaveBackground> createState() => _WaveBackgroundState();
}

class _WaveBackgroundState extends State<WaveBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 18),
  );

  /// Repaints capped at ~30fps (DESIGN.md §5 battery rule).
  late final Animation<double> _capped =
      CappedFrameAnimation(parent: _controller);

  @override
  void initState() {
    super.initState();
    // didChangeDependencies runs right after initState and syncs the
    // animation (it needs MediaQuery, unavailable in initState).
  }

  @override
  void didUpdateWidget(WaveBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncAnimation();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncAnimation();
  }

  void _syncAnimation() {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    if (widget.paused || reduceMotion) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    return CustomPaint(
      painter: _WavePainter(
        animation: reduceMotion ? null : _capped,
        night950: AppPalette.night950,
        night900: AppPalette.night900,
      ),
      child: widget.child,
    );
  }
}

class _WavePainter extends CustomPainter {
  _WavePainter({
    required this.animation,
    required this.night950,
    required this.night900,
  }) : super(repaint: animation);

  final Animation<double>? animation;
  final Color night950;
  final Color night900;

  static const List<({double speed, double amplitude, double baseline, double alpha})>
      _layers = [
    (speed: 1.0, amplitude: 16, baseline: 0.60, alpha: 0.60), // wave-1 #22305E
    (speed: 1.45, amplitude: 12, baseline: 0.70, alpha: 0.45), // wave-2 #2F4A8A
    (speed: 0.85, amplitude: 8, baseline: 0.80, alpha: 0.30), // wave-3 #4A6FB5
  ];

  static const List<Color> _colors = [
    Color(0xFF22305E),
    Color(0xFF2F4A8A),
    Color(0xFF4A6FB5),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    // Base: night-950 → night-900 vertical gradient (static fallback too).
    final base = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [night950, night900],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, base);

    final t = animation?.value ?? 0.0;

    for (var i = 0; i < _layers.length; i++) {
      final layer = _layers[i];
      final path = Path();
      final baseY = size.height * layer.baseline;
      final phase = t * 2 * math.pi * layer.speed + i * 1.7;
      path.moveTo(0, baseY);
      for (var x = 0.0; x <= size.width; x += 8) {
        final normalized = x / size.width;
        final y = baseY +
            math.sin(normalized * 2 * math.pi * 1.2 + phase) *
                layer.amplitude;
        path.lineTo(x, y);
      }
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.close();
      canvas.drawPath(
        path,
        Paint()..color = _colors[i].withValues(alpha: layer.alpha),
      );
    }
  }

  @override
  bool shouldRepaint(_WavePainter oldDelegate) =>
      oldDelegate.animation != animation;
}
