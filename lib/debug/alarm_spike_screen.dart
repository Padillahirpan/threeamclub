import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../app/theme/app_theme.dart';
import '../core/platform/alarm_scheduler.dart';
import '../core/platform/method_channel_alarm_scheduler.dart';
import '../core/widgets/hold_button.dart';

/// M0 alarm spike harness (PRD §11 M0, ARCHITECTURE.md §10), kept for
/// continued on-device alarm testing during M1+. Debug builds only;
/// strings here are intentionally not localized.
class AlarmSpikeScreen extends StatefulWidget {
  const AlarmSpikeScreen({super.key});

  @override
  State<AlarmSpikeScreen> createState() => _AlarmSpikeScreenState();
}

class _AlarmSpikeScreenState extends State<AlarmSpikeScreen>
    with WidgetsBindingObserver {
  final MethodChannelAlarmScheduler _alarm = MethodChannelAlarmScheduler();

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
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      helpText: 'ALARM TIME (spike — any time allowed)',
    );
    if (picked == null) return;
    final today = DateTime.now();
    var at = DateTime(
        today.year, today.month, today.day, picked.hour, picked.minute);
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
    final colors = Theme.of(context).extension<AppColors>()!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('M0 — Alarm Spike'),
        leading: BackButton(onPressed: () => context.canPop() ? context.pop() : null),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            icon: Icon(Icons.refresh, color: colors.mist200),
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
          _statusCard(colors),
          const SizedBox(height: 16),
          _permissionsCard(colors),
          const SizedBox(height: 16),
          _actionsCard(colors),
          const SizedBox(height: 16),
          Text('Event log',
              style: AppTextStyles.h2
                  .copyWith(color: AppPalette.sky100)),
          const SizedBox(height: 8),
          Container(
            constraints: const BoxConstraints(maxHeight: 260),
            decoration: BoxDecoration(
              color: colors.night700,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(12),
            child: _log.isEmpty
                ? const Text('No events yet.')
                : ListView(
                    children: [
                      for (final line in _log)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Text(
                            line,
                            style: const TextStyle(
                              color: AppPalette.mist200,
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

  Widget _statusCard(AppColors colors) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.night700,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Alarm status',
                style: AppTextStyles.h2
                    .copyWith(color: AppPalette.sky100)),
            const SizedBox(height: 8),
            if (_stored == null)
              const Text('No alarm stored.')
            else ...[
              Text('Scheduled for ${_fmt(_stored!.triggerAt)}'),
              const SizedBox(height: 4),
              Text(
                _countdownText(),
                style: const TextStyle(
                    color: AppPalette.dawn500, fontSize: 14),
              ),
              Text(
                'state: ${_stored!.state} · id: ${_stored!.alarmId}',
                style: const TextStyle(
                    color: AppPalette.mist200, fontSize: 12),
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

  Widget _permissionsCard(AppColors colors) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.night700,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Permissions',
                style: AppTextStyles.h2
                    .copyWith(color: AppPalette.sky100)),
            const SizedBox(height: 8),
            if (_permissions == null)
              const Text('…')
            else ...[
              _permRow('Notifications', _permissions!.notifications),
              _permRow('Full-screen intent', _permissions!.fullScreenIntent),
              _permRow('Battery optimization ignored',
                  _permissions!.batteryOptimizationIgnored),
              const SizedBox(height: 4),
              Text(
                'Android ${_permissions!.sdkInt} · ${_permissions!.manufacturer}',
                style: const TextStyle(
                    color: AppPalette.mist200, fontSize: 12),
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
              color: granted
                  ? AppPalette.success500
                  : AppPalette.mist200,
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(label)),
          ],
        ),
      );

  Widget _actionsCard(AppColors colors) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.night700,
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
              icon: const Icon(Icons.schedule),
              label: const Text('Schedule at a specific time'),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _stored == null ? null : _cancel,
              icon: const Icon(Icons.cancel_outlined),
              label: const Text('Cancel alarm'),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _healthCheck,
              icon: const Icon(Icons.health_and_safety),
              label: const Text('Health check (re-register)'),
            ),
          ],
        ),
      );
}

class _WakeSpikeScreen extends StatelessWidget {
  const _WakeSpikeScreen({required this.onStop});

  final Future<void> Function() onStop;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.night950,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppPalette.night900, Color(0xFF3B2A4F)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(),
              const Icon(
                Icons.wb_twilight,
                size: 96,
                color: AppPalette.dawn500,
              ),
              const SizedBox(height: 24),
              const Text(
                'Good morning. You said you would.',
                textAlign: TextAlign.center,
                style: AppTextStyles.wakeHeadline,
              ),
              const SizedBox(height: 8),
              Text(
                'The hardest part is this one minute. Hold on.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color:
                      AppPalette.mist200.withValues(alpha: 0.9),
                ),
              ),
              const SizedBox(height: 48),
              HoldButton(
                duration: const Duration(seconds: 5),
                label: 'Hold to wake up',
                onCompleted: () => onStop(),
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () => onStop(),
                child: const Text(
                  'Tap to stop instead (accessibility)',
                  style: TextStyle(fontSize: 13),
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
