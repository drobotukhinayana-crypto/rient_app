import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/core/widgets/date_strip.dart';
import 'package:rient_app/core/widgets/default_container.dart';
import 'package:rient_app/features/home/view/components/entity_selector_pill.dart';
import 'package:rient_app/resources/resources.dart';

class TopPanel extends StatelessWidget {
  const TopPanel({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return DefaultContainerWidget(
      borderRadius: BorderRadius.circular(24),
      hasShadow: false,
      padding: const EdgeInsets.only(top: 52, bottom: 16, left: 16, right: 16),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              // меню
              GestureDetector(
                onTap: () {},
                child: Image.asset(AppImages.burger),
              ),
              Gap(12),

              // заголовок
              Text(title, style: AppFonts.h3Medium),
              const Spacer(),

              // выбор пользователя
              const ProfileSelectorPill(),
            ],
          ),
          Gap(10),

          // календарь
          const DateStrip(),
        ],
      ),
    );
  }
}
