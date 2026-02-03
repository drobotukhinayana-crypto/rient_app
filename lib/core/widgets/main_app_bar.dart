import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({
    super.key,
    required this.title,
    this.rightWidget,
    this.showBackButton = true,
  });

  final String title;
  final Widget? rightWidget;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            // Левый виджет (стрелка)
            SizedBox(
              width: 24,
              child: showBackButton
                  ? GestureDetector(
                      onTap: () => context.pop(),
                      child: const Icon(Icons.arrow_back),
                    )
                  : const SizedBox.shrink(),
            ),
            // Заголовок по центру
            Expanded(
              child: Text(
                title,
                style: AppFonts.h1Semi,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            // Правый виджет (подстраивается под содержимое, по центру по вертикали)
            rightWidget != null
                ? IntrinsicWidth(child: Center(child: rightWidget))
                : const SizedBox(width: 24),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
