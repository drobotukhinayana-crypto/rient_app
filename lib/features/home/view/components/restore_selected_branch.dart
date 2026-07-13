import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/core/services/local_storage.dart';
import 'package:rient_app/features/chat/service/push_registration_service.dart';
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
  Object? _restoreScopeKey;

  @override
  void initState() {
    super.initState();
    // Холодный старт оффлайн: филиал нужен до ответа branches API.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _restored) return;
      unawaited(_restoreFromStorageEvenIfOffline());
    });
  }

  Future<void> _restoreFromStorageEvenIfOffline() async {
    final branch = await ensureSelectedBranchRestored(ref);
    if (branch != null && mounted) {
      _restored = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final restoreScopeKey = ref.watch(selectedBranchStorageKeyProvider);
    if (_restoreScopeKey != restoreScopeKey) {
      _restoreScopeKey = restoreScopeKey;
      _restored = false;
    }

    ref.listen(branchesProvider, (prev, next) {
      next.whenData((branches) {
        if (_restored &&
            ref.read(selectedBranchProvider) != null &&
            branches.results.isNotEmpty) {
          // Уже восстановили stub — заменим на полный объект из API при появлении сети.
          unawaited(_upgradeStubFromApiList(branches));
          return;
        }
        if (_restored) return;
        _restored = true;
        _doRestore(branches);
      });
    });
    return widget.child;
  }

  Future<void> _upgradeStubFromApiList(BranchesApiResponse branches) async {
    final current = ref.read(selectedBranchProvider);
    if (current == null) return;
    for (final b in branches.results) {
      if (b.id == current.id && b.name != current.name) {
        if (!mounted) return;
        ref.read(selectedBranchProvider.notifier).state = b;
        return;
      }
    }
  }

  Future<void> _doRestore(BranchesApiResponse branches) async {
    final storage = ref.read(localStorageProvider);
    final storageKey = ref.read(selectedBranchStorageKeyProvider);
    final idStr = await storage.getString(storageKey);
    final id = int.tryParse(idStr ?? '');
    if (id == null) {
      // Fallback: кэш записей / stub
      await ensureSelectedBranchRestored(ref);
      return;
    }
    BranchApi? branch;
    for (final b in branches.results) {
      if (b.id == id) {
        branch = b;
        break;
      }
    }
    branch ??= offlineStubBranch(id: id, name: 'Филиал');
    if (mounted) {
      ref.read(selectedBranchProvider.notifier).state = branch;
      if (branches.results.isNotEmpty) {
        unawaited(
          ref.read(pushRegistrationServiceProvider).registerForActiveSession(),
        );
      }
    }
  }
}
