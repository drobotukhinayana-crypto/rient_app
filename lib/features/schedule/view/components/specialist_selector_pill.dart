import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/core/widgets/worker_avatar_image.dart';
import 'package:rient_app/features/schedule/view/components/specialist_select_dialog.dart';
import 'package:rient_app/resources/resources.dart';

/// Карточка специалиста: аватар, имя, роль. При нескольких мастерах — шеврон и выбор по тапу.
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

  bool get _isSelectable => widget.specialists.length > 1;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? AppColors.secondaryDarkLight : AppColors.secondaryLight;
    final primaryText = isDark ? AppColors.primaryDarkDark : AppColors.primaryDark;
    final secondaryText = isDark ? AppColors.tabbarGreyDark : AppColors.tabbarGrey;
    final content = Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          _PillAvatar(pictureUrl: _selected.pictureUrl, name: _selected.name),
          const Gap(12),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _selected.name,
                  style: AppFonts.b2Medium.copyWith(color: primaryText),
                ),
                const Gap(2),
                Text(
                  _selected.role,
                  style: AppFonts.c2Tabbar.copyWith(
                    color: secondaryText,
                  ),
                ),
              ],
            ),
          ),
          if (_isSelectable)
            Image.asset(
              AppImages.arrowDown,
              color: AppColors.themeAccent(context),
            ),
        ],
      ),
    );

    return Material(
      color: surface,
      borderRadius: BorderRadius.circular(20),
      child: _isSelectable
          ? InkWell(
              onTap: _openDialog,
              borderRadius: BorderRadius.circular(20),
              child: content,
            )
          : content,
    );
  }
}

class _PillAvatar extends StatelessWidget {
  const _PillAvatar({this.pictureUrl, required this.name});

  final String? pictureUrl;
  final String name;

  @override
  Widget build(BuildContext context) {
    return WorkerAvatarImage(
      pictureUrl: pictureUrl,
      name: name,
      size: 40,
      placeholder: _placeholder(context),
    );
  }

  Widget _placeholder(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final initials = _extractInitials(name);
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isDark ? AppColors.secondaryDarkDark : Colors.white,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: AppFonts.c1Medium.copyWith(
          color: AppColors.themeAccent(context),
        ),
      ),
    );
  }

  String _extractInitials(String fullName) {
    final parts = fullName
        .trim()
        .split(RegExp(r'\s+'))
        .where((e) => e.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '—';
    final first = parts[0].substring(0, 1).toUpperCase();
    if (parts.length == 1) return first;
    final second = parts[1].substring(0, 1).toUpperCase();
    return '$first$second';
  }
}
