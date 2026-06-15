import 'package:flutter/material.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/features/schedule/view/components/schedule_calendar_day_multi_column.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/core/widgets/default_container.dart';
import 'package:rient_app/core/widgets/worker_avatar_image.dart';
import 'package:rient_app/features/schedule/view/components/specialist_select_dialog.dart';

class SpecialistListView extends StatelessWidget {
  const SpecialistListView({
    super.key,
    required this.specialists,
    this.scrollController,
    this.itemWidth = scheduleDaySpecialistColumnWidth,
    this.leadingInset = scheduleDaySpecialistLeadingInsetDefault,
    this.columnSeparatorWidth = scheduleDayColumnSeparatorWidth,
  });

  final List<SpecialistItem> specialists;
  final ScrollController? scrollController;
  final double itemWidth;
  final double leadingInset;
  final double columnSeparatorWidth;

  static double effectiveItemWidth({
    required int count,
    required double availableWidth,
    required double itemWidth,
    required double columnSeparatorWidth,
  }) {
    if (count <= 0) return itemWidth;
    final separatorsTotalWidth =
        count > 1 ? (count - 1) * columnSeparatorWidth : 0.0;
    final requestedCardsWidth = (count * itemWidth) + separatorsTotalWidth;
    if (requestedCardsWidth < availableWidth) {
      return (availableWidth - separatorsTotalWidth) / count;
    }
    return itemWidth;
  }

  static Widget buildRow(
    BuildContext context, {
    required List<SpecialistItem> specialists,
    required double effectiveItemWidth,
    double columnSeparatorWidth = scheduleDayColumnSeparatorWidth,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 16),
      child: Row(
        children: [
          for (var i = 0; i < specialists.length; i++) ...[
            if (i > 0) SizedBox(width: columnSeparatorWidth),
            _SpecialistCard(
              item: specialists[i],
              width: effectiveItemWidth,
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final count = specialists.length;
        final availableCardsWidth = (constraints.maxWidth - leadingInset).clamp(
          0.0,
          double.infinity,
        );
        final effectiveItemWidth = SpecialistListView.effectiveItemWidth(
          count: count,
          availableWidth: availableCardsWidth,
          itemWidth: itemWidth,
          columnSeparatorWidth: columnSeparatorWidth,
        );

        return SizedBox(
          height: 135,
          child: Row(
            children: [
              SizedBox(width: leadingInset),
              Expanded(
                child: scrollController == null
                    ? buildRow(
                        context,
                        specialists: specialists,
                        effectiveItemWidth: effectiveItemWidth,
                        columnSeparatorWidth: columnSeparatorWidth,
                      )
                    : ListView.separated(
                        controller: scrollController,
                        padding: const EdgeInsets.only(top: 6, bottom: 16),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => _SpecialistCard(
                          item: specialists[index],
                          width: effectiveItemWidth,
                        ),
                        separatorBuilder: (context, index) => SizedBox(
                          width: columnSeparatorWidth,
                        ),
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

class _SpecialistCard extends StatelessWidget {
  const _SpecialistCard({
    required this.item,
    required this.width,
  });

  final SpecialistItem item;
  final double width;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      width: width,
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
            const SizedBox(height: 12),
            Text(
              item.name,
              style: AppFonts.c1Medium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
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
  }
}

class _SpecialistAvatar extends StatelessWidget {
  const _SpecialistAvatar({this.pictureUrl, required this.name});

  final String? pictureUrl;
  final String name;

  @override
  Widget build(BuildContext context) {
    return WorkerAvatarImage(
      pictureUrl: pictureUrl,
      name: name,
      size: 40,
      placeholder: _placeholder(context),
    );
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
