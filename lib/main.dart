import 'dart:async';

import 'package:flutter/material.dart';

import 'core/platform/alarm_scheduler.dart';
import 'core/platform/method_channel_alarm_scheduler.dart';
import 'core/widgets/hold_button.dart';

/// M0 — Native alarm reliability spike (PRD §11 M0, ARCHITECTURE.md §10).
///
/// A minimal test harness around the AlarmScheduler contract:
/// schedule / cancel / health-check the native alarm, observe events,
/// and stop the ringing alarm with a 5s hold (FR-5.3).
void main() {
  runApp(const SpikeApp());
}

// Design tokens (DESIGN.md §2).
const _night950 = Color(0xFF060A1A);
const _night900 = Color(0xFF0B1026);
const _night700 = Color(0xFF1B2140);
const _dawn500 = Color(0xFFF4A261);
const _sky100 = Color(0xFFFDF6EC);
const _mist200 = Color(0xFFC9CEDB);

class SpikeApp extends StatelessWidget {
  const SpikeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '3AM Club — M0 Alarm Spike',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: _night900,
        colorScheme: const ColorScheme.dark(
          primary: _dawn500,
          surface: _night700,
        ),
        appBarTheme: const AppBarTheme(backgroundColor: _night900),
        useMaterial3: true,
      ),
      home: const SpikeHomePage(),
    );
  }
}

class SpikeHomePage extends StatefulWidget {
  const SpikeHomePage({super.key});

  @override
  State<SpikeHomePage> createState() => _SpikeHomePageState();
}

