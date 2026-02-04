import 'package:flutter/material.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';

class LinkPage extends StatelessWidget {
  const LinkPage({super.key});

  static const name = 'link_page';
  static const path = '/link_page';

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
