import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_decoration.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';

class MainButton extends ConsumerWidget {
  const MainButton({
    required this.title,
    required this.onTap,
    this.isLoading = false,
    this.unfocusOnTap = true,
    this.isActive = true,
    super.key,
    this.height = 48,
    this.width = double.infinity,

    this.color = AppColors.mainAccent,

    this.textColor = Colors.white,
  });

  final String title;
  final VoidCallback onTap;
  final bool isLoading;
  final bool unfocusOnTap;
  final bool isActive;
  final double height;
  final double width;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: isActive
            ? () {
                if (unfocusOnTap) FocusScope.of(context).unfocus();
                onTap();
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isActive
              ? (isDark ? AppColors.themeAccent(context) : color)
              : AppColors.grey,
          disabledBackgroundColor: AppColors.grey,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: AppDecoration.borderRadius300,
          ),
        ),
        child: isLoading
            ? const Center(
                child: SizedBox.square(
                  dimension: 12,
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: AppFonts.b2Semi.copyWith(
                      color: isActive
                          ? textColor
                          : const Color(0xff1F2132).withValues(alpha: .5),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
