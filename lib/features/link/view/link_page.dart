import 'package:flutter/material.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_decoration.dart';

class LinkPage extends StatelessWidget {
  const LinkPage({super.key});

  static const name = 'link_page';
  static const path = '/link_page';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark
          ? AppColors.secondaryDarkLight
          : AppColors.tabBarScreenBackground,
      body: const _BodyWidget(),
    );
  }
}

class _BodyWidget extends StatelessWidget {
  const _BodyWidget();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: AppDecoration.padding16,
        child: const SizedBox.shrink(),
      ),
    );
  }
}
