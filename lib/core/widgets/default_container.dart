import 'package:flutter/material.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_decoration.dart';

class DefaultContainerWidget extends StatelessWidget {
  const DefaultContainerWidget({
    super.key,
    required this.widget,
    this.padding,
    this.color,
    this.borderRadius,
    this.hasBorder = false,
    this.borderColor,
    this.hasShadow = true,
  });

  final Widget widget;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final BorderRadiusGeometry? borderRadius;
  final bool hasBorder;
  final Color? borderColor;
  final bool hasShadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: hasBorder
            ? Border.all(color: borderColor ?? AppColors.grey)
            : null,
        color: color ?? AppColors.secondaryLight,
        boxShadow: hasShadow
            ? [
                BoxShadow(
                  color: const Color(0xff8E8E8E).withOpacity(0.15),
                  blurRadius: 15,
                ),
              ]
            : null,
        borderRadius: borderRadius ?? AppDecoration.borderRadius300,
      ),
      child: widget,
    );
  }
}
