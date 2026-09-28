import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../app/router/routes.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/clock/clock.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/widgets/category_visual.dart';
import '../../../core/widgets/timer_wave.dart';
import '../../plan/application/phase_providers.dart';
import '../data/timer_repository.dart';

/// Promise timer — step 7 (PRD FR-7.x, DESIGN.md §7.7).
///
/// Locked while running: system back is blocked (`PopScope`) and the
/// router forces any other route back here while a session is active.
/// The only exits are Complete (after the countdown) and the safety exit.
/// Remaining time derives from the stored start timestamp, so it survives
/// app restart, phone calls and backgrounding (FR-7.4).
class PromiseTimerScreen extends ConsumerStatefulWidget {
  const PromiseTimerScreen({super.key, required this.promiseId});

  final String promiseId;

  @override
  ConsumerState<PromiseTimerScreen> createState() =>
      _PromiseTimerScreenState();
}

class _PromiseTimerScreenState extends ConsumerState<PromiseTimerScreen> {
  Timer? _ticker;
  bool _completing = false;
  bool _celebrating = false;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    WakelockPlus.disable();
    super.dispose();
  }

  Future<void> _start(TimerSession session, AppLocalizations s) async {
    await ref.read(timerRepositoryProvider).start(
          morningId: _morningId!,
          promiseId: widget.promiseId,
          completeTitle: s.appTitle,
          completeBody: session.title,
        );
  }

  String? get _morningId => ref.read(relevantMorningProvider).value?.id;

  Future<void> _complete(TimerSession session, AppLocalizations s) async {
    if (_completing) return;
    setState(() => _completing = true);
    final ok = await ref
        .read(timerRepositoryProvider)
        .complete(session.logId);
    if (!ok || !mounted) {
      if (mounted) setState(() => _completing = false);
      return;
    }
    HapticFeedback.heavyImpact();
    // Celebration: check draws in 300ms + gold pulse (DESIGN §5), then
    // back to Focus (FR-7.7).
    setState(() => _celebrating = true);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (mounted) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(s.promiseKept)));
      context.go(Routes.focus);
    }
  }

  Future<void> _endEarly(TimerSession session, AppLocalizations s) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(s.timerEndEarlyTitle),
        // Neutral wording — never "Failed" (FR-7.6).
        content: Text(s.timerEndEarlyBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(s.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(s.confirm),
          ),
        ],
      ),
    );
    if (confirmed ?? false) {
      await ref.read(timerRepositoryProvider).endEarly(session.logId);
      if (mounted) context.go(Routes.focus);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;
    final morning = ref.watch(relevantMorningProvider).value;
    final session = morning == null
        ? null
        : ref
            .watch(sessionProvider(
                (morningId: morning.id, promiseId: widget.promiseId)))
            .value;

    if (session == null) {
      // Morning closed or log missing — back to Focus.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && context.mounted) context.go(Routes.focus);
      });
      return const Scaffold(body: Center(child: SizedBox.shrink()));
    }

    final now = ref.watch(clockProvider).now();
    final remaining = session.remainingSec(now);
    final canComplete = session.canComplete(now);
    final progress =
        1 - remaining / (session.plannedSec == 0 ? 1 : session.plannedSec);

    // Keep the screen on while the timer runs (optional setting, M4 adds
    // the toggle; default on per ARCHITECTURE.md §3).
    if (session.isRunning) {
      WakelockPlus.enable();
    } else {
      WakelockPlus.disable();
    }

    return PopScope(
      // Locked mode: back is blocked while running (FR-7.3).
      canPop: !session.isRunning,
      child: Scaffold(
        backgroundColor: AppPalette.night900,
        body: TimerWave(
          progress: progress,
          child: SafeArea(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Icon(iconForKey(session.iconKey),
                              color: colorForKey(session.colorKey)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              session.categoryName,
                              style: TextStyle(
                                color: AppPalette.mist200
                                    .withValues(alpha: 0.8),
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        session.title,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.h1
                            .copyWith(color: AppPalette.sky100),
                      ),
                      if ((session.description ?? '').isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          session.description!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppPalette.mist200
                                .withValues(alpha: 0.8),
                            fontSize: 14,
                          ),
                        ),
                      ],
                      const SizedBox(height: 32),
                      // Big countdown (DESIGN §3 Timer style).
                      Text(
                        _format(remaining),
                        textAlign: TextAlign.center,
                        style: AppTextStyles.timer
                            .copyWith(color: AppPalette.sky100),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        s.timerLine,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppPalette.dawn300.withValues(alpha: 0.8),
                          fontSize: 13,
                        ),
                      ),
                      const Spacer(),
                      if (!session.isRunning && session.status == 'pending')
                        FilledButton(
                          onPressed: () => _start(session, s),
                          child: Text(s.timerStart),
                        )
                      else if (session.isRunning)
                        Column(
                          children: [
                            FilledButton(
                              // Complete is enabled only when time is up
                              // (FR-7.2); gold glow when enabled.
                              onPressed: canComplete && !_completing
                                  ? () => _complete(session, s)
                                  : null,
                              style: canComplete
                                  ? FilledButton.styleFrom(
                                      backgroundColor:
                                          AppPalette.gold400,
                                      foregroundColor:
                                          AppPalette.ink900,
                                    )
                                  : null,
                              child: Text(s.timerComplete),
                            ),
                            if (!canComplete)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  s.timerMinutesLeft(
                                      (remaining / 60).ceil()),
                                  style: TextStyle(
                                    color: AppPalette.mist200
                                        .withValues(alpha: 0.7),
                                    fontSize: 13,
                                    fontFeatures: const [
                                      FontFeature.tabularFigures()
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        )
                      else ...[
                        // kept / notFinished: nothing to run here anymore.
                        Text(
                          session.status == 'kept'
                              ? s.statusKept
                              : s.statusNotFinished,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppPalette.mist200),
                        ),
                      ],
                      const SizedBox(height: 8),
                      // Safety exit: small, long-press, always reachable
                      // incl. assistive tech (FR-7.6, DESIGN §10).
                      if (session.isRunning)
                        GestureDetector(
                          onLongPress: () => _endEarly(session, s),
                          child: TextButton(
                            onPressed: () => _endEarly(session, s),
                            child: Text(
                              s.timerEndEarly,
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                        ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
                if (_celebrating) const _CheckCelebration(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _format(int totalSec) {
    final m = (totalSec ~/ 60).toString().padLeft(2, '0');
    final sec = (totalSec % 60).toString().padLeft(2, '0');
    return '$m:$sec';
  }
}

/// Check draws in 300ms with a soft gold pulse (DESIGN §5).
class _CheckCelebration extends StatefulWidget {
  const _CheckCelebration();

  @override
  State<_CheckCelebration> createState() => _CheckCelebrationState();
}

class _CheckCelebrationState extends State<_CheckCelebration>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
  )..forward();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ColoredBox(
        color: AppPalette.night950.withValues(alpha: 0.7),
        child: Center(
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: _controller,
              curve: Curves.easeOutBack,
            ),
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppPalette.gold400.withValues(alpha: 0.25),
                border: Border.all(color: AppPalette.gold400, width: 2),
              ),
              child: const Icon(Icons.check,
                  size: 64, color: AppPalette.gold400),
            ),
          ),
        ),
      ),
    );
  }
}

/// Live session for one promise within the relevant morning.
final sessionProvider = StreamProvider.autoDispose
    .family<TimerSession?, ({String morningId, String promiseId})>(
  (ref, ids) {
    return ref.watch(timerRepositoryProvider).watchSession(
          morningId: ids.morningId,
          promiseId: ids.promiseId,
        );
  },
);
