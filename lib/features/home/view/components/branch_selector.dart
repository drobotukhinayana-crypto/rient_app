import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:rient_app/core/services/local_storage.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/features/home/data/models/branches_api/branches_api.dart';
import 'package:rient_app/features/home/view/providers/branches_provider.dart';
import 'package:rient_app/resources/resources.dart';

class BranchSelector extends ConsumerWidget {
  const BranchSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final branchesAsync = ref.watch(branchesProvider);
    final selectedBranch = ref.watch(selectedBranchProvider);

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

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              currentBranch.name ?? 'Без названия',
              style: AppFonts.b2Semi,
            ),
            Gap(4),
            PopupMenuButton<BranchApi>(
              onSelected: (BranchApi branch) async {
                ref.read(selectedBranchProvider.notifier).state = branch;
                final storage = ref.read(localStorageProvider);
                final storageKey = ref.read(selectedBranchStorageKeyProvider);
                await storage.saveString(
                  storageKey,
                  branch.id.toString(),
                );
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
        );
      },
      loading: () => const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
      error: (error, stack) => const SizedBox.shrink(),
    );
  }
}