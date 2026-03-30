import 'package:flutter/material.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/resources/resources.dart';

class AppRadio<T> extends StatelessWidget {
  const AppRadio({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  final T value;
  final T? groupValue;
  final void Function(T?)? onChanged;

  /// Как в `assets/images/radiobutton.png` (1x).
  static const double _assetSize = 20;

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget child;
    if (isDark && !isSelected) {
      // Заливка + обводка secondary-dark (тёмная палитра, не светлый #EDEEF2).
      child = SizedBox(
        width: _assetSize,
        height: _assetSize,
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primaryWhiteDark,
            border: Border.all(color: AppColors.secondaryDarkDark, width: 1.5),
          ),
        ),
      );
    } else {
      child = Image.asset(
        isSelected ? AppImages.radiobuttonActive : AppImages.radiobutton,
      );
    }

    return GestureDetector(
      onTap: onChanged != null ? () => onChanged!(value) : null,
      behavior: HitTestBehavior.opaque,
      child: child,
    );
  }
}
