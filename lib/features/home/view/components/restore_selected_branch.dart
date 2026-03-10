import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/core/services/local_storage.dart';
import 'package:rient_app/features/home/data/models/branches_api/branches_api.dart';
import 'package:rient_app/features/home/view/providers/branches_provider.dart';

/// Восстанавливает выбранный филиал из локального хранилища после загрузки списка филиалов.
/// Оборачивает дочерний виджет и при первом появлении данных о филиалах подставляет
/// сохранённый выбор в [selectedBranchProvider].
class RestoreSelectedBranch extends ConsumerStatefulWidget {
  const RestoreSelectedBranch({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<RestoreSelectedBranch> createState() =>
      _RestoreSelectedBranchState();
}

class _RestoreSelectedBranchState extends ConsumerState<RestoreSelectedBranch> {
  bool _restored = false;

  @override
  Widget build(BuildContext context) {
    ref.listen(branchesProvider, (prev, next) {
      next.whenData((branches) {
        if (_restored) return;
        if (ref.read(selectedBranchProvider) != null) return;
        _restored = true;
        _doRestore(branches);
      });
    });
    return widget.child;
  }

  Future<void> _doRestore(BranchesApiResponse branches) async {
    final storage = ref.read(localStorageProvider);
    final idStr = await storage.getString(selectedBranchIdStorageKey);
    final id = int.tryParse(idStr ?? '');
    if (id == null) return;
    BranchApi? branch;
    for (final b in branches.results) {
      if (b.id == id) {
        branch = b;
        break;
      }
    }
    if (branch != null && mounted) {
      ref.read(selectedBranchProvider.notifier).state = branch;
    }
  }
}
