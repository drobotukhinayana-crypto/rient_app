import 'package:flutter/material.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  static const name = 'schedule_page';
  static const path = '/schedule_page';

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
    return const Placeholder();
  }
}
