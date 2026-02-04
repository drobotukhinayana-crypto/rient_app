import 'package:flutter/material.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';

/// Названия месяцев в родительном падеже (для "19 декабря").
const _monthGenitive = [
  'января',
  'февраля',
  'марта',
  'апреля',
  'мая',
  'июня',
  'июля',
  'августа',
  'сентября',
  'октября',
  'ноября',
  'декабря',
];

/// Названия месяцев в именительном падеже (для "Декабрь, 2025").
const _monthNominative = [
  'Январь',
  'Февраль',
  'Март',
  'Апрель',
  'Май',
  'Июнь',
  'Июль',
  'Август',
  'Сентябрь',
  'Октябрь',
  'Ноябрь',
  'Декабрь',
];

class DateRangeNavigator extends StatelessWidget {
  const DateRangeNavigator({
    super.key,
    required this.mode,
    required this.weekStart,
    required this.month,
    required this.onPrevious,
    required this.onNext,
  });

  final DateNavigatorMode mode;
  final DateTime weekStart;
  final DateTime month;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final text = mode == DateNavigatorMode.week
        ? _weekRangeText(weekStart)
        : _monthYearText(month);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _NavButton(icon: Icons.chevron_left, onTap: onPrevious),
        const SizedBox(width: 12),
        Text(
          text,
          style: AppFonts.b2Medium.copyWith(color: AppColors.mainAccent),
        ),
        const SizedBox(width: 12),
        _NavButton(icon: Icons.chevron_right, onTap: onNext),
      ],
    );
  }

  String _weekRangeText(DateTime monday) {
    final sunday = monday.add(const Duration(days: 6));
    final sameMonth = monday.month == sunday.month;
    if (sameMonth) {
      return '${monday.day} – ${sunday.day} ${_monthGenitive[monday.month - 1]}';
    }
    return '${monday.day} ${_monthGenitive[monday.month - 1]} – ${sunday.day} ${_monthGenitive[sunday.month - 1]}';
  }

  String _monthYearText(DateTime firstDayOfMonth) {
    return '${_monthNominative[firstDayOfMonth.month - 1]}, ${firstDayOfMonth.year}';
  }
}

enum DateNavigatorMode { week, month }

class _NavButton extends StatelessWidget {
  const _NavButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Icon(icon, size: 24, color: AppColors.mainAccent),
        ),
      ),
    );
  }
}
