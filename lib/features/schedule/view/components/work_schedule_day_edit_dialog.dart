import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_decoration.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/core/widgets/change_time_picker_dialog.dart';
import 'package:rient_app/core/widgets/main_button.dart';
import 'package:rient_app/features/schedule/view/components/work_schedule_mock_data.dart';

class WorkScheduleDayEditResult {
  const WorkScheduleDayEditResult({
    required this.isWorkingDay,
    required this.workStart,
    required this.workEnd,
    this.breakStart,
    this.breakEnd,
  });

  final bool isWorkingDay;
  final String workStart;
  final String workEnd;
  final String? breakStart;
  final String? breakEnd;
}

int _timeToMinutes(String time) {
  final parts = time.split(':');
  final h = int.tryParse(parts.first) ?? 0;
  final m = int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 0;
  return h * 60 + m;
}

String? _validate({
  required bool isWorkingDay,
  required String workStart,
  required String workEnd,
  String? breakStart,
  String? breakEnd,
}) {
  if (!isWorkingDay) return null;

  if (workStart.trim().isEmpty || workEnd.trim().isEmpty) {
    return 'Укажите время работы';
  }
  if (_timeToMinutes(workStart) >= _timeToMinutes(workEnd)) {
    return 'Время окончания должно быть позже начала';
  }

  final hasBreakStart = breakStart != null && breakStart.trim().isNotEmpty;
  final hasBreakEnd = breakEnd != null && breakEnd.trim().isNotEmpty;
  if (hasBreakStart != hasBreakEnd) {
    return 'Укажите начало и конец перерыва';
  }
  if (hasBreakStart && hasBreakEnd) {
    if (_timeToMinutes(breakStart) >= _timeToMinutes(breakEnd)) {
      return 'Некорректное время перерыва';
    }
    final ws = _timeToMinutes(workStart);
    final we = _timeToMinutes(workEnd);
    final bs = _timeToMinutes(breakStart);
    final be = _timeToMinutes(breakEnd);
    if (bs < ws || be > we) {
      return 'Перерыв должен быть внутри рабочего времени';
    }
  }
  return null;
}

