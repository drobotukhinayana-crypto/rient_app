import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;
    return GestureDetector(
      onTap: onChanged != null ? () => onChanged!(value) : null,
      behavior: HitTestBehavior.opaque,
      child: Image.asset(
        isSelected ? AppImages.radiobuttonActive : AppImages.radiobutton,
      ),
    );
  }
}
