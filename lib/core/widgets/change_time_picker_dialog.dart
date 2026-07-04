import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/core/widgets/main_button.dart';

const _minuteStepValues = [0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55];

const _pickerItemExtent = 36.0;
const _pickerHeight = 180.0;
const _selectionBarHeight = 36.0;

({int hour, int minute}) _parseTime(String value) {
  final parts = value.split(':');
  final hour = int.tryParse(parts.first) ?? 0;
  final minute = int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 0;
  return (hour: hour.clamp(0, 23), minute: minute.clamp(0, 59));
}

int _timeToMinutes(int hour, int minute) => hour * 60 + minute;

int? _parseTimeToMinutes(String? value) {
  if (value == null || value.trim().isEmpty) return null;
  final parsed = _parseTime(value);
  return _timeToMinutes(parsed.hour, parsed.minute);
}

int _nearestMinuteStep(int minute) {
  final index = ((minute + 2) ~/ 5).clamp(0, _minuteStepValues.length - 1);
  return _minuteStepValues[index];
}

String _formatTime(int hour, int minute) =>
    '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

List<int> _hoursInRange(int minMinutes, int maxMinutes) {
  final minHour = minMinutes ~/ 60;
  final maxHour = maxMinutes ~/ 60;
  final hours = <int>[];
  for (var hour = minHour; hour <= maxHour; hour++) {
    if (_minutesInRangeForHour(hour, minMinutes, maxMinutes).isNotEmpty) {
      hours.add(hour);
    }
  }
  return hours;
}

List<int> _minutesInRangeForHour(int hour, int minMinutes, int maxMinutes) {
  return _minuteStepValues.where((minute) {
    final total = _timeToMinutes(hour, minute);
    return total >= minMinutes && total <= maxMinutes;
  }).toList();
}

({int hour, int minute}) _clampTimeToRange(
  int hour,
  int minute,
  int minMinutes,
  int maxMinutes,
) {
  final hours = _hoursInRange(minMinutes, maxMinutes);
  if (hours.isEmpty) {
    final minHour = minMinutes ~/ 60;
    final minMinute = _nearestMinuteStep(minMinutes % 60);
    return (hour: minHour, minute: minMinute);
  }

  var clampedHour = hour;
  if (!hours.contains(clampedHour)) {
    clampedHour = hours.firstWhere(
      (h) => h >= hour,
      orElse: () => hours.last,
    );
  }

  final minutes = _minutesInRangeForHour(
    clampedHour,
    minMinutes,
    maxMinutes,
  );
  if (minutes.isEmpty) {
    return (hour: hours.first, minute: _minutesInRangeForHour(
      hours.first,
      minMinutes,
      maxMinutes,
    ).first);
  }

  var clampedMinute = _nearestMinuteStep(minute);
  if (!minutes.contains(clampedMinute)) {
    clampedMinute = minutes.firstWhere(
      (m) => m >= clampedMinute,
      orElse: () => minutes.last,
    );
  }

  return (hour: clampedHour, minute: clampedMinute);
}

