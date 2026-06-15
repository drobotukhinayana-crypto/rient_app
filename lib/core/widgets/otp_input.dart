import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';

class OtpInput extends StatefulWidget {
  const OtpInput({
    super.key,
    this.length = 6,
    this.hasError = false,
    this.autofocus = false,
    this.fieldBackgroundColor,
    this.idleBorderColor,
    this.onCompleted,
    this.onChanged,
  });

  final int length;
  final bool hasError;
  final bool autofocus;
  final Color? fieldBackgroundColor;
  final Color? idleBorderColor;
  final void Function(String code)? onCompleted;
  final void Function(String code)? onChanged;

  @override
  State<OtpInput> createState() => _OtpInputState();
}

class _OtpInputState extends State<OtpInput> {
  static const _cellSize = 40.0;
  static const _cellGap = 12.0;

  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    _controller.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);
    if (widget.autofocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _focusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _focusNode.removeListener(_onFocusChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    setState(() => _focused = _focusNode.hasFocus);
  }

  void _onTextChanged() {
    setState(() {});
    final code = _controller.text;
    widget.onChanged?.call(code);
    if (code.length == widget.length) {
      widget.onCompleted?.call(code);
    }
  }

  int get _activeCellIndex {
    if (!_focused) return -1;
    if (_controller.text.isEmpty) return 0;
    if (_controller.text.length >= widget.length) {
      return widget.length - 1;
    }
    return _controller.text.length;
  }

  double get _totalWidth =>
      widget.length * _cellSize + (widget.length - 1) * _cellGap;

  @override
  Widget build(BuildContext context) {
    final focusedBorderColor = widget.hasError
        ? AppColors.red
        : AppColors.themeAccent(context);

    return SizedBox(
      width: _totalWidth,
      height: _cellSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.length, (index) {
              final digit = index < _controller.text.length
                  ? _controller.text[index]
                  : '';
              return Padding(
                padding: EdgeInsets.only(left: index == 0 ? 0 : _cellGap),
                child: _OtpCell(
                  digit: digit,
                  isActive: index == _activeCellIndex,
                  hasError: widget.hasError,
                  focusedBorderColor: focusedBorderColor,
                  fieldBackgroundColor: widget.fieldBackgroundColor,
                  idleBorderColor: widget.idleBorderColor,
                ),
              );
            }),
          ),
          Positioned.fill(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              autofocus: false,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              enableSuggestions: false,
              autocorrect: false,
              showCursor: false,
              style: const TextStyle(color: Colors.transparent, fontSize: 1),
              decoration: const InputDecoration(
                counterText: '',
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(widget.length),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OtpCell extends StatelessWidget {
  const _OtpCell({
    required this.digit,
    required this.isActive,
    required this.hasError,
    required this.focusedBorderColor,
    this.fieldBackgroundColor,
    this.idleBorderColor,
  });

  final String digit;
  final bool isActive;
  final bool hasError;
  final Color focusedBorderColor;
  final Color? fieldBackgroundColor;
  final Color? idleBorderColor;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final resolvedBorderColor = hasError
        ? AppColors.red
        : isActive
        ? focusedBorderColor
        : (idleBorderColor ?? Colors.transparent);

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: fieldBackgroundColor ??
            (isDark ? AppColors.secondaryDarkLight : AppColors.secondaryLight),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: resolvedBorderColor,
          width: 1,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        digit,
        style: AppFonts.b1Semi.copyWith(
          color: hasError
              ? AppColors.red
              : isDark
              ? AppColors.primaryWhite
              : AppColors.primaryDark,
        ),
      ),
    );
  }
}
