import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/time/time_budget.dart';
import '../domain/plan_draft.dart';

/// UI state for the three planning screens (sleep plan → promises → sign).
/// Not persisted until signed (ARCHITECTURE.md §9).
class PlanDraftController extends Notifier<PlanDraftState> {
  @override
  PlanDraftState build() => const PlanDraftState();

  void setBedMinute(int minute) =>
      state = state.copyWith(bedMinute: minute);

  void setWakeMinute(int minute) =>
      state = state.copyWith(wakeMinute: minute);

  void setWhyText(String text) => state = state.copyWith(whyText: text);

  // ---- Pre-sleep checklist ----

  void addChecklistItem(String title) {
    final item = ChecklistItemDraft(
      id: 'chk-${DateTime.now().microsecondsSinceEpoch}',
      title: title,
    );
    state = state.copyWith(checklist: [...state.checklist, item]);
  }

  void renameChecklistItem(String id, String title) {
    state = state.copyWith(
      checklist: [
        for (final item in state.checklist)
          if (item.id == id) item.copyWith(title: title) else item,
      ],
    );
  }

  void removeChecklistItem(String id) {
    state = state.copyWith(
      checklist: [
        for (final item in state.checklist)
          if (item.id != id) item,
      ],
    );
  }

  void reorderChecklist(int oldIndex, int newIndex) {
    final items = [...state.checklist];
    if (newIndex > oldIndex) newIndex -= 1;
    final item = items.removeAt(oldIndex);
    items.insert(newIndex, item);
    state = state.copyWith(checklist: items);
  }

  // ---- Promises ----

  void addPromise(PromiseDraft promise) {
    state = state.copyWith(promises: [...state.promises, promise]);
  }

  void updatePromise(PromiseDraft promise) {
    state = state.copyWith(
      promises: [
        for (final p in state.promises)
          if (p.id == promise.id) promise else p,
      ],
    );
  }

  void removePromise(String id) {
    state = state.copyWith(
      promises: [
        for (final p in state.promises)
          if (p.id != id) p,
      ],
    );
  }

  void reorderPromises(int oldIndex, int newIndex) {
    final items = [...state.promises];
    if (newIndex > oldIndex) newIndex -= 1;
    final item = items.removeAt(oldIndex);
    items.insert(newIndex, item);
    state = state.copyWith(promises: items);
  }
}

final planDraftProvider =
    NotifierProvider<PlanDraftController, PlanDraftState>(
  PlanDraftController.new,
);

/// Derived: budget vs. promise total (PRD FR-2.5).
final timeBudgetProvider = Provider<TimeBudget>((ref) {
  final draft = ref.watch(planDraftProvider);
  return computeTimeBudget(
    wakeMinute: draft.wakeMinute,
    promiseDurationMinutes:
        draft.promises.map((p) => p.durationMin),
  );
});

/// Derived: can the plan be signed? (FR-2.5 + FR-2.7)
final canSignProvider = Provider<bool>((ref) {
  final draft = ref.watch(planDraftProvider);
  final budget = ref.watch(timeBudgetProvider);
  return draft.promises.isNotEmpty && !budget.isOver;
});

/// Derived: sleep duration in minutes (FR-1.2).
final sleepDurationProvider = Provider<int>((ref) {
  final draft = ref.watch(planDraftProvider);
  return (draft.wakeMinute - draft.bedMinute + 24 * 60) % (24 * 60);
});
