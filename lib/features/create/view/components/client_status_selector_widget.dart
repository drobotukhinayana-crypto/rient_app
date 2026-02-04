import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/resources/resources.dart';

/// Вариант статуса клиента для выбора в записи.
class ClientStatusOption {
  const ClientStatusOption({
    required this.label,
    required this.dotColor,
    required this.backgroundColor,
    required this.borderColor,
  });

  final String label;
  final Color dotColor;

  /// Цвет фона кнопки выбранного статуса.
  final Color backgroundColor;

  /// Цвет обводки кнопки выбранного статуса.
  final Color borderColor;
}

/// Список статусов по умолчанию (Не подтвержден, Подтвержден, Клиент пришел, и т.д.).
const List<ClientStatusOption> defaultClientStatusOptions = [
  ClientStatusOption(
    label: 'Не подтвержден',
    dotColor: Color(0xFFFFA500),
    backgroundColor: Color(0x33FFA500),
    borderColor: Color(0xFFFFA500),
  ),
  ClientStatusOption(
    label: 'Подтвержден',
    dotColor: Color(0xffBA28FD),
    backgroundColor: Color(0xffEDD9F8),
    borderColor: Color(0xffBA28FD),
  ),
  ClientStatusOption(
    label: 'Клиент пришел',
    dotColor: Color(0xFF228B22),
    backgroundColor: Color(0xFFD9F8DA),
    borderColor: Color(0xFF228B22),
  ),
  ClientStatusOption(
    label: 'Клиент не пришел',
    dotColor: Color(0xFFDC143C),
    backgroundColor: Color(0x33DC143C),
    borderColor: Color(0xFFDC143C),
  ),
  ClientStatusOption(
    label: 'Отменен',
    dotColor: Color(0xFF8B0000),
    backgroundColor: Color(0x338B0000),
    borderColor: Color(0xFF8B0000),
  ),
];

/// Виджет выбора статуса клиента: заголовок "Клиент", кнопка с выбранным
/// статусом (стрелка вверх/вниз), при раскрытии — список опций с цветной точкой.
class ClientStatusSelectorWidget extends StatefulWidget {
  const ClientStatusSelectorWidget({
    super.key,
    this.options = defaultClientStatusOptions,
    this.initialIndex = 1,
    this.onSelected,
  });

  final List<ClientStatusOption> options;
  final int initialIndex;
  final void Function(int index, ClientStatusOption option)? onSelected;

  @override
  State<ClientStatusSelectorWidget> createState() =>
      _ClientStatusSelectorWidgetState();
}

class _ClientStatusSelectorWidgetState
    extends State<ClientStatusSelectorWidget> {
  late int _selectedIndex;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex.clamp(0, widget.options.length - 1);
  }

  @override
  void didUpdateWidget(covariant ClientStatusSelectorWidget oldWidget) {
    if (oldWidget.initialIndex != widget.initialIndex) {
      _selectedIndex = widget.initialIndex.clamp(0, widget.options.length - 1);
    }
    super.didUpdateWidget(oldWidget);
  }

  void _toggleExpanded() {
    setState(() => _isExpanded = !_isExpanded);
  }

  void _select(int index) {
    setState(() {
      _selectedIndex = index;
      _isExpanded = false;
    });
    widget.onSelected?.call(index, widget.options[index]);
  }

  @override
  Widget build(BuildContext context) {
    final option = widget.options[_selectedIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Клиент',
          style: AppFonts.b1Medium.copyWith(color: AppColors.primaryDark),
        ),

        Gap(12),
        GestureDetector(
          onTap: _toggleExpanded,
          behavior: HitTestBehavior.opaque,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: option.backgroundColor,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: option.borderColor, width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(option.label, style: AppFonts.c1Regular),
                Gap(8),
                Image.asset(
                  _isExpanded ? AppImages.arrowTop : AppImages.arrowDown,
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ),
        if (_isExpanded) ...[
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: AppColors.secondaryLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (int i = 0; i < widget.options.length; i++) ...[
                    _OptionTile(
                      option: widget.options[i],
                      isSelected: i == _selectedIndex,
                      onTap: () => _select(i),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  final ClientStatusOption option;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.secondaryLight,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // круг
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: option.dotColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),

              // название
              Expanded(
                child: Text(
                  option.label,
                  style: AppFonts.b2Regular.copyWith(
                    color: AppColors.primaryDark,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
