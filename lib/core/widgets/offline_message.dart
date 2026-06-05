import 'package:flutter/material.dart';
import 'package:rient_app/core/network/app_offline.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';

/// Текст «нет интернета» вместо бесконечного лоадера.
class OfflineMessage extends StatelessWidget {
  const OfflineMessage({
    super.key,
    this.padding = const EdgeInsets.all(24),
    this.message = appNoConnectionMessage,
  });

  final EdgeInsetsGeometry padding;
  final String message;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: padding,
      child: Text(
        message,
        style: AppFonts.b2Medium.copyWith(
          color: isDark ? AppColors.grey : AppColors.grey,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
