import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_decoration.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/resources/resources.dart';

class MainTextField extends ConsumerStatefulWidget {
  const MainTextField({
    required this.controller,
    required this.hintText,
    super.key,
    this.isPassword = false,
    this.hasError = false,
    this.isMultiline = false,
    this.maxLines = 3,
    this.canEdit = true,
    this.label,
    this.onChanged,
    this.inputFormatters,
    this.borderRadius,
  });

  final TextEditingController controller;
  final String hintText;
  final bool isPassword;
  final bool hasError;
  final bool isMultiline;
  final int? maxLines;
  final bool canEdit;
  final String? label;
  final void Function(String value)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final BorderRadius? borderRadius;

  @override
  ConsumerState<MainTextField> createState() => _MainTextFieldState();
}

class _MainTextFieldState extends ConsumerState<MainTextField> {
  bool isHidden = true;
  late bool hasError = widget.hasError;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() => setState(() {});

  Widget _buildSuffixIcon() {
    final showClose = widget.controller.text.length > 1;
    if (widget.isPassword) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {
              isHidden = !isHidden;
              setState(() {});
            },
            icon: isHidden
                ? Image.asset(AppImages.eyeShowLine)
                : Image.asset(AppImages.eyeHideLine),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
          ),
          if (showClose)
            GestureDetector(
              onTap: () => widget.controller.clear(),
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Image.asset(AppImages.close),
              ),
            ),
        ],
      );
    }
    if (showClose) {
      return GestureDetector(
        onTap: () => widget.controller.clear(),
        child: Image.asset(AppImages.close),
      );
    }
    return const SizedBox(height: 4, width: 4);
  }

  @override
  void didUpdateWidget(covariant MainTextField oldWidget) {
    hasError = widget.hasError;
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onTextChanged);
      widget.controller.addListener(_onTextChanged);
    }
    setState(() {});
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final border = OutlineInputBorder(
      borderRadius: widget.borderRadius ?? AppDecoration.borderRadius300,
      borderSide: BorderSide.none,
    );

    final errorBorder = OutlineInputBorder(
      borderRadius: widget.borderRadius ?? AppDecoration.borderRadius300,
      borderSide: const BorderSide(color: AppColors.red),
    );

    final focusedBorder = OutlineInputBorder(
      borderRadius: widget.borderRadius ?? AppDecoration.borderRadius300,
      borderSide: BorderSide.none,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(widget.label!, style: AppFonts.c1Medium),
          const Gap(8),
        ],
        TextField(
          enabled: widget.canEdit,
          maxLines: widget.isMultiline ? (widget.maxLines) : 1,
          minLines: widget.isMultiline ? (widget.maxLines ?? 5) : 1,
          cursorColor: AppColors.primaryDark,
          onTapOutside: (_) => FocusScope.of(context).unfocus(),
          onChanged: widget.onChanged,
          controller: widget.controller,
          obscureText: widget.isPassword && isHidden,
          obscuringCharacter: '*',
          style: AppFonts.c1Regular,
          inputFormatters: widget.inputFormatters,
          decoration: InputDecoration(
            filled: true,
            fillColor: widget.canEdit
                ? isDark
                      ? AppColors.secondaryDarkLight
                      : AppColors.secondaryLight
                : AppColors.grey,
            suffixIcon: _buildSuffixIcon(),
            prefixIconConstraints: const BoxConstraints(),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: border,
            focusedBorder: widget.hasError ? errorBorder : focusedBorder,
            errorBorder: errorBorder,
            enabledBorder: widget.hasError ? errorBorder : border,
            disabledBorder: border,
            focusedErrorBorder: errorBorder,
            hintText: widget.hintText,
            hintStyle: AppFonts.c1Regular.copyWith(color: AppColors.grey),
          ),
        ),
      ],
    );
  }
}
