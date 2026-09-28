import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/routes.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/time/minute_of_day.dart' as t;
import '../../../core/widgets/category_visual.dart';
import '../../plan/application/phase_providers.dart';
import '../../plan/data/morning_repository.dart';

/// Focus — step 6 (PRD FR-6.x, DESIGN.md §7.6).
///
/// Greeting, time left until 06:00, the "why" line (serif), progress, and
/// the promise cards in plan order with their statuses. Tapping a promise
/// opens its timer page (M3).
class FocusScreen extends ConsumerWidget {
  const FocusScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AppLocalizations.of(context)!;
    final plan = ref.watch(activePlanProvider).value;
    final morning = ref.watch(relevantMorningProvider).value;
    final board = morning == null
        ? const <MorningPromise>[]
        : ref.watch(morningBoardProvider(morning.id)).value ??
            const <MorningPromise>[];

    final kept =
        board.where((p) => p.status == 'kept').length;
    final allKept = board.isNotEmpty && kept == board.length;
    final why = (plan?.whyText ?? '').trim();

    return Scaffold(
      appBar: AppBar(
        title: Text(s.focusGreeting),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          if (why.isNotEmpty) ...[
            Text(
              why,
              style: AppTextStyles.wakeHeadline.copyWith(
                color: AppPalette.dawn300,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 8),
          ],
          _TimeLeftLabel(),
          const SizedBox(height: 12),
          Text(
            s.focusProgress(kept, board.length),
            style: const TextStyle(color: AppPalette.sky100),
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: board.isEmpty ? 0 : kept / board.length,
              minHeight: 6,
              backgroundColor: AppPalette.mist200.withValues(alpha: 0.15),
              valueColor: const AlwaysStoppedAnimation(AppPalette.dawn500),
            ),
          ),
          const SizedBox(height: 16),
          if (allKept) ...[
            _AllKeptCard(s: s),
            const SizedBox(height: 16),
          ],
          for (final promise in board)
            _PromiseCard(
              promise: promise,
              s: s,
              onTap: () => context.go(
                '${Routes.focus}/promise/${promise.promiseId}',
              ),
            ),
        ],
      ),
    );
  }
}

class _TimeLeftLabel extends StatefulWidget {
  @override
  State<_TimeLeftLabel> createState() => _TimeLeftLabelState();
}

class _TimeLeftLabelState extends State<_TimeLeftLabel> {
  Timer? _timer;
  int _minutesLeft = _compute();

  static int _compute() {
    final nowMinute = DateTime.now().hour * 60 + DateTime.now().minute;
    return (t.morningCloseMinute - nowMinute).clamp(0, t.minutesPerDay);
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) setState(() => _minutesLeft = _compute());
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;
    return Text(
      s.focusTimeLeft(_minutesLeft),
      style: TextStyle(
        color: AppPalette.mist200.withValues(alpha: 0.8),
        fontSize: 13,
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
    );
  }
}

class _AllKeptCard extends StatelessWidget {
  const _AllKeptCard({required this.s});

  final AppLocalizations s;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppPalette.gold400.withValues(alpha: 0.18),
            AppPalette.night700,
          ],
        ),
        border: Border.all(color: AppPalette.gold400.withValues(alpha: 0.4)),
      ),
      child: Column(
        children: [
          const Icon(Icons.wb_sunny, size: 40, color: AppPalette.gold400),
          const SizedBox(height: 12),
          Text(
            s.focusAllKept, // full-morning line (copy library)
            textAlign: TextAlign.center,
            style: AppTextStyles.h2.copyWith(color: AppPalette.sky100),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () => context.go(Routes.dashboard),
            child: Text(s.seeYourProgress),
          ),
        ],
      ),
    );
  }
}

class _PromiseCard extends StatelessWidget {
  const _PromiseCard({required this.promise, required this.s, this.onTap});

  final MorningPromise promise;
  final AppLocalizations s;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final (label, color, dimmed) = switch (promise.status) {
      'kept' => (s.statusKept, AppPalette.success500, true),
      'inProgress' => (s.statusInProgress, AppPalette.dawn500, false),
      'notFinished' => (s.statusNotFinished, AppPalette.mist200, true),
      _ => (s.statusNotStarted, AppPalette.mist200, false),
    };

    return Opacity(
      opacity: dimmed ? 0.6 : 1,
      child: Card(
        child: ListTile(
          onTap: promise.status == 'kept' ? null : onTap,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          leading: Icon(
            promise.status == 'kept'
                ? Icons.check_circle
                : iconForKey(promise.iconKey),
            color: promise.status == 'kept'
                ? AppPalette.success500
                : colorForKey(promise.colorKey),
          ),
          title: Text(promise.title),
          subtitle: Text(
            '${promise.categoryName} · ${s.durationMinutes(promise.durationMin)}',
            style: TextStyle(
              color: AppPalette.mist200.withValues(alpha: 0.8),
              fontSize: 13,
            ),
          ),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              label,
              style: TextStyle(color: color, fontSize: 12),
            ),
          ),
        ),
      ),
    );
  }
}

/// Live promise board for the focus screen (drift `watch()`).
final morningBoardProvider =
    StreamProvider.autoDispose.family<List<MorningPromise>, String>(
  (ref, morningId) {
    return ref.watch(morningRepositoryProvider).watchMorningBoard(morningId);
  },
);
