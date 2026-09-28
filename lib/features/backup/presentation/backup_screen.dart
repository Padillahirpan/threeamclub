import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../app/theme/app_theme.dart';
import '../../../core/l10n/app_localizations.dart';
import '../data/backup_repository.dart';

/// Backup & restore (PRD FR-10.1, ARCHITECTURE.md §14): export a
/// versioned JSON via the system share sheet; restore with validate →
/// preview counts → replace.
class BackupScreen extends ConsumerStatefulWidget {
  const BackupScreen({super.key});

  @override
  ConsumerState<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends ConsumerState<BackupScreen> {
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(s.backupTitle)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            s.backupBody,
            style: const TextStyle(
                color: AppPalette.mist200, fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _busy ? null : _export,
            icon: const Icon(Icons.ios_share),
            label: Text(s.backupExport),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _busy ? null : _restore,
            icon: const Icon(Icons.restore),
            label: Text(s.backupImport),
          ),
          if (_busy)
            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  Future<void> _export() async {
    final s = AppLocalizations.of(context)!;
    final repo = ref.read(backupRepositoryProvider);
    setState(() => _busy = true);
    try {
      final json = await repo.exportAll();
      final dir = await getTemporaryDirectory();
      final file =
          File('${dir.path}${Platform.pathSeparator}subuhan-backup.json');
      await file.writeAsString(jsonEncode(json), flush: true);
      await SharePlus.instance.share(
        ShareParams(files: [XFile(file.path)]),
      );
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(s.backupExportDone)));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _restore() async {
    final s = AppLocalizations.of(context)!;
    final repo = ref.read(backupRepositoryProvider);

    final picked = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    final path = picked.isEmpty ? null : picked.first.path;
    if (path == null) return;

    setState(() => _busy = true);
    try {
      final decoded = jsonDecode(await File(path).readAsString());
      if (decoded is! Map<String, dynamic>) {
        throw const InvalidBackupException();
      }
      final preview = repo.readPreview(decoded);
      if (!mounted) return;

      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(s.backupPreviewTitle),
          content: Text(
            '${s.backupPreviewCounts(
              preview.mornings,
              preview.promises,
              preview.plans,
            )}\n\n${s.backupReplaceNote}',
          ),
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
        await repo.importAll(decoded);
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(s.backupRestoreDone)));
        }
      }
    } on InvalidBackupException {
      _invalidFile(s);
    } on FormatException {
      _invalidFile(s);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _invalidFile(AppLocalizations s) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(s.backupInvalidFile)));
  }
}
