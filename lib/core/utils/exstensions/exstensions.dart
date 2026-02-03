import 'package:flutter/material.dart';

extension MediaQueryExtendion on BuildContext {
  MediaQueryData get _mediaQuery => MediaQuery.of(this);
  Size get size => _mediaQuery.size;
  double get width => size.width;
  double get height => size.height;
  EdgeInsets get safeArea => _mediaQuery.viewPadding;
}

extension CapitilizeText on String {
  String get firstCapitilized {
    if (isEmpty) return this;
    final lowerCaseString = toLowerCase();
    return lowerCaseString[0].toUpperCase() + lowerCaseString.substring(1);
  }
}

extension AsInt on String {
  int asInt() => int.parse(this);
}
