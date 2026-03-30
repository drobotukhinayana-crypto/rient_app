import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:rient_app/core/providers/locale_provider.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/resources/resources.dart';

const _supportedLanguageCodes = [
  'az',
  'be',
  'en',
  'hy',
  'kk',
  'ky',
  'ru',
  'ro',
  'tg',
  'uk',
  'uz',
];
const _languageNames = {
  'az': 'Azərbaycanca',
  'be': 'Беларуская',
  'en': 'English',
  'hy': 'Հայերեն',
  'kk': 'Қазақ тілі',
  'ky': 'Кыргыз тили',
  'ru': 'Русский',
  'ro': 'Română',
  'tg': 'Тоҷикӣ',
  'uk': 'Українська',
  'uz': 'Oʻzbekcha',
};

class LanguageDropdownPill extends ConsumerWidget {
  const LanguageDropdownPill({super.key, this.showLeadingIcon = true});

  final bool showLeadingIcon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final locale = ref.watch(localeProvider);
    final code = locale.languageCode;
    final name = _languageNames[code] ?? _languageNames['ru']!;

    return Material(
      color: isDark ? AppColors.secondaryDarkLight : AppColors.secondaryLight,
      borderRadius: BorderRadius.circular(300),
      child: InkWell(
        onTap: () => _showMenu(context, ref, code),
        borderRadius: BorderRadius.circular(300),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showLeadingIcon) Image.asset(AppImages.language),
              if (showLeadingIcon) const Gap(6),
              Text(name, style: AppFonts.c1Regular),
              const Gap(12),
              Image.asset(AppImages.arrowDown),
            ],
          ),
        ),
      ),
    );
  }

  void _showMenu(BuildContext context, WidgetRef ref, String currentCode) {
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
      items: _supportedLanguageCodes.map((code) {
        final isSelected = code == currentCode;
        return PopupMenuItem<String>(
          value: code,
          child: Row(
            children: [
              if (isSelected)
                Icon(
                  Icons.check,
                  size: 18,
                  color: AppColors.themeAccent(context),
                ),
              if (isSelected) const SizedBox(width: 8),
              Text(_languageNames[code] ?? code),
            ],
          ),
        );
      }).toList(),
    ).then((value) {
      if (value != null) {
        ref.read(localeProvider.notifier).setLocale(value);
      }
    });
  }
}
