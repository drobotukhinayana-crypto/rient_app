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

int _nearestMinuteStep(int minute) {
  final index = ((minute + 2) ~/ 5).clamp(0, _minuteStepValues.length - 1);
  return _minuteStepValues[index];
}

String _formatTime(int hour, int minute) =>
    '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

/// Модальное окно «Изменить время» с барабанным выбором часов и минут (шаг 5 мин).
Future<String?> showChangeTimePicker(
  BuildContext context, {
  required String initialTime,
}) {
  final parsed = _parseTime(initialTime);
  var selectedHour = parsed.hour.clamp(0, 23);
  var selectedMinute = _nearestMinuteStep(parsed.minute);

  final minuteIndex = _minuteStepValues.indexOf(selectedMinute);
  final hourController = FixedExtentScrollController(initialItem: selectedHour);
  final minuteController = FixedExtentScrollController(
    initialItem: minuteIndex >= 0 ? minuteIndex : 0,
  );

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
                                  setDialogState(() => selectedHour = index);
                                },
                                children: List<Widget>.generate(
                                  24,
                                  (index) => Center(
                                    child: Text(
                                      index.toString().padLeft(2, '0'),
                                      style: AppFonts.h2Regular.copyWith(
                                        color: wheelColor,
                                      ),
                                    ),
                                  ),
                                ),
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
                                  setDialogState(
                                    () => selectedMinute =
                                        _minuteStepValues[index],
                                  );
                                },
                                children: List<Widget>.generate(
                                  _minuteStepValues.length,
                                  (index) => Center(
                                    child: Text(
                                      _minuteStepValues[index]
                                          .toString()
                                          .padLeft(2, '0'),
                                      style: AppFonts.h2Regular.copyWith(
                                        color: wheelColor,
                                      ),
                                    ),
                                  ),
                                ),
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
