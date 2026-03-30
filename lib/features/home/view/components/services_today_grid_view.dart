import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/core/widgets/default_container.dart';
import 'package:rient_app/features/home/view/providers/selected_date_provider.dart';
import 'package:rient_app/features/home/view/providers/statistics_provider.dart';

class ServicesTodayGridView extends ConsumerWidget {
  const ServicesTodayGridView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final statisticsAsync = ref.watch(statisticsProvider);
    final selectedDate = ref.watch(selectedDateProvider);
    final selectedDateStr =
        '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';

    return statisticsAsync.when(
      data: (statistics) {
        final dayItem = statistics.servicesByDay
            .where((e) => e.date == selectedDateStr)
            .firstOrNull;
        final services = dayItem?.services ?? {};
        if (services.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: Text('Нет данных об услугах'),
            ),
          );
        }

        final entries = services.entries.toList();
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(vertical: 12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 3.5,
          ),
          itemCount: entries.length,
          itemBuilder: (context, index) {
            final entry = entries[index];
            final name = entry.key;
            final count = entry.value;
            return DefaultContainerWidget(
              color: isDark ? AppColors.primaryWhiteDark : Colors.white,
              hasShadow: false,
              borderRadius: BorderRadius.circular(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      name,
                      style: AppFonts.b2Medium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '$count',
                    style: AppFonts.b2Semi.copyWith(
                      color: AppColors.themeAccent(context),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stack) => const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Ошибка загрузки статистики',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }
}
