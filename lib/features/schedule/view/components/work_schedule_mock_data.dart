import 'package:flutter/material.dart';

enum WorkScheduleShiftTone { full, short }

abstract final class WorkScheduleCellColors {
  static const dayOff = Color(0xFF4790AC);
  static const shift = Color(0xFF166BA1);

  /// Ручная правка дня (`schedules.auto == false`), как на вебе.
  static const manualEdit = Color(0xFF5657AC);

  /// Приглушённый синий/бирюзовый для прошедших дней (как на вебе).
  static Color get shiftPast => Color.lerp(shift, Colors.white, 0.48)!;

  static Color get dayOffPast => Color.lerp(dayOff, Colors.white, 0.48)!;

  static Color get manualEditPast => Color.lerp(manualEdit, Colors.white, 0.48)!;

  static Color get dateHeaderPastFill =>
      Color.lerp(shift, Colors.white, 0.72)!;
}

bool isPastWorkScheduleDate(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final normalized = DateTime(date.year, date.month, date.day);
  return normalized.isBefore(today);
}

enum WorkScheduleCellKind { shift, dayOff }

class WorkScheduleDayCell {
  const WorkScheduleDayCell.dayOff({this.isManuallyEdited = false})
    : kind = WorkScheduleCellKind.dayOff,
      timeStart = null,
      timeEnd = null,
      tone = WorkScheduleShiftTone.full,
      isSelected = false;

  const WorkScheduleDayCell.shift({
    required this.timeStart,
    required this.timeEnd,
    this.tone = WorkScheduleShiftTone.full,
    this.isSelected = false,
    this.isManuallyEdited = false,
  }) : kind = WorkScheduleCellKind.shift;

  final WorkScheduleCellKind kind;
  final String? timeStart;
  final String? timeEnd;
  final WorkScheduleShiftTone tone;
  final bool isSelected;

  /// День изменён вручную (`auto: false` в workers/.../schedules/).
  final bool isManuallyEdited;
}

class WorkScheduleEmployeeRow {
  const WorkScheduleEmployeeRow({
    required this.id,
    required this.name,
    required this.monthCells,
    this.pictureUrl,
  });

  final String id;
  final String name;
  final String? pictureUrl;
  final List<WorkScheduleDayCell> monthCells;
}

int daysInMonth(DateTime month) =>
    DateTime(month.year, month.month + 1, 0).day;

List<DateTime> daysOfMonth(DateTime month) {
  final count = daysInMonth(month);
  return [
    for (var day = 1; day <= count; day++)
      DateTime(month.year, month.month, day),
  ];
}

List<WorkScheduleEmployeeRow> mockWorkScheduleEmployeesForMonth(
  DateTime month, {
  /// Подсветка рамкой ячейки только при явном тапе по ячейке (не для «сегодня»).
  DateTime? highlightedCellDate,
}) {
  final days = daysOfMonth(month);
  final highlighted = highlightedCellDate != null
      ? DateTime(
          highlightedCellDate.year,
          highlightedCellDate.month,
          highlightedCellDate.day,
        )
      : null;

  WorkScheduleDayCell cellForDay(
    int employeeIndex,
    DateTime date, {
    bool selected = false,
  }) {
    final weekday = date.weekday;
    if (weekday == DateTime.saturday || weekday == DateTime.sunday) {
      return const WorkScheduleDayCell.dayOff();
    }
    final shortDay = (employeeIndex + date.day) % 3 == 0;
    final timeEnd = shortDay ? '19:00' : '21:00';
    return WorkScheduleDayCell.shift(
      timeStart: '10:00',
      timeEnd: timeEnd,
      tone: timeEnd == '21:00'
          ? WorkScheduleShiftTone.full
          : WorkScheduleShiftTone.short,
      isSelected: selected,
    );
  }

  const names = [
    'Вита',
    'Иван Иванов',
    'Мария К.',
    'Алексей П.',
    'Ольга С.',
    'Дмитрий В.',
  ];

  return [
    for (var i = 0; i < names.length; i++)
      WorkScheduleEmployeeRow(
        id: '${i + 1}',
        name: names[i],
        monthCells: [
          for (final date in days)
            cellForDay(
              i,
              date,
              selected: highlighted != null &&
                  highlighted.year == date.year &&
                  highlighted.month == date.month &&
                  highlighted.day == date.day,
            ),
        ],
      ),
  ];
}

