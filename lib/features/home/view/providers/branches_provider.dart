import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:rient_app/core/services/token_storage.dart';
import 'package:rient_app/features/home/data/models/branches_api/branches_api.dart';
import 'package:rient_app/features/home/service/branches_service.dart';

/// Ключ для сохранения id выбранного филиала в локальное хранилище.
const selectedBranchIdStorageKey = 'selected_branch_id';

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
      if (selectedBranch != null && selectedBranch.id != null) {
        return selectedBranch.id!;
      }

      // Иначе возвращаем ID первого филиала
      if (branchesResponse.results.isNotEmpty && branchesResponse.results.first.id != null) {
        return branchesResponse.results.first.id!;
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