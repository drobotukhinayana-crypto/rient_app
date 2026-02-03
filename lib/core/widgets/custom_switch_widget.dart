import 'package:flutter/material.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';

class CustomSwitchWidget extends StatelessWidget {
  const CustomSwitchWidget({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 62,
      height: 30,
      child: Switch(
        value: value,
        onChanged: onChanged,
        activeTrackColor: AppColors.secondaryLight,
        inactiveThumbColor: Colors.white,
        inactiveTrackColor: AppColors.grey,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}
