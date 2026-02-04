import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/resources/resources.dart';

class ProfileSelectorPill extends StatefulWidget {
  const ProfileSelectorPill({
    super.key,
    this.options = const ['Вита', 'Офис 2', 'Салон 1'],
  });

  final List<String> options;

  @override
  State<ProfileSelectorPill> createState() => _ProfileSelectorPillState();
}

class _ProfileSelectorPillState extends State<ProfileSelectorPill> {
  late String _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.options.isNotEmpty ? widget.options.first : '';
  }

  @override
  void didUpdateWidget(covariant ProfileSelectorPill oldWidget) {
    if (oldWidget.options != widget.options && widget.options.isNotEmpty) {
      _selected = widget.options.first;
    }
    super.didUpdateWidget(oldWidget);
  }

  void _showMenu(BuildContext context) {
    final box = context.findRenderObject() as RenderBox?;
    final overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox?;
    if (box == null || overlay == null) return;

    final position = box.localToGlobal(Offset.zero, ancestor: overlay);
    final size = box.size;

    showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy + size.height + 4,
        position.dx + size.width,
        position.dy + size.height + 200,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      items: widget.options.map((name) {
        final isSelected = name == _selected;
        return PopupMenuItem<String>(
          value: name,
          child: Row(
            children: [
              if (isSelected)
                Icon(Icons.check, size: 18, color: AppColors.mainAccent),
              if (isSelected) const SizedBox(width: 8),
              Text(name),
            ],
          ),
        );
      }).toList(),
    ).then((value) {
      if (value != null) setState(() => _selected = value);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.options.isEmpty) return const SizedBox.shrink();

    return Builder(
      builder: (ctx) {
        return Material(
          color: AppColors.secondaryLight,
          borderRadius: BorderRadius.circular(300),
          child: InkWell(
            onTap: () => _showMenu(ctx),
            borderRadius: BorderRadius.circular(300),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // текст
                  Text(
                    _selected,
                    style: AppFonts.b2Medium.copyWith(
                      color: AppColors.primaryDark,
                    ),
                  ),
                  Gap(6),

                  // стрелка
                  Image.asset(
                    AppImages.arrowOutlinedDown,
                    color: AppColors.mainAccent,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