/// Диалог правки одного дня графика (как на вебе).
Future<WorkScheduleDayEditResult?> showWorkScheduleDayEditDialog(
  BuildContext context, {
  required WorkScheduleDayCell cell,
}) {
  final isWorkingDayInitial = cell.kind == WorkScheduleCellKind.shift;
  var isWorkingDay = isWorkingDayInitial;
  var workStart = cell.timeStart ?? '09:00';
  var workEnd = cell.timeEnd ?? '20:00';
  var breakStart = cell.breakStart ?? '';
  var breakEnd = cell.breakEnd ?? '';
  String? errorText;

  return showDialog<WorkScheduleDayEditResult>(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withValues(alpha: 0.35),
    builder: (dialogContext) {
      final isDark = Theme.of(dialogContext).brightness == Brightness.dark;
      final cardColor = isDark ? AppColors.primaryWhiteDark : Colors.white;
      final labelColor = isDark ? AppColors.primaryWhite : AppColors.primaryDark;
      final fieldFill =
          isDark ? AppColors.secondaryDarkLight : AppColors.secondaryLight;
      final accent = AppColors.themeAccent(dialogContext);

      return StatefulBuilder(
        builder: (context, setDialogState) {
          Future<void> pickTime(
            String current,
            void Function(String) onPicked,
          ) async {
            final picked = await showChangeTimePicker(
              context,
              initialTime: current,
            );
            if (picked != null) {
              setDialogState(() {
                onPicked(picked);
                errorText = null;
              });
            }
          }

          return Dialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 24),
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _DayTypeOption(
                    label: 'Выходной',
                    selected: !isWorkingDay,
                    accent: accent,
                    labelColor: labelColor,
                    onTap: () => setDialogState(() {
                      isWorkingDay = false;
                      errorText = null;
                    }),
                  ),
                  const Gap(8),
                  _DayTypeOption(
                    label: 'Рабочий день',
                    selected: isWorkingDay,
                    accent: accent,
                    labelColor: labelColor,
                    onTap: () => setDialogState(() {
                      isWorkingDay = true;
                      errorText = null;
                    }),
                  ),
                  if (isWorkingDay) ...[
                    const Gap(16),
                    Row(
                      children: [
                        Expanded(
                          child: _TimeField(
                            label: workStart,
                            fillColor: fieldFill,
                            labelColor: labelColor,
                            onTap: () => pickTime(workStart, (v) => workStart = v),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            '—',
                            style: AppFonts.b1Medium.copyWith(color: labelColor),
                          ),
                        ),
                        Expanded(
                          child: _TimeField(
                            label: workEnd,
                            fillColor: fieldFill,
                            labelColor: labelColor,
                            onTap: () => pickTime(workEnd, (v) => workEnd = v),
                          ),
                        ),
                      ],
                    ),
                    const Gap(16),
                    Text(
                      'Перерыв',
                      style: AppFonts.b1Medium.copyWith(color: labelColor),
                    ),
                    const Gap(8),
                    Row(
                      children: [
                        Expanded(
                          child: _TimeField(
                            label: breakStart.isEmpty ? '—' : breakStart,
                            fillColor: fieldFill,
                            labelColor: labelColor,
                            isPlaceholder: breakStart.isEmpty,
                            onTap: () => pickTime(
                              breakStart.isEmpty ? workStart : breakStart,
                              (v) => breakStart = v,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            '—',
                            style: AppFonts.b1Medium.copyWith(color: labelColor),
                          ),
                        ),
                        Expanded(
                          child: _TimeField(
                            label: breakEnd.isEmpty ? '—' : breakEnd,
                            fillColor: fieldFill,
                            labelColor: labelColor,
                            isPlaceholder: breakEnd.isEmpty,
                            onTap: () => pickTime(
                              breakEnd.isEmpty ? workEnd : breakEnd,
                              (v) => breakEnd = v,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (errorText != null) ...[
                    const Gap(12),
                    Text(
                      errorText!,
                      style: AppFonts.c1Medium.copyWith(
                        color: AppColors.red,
                      ),
                    ),
                  ],
                  const Gap(20),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.of(dialogContext).pop(),
                          child: Text(
                            'Отмена',
                            style: AppFonts.b1Medium.copyWith(color: accent),
                          ),
                        ),
                      ),
                      const Gap(12),
                      Expanded(
                        child: MainButton(
                          title: 'Сохранить',
                          height: 44,
                          onTap: () {
                            final validation = _validate(
                              isWorkingDay: isWorkingDay,
                              workStart: workStart,
                              workEnd: workEnd,
                              breakStart: breakStart,
                              breakEnd: breakEnd,
                            );
                            if (validation != null) {
                              setDialogState(() => errorText = validation);
                              return;
                            }
                            Navigator.of(dialogContext).pop(
                              WorkScheduleDayEditResult(
                                isWorkingDay: isWorkingDay,
                                workStart: workStart,
                                workEnd: workEnd,
                                breakStart: breakStart.trim().isEmpty
                                    ? null
                                    : breakStart.trim(),
                                breakEnd: breakEnd.trim().isEmpty
                                    ? null
                                    : breakEnd.trim(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

class _DayTypeOption extends StatelessWidget {
  const _DayTypeOption({
    required this.label,
    required this.selected,
    required this.accent,
    required this.labelColor,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final Color accent;
  final Color labelColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppDecoration.borderRadius300,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Icon(
                selected ? Icons.radio_button_checked : Icons.radio_button_off,
                color: selected ? accent : AppColors.tabbarGrey,
                size: 22,
              ),
              const Gap(10),
              Text(
                label,
                style: AppFonts.b1Medium.copyWith(color: labelColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimeField extends StatelessWidget {
  const _TimeField({
    required this.label,
    required this.fillColor,
    required this.labelColor,
    required this.onTap,
    this.isPlaceholder = false,
  });

  final String label;
  final Color fillColor;
  final Color labelColor;
  final VoidCallback onTap;
  final bool isPlaceholder;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: fillColor,
          borderRadius: AppDecoration.borderRadius300,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppFonts.b1Medium.copyWith(
            color: isPlaceholder ? AppColors.tabbarGrey : labelColor,
          ),
        ),
      ),
    );
  }
}
