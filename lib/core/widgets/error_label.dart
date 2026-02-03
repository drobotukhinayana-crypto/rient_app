import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';

class ErrorLabel extends ConsumerWidget {
  const ErrorLabel(
    this.text, {
    super.key,
    this.alignment = Alignment.centerLeft,
  });
  final String text;
  final Alignment alignment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCenter = alignment == Alignment.center;
    return Align(
      alignment: alignment,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: isCenter
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          const Gap(10),
          Text(
            text,
            textAlign: isCenter ? TextAlign.center : TextAlign.left,
            style: AppFonts.c2Tabbar.copyWith(color: AppColors.red),
          ),
        ],
      ),
    );
  }
}
