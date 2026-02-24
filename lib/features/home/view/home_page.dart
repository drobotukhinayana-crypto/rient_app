import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_decoration.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/core/widgets/default_container.dart';
import 'package:rient_app/core/widgets/top_panel.dart';
import 'package:rient_app/features/home/view/components/services_today_grid_view.dart';
import 'package:rient_app/features/home/view/components/branch_selector.dart';
import 'package:rient_app/features/home/view/providers/statistics_provider.dart';
import 'package:rient_app/resources/resources.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const name = 'home_page';
  static const path = '/home_page';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.tabBarScreenBackground,
      body: _BodyWidget(),
    );
  }
}

class _BodyWidget extends StatelessWidget {
  const _BodyWidget();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TopPanel(title: 'Главная', showViewModeSwitcher: false),

        // контент
        Expanded(
          child: SingleChildScrollView(
            padding: AppDecoration.padding16.copyWith(top: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BranchSelector(),
                Gap(16),
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
    final statisticsAsync = ref.watch(statisticsProvider);

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
              ),
            ],
          ),
        ),
        if (_expanded) ...[
          Gap(12),
          statisticsAsync.when(
            data: (statistics) {
              // Вычисляем суммарные значения
              final totalAppointments = statistics.appointments.completed +
                  statistics.appointments.canceled +
                  statistics.appointments.stalled +
                  statistics.appointments.confirmed +
                  statistics.appointments.created;

              final totalIncome = statistics.incomeByDay.fold<double>(
                0.0,
                (sum, item) => sum + item.income,
              );

              final totalPayDue = statistics.incomeByDay.fold<double>(
                0.0,
                (sum, item) => sum + item.payDue,
              );

              return Column(
                children: [
                  Row(
                    children: [
                      // записей
                      Expanded(
                        child: DefaultContainerWidget(
                          color: Colors.white,
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
                                  color: AppColors.mainAccent,
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
                          color: Colors.white,
                          hasShadow: false,
                          borderRadius: BorderRadius.circular(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Новых', style: AppFonts.b2Medium),
                              Gap(8),
                              Text(
                                statistics.appointments.created.toString(),
                                style: AppFonts.h4Medium.copyWith(
                                  color: AppColors.mainAccent,
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
                          color: Colors.white,
                          hasShadow: false,
                          borderRadius: BorderRadius.circular(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Отменено', style: AppFonts.b2Medium),
                              Gap(8),
                              Text(
                                statistics.appointments.canceled.toString(),
                                style: AppFonts.h4Medium.copyWith(color: AppColors.red),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  Gap(10),

                  Row(
                    children: [
                      // доход
                      Expanded(
                        child: DefaultContainerWidget(
                          color: Colors.white,
                          hasShadow: false,
                          borderRadius: BorderRadius.circular(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Доход', style: AppFonts.b2Medium),
                              Gap(8),
                              Text(
                                '${totalIncome.toStringAsFixed(0)} ₽',
                                style: AppFonts.h4Medium.copyWith(
                                  color: AppColors.mainAccent,
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
                          color: Colors.white,
                          hasShadow: false,
                          borderRadius: BorderRadius.circular(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('К выплате', style: AppFonts.b2Medium),
                              Gap(8),
                              Text(
                                '${totalPayDue.toStringAsFixed(0)} ₽',
                                style: AppFonts.h4Medium.copyWith(
                                  color: AppColors.mainAccent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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
