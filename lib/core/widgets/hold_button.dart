import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Hold-to-confirm button — DESIGN.md §5/§8.
///
/// - Progress ring fills linearly over [duration].
/// - Haptic tick each whole second; stronger haptic on completion.
/// - Releasing early drains the ring back in 300ms (no error state).
///
/// Accessibility: callers must offer a non-hold alternative next to this
/// button (DESIGN.md §10). This widget also exposes a semantic long-press
/// action.
class HoldButton extends StatefulWidget {
  const HoldButton({
    super.key,
    required this.duration,
    required this.label,
    required this.onCompleted,
    this.size = 168,
    this.ringColor = const Color(0xFFF4A261), // dawn-500
    this.trackColor = const Color(0x33C9CEDB), // mist-200 @ 20%
  });

  final Duration duration;
  final String label;
  final VoidCallback onCompleted;
  final double size;
  final Color ringColor;
  final Color trackColor;

  @override
  State<HoldButton> createState() => _HoldButtonState();
}

class _HoldButtonState extends State<HoldButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  int _lastWholeSecond = -1;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..addListener(_onTick)
      ..addStatusListener(_onStatus);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTick() {
    final second =
        (_controller.value * widget.duration.inMilliseconds / 1000).floor();
    if (second != _lastWholeSecond) {
      _lastWholeSecond = second;
      HapticFeedback.selectionClick();
    }
  }

  void _onStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      HapticFeedback.heavyImpact();
      widget.onCompleted();
      _drain(from: 1);
    }
  }

  void _press() {
    _controller
      ..duration = widget.duration
      ..forward();
  }

  void _release() {
    if (_controller.isAnimating || _controller.value > 0) {
      _drain(from: _controller.value);
    }
  }

  /// Drain the ring back to zero in 300ms (DESIGN.md §5).
  void _drain({required double from}) {
    if (from <= 0) {
      _controller.value = 0;
      return;
    }
    _controller.stop();
    // The running reverse animation is built with the 300ms duration;
    // restoring immediately is safe for the next hold.
    _controller.duration = const Duration(milliseconds: 300);
    _controller.reverse(from: from);
    _controller.duration = widget.duration;
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.label,
      button: true,
      onLongPress: () {
        // Accessible long-press alternative: complete immediately
        // after a semantic long-press activation.
        _controller.value = 1;
      },
      child: Listener(
        onPointerDown: (_) => _press(),
        onPointerUp: (_) => _release(),
        onPointerCancel: (_) => _release(),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return CustomPaint(
              painter: _HoldRingPainter(
                progress: _controller.value,
                ringColor: widget.ringColor,
                trackColor: widget.trackColor,
              ),
              child: SizedBox(
                width: widget.size,
                height: widget.size,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.label,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xFFFDF6EC), // sky-100
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'hold ${widget.duration.inSeconds}s',
                          style: const TextStyle(
                            color: Color(0xFFC9CEDB), // mist-200
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _HoldRingPainter extends CustomPainter {
  _HoldRingPainter({
    required this.progress,
    required this.ringColor,
    required this.trackColor,
  });

  final double progress;
  final Color ringColor;
  final Color trackColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide / 2 - 6;
    const stroke = 8.0;
    const startAngle = -mathPi / 2;

    final track = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..color = trackColor;
    canvas.drawCircle(center, radius, track);

    if (progress > 0) {
      final ring = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round
        ..color = ringColor;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        progress * 2 * mathPi,
        false,
        ring,
      );
    }
  }

  static const double mathPi = 3.1415926535897932;

  @override
  bool shouldRepaint(_HoldRingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
