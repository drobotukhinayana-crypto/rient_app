import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/core/widgets/app_radio.dart';
import 'package:rient_app/core/widgets/default_container.dart';
import 'package:rient_app/features/auth/data/models/organization.dart';
import 'package:rient_app/features/auth/data/models/organization_member/organization_member.dart';
import 'package:rient_app/features/auth/data/models/user_role/user_role.dart';

class AuthCompanyListView extends StatefulWidget {
  const AuthCompanyListView({
    super.key,
    required this.organizationMembers,
    this.onSelectedMemberChanged,
  });

  final OrganizationMembers organizationMembers;

  /// Вызывается при выборе компании (в т.ч. при первой загрузке).
  final void Function(OrganizationMember member)? onSelectedMemberChanged;

  @override
  State<AuthCompanyListView> createState() => _AuthCompanyListViewState();
}

class _AuthCompanyListViewState extends State<AuthCompanyListView> {
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    if (widget.organizationMembers.isNotEmpty) {
      _selectedIndex = 0;
      // Откладываем обновление провайдеров до конца построения дерева виджетов
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onSelectedMemberChanged?.call(widget.organizationMembers.first);
      });
    }
  }

  void _onSelectionChanged(int? index) {
    setState(() => _selectedIndex = index);
    if (index != null &&
        index >= 0 &&
        index < widget.organizationMembers.length) {
      widget.onSelectedMemberChanged?.call(widget.organizationMembers[index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) => _AuthCompanyItem(
        role: widget.organizationMembers[index].role,
        index: index,
        selectedIndex: _selectedIndex,
        onChanged: _onSelectionChanged,
        organization: widget.organizationMembers[index].organization,
      ),
      separatorBuilder: (BuildContext context, int index) => Gap(16),
      itemCount: widget.organizationMembers.length,
    );
  }
}

class _AuthCompanyItem extends StatelessWidget {
  const _AuthCompanyItem({
    required this.index,
    required this.selectedIndex,
    required this.onChanged,
    required this.organization,
    required this.role,
  });

  final int index;
  final int? selectedIndex;
  final void Function(int?) onChanged;
  final Organization organization;
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
            CircleAvatar(
              backgroundColor: AppColors.secondaryLight,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(300),
                child: Image.network(organization.logo ?? ''),
              ),
            ),
            Gap(6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(organization.name ?? '', style: AppFonts.b2Medium),
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
