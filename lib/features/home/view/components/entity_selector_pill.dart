import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/features/home/data/models/branches_api/branches_api.dart';
import 'package:rient_app/features/home/view/providers/branches_provider.dart';
import 'package:rient_app/resources/resources.dart';

class ProfileSelectorPill extends StatefulWidget {
  const ProfileSelectorPill({super.key});

  @override
  State<ProfileSelectorPill> createState() => _ProfileSelectorPillState();
}

class _ProfileSelectorPillState extends State<ProfileSelectorPill> {
  @override

  void _showMenu(BuildContext context, WidgetRef ref, List<BranchApi> branches, BranchApi? selectedBranch) {
    final box = context.findRenderObject() as RenderBox?;
    final overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox?;
    if (box == null || overlay == null) return;

    final position = box.localToGlobal(Offset.zero, ancestor: overlay);
    final size = box.size;

    showMenu<BranchApi>(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy + size.height + 4,
        position.dx + size.width,
        position.dy + size.height + 200,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      items: branches.map((branch) {
        final isSelected = branch.id == selectedBranch?.id;
        return PopupMenuItem<BranchApi>(
          value: branch,
          child: Row(
            children: [
              if (isSelected)
                Icon(Icons.check, size: 18, color: AppColors.mainAccent),
              if (isSelected) const SizedBox(width: 8),
              Text(branch.name ?? 'Без названия'),
            ],
          ),
        );
      }).toList(),
    ).then((value) {
      if (value != null) {
        ref.read(selectedBranchProvider.notifier).state = value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
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

        return Builder(
          builder: (ctx) {
            return Material(
              color: AppColors.secondaryLight,
              borderRadius: BorderRadius.circular(300),
              child: InkWell(
                onTap: () => _showMenu(ctx, ref, branchesResponse.results, selectedBranch),
                borderRadius: BorderRadius.circular(300),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // текст
                      Text(
                        currentBranch.name ?? 'Без названия',
                        style: AppFonts.b2Medium.copyWith(
                          color: AppColors.primaryDark,
                        ),
                      ),
                      Gap(6),

                      // стрелка
                      Image.asset(
                        AppImages.arrowOutlinedDown,
                        color: AppColors.mainAccent,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
      loading: () => const SizedBox(
        width: 80,
        height: 40,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      error: (error, stack) => const SizedBox.shrink(),
    );
      },
    );
  }
}
