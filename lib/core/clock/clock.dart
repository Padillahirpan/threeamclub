import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Injectable time source so domain rules are unit-testable with a fake
/// clock (ARCHITECTURE.md §9 `clockProvider`).
abstract class Clock {
  DateTime now();
}

class SystemClock implements Clock {
  const SystemClock();

  @override
  DateTime now() => DateTime.now();
}

class FixedClock implements Clock {
  FixedClock(this._now);

  final DateTime _now;

  @override
  DateTime now() => _now;
}

/// Test-friendly clock whose time can be moved.
class MutableClock implements Clock {
  MutableClock(DateTime initial) : _now = initial;

  DateTime _now;

  @override
  DateTime now() => _now;

  void set(DateTime time) => _now = time;
}

/// Keep-alive: one clock for the whole app.
final clockProvider = Provider<Clock>((ref) => const SystemClock());
