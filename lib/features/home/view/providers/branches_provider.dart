import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:rient_app/features/auth/view/providers/role_provider.dart';
import 'package:rient_app/features/home/data/models/branches_api/branches_api.dart';
import 'package:rient_app/features/home/service/branches_service.dart';
import 'package:rient_app/features/auth/data/models/user_role/user_role.dart';

// Provider для загрузки списка филиалов
final branchesProvider = FutureProvider<BranchesApiResponse>((ref) async {
  final service = ref.watch(branchesServiceProvider);
  return service.getBranches();
});

// Provider для выбранного филиала (StateProvider для возможности изменения)
final selectedBranchProvider = StateProvider<BranchApi?>((ref) => null);

// Computed provider для получения текущего branchId
// Если пользователь владелец - возвращает 0
// Иначе возвращает id первого филиала из списка
final currentBranchIdProvider = Provider<int>((ref) {
  final role = ref.watch(roleProvider);
  final branchesAsync = ref.watch(branchesProvider);

  // Если пользователь владелец - branchId = 0
  if (role == UserRole.owner.value) {
    return 0;
  }

  // Иначе берем первый филиал из списка
  return branchesAsync.maybeWhen(
    data: (branchesResponse) {
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