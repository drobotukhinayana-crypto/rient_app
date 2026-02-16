import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/core/widgets/app_radio.dart';
import 'package:rient_app/core/widgets/default_container.dart';

class AuthBranchListView extends StatefulWidget {
  const AuthBranchListView({super.key});

  @override
  State<AuthBranchListView> createState() => _AuthBranchListViewState();
}

class _AuthBranchListViewState extends State<AuthBranchListView> {
  int? _selectedIndex;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) => _AuthBranchItem(
        index: index,
        selectedIndex: _selectedIndex,
        onChanged: (value) => setState(() => _selectedIndex = value),
      ),
      separatorBuilder: (BuildContext context, int index) => Gap(16),
      itemCount: 15,
    );
  }
}

class _AuthBranchItem extends StatelessWidget {
  const _AuthBranchItem({
    required this.index,
    required this.selectedIndex,
    required this.onChanged,
  });

  final int index;
  final int? selectedIndex;
  final void Function(int?) onChanged;

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
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondaryAccent,
              ),
            ),
            Gap(6),
            Expanded(child: Text('Название филиала', style: AppFonts.b2Medium)),
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
