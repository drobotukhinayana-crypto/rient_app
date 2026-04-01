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
    this.leadingInset = 28,
  });

  final List<SpecialistItem> specialists;
  final ScrollController? scrollController;
  final double itemWidth;
  final double leadingInset;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return LayoutBuilder(
      builder: (context, constraints) {
        final count = specialists.length;
        const separatorWidth = 4.0;
        final separatorsTotalWidth = count > 1 ? (count - 1) * separatorWidth : 0;
        final availableCardsWidth = (constraints.maxWidth - leadingInset).clamp(
          0.0,
          double.infinity,
        );
        final requestedCardsWidth = (count * itemWidth) + separatorsTotalWidth;
        final effectiveItemWidth =
            (count > 0 && requestedCardsWidth < availableCardsWidth)
            ? ((availableCardsWidth - separatorsTotalWidth) / count)
            : itemWidth;

        return SizedBox(
          height: 135,
          child: Row(
            children: [
              SizedBox(width: leadingInset),
              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  padding: const EdgeInsets.only(top: 6, bottom: 16),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    final item = specialists[index];
                    return SizedBox(
                      width: effectiveItemWidth,
                      child: DefaultContainerWidget(
                        borderRadius: BorderRadius.circular(20),
                        padding: const EdgeInsets.all(12),
                        color: isDark ? AppColors.primaryWhiteDark : Colors.white,
                        hasShadow: false,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _SpecialistAvatar(
                              pictureUrl: item.pictureUrl,
                              name: item.name,
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
                              style: AppFonts.c2Tabbar.copyWith(
                                color: AppColors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) => Gap(4),
                  itemCount: specialists.length,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SpecialistAvatar extends StatelessWidget {
  const _SpecialistAvatar({this.pictureUrl, required this.name});

  final String? pictureUrl;
  final String name;

  @override
  Widget build(BuildContext context) {
    if (pictureUrl != null && pictureUrl!.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          pictureUrl!,
          width: 40,
          height: 40,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _placeholder(context),
        ),
      );
    }
    return _placeholder(context);
  }

  Widget _placeholder(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final initials = _extractInitials(name);
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isDark ? AppColors.forthLightDark : AppColors.secondaryLight,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: AppFonts.c1Medium.copyWith(
          color: AppColors.themeAccent(context),
        ),
      ),
    );
  }

  String _extractInitials(String fullName) {
    final parts = fullName
        .trim()
        .split(RegExp(r'\s+'))
        .where((e) => e.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '—';
    final first = parts[0].substring(0, 1).toUpperCase();
    if (parts.length == 1) return first;
    final second = parts[1].substring(0, 1).toUpperCase();
    return '$first$second';
  }
}