/// Модальное окно «Изменить время» с барабанным выбором часов и минут (шаг 5 мин).
Future<String?> showChangeTimePicker(
  BuildContext context, {
  required String initialTime,
  String? minTime,
  String? maxTime,
}) {
  final minMinutes = _parseTimeToMinutes(minTime) ?? 0;
  final maxMinutes = _parseTimeToMinutes(maxTime) ?? (23 * 60 + 55);
  final parsed = _parseTime(initialTime);
  final clamped = _clampTimeToRange(
    parsed.hour,
    parsed.minute,
    minMinutes,
    maxMinutes,
  );
  var selectedHour = clamped.hour;
  var selectedMinute = clamped.minute;

  final hours = _hoursInRange(minMinutes, maxMinutes);
  final effectiveHours = hours.isEmpty ? [0] : hours;
  final hourIndex = effectiveHours.indexOf(selectedHour).clamp(
        0,
        effectiveHours.length - 1,
      );
  selectedHour = effectiveHours[hourIndex];

  final initialMinutes =
      _minutesInRangeForHour(selectedHour, minMinutes, maxMinutes);
  final minuteIndex = initialMinutes.indexOf(selectedMinute).clamp(
        0,
        initialMinutes.isEmpty ? 0 : initialMinutes.length - 1,
      );
  if (initialMinutes.isNotEmpty) {
    selectedMinute = initialMinutes[minuteIndex];
  }

  final hourController = FixedExtentScrollController(initialItem: hourIndex);
  final minuteController = FixedExtentScrollController(initialItem: minuteIndex);

  return showDialog<String>(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withValues(alpha: 0.35),
    builder: (dialogContext) {
      final isDark = Theme.of(dialogContext).brightness == Brightness.dark;
      final cardColor = isDark ? AppColors.primaryWhiteDark : Colors.white;
      final titleColor =
          isDark ? AppColors.primaryWhite : AppColors.primaryDark;
      final wheelColor =
          isDark ? AppColors.primaryWhite : AppColors.primaryDark;
      final pickerBackground = isDark
          ? AppColors.secondaryDarkLight
          : AppColors.secondaryLight;
      final selectionColor =
          isDark ? AppColors.primaryWhiteDark : Colors.white;

      return StatefulBuilder(
        builder: (context, setDialogState) {
          final minuteOptions =
              _minutesInRangeForHour(selectedHour, minMinutes, maxMinutes);
          if (minuteOptions.isNotEmpty &&
              !minuteOptions.contains(selectedMinute)) {
            selectedMinute = minuteOptions.first;
          }
          final selectedTime = _formatTime(selectedHour, selectedMinute);

          return Dialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 24),
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Изменить время',
                          style: AppFonts.b1Semi.copyWith(color: titleColor),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(dialogContext).pop(),
                        behavior: HitTestBehavior.opaque,
                        child: const Icon(
                          Icons.close,
                          size: 20,
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                  const Gap(12),
                  Container(
                    height: _pickerHeight,
                    decoration: BoxDecoration(
                      color: pickerBackground,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        IgnorePointer(
                          child: Container(
                            height: _selectionBarHeight,
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              color: selectionColor,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 6,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: CupertinoPicker(
                                scrollController: hourController,
                                itemExtent: _pickerItemExtent,
                                magnification: 1.04,
                                squeeze: 1.18,
                                useMagnifier: true,
                                selectionOverlay:
                                    const SizedBox.shrink(),
                                onSelectedItemChanged: (index) {
                                  final nextHour = effectiveHours[index];
                                  final nextMinutes = _minutesInRangeForHour(
                                    nextHour,
                                    minMinutes,
                                    maxMinutes,
                                  );
                                  if (nextMinutes.isEmpty) return;

                                  var nextMinute = selectedMinute;
                                  if (!nextMinutes.contains(nextMinute)) {
                                    nextMinute = nextMinutes.first;
                                  }
                                  final minuteScrollIndex =
                                      nextMinutes.indexOf(nextMinute);

                                  setDialogState(() {
                                    selectedHour = nextHour;
                                    selectedMinute = nextMinute;
                                  });

                                  if (minuteScrollIndex >= 0 &&
                                      minuteController.hasClients) {
                                    minuteController.jumpToItem(
                                      minuteScrollIndex,
                                    );
                                  }
                                },
                                children: [
                                  for (final hour in effectiveHours)
                                    Center(
                                      child: Text(
                                        hour.toString().padLeft(2, '0'),
                                        style: AppFonts.h2Regular.copyWith(
                                          color: wheelColor,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: CupertinoPicker(
                                scrollController: minuteController,
                                itemExtent: _pickerItemExtent,
                                magnification: 1.04,
                                squeeze: 1.18,
                                useMagnifier: true,
                                selectionOverlay:
                                    const SizedBox.shrink(),
                                onSelectedItemChanged: (index) {
                                  if (index >= minuteOptions.length) return;
                                  setDialogState(
                                    () => selectedMinute = minuteOptions[index],
                                  );
                                },
                                children: [
                                  for (final minute in minuteOptions)
                                    Center(
                                      child: Text(
                                        minute.toString().padLeft(2, '0'),
                                        style: AppFonts.h2Regular.copyWith(
                                          color: wheelColor,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Gap(12),
                  MainButton(
                    title: 'Сохранить',
                    height: 44,
                    onTap: () => Navigator.of(dialogContext).pop(selectedTime),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  ).whenComplete(() {
    hourController.dispose();
    minuteController.dispose();
  });
}
