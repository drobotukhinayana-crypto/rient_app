import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/core/widgets/default_container.dart';
import 'package:rient_app/core/widgets/specialist_select_dialog.dart';

class SpecialistListView extends StatelessWidget {
  const SpecialistListView({super.key, required this.specialists});

  final List<SpecialistItem> specialists;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 135,
      child: ListView.separated(
        padding: const EdgeInsets.only(left: 28, right: 16, top: 6, bottom: 16),
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          final item = specialists[index];
          return SizedBox(
            width: 114,
            child: DefaultContainerWidget(
              borderRadius: BorderRadius.circular(20),
              padding: const EdgeInsets.all(12),
              color: Colors.white,
              hasShadow: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.secondaryLight,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Gap(12),
                  Text(
                    item.name,
                    style: AppFonts.c1Medium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Gap(2),
                  Text(
                    item.role,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppFonts.c2Tabbar.copyWith(color: AppColors.grey),
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) => Gap(4),
        itemCount: specialists.length,
      ),
    );
  }
}
