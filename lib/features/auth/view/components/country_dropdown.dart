import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_decoration.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/resources/resources.dart';

class CountryDropdown extends StatefulWidget {
  const CountryDropdown({
    super.key,
    this.label = 'Страна',
    this.initialCountry,
    this.onCountrySelected,
  });

  final String label;
  final Country? initialCountry;
  final void Function(Country country)? onCountrySelected;

  @override
  State<CountryDropdown> createState() => _CountryDropdownState();
}

class _CountryDropdownState extends State<CountryDropdown> {
  late Country _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialCountry ?? Country.tryParse('RU')!;
  }

  @override
  void didUpdateWidget(covariant CountryDropdown oldWidget) {
    if (widget.initialCountry != null && widget.initialCountry != _selected) {
      _selected = widget.initialCountry!;
    }
    super.didUpdateWidget(oldWidget);
  }

  void _openPicker() {
    showCountryPicker(
      context: context,
      showPhoneCode: false,
      onSelect: (Country country) {
        setState(() => _selected = country);
        widget.onCountrySelected?.call(country);
      },
      countryListTheme: CountryListThemeData(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        bottomSheetHeight: MediaQuery.of(context).size.height * 0.7,
        inputDecoration: InputDecoration(
          hintText: 'Поиск',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: AppFonts.c1Medium.copyWith(color: AppColors.primaryDark),
        ),
        const Gap(8),
        GestureDetector(
          onTap: () {},
          // _openPicker,
          behavior: HitTestBehavior.opaque,
          child: Container(
            height: 45,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.secondaryDarkLight
                  : AppColors.secondaryLight,
              borderRadius: AppDecoration.borderRadius300,
            ),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                ClipOval(
                  child: SizedBox(
                    width: 28,
                    height: 28,
                    child: Center(
                      child: Text(
                        _selected.flagEmoji,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ),
                const Gap(4),
                Expanded(
                  child: Text(
                    _selected.name,
                    style: AppFonts.c1Regular,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Image.asset(AppImages.arrowDown),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
