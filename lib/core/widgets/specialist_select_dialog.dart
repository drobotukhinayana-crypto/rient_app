import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/core/widgets/app_radio.dart';
import 'package:rient_app/core/widgets/main_button.dart';
import 'package:rient_app/resources/resources.dart';

class SpecialistItem {
  const SpecialistItem({required this.name, required this.role});
  final String name;
  final String role;
}

class SpecialistSelectDialog extends StatefulWidget {
  const SpecialistSelectDialog({
    super.key,
    required this.specialists,
    required this.initialSelected,
    required this.onSave,
  });

  final List<SpecialistItem> specialists;
  final SpecialistItem initialSelected;
  final ValueChanged<SpecialistItem> onSave;

  static Future<void> show(
    BuildContext context, {
    required List<SpecialistItem> specialists,
    required SpecialistItem initialSelected,
    required ValueChanged<SpecialistItem> onSave,
  }) {
    return showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) => SpecialistSelectDialog(
        specialists: specialists,
        initialSelected: initialSelected,
        onSave: onSave,
      ),
    );
  }

  @override
  State<SpecialistSelectDialog> createState() => _SpecialistSelectDialogState();
}

class _SpecialistSelectDialogState extends State<SpecialistSelectDialog> {
  late SpecialistItem _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialSelected;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Выбрать специалиста', style: AppFonts.h4Medium),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Image.asset(AppImages.closeRounded),
                ),
              ],
            ),
            const Gap(16),
            Flexible(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.secondaryLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: widget.specialists.length,
                  separatorBuilder: (_, __) => const Gap(12),
                  itemBuilder: (context, index) {
                    final s = widget.specialists[index];
                    return InkWell(
                      onTap: () => setState(() => _selected = s),
                      child: Row(
                        children: [
                          // аватарка
                          Container(
                            width: 30,
                            height: 30,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),

                          Gap(6),

                          // имя
                          Text(s.name, style: AppFonts.c1Regular),
                          const Spacer(),

                          // радиобаттон
                          AppRadio(
                            value: index,
                            groupValue: widget.specialists.indexWhere(
                              (e) =>
                                  e.name == _selected.name &&
                                  e.role == _selected.role,
                            ),
                            onChanged: (_) => setState(() => _selected = s),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            const Gap(20),
            MainButton(
              title: 'Сохранить',
              onTap: () {
                widget.onSave(_selected);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
