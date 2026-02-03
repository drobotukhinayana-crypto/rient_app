import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/core/widgets/main_button.dart';
import 'package:rient_app/resources/resources.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({
    super.key,
    required this.title,
    required this.description,
    required this.onTap,
    required this.titleButton,
  });

  final String title;
  final String titleButton;
  final Widget description;
  final VoidCallback onTap;

  static void show(
    BuildContext context, {
    required String title,
    required Widget description,
    required String titleButton,
    required VoidCallback onTap,
  }) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (context) => CustomDialog(
        title: title,
        description: description,
        onTap: onTap,
        titleButton: titleButton,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: EdgeInsetsGeometry.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: AppFonts.h4Medium,
                    textAlign: TextAlign.center,
                  ),
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Image.asset(AppImages.closeRounded),
                  ),
                ],
              ),
              const Gap(16),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Мы отправили код на вашу почту\n',
                      style: AppFonts.c1Medium,
                    ),
                    TextSpan(
                      text: 'example@gmail.com,',
                      style: AppFonts.c1Bold,
                    ),
                    TextSpan(
                      text:
                          ' проверьте входящие письма и спам, если код не пришел, нажмите кнопку ',
                      style: AppFonts.c1Medium,
                    ),
                    TextSpan(
                      text: '“Отправить новый код”',
                      style: AppFonts.c1Bold,
                    ),
                    TextSpan(
                      text: ' когда таймер закончится',
                      style: AppFonts.c1Medium,
                    ),
                  ],
                ),
              ),
              const Gap(16),
              MainButton(title: titleButton, onTap: onTap),
            ],
          ),
        ),
      ),
    );
  }
}
