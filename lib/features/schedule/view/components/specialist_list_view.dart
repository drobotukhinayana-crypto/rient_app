import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/core/widgets/default_container.dart';
import 'package:rient_app/features/schedule/view/components/specialist_select_dialog.dart';

class SpecialistListView extends StatelessWidget {
  const SpecialistListView({
    super.key,
    required this.specialists,
    this.scrollController,
    this.itemWidth = 114,
  });

  final List<SpecialistItem> specialists;
  final ScrollController? scrollController;
  final double itemWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 135,
      child: ListView.separated(
        controller: scrollController,
        padding: const EdgeInsets.only(left: 28, top: 6, bottom: 16),
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          final item = specialists[index];
          return SizedBox(
            width: itemWidth,
            child: DefaultContainerWidget(
              borderRadius: BorderRadius.circular(20),
              padding: const EdgeInsets.all(12),
              color: Colors.white,
              hasShadow: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SpecialistAvatar(pictureUrl: item.pictureUrl),
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

class _SpecialistAvatar extends StatelessWidget {
  const _SpecialistAvatar({this.pictureUrl});

  final String? pictureUrl;

  @override
  Widget build(BuildContext context) {
    if (pictureUrl != null && pictureUrl!.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          pictureUrl!,
          width: 40,
          height: 40,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _placeholder(),
        ),
      );
    }
    return _placeholder();
  }

  Widget _placeholder() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.secondaryLight,
        shape: BoxShape.circle,
      ),
    );
  }
}
