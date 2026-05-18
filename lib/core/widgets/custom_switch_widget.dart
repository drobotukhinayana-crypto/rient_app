import 'package:flutter/material.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';

/// Переключатель дня в графике специалиста: зелёный трек при включении, серый при выключении.
class CustomSwitchWidget extends StatelessWidget {
  const CustomSwitchWidget({
    super.key,
    required this.value,
    required this.onChanged,
  });

  static const _activeTrackColor = Color(0xFF34C759);
  static const _inactiveTrackColor = Color(0xFFE5E7EB);

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: 62,
      height: 30,
      child: Switch(
        value: value,
        onChanged: onChanged,
        activeTrackColor: _activeTrackColor,
        activeThumbColor: Colors.white,
        inactiveThumbColor: Colors.white,
        inactiveTrackColor:
            isDark ? AppColors.secondaryDarkDark : _inactiveTrackColor,
        trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}
