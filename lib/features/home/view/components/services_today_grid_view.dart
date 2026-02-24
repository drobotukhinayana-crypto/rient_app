import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/core/widgets/default_container.dart';
import 'package:rient_app/features/home/view/providers/statistics_provider.dart';

class ServicesTodayGridView extends ConsumerWidget {
  const ServicesTodayGridView({
    super.key,
    this.selectedDate,
  });

  final DateTime? selectedDate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statisticsAsync = ref.watch(statisticsProvider);

    return statisticsAsync.when(
      data: (statistics) {
        // Получаем выбранную дату или используем сегодняшний день
        final date = selectedDate ?? DateTime.now();
        final dateKey = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

        // Ищем услуги для выбранной даты
        final servicesForDay = statistics.servicesByDay[dateKey] ?? [];

        if (servicesForDay.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: Text('Нет услуг на выбранную дату'),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок с выбранной датой
            Text(
              'Услуги на ${date.day}.${date.month}.${date.year}',
              style: AppFonts.h4Medium,
            ),
            Gap(12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(vertical: 12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 3.5,
              ),
              itemCount: servicesForDay.length,
              itemBuilder: (context, index) {
                final service = servicesForDay[index];
                return DefaultContainerWidget(
                  color: Colors.white,
                  hasShadow: false,
                  borderRadius: BorderRadius.circular(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          service.date, // В ServiceByDay поле date содержит название услуги
                          style: AppFonts.b2Medium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '${service.count}',
                        style: AppFonts.b2Semi.copyWith(color: AppColors.mainAccent),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
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
          padding: EdgeInsets.all(32.0),
          child: Text('Ошибка загрузки услуг'),
        ),
      ),
    );
  }
}
