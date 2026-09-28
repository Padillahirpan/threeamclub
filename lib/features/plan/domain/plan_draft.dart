import 'package:freezed_annotation/freezed_annotation.dart';

part 'plan_draft.freezed.dart';

/// In-progress builder state, persisted only when signed
/// (ARCHITECTURE.md §9 `planDraftProvider`).
@freezed
abstract class PlanDraftState with _$PlanDraftState {
  const factory PlanDraftState({
    @Default(21 * 60) int bedMinute, // 21:00
    @Default(4 * 60) int wakeMinute, // 04:00
    @Default(<ChecklistItemDraft>[]) List<ChecklistItemDraft> checklist,
    @Default(<PromiseDraft>[]) List<PromiseDraft> promises,
    @Default('') String whyText,
  }) = _PlanDraftState;
}

@freezed
abstract class ChecklistItemDraft with _$ChecklistItemDraft {
  const factory ChecklistItemDraft({
    required String id,
    required String title,
  }) = _ChecklistItemDraft;
}

@freezed
abstract class PromiseDraft with _$PromiseDraft {
  const factory PromiseDraft({
    required String id,
    required String categoryId,
    required String title,
    String? description,
    @Default(15) int durationMin,
  }) = _PromiseDraft;
}
