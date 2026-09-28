import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_theme.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/time/minute_of_day.dart' as t;
import '../../../core/widgets/category_visual.dart';
import '../../../core/widgets/hold_button.dart';
import '../../plan/application/plan_draft_controller.dart';
import '../../plan/data/plan_repository.dart';
import '../../promises/data/drift_category_repository.dart';
import '../../promises/domain/category.dart';

/// Sign the promise — step 3 (PRD FR-3.x, DESIGN.md §7.3).
class SignScreen extends ConsumerStatefulWidget {
  const SignScreen({super.key});

  @override
  ConsumerState<SignScreen> createState() => _SignScreenState();
}

class _SignScreenState extends ConsumerState<SignScreen> {
  bool _signing = false;
  late final TextEditingController _whyController =
      TextEditingController(text: ref.read(planDraftProvider).whyText);

  @override
  void dispose() {
    _whyController.dispose();
    super.dispose();
  }

  Future<void> _sign(AppLocalizations s) async {
    if (_signing) return;
    setState(() => _signing = true);
    try {
      final draft = ref.read(planDraftProvider);
      await ref.read(planRepositoryProvider).signPlan(
            draft,
            alarmTitle: s.appTitle,
            alarmBody: draft.whyText.isNotEmpty
                ? draft.whyText
                : s.alarmWakeLine,
            reminderTitle: s.notifBedtimeTitle,
            reminderBody: s.notifBedtimeBody,
          );
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(s.promiseSigned)));
      if (mounted) context.go('/night');
    } on Exception {
      if (mounted) setState(() => _signing = false);
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;
    final colors = Theme.of(context).extension<AppColors>()!;
    final draft = ref.watch(planDraftProvider);
    final budget = ref.watch(timeBudgetProvider);
    final canSign = ref.watch(canSignProvider);
    final categories =
        ref.watch(categoriesProvider).value ?? const <Category>[];
    final sleepMinutes = ref.watch(sleepDurationProvider);

    final finishTime = t.formatMinuteOfDay(budget.finishMinute);

    return Scaffold(
      appBar: AppBar(title: Text(s.signTitle)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _SummaryRow(label: s.signWakeLabel, value: t.formatMinuteOfDay(draft.wakeMinute)),
                  _SummaryRow(label: s.signBedtimeLabel, value: t.formatMinuteOfDay(draft.bedMinute)),
                  _SummaryRow(
                      label: s.signSleepLabel,
                      value: '${sleepMinutes ~/ 60}h ${sleepMinutes % 60}m'),
                  if (draft.checklist.isNotEmpty) ...[
                    const Divider(),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        s.signChecklistLabel,
                        style:
                            TextStyle(color: colors.mist200, fontSize: 13),
                      ),
                    ),
                    for (final item in draft.checklist)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Icon(Icons.check_circle_outline,
                                size: 16, color: colors.mist200),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                item.title,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                  const Divider(),
                  for (final promise in draft.promises)
                    _SummaryRow(
                      label: promise.title,
                      value: s.durationMinutes(promise.durationMin),
                      icon: Icon(
                        Icons.circle,
                        size: 10,
                        color: colorForCategoryId(categories, promise.categoryId),
                      ),
                    ),
                  const Divider(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      s.finishAround(finishTime),
                      style: TextStyle(
                        color: colors.dawn300,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            s.signWhyTitle,
            style:
                AppTextStyles.h2.copyWith(color: AppPalette.sky100),
          ),
          const SizedBox(height: 8),
          TextField(
            maxLength: 140, // FR-3.2: max ~140 characters
            minLines: 1,
            maxLines: 3,
            controller: _whyController,
            onChanged: ref.read(planDraftProvider.notifier).setWhyText,
            decoration: InputDecoration(hintText: s.signWhyHint),
          ),
          const SizedBox(height: 32),
          if (canSign) ...[
            Center(
              child: HoldButton(
                duration: const Duration(seconds: 3), // FR-3.3
                label: s.signHold,
                onCompleted: () => _sign(s),
              ),
            ),
            const SizedBox(height: 8),
            // A11y alternative to the hold gesture (FR-3.5, DESIGN.md §10).
            Center(
              child: TextButton(
                onPressed: () => _sign(s),
                child: Text(
                  s.signWithoutHold,
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            ),
          ] else
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text(
                budget.isOver
                    ? s.overBudget(budget.overByMinutes)
                    : s.signNeedsPromise,
                textAlign: TextAlign.center,
                style: TextStyle(color: colors.mist200),
              ),
            ),
        ],
      ),
    );
  }
}

Color colorForCategoryId(List<Category> categories, String id) {
  final match = categories.where((c) => c.id == id).firstOrNull;
  return switch (match?.colorKey) {
    final key? when categoryColorKeys.containsKey(key) =>
      categoryColorKeys[key]!,
    _ => AppPalette.dawn500,
  };
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.icon,
  });

  final String label;
  final String value;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          if (icon != null) ...[icon!, const SizedBox(width: 8)],
          Expanded(child: Text(label)),
          Text(
            value,
            style: const TextStyle(
              fontFeatures: [FontFeature.tabularFigures()],
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