class _SpikeHomePageState extends State<SpikeHomePage>
    with WidgetsBindingObserver {
  late final MethodChannelAlarmScheduler _alarm =
      MethodChannelAlarmScheduler();

  StreamSubscription<AlarmEvent>? _eventsSub;

  AlarmPermissions? _permissions;
  StoredAlarm? _stored;
  bool _ringing = false;
  final List<String> _log = <String>[];
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _eventsSub = _alarm.events.listen(_onEvent, onError: (Object e) {
      _addLog('event stream error: $e');
    });
    _bootstrap();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _eventsSub?.cancel();
    _ticker?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _addLog('app resumed — health check');
      _healthCheck();
    }
  }

  Future<void> _bootstrap() async {
    // Cold start via full-screen intent: consume the cached event.
    final launchEvent = await _alarm.consumeLaunchEvent();
    if (launchEvent != null) {
      _onEvent(launchEvent, cached: true);
    }
    await _refreshPermissions();
    await _healthCheck();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  void _onEvent(AlarmEvent event, {bool cached = false}) {
    _addLog('event: ${event.type}'
        '${cached ? ' (cached launch)' : ''} @ ${_fmt(event.at)}');
    switch (event.type) {
      case 'fired':
      case 'openWake':
        if (mounted) setState(() => _ringing = true);
      case 'stopped':
        if (mounted) setState(() => _ringing = false);
        _healthCheck();
      case 'scheduled':
        _healthCheck();
    }
  }

  Future<void> _refreshPermissions() async {
    try {
      final perms = await _alarm.checkPermissions();
      if (mounted) setState(() => _permissions = perms);
      _addLog(
        'permissions: notif=${perms.notifications} '
        'fsi=${perms.fullScreenIntent} '
        'batteryIgnored=${perms.batteryOptimizationIgnored} '
        '(Android ${perms.sdkInt}, ${perms.manufacturer})',
      );
    } on Exception catch (e) {
      _addLog('checkPermissions failed: $e');
    }
  }

  /// ARCHITECTURE.md §10: verify the next alarm is registered, re-register.
  Future<void> _healthCheck() async {
    try {
      final stored = await _alarm.storedAlarm();
      if (mounted) setState(() => _stored = stored);
      if (stored == null) {
        _addLog('health check: no alarm stored');
        return;
      }
      if (stored.triggerAtMillis <= DateTime.now().millisecondsSinceEpoch) {
        _addLog('health check: stored alarm is in the past — clearing');
        await _alarm.cancel(stored.alarmId);
        if (mounted) setState(() => _stored = null);
        return;
      }
      await _alarm.rescheduleFromStore();
      _addLog('health check: alarm re-registered for ${_fmt(stored.triggerAt)}');
    } on Exception catch (e) {
      _addLog('health check failed: $e');
    }
  }

  Future<void> _scheduleIn(Duration delay) async {
    final at = DateTime.now().add(delay);
    await _alarm.schedule(AlarmSpec(
      alarmId: 'm0-spike',
      triggerAtMillis: at.millisecondsSinceEpoch,
      title: '3AM Club',
      body: 'Good morning. You said you would.',
    ));
    _addLog('scheduled for ${_fmt(at)} (in ${delay.inSeconds}s)');
    await _healthCheck();
  }

  Future<void> _scheduleAtTime() async {
    final now = TimeOfDay.now();
    final picked = await showTimePicker(
      context: context,
      initialTime: now,
      helpText: 'ALARM TIME (spike — any time allowed)',
    );
    if (picked == null) return;
    final today = DateTime.now();
    var at = DateTime(today.year, today.month, today.day,
        picked.hour, picked.minute);
    if (!at.isAfter(today)) {
      at = at.add(const Duration(days: 1));
    }
    await _alarm.schedule(AlarmSpec(
      alarmId: 'm0-spike',
      triggerAtMillis: at.millisecondsSinceEpoch,
      title: '3AM Club',
      body: 'Good morning. You said you would.',
    ));
    _addLog('scheduled for ${_fmt(at)}');
    await _healthCheck();
  }

  Future<void> _cancel() async {
    final id = _stored?.alarmId ?? 'm0-spike';
    await _alarm.cancel(id);
    _addLog('cancelled');
    await _healthCheck();
  }

  Future<void> _requestAllPermissions() async {
    final notif = await _alarm.requestNotificationPermission();
    _addLog('notification permission: $notif');
    final perms = await _alarm.checkPermissions();
    if (mounted) setState(() => _permissions = perms);
    if (!perms.fullScreenIntent) {
      _addLog('full-screen intent not granted — opening settings');
      await _alarm.openFullScreenIntentSettings();
    }
    if (!perms.batteryOptimizationIgnored) {
      _addLog('requesting battery-optimization exemption');
      await _alarm.requestIgnoreBatteryOptimizations();
    }
    await _refreshPermissions();
  }

  Future<void> _stopRinging() async {
    await _alarm.stopRinging();
    if (mounted) setState(() => _ringing = false);
    _addLog('stopRinging sent');
  }

  void _addLog(String msg) {
    debugPrint('[m0] $msg');
    if (mounted) {
      setState(() {
        _log.insert(0, '${_fmt(DateTime.now())}  $msg');
        if (_log.length > 80) _log.removeLast();
      });
    }
  }

  String _fmt(DateTime t) =>
      '${t.hour.toString().padLeft(2, '0')}:'
      '${t.minute.toString().padLeft(2, '0')}:'
      '${t.second.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    if (_ringing) return _WakeSpikeScreen(onStop: _stopRinging);
    return Scaffold(
      appBar: AppBar(
        title: const Text('M0 — Alarm Spike'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            icon: const Icon(Icons.refresh, color: _mist200),
            onPressed: () {
              _refreshPermissions();
              _healthCheck();
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _statusCard(),
          const SizedBox(height: 16),
          _permissionsCard(),
          const SizedBox(height: 16),
          _actionsCard(),
          const SizedBox(height: 16),
          Text('Event log', style: _h2),
          const SizedBox(height: 8),
          Container(
            constraints: const BoxConstraints(maxHeight: 260),
            decoration: BoxDecoration(
              color: _night700,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(12),
            child: _log.isEmpty
                ? const Text('No events yet.',
                    style: TextStyle(color: _mist200))
                : ListView(
                    children: [
                      for (final line in _log)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Text(
                            line,
                            style: const TextStyle(
                              color: _mist200,
                              fontSize: 12,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                    ],
                  ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _statusCard() => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _night700,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Alarm status', style: _h2),
            const SizedBox(height: 8),
            if (_stored == null)
              const Text('No alarm stored.',
                  style: TextStyle(color: _mist200))
            else ...[
              Text(
                'Scheduled for ${_fmt(_stored!.triggerAt)}',
                style: const TextStyle(color: _sky100, fontSize: 16),
              ),
              const SizedBox(height: 4),
              Text(
                _countdownText(),
                style: const TextStyle(color: _dawn500, fontSize: 14),
              ),
              Text(
                'state: ${_stored!.state} · id: ${_stored!.alarmId}',
                style: const TextStyle(color: _mist200, fontSize: 12),
              ),
            ],
          ],
        ),
      );

  String _countdownText() {
    final remaining = _stored!.triggerAt.difference(DateTime.now());
    if (remaining.isNegative) return 'in the past';
    final m = remaining.inMinutes;
    final s = remaining.inSeconds % 60;
    return 'rings in ${m}m ${s.toString().padLeft(2, '0')}s';
  }

  Widget _permissionsCard() => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _night700,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Permissions', style: _h2),
            const SizedBox(height: 8),
            if (_permissions == null)
              const Text('…', style: TextStyle(color: _mist200))
            else ...[
              _permRow('Notifications',
                  _permissions!.notifications),
              _permRow('Full-screen intent',
                  _permissions!.fullScreenIntent),
              _permRow('Battery optimization ignored',
                  _permissions!.batteryOptimizationIgnored),
              const SizedBox(height: 4),
              Text(
                'Android ${_permissions!.sdkInt} · '
                '${_permissions!.manufacturer}',
                style: const TextStyle(color: _mist200, fontSize: 12),
              ),
            ],
          ],
        ),
      );

  Widget _permRow(String label, bool granted) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          children: [
            Icon(
              granted ? Icons.check_circle : Icons.circle_outlined,
              color: granted ? const Color(0xFF6FCF97) : _mist200,
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(label, style: const TextStyle(color: _sky100))),
          ],
        ),
      );

  Widget _actionsCard() => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _night700,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FilledButton.icon(
              onPressed: _requestAllPermissions,
              icon: const Icon(Icons.admin_panel_settings_outlined),
              label: const Text('1. Check & request permissions'),
            ),
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: () => _scheduleIn(const Duration(minutes: 1)),
              icon: const Icon(Icons.alarm),
              label: const Text('2. Schedule alarm in 1 minute'),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _scheduleAtTime,
              icon: const Icon(Icons.schedule, color: _mist200),
              label: const Text('Schedule at a specific time'),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _stored == null ? null : _cancel,
              icon: const Icon(Icons.cancel_outlined, color: _mist200),
              label: const Text('Cancel alarm'),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _healthCheck,
              icon: const Icon(Icons.health_and_safety, color: _mist200),
              label: const Text('Health check (re-register)'),
            ),
          ],
        ),
      );

  static const _h2 = TextStyle(
    color: _sky100,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );
}

/// Wake-path spike screen (FR-5.3): alarm stops only when the 5s hold
/// completes. Instant open — no spinners (PRD §9 Performance).
class _WakeSpikeScreen extends StatelessWidget {
  const _WakeSpikeScreen({required this.onStop});

  final Future<void> Function() onStop;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _night950,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_night900, Color(0xFF3B2A4F)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(),
              Icon(
                Icons.wb_twilight,
                size: 96,
                color: _dawn500,
              ),
              const SizedBox(height: 24),
              const Text(
                'Good morning. You said you would.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _sky100,
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'The hardest part is this one minute. Hold on.',
                textAlign: TextAlign.center,
                style: TextStyle(color: _mist200.withValues(alpha: 0.9)),
              ),
              const SizedBox(height: 48),
              HoldButton(
                duration: const Duration(seconds: 5),
                label: 'Hold to wake up',
                onCompleted: () => onStop(),
              ),
              const SizedBox(height: 24),
              // A11y alternative to the hold gesture (DESIGN.md §10).
              TextButton(
                onPressed: () => onStop(),
                child: const Text(
                  'Tap to stop instead (accessibility)',
                  style: TextStyle(color: _mist200, fontSize: 13),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
