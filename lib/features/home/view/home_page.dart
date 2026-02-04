import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_decoration.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/core/widgets/default_container.dart';
import 'package:rient_app/core/widgets/top_panel.dart';
import 'package:rient_app/features/home/view/components/services_today_grid_view.dart';
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
        const TopPanel(title: 'Главная'),

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

class _StatisticsWidget extends StatefulWidget {
  const _StatisticsWidget();

  @override
  State<_StatisticsWidget> createState() => _StatisticsWidgetState();
}

class _StatisticsWidgetState extends State<_StatisticsWidget> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
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
                        '21',
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
                        '12',
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
                        '2',
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
                        '21 300 ₽',
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
                        '11 300 ₽',
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
      ],
    );
  }
}
