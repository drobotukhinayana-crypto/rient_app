import 'package:flutter/material.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/core/widgets/default_container.dart';

class ServicesTodayGridView extends StatelessWidget {
  const ServicesTodayGridView({super.key});

  static const _items = [
    ('Маникюр', 2),
    ('Педикюр', 4),
    ('Стрижка', 2),
    ('Укладка', 4),
    ('Маникюр', 2),
    ('Педикюр', 4),
    ('Стрижка', 2),
    ('Укладка', 4),
    ('Маникюр', 2),
    ('Педикюр', 4),
    ('Стрижка', 2),
    ('Укладка', 4),
    ('Маникюр', 2),
    ('Педикюр', 4),
    ('Стрижка', 2),
    ('Укладка', 4),
    ('Маникюр', 2),
    ('Педикюр', 4),
    ('Стрижка', 2),
    ('Укладка', 4),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(vertical: 12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 3.5,
      ),
      itemCount: _items.length,
      itemBuilder: (context, index) {
        final item = _items[index];
        return DefaultContainerWidget(
          color: Colors.white,
          hasShadow: false,
          borderRadius: BorderRadius.circular(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(item.$1, style: AppFonts.b2Medium),
              Text(
                '${item.$2}',
                style: AppFonts.b2Semi.copyWith(color: AppColors.mainAccent),
              ),
            ],
          ),
        );
      },
    );
  }
}
