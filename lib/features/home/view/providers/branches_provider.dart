import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:rient_app/core/services/email_storage.dart';
import 'package:rient_app/core/services/token_storage.dart';
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

// Provider для загрузки списка филиалов
final branchesProvider = FutureProvider<BranchesApiResponse>((ref) async {
  // Ждем, пока токен будет загружен
  final token = ref.watch(tokenProvider);
  if (token == null || token.isEmpty) {
    throw Exception('Token not available');
  }

  final service = ref.watch(branchesServiceProvider);
  return service.getBranches();
});

// Provider для выбранного филиала (StateProvider для возможности изменения)
final selectedBranchProvider = StateProvider<BranchApi?>((ref) => null);

// Computed provider для получения текущего branchId
// Возвращает id выбранного филиала или первого из списка
final currentBranchIdProvider = Provider<int>((ref) {
  final branchesAsync = ref.watch(branchesProvider);
  final selectedBranch = ref.watch(selectedBranchProvider);

  return branchesAsync.maybeWhen(
    data: (branchesResponse) {
      // Если есть выбранный филиал, возвращаем его ID
      if (selectedBranch != null) {
        return selectedBranch.id;
      }

      // Иначе возвращаем ID первого филиала
      if (branchesResponse.results.isNotEmpty) {
        return branchesResponse.results.first.id;
      }
      return 0; // fallback
    },
    orElse: () => 0, // fallback во время загрузки или ошибки
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