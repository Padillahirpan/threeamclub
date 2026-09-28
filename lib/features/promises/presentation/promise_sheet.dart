import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_theme.dart';
import '../../../core/db/app_database.dart' show promiseTemplates;
import '../../../core/l10n/app_localizations.dart';
import '../../../core/widgets/category_visual.dart';
import '../../plan/domain/plan_draft.dart';
import '../data/drift_category_repository.dart';
import '../domain/category.dart';

const _durationPresets = <int>[5, 10, 15, 20, 30, 45, 60];
const _minDuration = 1;
const _maxDuration = 180; // PRD FR-2.1

/// Add/edit promise sheet (PRD FR-2.1–2.3, DESIGN.md §7.2).
///
/// Returns the new/updated draft, or null when cancelled.
Future<PromiseDraft?> showPromiseSheet(
  BuildContext context, {
  required List<Category> categories,
  PromiseDraft? initial,
}) {
  return showModalBottomSheet<PromiseDraft>(
    context: context,
    isScrollControlled: true,
    builder: (context) => Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: _PromiseSheet(categories: categories, initial: initial),
    ),
  );
}

class _PromiseSheet extends ConsumerStatefulWidget {
  const _PromiseSheet({required this.categories, this.initial});

  final List<Category> categories;
  final PromiseDraft? initial;

  @override
  ConsumerState<_PromiseSheet> createState() => _PromiseSheetState();
}

class _PromiseSheetState extends ConsumerState<_PromiseSheet> {
  late final TextEditingController _titleController =
      TextEditingController(text: widget.initial?.title ?? '');
  late final TextEditingController _descriptionController =
      TextEditingController(text: widget.initial?.description ?? '');
  late String _categoryId =
      widget.initial?.categoryId ?? widget.categories.firstOrNull?.id ?? '';
  late int _duration = widget.initial?.durationMin ?? 15;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _save(AppLocalizations s) {
    final title = _titleController.text.trim();
    if (title.isEmpty || _duration < _minDuration || _categoryId.isEmpty) {
      return;
    }
    final description = _descriptionController.text.trim();
    Navigator.of(context).pop(
      (widget.initial ?? _newDraft()).copyWith(
        categoryId: _categoryId,
        title: title,
        description: description.isEmpty ? null : description,
        durationMin: _duration,
      ),
    );
  }

  PromiseDraft _newDraft() => PromiseDraft(
        id: 'promise-${DateTime.now().microsecondsSinceEpoch}',
        categoryId: _categoryId,
        title: '',
      );

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;
    final colors = Theme.of(context).extension<AppColors>()!;
    // Watch live so a freshly created custom category appears immediately.
    final categories = ref.watch(categoriesProvider).value ?? widget.categories;

    final templates = promiseTemplates[_categoryId] ?? const [];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(s.categoryLabel,
              style: AppTextStyles.h2
                  .copyWith(color: AppPalette.sky100)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final category in categories)
                _CategoryChip(
                  category: category,
                  selected: category.id == _categoryId,
                  onTap: () => setState(() => _categoryId = category.id),
                  onLongPress: !category.isBuiltIn
                      ? () => _showCustomCategoryActions(context, category)
                      : null,
                ),
              ActionChip(
                avatar: Icon(Icons.add, size: 18, color: colors.dawn300),
                label: Text(s.newCategory),
                onPressed: () => _createCategory(context),
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _titleController,
            autofocus: widget.initial == null,
            decoration: InputDecoration(
              labelText: s.promiseTitleLabel,
              hintText: s.promiseTitleHint,
            ),
          ),
          if (templates.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final template in templates)
                  ActionChip(
                    label: Text(
                      '${template.title} · ${s.durationMinutes(template.durationMin)}',
                      style: const TextStyle(fontSize: 13),
                    ),
                    onPressed: () {
                      _titleController.text = template.title;
                      setState(() => _duration = template.durationMin);
                    },
                  ),
              ],
            ),
          ],
          const SizedBox(height: 12),
          TextField(
            controller: _descriptionController,
            decoration:
                InputDecoration(labelText: s.promiseDescriptionLabel),
            minLines: 1,
            maxLines: 3,
          ),
          const SizedBox(height: 20),
          Text(s.promiseDurationLabel,
              style: AppTextStyles.h2
                  .copyWith(color: AppPalette.sky100)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final preset in _durationPresets)
                ChoiceChip(
                  label: Text(s.durationMinutes(preset)),
                  selected: _duration == preset,
                  onSelected: (_) => setState(() => _duration = preset),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                s.customDuration,
                style: TextStyle(color: colors.mist200, fontSize: 13),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: _duration > _minDuration
                    ? () => setState(() => _duration--)
                    : null,
                icon: const Icon(Icons.remove_circle_outline),
              ),
              Text(
                s.durationMinutes(_duration),
                style: AppTextStyles.h2.copyWith(
                  color: AppPalette.sky100,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              IconButton(
                onPressed: _duration < _maxDuration
                    ? () => setState(() => _duration++)
                    : null,
                icon: const Icon(Icons.add_circle_outline),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => _save(s),
              child: Text(s.save),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _createCategory(BuildContext context) async {
    final created = await showCategoryDialog(context);
    if (created != null) {
      final category = await ref
          .read(categoryRepositoryProvider)
          .createCustom(
            name: created.$1,
            iconKey: created.$2,
            colorKey: created.$3,
          );
      setState(() => _categoryId = category.id);
    }
  }

  Future<void> _showCustomCategoryActions(
    BuildContext context,
    Category category,
  ) async {
    final s = AppLocalizations.of(context)!;
    final action = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: Text(s.editCategoryTitle),
              onTap: () => Navigator.pop(context, 'edit'),
            ),
            ListTile(
              leading: const Icon(Icons.archive_outlined),
              title: Text(s.archive),
              onTap: () => Navigator.pop(context, 'archive'),
            ),
          ],
        ),
      ),
    );
    if (!mounted || !context.mounted || action == null) return;

    switch (action) {
      case 'edit':
        final edited = await showCategoryDialog(
          context,
          initialName: category.name,
          initialIconKey: category.iconKey,
          initialColorKey: category.colorKey,
        );
        if (edited != null) {
          await ref.read(categoryRepositoryProvider).updateCustom(
                id: category.id,
                name: edited.$1,
                iconKey: edited.$2,
                colorKey: edited.$3,
              );
        }
      case 'archive':
        if (!context.mounted) return;
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(s.archiveCategoryTitle),
            content: Text(s.archiveCategoryBody),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(s.cancel),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(s.archive),
              ),
            ],
          ),
        );
        if (confirmed ?? false) {
          await ref.read(categoryRepositoryProvider).archive(category.id);
          if (_categoryId == category.id) {
            setState(() => _categoryId = '');
          }
        }
    }
  }
}

