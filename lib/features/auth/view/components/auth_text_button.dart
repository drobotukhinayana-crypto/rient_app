import 'package:flutter/widgets.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';

class AuthTextButton extends StatelessWidget {
  const AuthTextButton({super.key, required this.title, required this.onTap});

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        title,
        style: AppFonts.b2Medium.copyWith(
          color: AppColors.mainAccent,
          decoration: TextDecoration.underline,
          decorationColor: AppColors.mainAccent,
        ),
      ),
    );
  }
}
