import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:rient_app/core/network/app_connectivity_provider.dart';
import 'package:rient_app/core/network/app_offline.dart'
    show appNoConnectionMessage, shouldShowNoConnectionMessage;
import 'package:rient_app/core/network/connectivity_recovery_listener.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_decoration.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/core/widgets/app_refresh_indicator.dart';
import 'package:rient_app/core/widgets/default_container.dart';
import 'package:rient_app/core/widgets/offline_message.dart';
import 'package:rient_app/core/widgets/schedule_offline_banner.dart';
import 'package:rient_app/core/widgets/top_panel.dart';
import 'package:rient_app/features/auth/data/models/user_role/user_role.dart';
import 'package:rient_app/features/auth/view/providers/role_provider.dart';
import 'package:rient_app/features/home/view/components/services_today_grid_view.dart';
import 'package:rient_app/features/home/view/providers/selected_date_provider.dart';
import 'package:rient_app/features/home/view/providers/statistics_provider.dart';
import 'package:rient_app/features/home/view/providers/worker_permissions_provider.dart';
import 'package:rient_app/features/schedule/view/providers/appointments_provider.dart';
import 'package:rient_app/features/schedule/view/providers/schedule_appointments_refresh.dart'
    show syncScheduleDateFromHome;
import 'package:rient_app/features/schedule/view/providers/schedule_offline_provider.dart'
    show scheduleOfflineModeProvider, tryRecoverScheduleNetwork;
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

    ref.watch(connectivityRecoveryListenerProvider);

    final isOffline =
        ref.watch(appNoConnectionProvider) ||
        ref.watch(scheduleOfflineModeProvider);

    Future<void> onRefresh() async {
      final recovered = await tryRecoverScheduleNetwork(ref);
      if (!recovered) return;
      ref.invalidate(connectivityCheckProvider);
      ref.invalidate(statisticsProvider);
      ref.invalidate(scheduleAppointmentsProvider);
      try {
        await ref.read(statisticsProvider.future);
      } catch (_) {}
    }

    return Column(
      children: [
        TopPanel(
          title: 'Главная',
          occupancyByDay: occupancyByDay,
          showViewModeSwitcher: false,
          selectedDate: selectedDate,
          onDateSelected: (date) {
            ref.read(selectedDateProvider.notifier).setDate(date);
            syncScheduleDateFromHome(ref);
          },
        ),
        if (isOffline)
          const ScheduleOfflineBanner(message: appNoConnectionMessage),

        Expanded(
          child: AppRefreshIndicator(
            onRefresh: onRefresh,
            child: SingleChildScrollView(
              physics: AppRefreshIndicator.scrollPhysics,
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
    final workerPermissions = ref
        .watch(workerPermissionsProvider)
        .maybeWhen(data: (v) => v, orElse: () => null);
    final isOwnerOrManager =
        roleId == UserRole.owner.value || roleId == UserRole.manager.value;
    final isOffline =
        ref.watch(appNoConnectionProvider) ||
        ref.watch(scheduleOfflineModeProvider);

    if (isOffline) {
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
          if (_expanded) const OfflineMessage(),
        ],
      );
    }

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
              final dayIncomeValue = dayIncome?.factualIncome ?? 0.0;
              final dayPayDueValue = dayIncome?.payDue ?? 0.0;
              final statTitleStyle = AppFonts.c1Medium;
              TextStyle statRublesStyle(Color color) =>
                  AppFonts.c1Medium.copyWith(color: color);

              Widget statRublesText(String text, Color color) {
                return FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    text,
                    maxLines: 1,
                    style: statRublesStyle(color),
                  ),
                );
              }

              Widget metricCard({
                required String topTitle,
                required double value,
              }) {
                return DefaultContainerWidget(
                  color: isDark ? AppColors.primaryWhiteDark : Colors.white,
                  hasShadow: false,
                  borderRadius: BorderRadius.circular(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        topTitle,
                        style: statTitleStyle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Gap(8),
                      statRublesText(
                        '${value.toStringAsFixed(0)} ₽',
                        AppColors.themeAccent(context),
                      ),
                    ],
                  ),
                );
              }

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
                              Text('Записей', style: statTitleStyle),
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
                              Text('Новых', style: statTitleStyle),
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
                                'Отмена',
                                style: statTitleStyle,
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

                  if (isWorkerRole &&
                      statistics.incomeByDay != null &&
                      ((workerPermissions?.seeIncome ?? true) ||
                          (workerPermissions?.seeToBePaid ?? true))) ...[
                    Gap(10),
                    Row(
                      children: [
                        if (workerPermissions?.seeIncome ?? true)
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
                                  statRublesText(
                                    '${dayIncomeValue.toStringAsFixed(0)} ₽',
                                    AppColors.themeAccent(context),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if ((workerPermissions?.seeIncome ?? true) &&
                            (workerPermissions?.seeToBePaid ?? true))
                          Gap(12),
                        if (workerPermissions?.seeToBePaid ?? true)
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
                                  statRublesText(
                                    '${dayPayDueValue.toStringAsFixed(0)} ₽',
                                    AppColors.themeAccent(context),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                  if (isOwnerOrManager) ...[
                    Gap(10),
                    Row(
                      children: [
                        Expanded(
                          child: metricCard(
                            topTitle: 'Прогноз',
                            value: dayIncome?.projectedIncomeValue ?? 0,
                          ),
                        ),
                        Gap(8),
                        Expanded(
                          child: metricCard(
                            topTitle: 'Факт',
                            value: dayIncome?.factualIncomeValue ?? 0,
                          ),
                        ),
                        Gap(8),
                        Expanded(
                          child: metricCard(
                            topTitle: 'Ср. Чек',
                            value: dayIncome?.averageCheckValue ?? 0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              );
            },
            loading: () => isOffline
                ? const OfflineMessage()
                : const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: CircularProgressIndicator(),
                    ),
                  ),
            error: (error, stack) => shouldShowNoConnectionMessage(error)
                ? const OfflineMessage()
                : Center(
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