/// Custom category editor: returns (name, iconKey, colorKey).
Future<(String, String, String)?> showCategoryDialog(
  BuildContext context, {
  String? initialName,
  String? initialIconKey,
  String? initialColorKey,
}) {
  return showDialog<(String, String, String)>(
    context: context,
    builder: (context) => _CategoryDialog(
      initialName: initialName,
      initialIconKey: initialIconKey,
      initialColorKey: initialColorKey,
    ),
  );
}

class _CategoryDialog extends StatefulWidget {
  const _CategoryDialog({
    this.initialName,
    this.initialIconKey,
    this.initialColorKey,
  });

  final String? initialName;
  final String? initialIconKey;
  final String? initialColorKey;

  @override
  State<_CategoryDialog> createState() => _CategoryDialogState();
}

class _CategoryDialogState extends State<_CategoryDialog> {
  late final TextEditingController _nameController =
      TextEditingController(text: widget.initialName ?? '');
  late String _iconKey = widget.initialIconKey ?? selectableIconKeys.first;
  late String _colorKey = widget.initialColorKey ?? categoryColorKeys.keys.first;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;
    final colors = Theme.of(context).extension<AppColors>()!;
    return AlertDialog(
      title: Text(widget.initialName == null
          ? s.newCategory
          : s.editCategoryTitle),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nameController,
                autofocus: true,
                decoration:
                    InputDecoration(labelText: s.newCategoryName),
              ),
              const SizedBox(height: 16),
              Text(s.chooseIcon,
                  style: TextStyle(color: colors.mist200, fontSize: 13)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final key in selectableIconKeys)
                    IconButton(
                      isSelected: _iconKey == key,
                      onPressed: () => setState(() => _iconKey = key),
                      icon: Icon(iconForKey(key)),
                      color: colors.mist200,
                      selectedIcon: Icon(iconForKey(key)),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Text(s.chooseColor,
                  style: TextStyle(color: colors.mist200, fontSize: 13)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final entry in categoryColorKeys.entries)
                    GestureDetector(
                      onTap: () => setState(() => _colorKey = entry.key),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: entry.value,
                          shape: BoxShape.circle,
                          border: _colorKey == entry.key
                              ? Border.all(
                                  color: colors.sky100, width: 3)
                              : null,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(s.cancel),
        ),
        FilledButton(
          onPressed: () {
            final name = _nameController.text.trim();
            if (name.isEmpty) return;
            Navigator.pop(context, (name, _iconKey, _colorKey));
          },
          child: Text(widget.initialName == null
              ? s.createCategory
              : s.saveChanges),
        ),
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.category,
    required this.selected,
    required this.onTap,
    this.onLongPress,
  });

  final Category category;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final color = colorForKey(category.colorKey);
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? color : colors.night900,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? color : colors.mist200.withValues(alpha: 0.25),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              iconForKey(category.iconKey),
              size: 18,
              color: selected ? colors.ink900 : color,
            ),
            const SizedBox(width: 8),
            Text(
              category.name,
              style: TextStyle(
                color: selected ? colors.ink900 : colors.sky100,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
