import 'package:flutter/material.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';

/// Pull-to-refresh в стиле приложения (как Gmail / Яндекс Метрика).
class AppRefreshIndicator extends StatelessWidget {
  const AppRefreshIndicator({
    super.key,
    required this.onRefresh,
    required this.child,
    this.displacement = 52,
  });

  final Future<void> Function() onRefresh;
  final Widget child;
  final double displacement;

  static const scrollPhysics = AlwaysScrollableScrollPhysics(
    parent: BouncingScrollPhysics(),
  );

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return RefreshIndicator(
      color: AppColors.themeAccent(context),
      backgroundColor: isDark ? AppColors.primaryWhiteDark : Colors.white,
      displacement: displacement,
      strokeWidth: 2.5,
      onRefresh: onRefresh,
      child: child,
    );
  }
}

/// Обёртка для экранов с фиксированным контентом (сетка, календарь, пустой список).
class AppRefreshable extends StatelessWidget {
  const AppRefreshable({
    super.key,
    required this.onRefresh,
    required this.child,
    this.padding,
    this.controller,
    this.hasScrollBody = false,
  });

  final Future<void> Function() onRefresh;
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final ScrollController? controller;

  /// true — если внутри есть свой вертикальный скролл (календарь, ListView).
  final bool hasScrollBody;

  @override
  Widget build(BuildContext context) {
    return AppRefreshIndicator(
      onRefresh: onRefresh,
      child: CustomScrollView(
        controller: controller,
        physics: AppRefreshIndicator.scrollPhysics,
        slivers: [
          SliverPadding(
            padding: padding ?? EdgeInsets.zero,
            sliver: SliverFillRemaining(
              hasScrollBody: hasScrollBody,
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
