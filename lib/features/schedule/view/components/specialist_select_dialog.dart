import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_decoration.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/core/widgets/app_radio.dart';
import 'package:rient_app/core/widgets/main_button.dart';
import 'package:rient_app/resources/resources.dart';

class SpecialistItem {
  const SpecialistItem({
    required this.name,
    required this.role,
    this.id,
    this.pictureUrl,
  });
  final String name;
  final String role;
  final int? id;
  final String? pictureUrl;
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
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _selected = widget.initialSelected;
    _searchController.addListener(() {
      setState(
        () => _searchQuery = _searchController.text.trim().toLowerCase(),
      );
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<SpecialistItem> get _filteredSpecialists {
    if (_searchQuery.isEmpty) return widget.specialists;
    return widget.specialists.where((s) {
      return s.name.toLowerCase().contains(_searchQuery) ||
          s.role.toLowerCase().contains(_searchQuery);
    }).toList();
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
            TextField(
              controller: _searchController,
              onTapOutside: (_) => FocusScope.of(context).unfocus(),
              style: AppFonts.c1Regular,
              decoration: InputDecoration(
                hintText: 'Поиск',
                hintStyle: AppFonts.c1Regular.copyWith(color: AppColors.grey),
                filled: true,
                fillColor: AppColors.secondaryLight,
                border: OutlineInputBorder(
                  borderRadius: AppDecoration.borderRadius300,
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
            const Gap(12),
            Flexible(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.secondaryLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: _filteredSpecialists.length,
                  separatorBuilder: (_, __) => const Gap(12),
                  itemBuilder: (context, index) {
                    final s = _filteredSpecialists[index];
                    final originalIndex = widget.specialists.indexWhere(
                      (e) => e.name == s.name && e.role == s.role,
                    );
                    return InkWell(
                      onTap: () => setState(() => _selected = s),
                      child: Row(
                        children: [
                          _SpecialistAvatarSmall(pictureUrl: s.pictureUrl),
                          Gap(6),
                          Text(s.name, style: AppFonts.c1Regular),
                          const Spacer(),
                          AppRadio(
                            value: originalIndex,
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

class _SpecialistAvatarSmall extends StatelessWidget {
  const _SpecialistAvatarSmall({this.pictureUrl});

  final String? pictureUrl;

  @override
  Widget build(BuildContext context) {
    if (pictureUrl != null && pictureUrl!.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          pictureUrl!,
          width: 30,
          height: 30,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _placeholder(),
        ),
      );
    }
    return _placeholder();
  }

  Widget _placeholder() {
    return Container(
      width: 30,
      height: 30,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }
}
