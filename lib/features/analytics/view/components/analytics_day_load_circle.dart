import 'package:flutter/material.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';

const _weekdayShort = ['ПН', 'ВТ', 'СР', 'ЧТ', 'ПТ', 'СБ', 'ВС'];

/// Кружок загруженности дня (число + дуга + подпись дня недели).
class AnalyticsDayLoadCircle extends StatelessWidget {
  const AnalyticsDayLoadCircle({
    super.key,
    required this.date,
    required this.occupancyPercent,
    this.isDark = false,
  });

  final DateTime date;
  final double occupancyPercent;
  final bool isDark;

  static const _size = 48.0;

  @override
  Widget build(BuildContext context) {
    final accent = AppColors.themeAccent(context);
    final dayColor = isDark ? AppColors.primaryWhite : AppColors.primaryDark;
    final weekdayColor = AppColors.tabbarGrey;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: _size,
          height: _size,
          child: CustomPaint(
            painter: _AnalyticsLoadArcPainter(
              percent: occupancyPercent,
              accent: accent,
              fillColor:
                  isDark ? AppColors.primaryWhiteDark : AppColors.primaryWhite,
            ),
            child: Center(
              child: Text(
                '${date.day}',
                style: AppFonts.b2Medium.copyWith(color: dayColor),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _weekdayShort[date.weekday - 1],
          style: AppFonts.c2Tabbar.copyWith(color: weekdayColor),
        ),
      ],
    );
  }
}

class _AnalyticsLoadArcPainter extends CustomPainter {
  _AnalyticsLoadArcPainter({
    required this.percent,
    required this.accent,
    required this.fillColor,
  });

  final double percent;
  final Color accent;
  final Color fillColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 1;

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = fillColor
        ..style = PaintingStyle.fill,
    );

    final clamped = percent.clamp(0.0, 100.0);
    if (clamped <= 0) return;

    final sweep = (2 * 3.1415926535) * (clamped / 100);
    const startAngle = -3.1415926535 / 2;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 1),
      startAngle,
      sweep,
      false,
      Paint()
        ..color = accent
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _AnalyticsLoadArcPainter old) =>
      old.percent != percent || old.accent != accent;
}
