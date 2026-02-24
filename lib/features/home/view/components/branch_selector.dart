import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/core/widgets/default_container.dart';
import 'package:rient_app/features/auth/view/providers/role_provider.dart';
import 'package:rient_app/features/home/data/models/branches_api/branches_api.dart';
import 'package:rient_app/features/home/view/providers/branches_provider.dart';
import 'package:rient_app/features/auth/data/models/user_role/user_role.dart';
import 'package:rient_app/resources/resources.dart';

class BranchSelector extends ConsumerWidget {
  const BranchSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.watch(roleProvider);
    final branchesAsync = ref.watch(branchesProvider);
    final selectedBranch = ref.watch(selectedBranchProvider);

    // Если пользователь владелец - не показываем селектор филиалов
    if (role == UserRole.owner.value) {
      return const SizedBox.shrink();
    }

    return branchesAsync.when(
      data: (branchesResponse) {
        if (branchesResponse.results.isEmpty) {
          return const SizedBox.shrink();
        }

        final currentBranch = selectedBranch ??
            (branchesResponse.results.isNotEmpty ? branchesResponse.results.first : null);

        if (currentBranch == null) {
          return const SizedBox.shrink();
        }

        return DefaultContainerWidget(
          color: Colors.white,
          hasShadow: false,
          borderRadius: BorderRadius.circular(16),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Text(
                'Филиал:',
                style: AppFonts.b2Medium.copyWith(color: AppColors.mainAccent),
              ),
              Gap(8),
              Expanded(
                child: Text(
                  currentBranch.name ?? 'Без названия',
                  style: AppFonts.b2Semi,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Gap(8),
              PopupMenuButton<BranchApi>(
                onSelected: (BranchApi branch) {
                  ref.read(selectedBranchProvider.notifier).state = branch;
                },
                itemBuilder: (BuildContext context) {
                  return branchesResponse.results.map((BranchApi branch) {
                    return PopupMenuItem<BranchApi>(
                      value: branch,
                      child: Text(branch.name ?? 'Без названия'),
                    );
                  }).toList();
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(AppImages.arrowOutlinedDown, width: 16, height: 16),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox(
        height: 50,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => const SizedBox.shrink(),
    );
  }
}