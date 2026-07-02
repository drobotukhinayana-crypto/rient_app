import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:rient_app/core/services/email_storage.dart';
import 'package:rient_app/core/services/token_storage.dart';
import 'package:rient_app/core/network/app_connectivity_provider.dart'
    show appNoConnectionProvider, scheduleServerReachableProvider;
import 'package:rient_app/features/auth/view/providers/organization_id_provider.dart';
import 'package:rient_app/features/auth/view/providers/role_provider.dart';
import 'package:rient_app/features/home/data/models/branches_api/branches_api.dart';
import 'package:rient_app/features/home/service/branches_service.dart';

/// Ключ для сохранения id выбранного филиала в локальное хранилище.
const selectedBranchIdStorageKey = 'selected_branch_id';

String buildSelectedBranchStorageKey({
  required String? email,
  required int organizationId,
  required int roleId,
}) {
  final safeEmail = (email ?? '').trim().toLowerCase();
  if (safeEmail.isEmpty || organizationId <= 0 || roleId < 0) {
    return selectedBranchIdStorageKey;
  }
  return '${selectedBranchIdStorageKey}_${safeEmail}_${organizationId}_$roleId';
}

final selectedBranchStorageKeyProvider = Provider<String>((ref) {
  final email = ref.watch(emailStorageProvider);
  final organizationId = ref.watch(organizationIdProvider);
  final roleId = ref.watch(roleProvider);
  return buildSelectedBranchStorageKey(
    email: email,
    organizationId: organizationId,
    roleId: roleId,
  );
});

/// Стабильный ключ сессии — один rebuild списка филиалов на вход,
/// без «multiple times in the same frame» у FutureProvider.
final branchesRequestKeyProvider = Provider<(int, String)?>((ref) {
  final token = ref.watch(tokenProvider);
  final organizationId = ref.watch(organizationIdProvider);
  if (token == null || token.isEmpty || organizationId <= 0) {
    return null;
  }
  return (organizationId, token);
});

// Provider для загрузки списка филиалов
final branchesProvider = FutureProvider<BranchesApiResponse>((ref) async {
  final sessionKey = ref.watch(branchesRequestKeyProvider);
  if (sessionKey == null) {
    throw Exception('Session not ready');
  }

  final selectedBranch = ref.read(selectedBranchProvider);
  final isOffline = ref.watch(appNoConnectionProvider) ||
      !ref.watch(scheduleServerReachableProvider);
  if (isOffline) {
    if (selectedBranch != null) {
      return BranchesApiResponse(
        count: 1,
        next: null,
        previous: null,
        results: [selectedBranch],
      );
    }
    return const BranchesApiResponse(
      count: 0,
      next: null,
      previous: null,
      results: [],
    );
  }

  return ref.read(branchesServiceProvider).getBranches();
});

// Provider для выбранного филиала (StateProvider для возможности изменения)
final selectedBranchProvider = StateProvider<BranchApi?>((ref) => null);

// Computed provider для получения текущего branchId
// Возвращает id выбранного филиала или первого из списка
final currentBranchIdProvider = Provider<int>((ref) {
  final selectedBranch = ref.watch(selectedBranchProvider);
  if (selectedBranch != null) {
    return selectedBranch.id;
  }

  final branchesAsync = ref.watch(branchesProvider);

  return branchesAsync.maybeWhen(
    data: (branchesResponse) {
      if (branchesResponse.results.isNotEmpty) {
        return branchesResponse.results.first.id;
      }
      return 0;
    },
    orElse: () => 0,
  );
});

// Provider для получения текущего выбранного филиала
final currentBranchProvider = Provider<BranchApi?>((ref) {
  final selectedBranch = ref.watch(selectedBranchProvider);
  final branchesAsync = ref.watch(branchesProvider);

  // Если есть выбранный филиал - возвращаем его
  if (selectedBranch != null) {
    return selectedBranch;
  }

  // Иначе возвращаем первый филиал из списка
  return branchesAsync.maybeWhen(
    data: (branchesResponse) {
      if (branchesResponse.results.isNotEmpty) {
        return branchesResponse.results.first;
      }
      return null;
    },
    orElse: () => null,
  );
});