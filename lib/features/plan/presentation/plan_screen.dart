import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_theme.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/time/minute_of_day.dart' as t;
import '../../../core/widgets/time_wheel_picker.dart';
import '../application/plan_draft_controller.dart';

/// Sleep plan screen — step 1 (PRD FR-1.x, DESIGN.md §7.1).
class PlanScreen extends ConsumerWidget {
  const PlanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AppLocalizations.of(context)!;
    final colors = Theme.of(context).extension<AppColors>()!;
    final draft = ref.watch(planDraftProvider);
    final sleepMinutes = ref.watch(sleepDurationProvider);
    final hours = sleepMinutes ~/ 60;
    final minutes = sleepMinutes % 60;

    final sleepChip = minutes == 0
        ? s.sleepDurationChipH(hours)
        : hours == 0
            ? s.sleepDurationChipM(minutes)
            : s.sleepDurationChip(hours, minutes);
    final tooShort =
        sleepMinutes < t.sleepHintThresholdMinutes;

    return Scaffold(
      appBar: AppBar(
        title: Text(s.planTitle),
        actions: [
          if (kDebugMode)
            IconButton(
              tooltip: s.alarmSpikeTitle,
              icon: Icon(Icons.bug_report_outlined, color: colors.mist200),
              onPressed: () => context.go('/debug/alarm-spike'),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _TimeRow(
            label: s.bedtimeLabel,
            value: t.formatMinuteOfDay(draft.bedMinute),
            onTap: () => _pickTime(
              context,
              ref,
              confirmLabel: s.confirm,
              cancelLabel: s.cancel,
              initial: draft.bedMinute,
              min: 0,
              max: t.minutesPerDay - 5,
              onPicked: ref.read(planDraftProvider.notifier).setBedMinute,
            ),
          ),
          const SizedBox(height: 8),
          _TimeRow(
            label: s.wakeTimeLabel,
            value: t.formatMinuteOfDay(draft.wakeMinute),
            subtitle: s.wakeRangeHint,
            onTap: () => _pickTime(
              context,
              ref,
              confirmLabel: s.confirm,
              cancelLabel: s.cancel,
              initial: draft.wakeMinute,
              min: t.wakeWindowStart,
              max: t.wakeWindowEnd,
              onPicked: ref.read(planDraftProvider.notifier).setWakeMinute,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: colors.night700,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  sleepChip,
                  style: const TextStyle(
                    color: AppPalette.sky100,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (tooShort) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    s.sleepHint, // gentle, non-blocking (FR-1.2)
                    style: TextStyle(color: colors.warn500, fontSize: 13),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 32),
          _ChecklistEditor(s: s, colors: colors),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: FilledButton(
            onPressed: () => context.go('/plan/promises'),
            child: Text(s.planNext),
          ),
        ),
      ),
    );
  }

  Future<void> _pickTime(
    BuildContext context,
    WidgetRef ref, {
    required String confirmLabel,
    required String cancelLabel,
    required int initial,
    required int min,
    required int max,
    required ValueChanged<int> onPicked,
  }) async {
    final minute = await showTimeWheelPicker(
      context,
      confirmLabel: confirmLabel,
      cancelLabel: cancelLabel,
      initialMinute: initial,
      minMinute: min,
      maxMinute: max,
    );
    if (minute != null) onPicked(minute);
  }
}

class _TimeRow extends StatelessWidget {
  const _TimeRow({
    required this.label,
    required this.value,
    required this.onTap,
    this.subtitle,
  });

  final String label;
  final String value;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Material(
      color: colors.night700,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label,
                        style: TextStyle(
                            color: colors.mist200, fontSize: 13)),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        style: TextStyle(
                            color: colors.mist200
                                .withValues(alpha: 0.7),
                            fontSize: 11),
                      ),
                  ],
                ),
              ),
              Text(
                value,
                style: AppTextStyles.h2.copyWith(
                  color: AppPalette.sky100,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right, color: colors.mist200),
            ],
          ),
        ),
      ),
    );
  }
}

/// Pre-sleep checklist editor (FR-1.3): add, rename, delete, reorder.
class _ChecklistEditor extends ConsumerStatefulWidget {
  const _ChecklistEditor({required this.s, required this.colors});

  final AppLocalizations s;
  final AppColors colors;

  @override
  ConsumerState<_ChecklistEditor> createState() => _ChecklistEditorState();
}

class _ChecklistEditorState extends ConsumerState<_ChecklistEditor> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<String> get _suggestions => [
        widget.s.checklistSuggestion1,
        widget.s.checklistSuggestion2,
        widget.s.checklistSuggestion3,
        widget.s.checklistSuggestion4,
      ];

  @override
  Widget build(BuildContext context) {
    final s = widget.s;
    final colors = widget.colors;
    final draft = ref.watch(planDraftProvider);
    final notifier = ref.read(planDraftProvider.notifier);
    final remainingSuggestions =
        _suggestions.where((x) => !draft.checklist.any((i) => i.title == x));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(s.checklistTitle,
            style: AppTextStyles.h2
                .copyWith(color: AppPalette.sky100)),
        const SizedBox(height: 12),
        if (draft.checklist.isNotEmpty)
          ReorderableListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            buildDefaultDragHandles: false,
            itemCount: draft.checklist.length,
            onReorder: notifier.reorderChecklist,
            proxyDecorator: (child, index, animation) => child,
            itemBuilder: (context, index) {
              final item = draft.checklist[index];
              return Dismissible(
                key: ValueKey(item.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    color: colors.night700,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.delete_outline, color: colors.mist200),
                ),
                onDismissed: (_) => notifier.removeChecklistItem(item.id),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  tileColor: colors.night700,
                  title: Text(
                    item.title,
                    style:
                        const TextStyle(color: AppPalette.sky100),
                  ),
                  trailing: ReorderableDragStartListener(
                    index: index,
                    child: Icon(Icons.drag_handle, color: colors.mist200),
                  ),
                  onTap: () async {
                    final controller =
                        TextEditingController(text: item.title);
                    final renamed = await showDialog<String>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(s.checklistRenameTitle),
                        content: TextField(
                          controller: controller,
                          autofocus: true,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(s.cancel),
                          ),
                          FilledButton(
                            onPressed: () =>
                                Navigator.pop(context, controller.text),
                            child: Text(s.save),
                          ),
                        ],
                      ),
                    );
                    if (renamed != null && renamed.trim().isNotEmpty) {
                      notifier.renameChecklistItem(item.id, renamed.trim());
                    }
                  },
                ),
              );
            },
          ),
        if (draft.checklist.isNotEmpty) const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                onSubmitted: _add,
                decoration: InputDecoration(hintText: s.checklistAddHint),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () => _add(_controller.text),
              icon: const Icon(Icons.add_circle_outline),
              color: colors.dawn500,
            ),
          ],
        ),
        if (remainingSuggestions.isNotEmpty) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final suggestion in remainingSuggestions)
                ActionChip(
                  label: Text(
                    suggestion,
                    style: const TextStyle(fontSize: 13),
                  ),
                  onPressed: () => notifier.addChecklistItem(suggestion),
                ),
            ],
          ),
        ],
      ],
    );
  }

  void _add(String value) {
    final title = value.trim();
    if (title.isEmpty) return;
    ref.read(planDraftProvider.notifier).addChecklistItem(title);
    _controller.clear();
  }
}
