import 'package:flutter/material.dart';

class AppDecoration {
  static const padding16 = EdgeInsets.symmetric(horizontal: 16);
  static final borderRadius300 = BorderRadius.circular(300);

  /// Системная зона снизу (жесты / кнопки навигации Android).
  static double systemBottomInset(BuildContext context) =>
      MediaQuery.paddingOf(context).bottom;

  /// Нижний отступ для прокручиваемого контента над системной панелью.
  static double scrollBottomPadding(
    BuildContext context, {
    double extra = 24,
  }) =>
      extra + systemBottomInset(context);
}
