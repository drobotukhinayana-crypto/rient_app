import 'package:flutter/material.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/core/network/app_offline.dart';

class ScheduleOfflineBanner extends StatelessWidget {
  const ScheduleOfflineBanner({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: isDark ? const Color(0xFF3D3520) : const Color(0xFFFFF4E5),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Text(
          message ?? scheduleOfflineBannerMessage,
          style: AppFonts.c1Medium.copyWith(
            color: isDark ? AppColors.lightYel : const Color(0xFF8A5A00),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
