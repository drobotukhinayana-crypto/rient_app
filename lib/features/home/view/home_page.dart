import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_decoration.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/core/widgets/default_container.dart';
import 'package:rient_app/core/widgets/top_panel.dart';
import 'package:rient_app/features/auth/data/models/user_role/user_role.dart';
import 'package:rient_app/features/auth/view/providers/role_provider.dart';
import 'package:rient_app/features/home/view/components/services_today_grid_view.dart';
import 'package:rient_app/features/home/view/providers/selected_date_provider.dart';
import 'package:rient_app/features/home/view/providers/statistics_provider.dart';
import 'package:rient_app/resources/resources.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const name = 'home_page';
  static const path = '/home_page';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark
          ? AppColors.secondaryDarkLight
          : AppColors.tabBarScreenBackground,
      body: _BodyWidget(),
    );
  }
}

class _BodyWidget extends ConsumerWidget {
  const _BodyWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    final occupancyByDay =
        ref.watch(statisticsProvider).value?.occupancyByDay ?? [];
    return Column(
      children: [
        TopPanel(
          title: 'Главная',
          occupancyByDay: occupancyByDay,
          showViewModeSwitcher: false,
          selectedDate: selectedDate,
          onDateSelected: (date) =>
              ref.read(selectedDateProvider.notifier).setDate(date),
        ),

        // контент
        Expanded(
          child: SingleChildScrollView(
            padding: AppDecoration.padding16.copyWith(top: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _StatisticsWidget(),
                Gap(24),
                Text('Услуги на сегодня', style: AppFonts.h4Medium),
                Gap(12),
                const ServicesTodayGridView(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _StatisticsWidget extends ConsumerStatefulWidget {
  const _StatisticsWidget();

  @override
  ConsumerState<_StatisticsWidget> createState() => _StatisticsWidgetState();
}

class _StatisticsWidgetState extends ConsumerState<_StatisticsWidget> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final statisticsAsync = ref.watch(statisticsProvider);
    final roleId = ref.watch(roleProvider);
    final isWorkerRole = roleId == UserRole.worker.value;

    return Column(
      children: [
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          behavior: HitTestBehavior.opaque,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Статистика', style: AppFonts.h4Medium),
              Image.asset(
                _expanded
                    ? AppImages.arrowOutlinedTop
                    : AppImages.arrowOutlinedDown,
                color: AppColors.themeAccent(context),
              ),
            ],
          ),
        ),
        if (_expanded) ...[
          Gap(12),
          statisticsAsync.when(
            data: (statistics) {
              final selectedDate = ref.watch(selectedDateProvider);
              final selectedDateStr =
                  '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';

              final dayAppointments = statistics.appointmentsByDay
                  .where((e) => e.date == selectedDateStr)
                  .firstOrNull
                  ?.appointments;
              final dayIncome = statistics.incomeByDay
                  ?.where(
                    (e) =>
                        e.date.year == selectedDate.year &&
                        e.date.month == selectedDate.month &&
                        e.date.day == selectedDate.day,
                  )
                  .firstOrNull;

              final totalAppointments = dayAppointments?.total ?? 0;
              final newCount = dayAppointments?.newCount ?? 0;
              final cancelled = dayAppointments?.cancelled ?? 0;
              final dayIncomeValue = dayIncome?.income ?? 0.0;
              final dayPayDueValue = dayIncome?.payDue ?? 0.0;

              return Column(
                children: [
                  Row(
                    children: [
                      // записей
                      Expanded(
                        child: DefaultContainerWidget(
                          color: isDark
                              ? AppColors.primaryWhiteDark
                              : Colors.white,
                          hasShadow: false,
                          borderRadius: BorderRadius.circular(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Записей', style: AppFonts.b2Medium),
                              Gap(8),
                              Text(
                                totalAppointments.toString(),
                                style: AppFonts.h4Medium.copyWith(
                                  color: AppColors.themeAccent(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Gap(8),

                      // новых
                      Expanded(
                        child: DefaultContainerWidget(
                          color: isDark
                              ? AppColors.primaryWhiteDark
                              : Colors.white,
                          hasShadow: false,
                          borderRadius: BorderRadius.circular(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Новых', style: AppFonts.b2Medium),
                              Gap(8),
                              Text(
                                newCount.toString(),
                                style: AppFonts.h4Medium.copyWith(
                                  color: AppColors.themeAccent(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Gap(8),

                      // отмененных
                      Expanded(
                        child: DefaultContainerWidget(
                          color: isDark
                              ? AppColors.primaryWhiteDark
                              : Colors.white,
                          hasShadow: false,
                          borderRadius: BorderRadius.circular(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Отменено',
                                style: AppFonts.b2Medium,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Gap(8),
                              Text(
                                cancelled.toString(),
                                style: AppFonts.h4Medium.copyWith(
                                  color: isDark
                                      ? AppColors.redDark
                                      : AppColors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  if (isWorkerRole && statistics.incomeByDay != null) ...[
                    Gap(10),
                    Row(
                      children: [
                        // доход
                        Expanded(
                          child: DefaultContainerWidget(
                            color: isDark
                                ? AppColors.primaryWhiteDark
                                : Colors.white,
                            hasShadow: false,
                            borderRadius: BorderRadius.circular(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Доход', style: AppFonts.b2Medium),
                                Gap(8),
                                Text(
                                  '${dayIncomeValue.toStringAsFixed(0)} ₽',
                                  style: AppFonts.h4Medium.copyWith(
                                    color: AppColors.themeAccent(context),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Gap(12),
                        // к выплате
                        Expanded(
                          child: DefaultContainerWidget(
                            color: isDark
                                ? AppColors.primaryWhiteDark
                                : Colors.white,
                            hasShadow: false,
                            borderRadius: BorderRadius.circular(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('К выплате', style: AppFonts.b2Medium),
                                Gap(8),
                                Text(
                                  '${dayPayDueValue.toStringAsFixed(0)} ₽',
                                  style: AppFonts.h4Medium.copyWith(
                                    color: AppColors.themeAccent(context),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              );
            },
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (error, stack) => Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Ошибка загрузки статистики',
                  style: AppFonts.b2Medium.copyWith(color: AppColors.red),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
