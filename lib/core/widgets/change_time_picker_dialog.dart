import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/core/widgets/main_button.dart';

const _minuteStepValues = [0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55];

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
  var selectedHour = parsed.hour;
  var selectedMinute = _nearestMinuteStep(parsed.minute);

  final hourController = FixedExtentScrollController(initialItem: selectedHour);
  final minuteController = FixedExtentScrollController(
    initialItem: _minuteStepValues.indexOf(selectedMinute),
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
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Изменить время',
                          style: AppFonts.h3Medium.copyWith(color: titleColor),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(dialogContext).pop(),
                        behavior: HitTestBehavior.opaque,
                        child: const Icon(
                          Icons.close,
                          size: 22,
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                  const Gap(16),
                  Container(
                    height: 220,
                    decoration: BoxDecoration(
                      color: pickerBackground,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        IgnorePointer(
                          child: Container(
                            height: 42,
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: selectionColor,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.06),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
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
                                itemExtent: 42,
                                magnification: 1.08,
                                squeeze: 1.05,
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
                                      style: AppFonts.h2Semi.copyWith(
                                        color: wheelColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: CupertinoPicker(
                                scrollController: minuteController,
                                itemExtent: 42,
                                magnification: 1.08,
                                squeeze: 1.05,
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
                                      style: AppFonts.h2Semi.copyWith(
                                        color: wheelColor,
                                        fontWeight: FontWeight.w600,
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
                  const Gap(16),
                  MainButton(
                    title: 'Сохранить',
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
