import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_theme.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/widgets/category_visual.dart';
import '../../../core/widgets/time_budget_bar.dart';
import '../../plan/application/plan_draft_controller.dart';
import '../data/drift_category_repository.dart';
import '../domain/category.dart';
import 'promise_sheet.dart';

const Category _fallbackCategory = Category(
  id: '',
  name: '',
  iconKey: 'plan',
  colorKey: 'dawn',
  isBuiltIn: false,
  isArchived: false,
);

Category _categoryFor(List<Category> categories, String id) =>
    categories.firstWhere((c) => c.id == id, orElse: () => _fallbackCategory);

/// Promise builder — step 2 (PRD FR-2.x, DESIGN.md §7.2).
class PromiseBuilderScreen extends ConsumerWidget {
  const PromiseBuilderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AppLocalizations.of(context)!;
    final colors = Theme.of(context).extension<AppColors>()!;
    final draft = ref.watch(planDraftProvider);
    final budget = ref.watch(timeBudgetProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final canSign = ref.watch(canSignProvider);

    final categories = categoriesAsync.value ?? const <Category>[];

    return Scaffold(
      appBar: AppBar(title: Text(s.promisesTitle)),
      floatingActionButton: FloatingActionButton(
        backgroundColor: colors.dawn500,
        foregroundColor: colors.ink900,
        onPressed: () async {
          final created = await showPromiseSheet(
            context,
            categories: categories,
          );
          if (created != null) {
            ref.read(planDraftProvider.notifier).addPromise(created);
          }
        },
        child: const Icon(Icons.add),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 96),
        children: [
          TimeBudgetBar(
            wakeMinute: draft.wakeMinute,
            label: s.budgetUsedOf(budget.usedMinutes, budget.budgetMinutes),
            overBudget: budget.isOver,
            segments: [
              for (final promise in draft.promises)
                BudgetSegment(
                  minutes: promise.durationMin,
                  color: colorForKey(_categoryFor(
                    categories,
                    promise.categoryId,
                  ).colorKey),
                ),
            ],
          ),
          if (budget.isOver) ...[
            const SizedBox(height: 8),
            Text(
              s.overBudget(budget.overByMinutes),
              style: TextStyle(
                color: colors.warn500,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          if (draft.promises.length > 4) ...[
            const SizedBox(height: 8),
            Text(
              s.startSmall, // non-blocking hint (FR-2.6)
              style: TextStyle(
                color: colors.mist200.withValues(alpha: 0.8),
                fontSize: 13,
              ),
            ),
          ],
          const SizedBox(height: 16),
          if (draft.promises.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 48),
              child: Center(
                child: Text(
                  s.addPromise,
                  style: TextStyle(
                      color: colors.mist200.withValues(alpha: 0.7)),
                ),
              ),
            )
          else
            ReorderableListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              buildDefaultDragHandles: false,
              itemCount: draft.promises.length,
              onReorder: ref.read(planDraftProvider.notifier).reorderPromises,
              proxyDecorator: (child, index, animation) => child,
              itemBuilder: (context, index) {
                final promise = draft.promises[index];
                final category = _categoryFor(categories, promise.categoryId);
                return Dismissible(
                  key: ValueKey(promise.id),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (_) => _confirmDelete(context, s),
                  onDismissed: (_) => ref
                      .read(planDraftProvider.notifier)
                      .removePromise(promise.id),
                  child: Card(
                    key: ValueKey('card-${promise.id}'),
                    child: ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      leading: Icon(
                        iconForKey(category.iconKey),
                        color: colorForKey(category.colorKey),
                      ),
                      title: Text(promise.title),
                      subtitle: Text(
                        '${category.name} · ${s.durationMinutes(promise.durationMin)}',
                        style: TextStyle(
                            color: colors.mist200
                                .withValues(alpha: 0.8),
                            fontSize: 13),
                      ),
                      trailing: ReorderableDragStartListener(
                        index: index,
                        child: Icon(Icons.drag_handle,
                            color: colors.mist200),
                      ),
                      onTap: () async {
                        final updated = await showPromiseSheet(
                          context,
                          categories: categories,
                          initial: promise,
                        );
                        if (updated != null) {
                          ref
                              .read(planDraftProvider.notifier)
                              .updatePromise(updated);
                        }
                      },
                    ),
                  ),
                );
              },
            ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FilledButton(
                // Signing is blocked while over budget / with no promises
                // (FR-2.5, FR-2.7).
                onPressed: canSign ? () => context.go('/plan/sign') : null,
                child: Text(s.reviewPromise),
              ),
              if (!canSign)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    budget.isOver
                        ? s.overBudget(budget.overByMinutes)
                        : s.signNeedsPromise,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: colors.mist200, fontSize: 13),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _confirmDelete(BuildContext context, AppLocalizations s) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(s.deletePromiseTitle),
        content: Text(s.deletePromiseBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(s.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(s.delete),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}
