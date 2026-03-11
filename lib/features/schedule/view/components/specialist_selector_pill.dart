import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/features/schedule/view/components/specialist_select_dialog.dart';
import 'package:rient_app/resources/resources.dart';

/// Пилюля выбора специалиста: аватар, имя, роль, шеврон. По тапу открывает диалог.
class SpecialistSelectorPill extends StatefulWidget {
  const SpecialistSelectorPill({
    super.key,
    this.specialists = _defaultSpecialists,
    this.initialSelected,
    this.onSelected,
  });

  final List<SpecialistItem> specialists;
  final SpecialistItem? initialSelected;

  /// Вызывается при сохранении выбора в диалоге (чтобы сохранить выбор снаружи).
  final ValueChanged<SpecialistItem>? onSelected;

  static const _defaultSpecialists = [
    SpecialistItem(name: 'Иванов Иван', role: 'Барбер'),
    SpecialistItem(name: 'Иванова Алина', role: 'Барбер'),
    SpecialistItem(name: 'Иван Алин', role: 'Барбер'),
  ];

  @override
  State<SpecialistSelectorPill> createState() => _SpecialistSelectorPillState();
}

class _SpecialistSelectorPillState extends State<SpecialistSelectorPill> {
  late SpecialistItem _selected;

  @override
  void initState() {
    super.initState();
    _selected =
        widget.initialSelected ??
        (widget.specialists.isNotEmpty ? widget.specialists.first : _fallback);
  }

  static const _fallback = SpecialistItem(name: '—', role: '—');

  @override
  void didUpdateWidget(covariant SpecialistSelectorPill oldWidget) {
    if (widget.initialSelected != null &&
        widget.initialSelected != oldWidget.initialSelected) {
      _selected = widget.initialSelected!;
    } else if (widget.initialSelected == null &&
        widget.specialists.isNotEmpty &&
        _selected == _fallback) {
      _selected = widget.specialists.first;
    }
    super.didUpdateWidget(oldWidget);
  }

  Future<void> _openDialog() async {
    if (widget.specialists.isEmpty) return;
    await SpecialistSelectDialog.show(
      context,
      specialists: widget.specialists,
      initialSelected: _selected,
      onSave: (s) {
        setState(() => _selected = s);
        widget.onSelected?.call(s);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.secondaryLight,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: _openDialog,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              _PillAvatar(pictureUrl: _selected.pictureUrl),
              Gap(12),

              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // имя
                    Text(_selected.name, style: AppFonts.b2Medium),
                    Gap(2),

                    // роль
                    Text(
                      _selected.role,
                      style: AppFonts.c2Tabbar.copyWith(
                        color: AppColors.tabbarGrey,
                      ),
                    ),
                  ],
                ),
              ),

              // стрелка
              Image.asset(AppImages.arrowDown),
            ],
          ),
        ),
      ),
    );
  }
}

class _PillAvatar extends StatelessWidget {
  const _PillAvatar({this.pictureUrl});

  final String? pictureUrl;

  @override
  Widget build(BuildContext context) {
    if (pictureUrl != null && pictureUrl!.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          pictureUrl!,
          width: 40,
          height: 40,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _placeholder(),
        ),
      );
    }
    return _placeholder();
  }

  Widget _placeholder() {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }
}
