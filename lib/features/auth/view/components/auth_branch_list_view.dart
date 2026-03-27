import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/core/widgets/app_radio.dart';
import 'package:rient_app/core/widgets/default_container.dart';
import 'package:rient_app/features/auth/data/models/branches/branches.dart';
import 'package:rient_app/features/auth/data/models/branches_member/branches_member.dart';
import 'package:rient_app/features/auth/data/models/user_role/user_role.dart';
import 'package:rient_app/resources/resources.dart';

class AuthBranchListView extends StatefulWidget {
  const AuthBranchListView({
    super.key,
    required this.branchesMembers,
    this.onSelectedMemberChanged,
  });

  final BranchesMembers branchesMembers;

  /// Вызывается при выборе компании (в т.ч. при первой загрузке).
  final void Function(BranchesMember member)? onSelectedMemberChanged;

  @override
  State<AuthBranchListView> createState() => _AuthBranchListViewState();
}

class _AuthBranchListViewState extends State<AuthBranchListView> {
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    if (widget.branchesMembers.isNotEmpty) {
      _selectedIndex = 0;
      // Откладываем обновление провайдеров до конца построения дерева виджетов
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onSelectedMemberChanged?.call(widget.branchesMembers.first);
      });
    }
  }

  void _onSelectionChanged(int? index) {
    setState(() => _selectedIndex = index);
    if (index != null && index >= 0 && index < widget.branchesMembers.length) {
      widget.onSelectedMemberChanged?.call(widget.branchesMembers[index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) => _AuthBranchItem(
        role: widget.branchesMembers[index].role,
        index: index,
        selectedIndex: _selectedIndex,
        onChanged: _onSelectionChanged,
        branch: widget.branchesMembers[index].branches.first,
      ),
      separatorBuilder: (BuildContext context, int index) => Gap(16),
      itemCount: widget.branchesMembers.length,
    );
  }
}

class _AuthBranchItem extends StatelessWidget {
  const _AuthBranchItem({
    required this.index,
    required this.selectedIndex,
    required this.onChanged,
    required this.branch,
    required this.role,
  });

  final int index;
  final int? selectedIndex;
  final void Function(int?) onChanged;
  final Branch branch;
  final UserRole role;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return DefaultContainerWidget(
      hasShadow: false,
      color: isDark ? AppColors.secondaryDarkLight : AppColors.secondaryDark,
      child: InkWell(
        onTap: () => onChanged(index),
        borderRadius: BorderRadius.circular(300),
        child: Row(
          children: [
            Image.asset(
              AppImages.branch,
              width: 40,
              height: 40,
              fit: BoxFit.contain,
            ),
            Gap(6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(branch.name ?? '', style: AppFonts.b2Medium),
                  Text(
                    role.title,
                    style: AppFonts.c1Medium.copyWith(
                      color: AppColors.tabbarGrey,
                    ),
                  ),
                ],
              ),
            ),
            AppRadio(
              value: index,
              groupValue: selectedIndex,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}
