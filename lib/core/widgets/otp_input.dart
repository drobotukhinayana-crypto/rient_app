import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';

class OtpInput extends StatefulWidget {
  const OtpInput({
    super.key,
    this.length = 4,
    this.hasError = false,
    this.onCompleted,
    this.onChanged,
  });

  final int length;
  final bool hasError;
  final void Function(String code)? onCompleted;
  final void Function(String code)? onChanged;

  @override
  State<OtpInput> createState() => _OtpInputState();
}

class _OtpInputState extends State<OtpInput> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (i) {
      return FocusNode(onKeyEvent: (node, event) => _onKeyDown(i, node, event));
    });
    for (var i = 0; i < widget.length; i++) {
      _controllers[i].addListener(_onTextChanged);
    }
  }

  @override
  void dispose() {
    for (var i = 0; i < widget.length; i++) {
      _controllers[i].removeListener(_onTextChanged);
      _controllers[i].dispose();
      _focusNodes[i].dispose();
    }
    super.dispose();
  }

  void _onTextChanged() {
    final code = _getCode();
    widget.onChanged?.call(code);
    if (code.length == widget.length) {
      widget.onCompleted?.call(code);
    }
  }

  String _getCode() {
    return _controllers.map((c) => c.text).join();
  }

  void _onFieldChanged(int index, String value) {
    if (value.length > 1) {
      final digits = value
          .replaceAll(RegExp(r'\D'), '')
          .split('')
          .take(widget.length)
          .toList();
      for (var i = 0; i < widget.length; i++) {
        _controllers[i].text = i < digits.length ? digits[i] : '';
      }
      if (digits.isNotEmpty) {
        final nextIndex = digits.length.clamp(0, widget.length - 1);
        _focusNodes[nextIndex].requestFocus();
      }
      return;
    }
    if (value.isNotEmpty) {
      _controllers[index].text = value[value.length - 1];
      if (index < widget.length - 1) {
        _focusNodes[index + 1].requestFocus();
      }
    }
  }

  KeyEventResult _onKeyDown(int index, FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    if (event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _focusNodes[index - 1].requestFocus();
      _controllers[index - 1].clear();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = widget.hasError ? AppColors.red : Colors.transparent;
    final focusedBorderColor = widget.hasError
        ? AppColors.red
        : AppColors.mainAccent;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.length, (index) {
        return Padding(
          padding: EdgeInsets.only(left: index == 0 ? 0 : 12),
          child: _OtpDigitField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            maxLength: index == 0 ? 4 : 1,
            hasError: widget.hasError,
            borderColor: borderColor,
            focusedBorderColor: focusedBorderColor,
            onChanged: (value) => _onFieldChanged(index, value),
          ),
        );
      }),
    );
  }
}

class _OtpDigitField extends StatefulWidget {
  const _OtpDigitField({
    required this.controller,
    required this.focusNode,
    required this.maxLength,
    required this.hasError,
    required this.borderColor,
    required this.focusedBorderColor,
    required this.onChanged,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final int maxLength;
  final bool hasError;
  final Color borderColor;
  final Color focusedBorderColor;
  final void Function(String) onChanged;

  @override
  State<_OtpDigitField> createState() => _OtpDigitFieldState();
}

class _OtpDigitFieldState extends State<_OtpDigitField> {
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChange);
    super.dispose();
  }

  void _onFocusChange() {
    setState(() => _focused = widget.focusNode.hasFocus);
  }

  @override
  Widget build(BuildContext context) {
    final isFocused = _focused;
    final borderColor = isFocused
        ? widget.focusedBorderColor
        : widget.borderColor;
    final showBorder = isFocused || widget.hasError;

    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.secondaryLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: showBorder ? borderColor : Colors.transparent,
          width: 1,
        ),
      ),
      child: TextFormField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: widget.maxLength,
        style: AppFonts.b1Semi.copyWith(
          color: widget.hasError ? AppColors.red : AppColors.primaryDark,
        ),
        cursorColor: widget.hasError ? AppColors.red : AppColors.mainAccent,
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: widget.onChanged,
      ),
    );
  }
}
