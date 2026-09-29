import 'package:flutter/animation.dart';

/// Wraps an animation and notifies listeners at most once per [interval]
/// (~30fps) — the battery rule for night/timer screen motion
/// (DESIGN.md §5: "animations capped at 30fps").
///
/// The wrapped controller keeps ticking; only listener notifications (and
/// therefore repaints driven by `CustomPainter(repaint:)`) are throttled.
class CappedFrameAnimation extends Animation<double> {
  CappedFrameAnimation({
    required this.parent,
    this.interval = const Duration(milliseconds: 33),
  });

  final Animation<double> parent;
  final Duration interval;

  final List<VoidCallback> _listeners = [];
  DateTime _last = DateTime.fromMillisecondsSinceEpoch(0);

  void _tick() {
    final now = DateTime.now();
    if (now.difference(_last) < interval) return;
    _last = now;
    for (final listener in List<VoidCallback>.of(_listeners)) {
      listener();
    }
  }

  @override
  void addListener(VoidCallback listener) {
    if (_listeners.isEmpty) {
      parent.addListener(_tick);
    }
    _listeners.add(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
    if (_listeners.isEmpty) {
      parent.removeListener(_tick);
    }
  }

  @override
  void addStatusListener(AnimationStatusListener listener) =>
      parent.addStatusListener(listener);

  @override
  void removeStatusListener(AnimationStatusListener listener) =>
      parent.removeStatusListener(listener);

  @override
  AnimationStatus get status => parent.status;

  @override
  double get value => parent.value;
}
