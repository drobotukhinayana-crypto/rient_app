import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/core/widgets/app_radio.dart';
import 'package:rient_app/core/widgets/default_container.dart';
import 'package:rient_app/features/auth/data/models/organization.dart';

class AuthCompanyListView extends StatefulWidget {
  const AuthCompanyListView({super.key, required this.organizations});

  final Organizations organizations;

  @override
  State<AuthCompanyListView> createState() => _AuthCompanyListViewState();
}

class _AuthCompanyListViewState extends State<AuthCompanyListView> {
  int? _selectedIndex;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) => _AuthCompanyItem(
        index: index,
        selectedIndex: _selectedIndex,
        onChanged: (value) => setState(() => _selectedIndex = value),
        organization: widget.organizations[index],
      ),
      separatorBuilder: (BuildContext context, int index) => Gap(16),
      itemCount: widget.organizations.length,
    );
  }
}

class _AuthCompanyItem extends StatelessWidget {
  const _AuthCompanyItem({
    required this.index,
    required this.selectedIndex,
    required this.onChanged,
    required this.organization,
  });

  final int index;
  final int? selectedIndex;
  final void Function(int?) onChanged;
  final Organization organization;

  @override
  Widget build(BuildContext context) {
    return DefaultContainerWidget(
      color: AppColors.secondaryDark,
      child: InkWell(
        onTap: () => onChanged(index),
        borderRadius: BorderRadius.circular(300),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.secondaryAccent,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(300),
                child: Image.network(organization.logo ?? ''),
              ),
            ),
            Gap(6),
            Expanded(
              child: Text(organization.name ?? '', style: AppFonts.b2Medium),
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
