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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? AppColors.primaryWhiteDark : Colors.white;
    final listSurface = isDark ? AppColors.secondaryDarkLight : AppColors.secondaryLight;
    final primaryText = isDark ? AppColors.primaryDarkDark : AppColors.primaryDark;
    final secondaryText = isDark ? AppColors.tabbarGreyDark : AppColors.grey;

    return Dialog(
      backgroundColor: surface,
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
                Text(
                  'Выбрать специалиста',
                  style: AppFonts.h4Medium.copyWith(color: primaryText),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Image.asset(
                    AppImages.closeRounded,
                    color: secondaryText,
                  ),
                ),
              ],
            ),
            const Gap(16),
            TextField(
              controller: _searchController,
              onTapOutside: (_) => FocusScope.of(context).unfocus(),
              style: AppFonts.c1Regular.copyWith(color: primaryText),
              decoration: InputDecoration(
                hintText: 'Поиск',
                hintStyle: AppFonts.c1Regular.copyWith(color: secondaryText),
                filled: true,
                fillColor: listSurface,
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
                  color: listSurface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _filteredSpecialists.isEmpty
                    ? Center(
                        child: Text(
                          'Специалист не найден',
                          style: AppFonts.c1Regular.copyWith(
                            color: secondaryText,
                          ),
                        ),
                      )
                    : ListView.separated(
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
                                _SpecialistAvatarSmall(
                                  pictureUrl: s.pictureUrl,
                                  name: s.name,
                                ),
                                Gap(6),
                                Text(
                                  s.name,
                                  style: AppFonts.c1Regular.copyWith(
                                    color: primaryText,
                                  ),
                                ),
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
  const _SpecialistAvatarSmall({this.pictureUrl, required this.name});

  final String? pictureUrl;
  final String name;

  @override
  Widget build(BuildContext context) {
    if (pictureUrl != null && pictureUrl!.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          pictureUrl!,
          width: 30,
          height: 30,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _placeholder(context),
        ),
      );
    }
    return _placeholder(context);
  }

  Widget _placeholder(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final initials = _extractInitials(name);
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: isDark ? AppColors.secondaryDarkDark : Colors.white,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: AppFonts.c0Regular.copyWith(
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
