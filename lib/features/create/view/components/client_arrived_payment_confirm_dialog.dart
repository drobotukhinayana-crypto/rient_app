import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_decoration.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/core/widgets/loading_widget.dart';

/// Индекс статуса «Клиент пришел» в [defaultClientStatusOptions].
const int kClientArrivedStatusIndex = 2;

enum ClientArrivedPaymentDialogResult { pay, saveOnly, dismiss }

String formatPaymentPriceForApi(double amount) => amount.toStringAsFixed(2);

String formatPaymentPriceForDialog(double amount) {
  return '${amount.toStringAsFixed(2).replaceAll('.', ',')} ₽';
}

/// Первый шаг: «Вы уверены?» → «Оплатить» / «Нет, просто сохранить».
Future<ClientArrivedPaymentDialogResult?> showClientArrivedPaymentConfirmDialog({
  required BuildContext context,
  required int appointmentId,
}) {
  return showDialog<ClientArrivedPaymentDialogResult>(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withValues(alpha: 0.5),
    builder: (dialogContext) {
      final isDark = Theme.of(dialogContext).brightness == Brightness.dark;
      final surface = isDark ? AppColors.primaryDark : Colors.white;
      final onSurface = isDark ? AppColors.primaryWhite : AppColors.primaryDark;
      final muted = isDark ? AppColors.grey : AppColors.tabbarGrey;
      final accent = AppColors.themeAccent(dialogContext);
      final divider = isDark ? AppColors.secondaryDarkDark : AppColors.secondaryDark;

      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 40),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Container(
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.fromLTRB(16, 12, 12, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(
                      'Вы уверены?',
                      textAlign: TextAlign.center,
                      style: AppFonts.h4Medium.copyWith(color: onSurface),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Material(
                        color: isDark
                            ? AppColors.secondaryDarkDark
                            : const Color(0xFFE8F0FE),
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () => Navigator.of(dialogContext).pop(
                            ClientArrivedPaymentDialogResult.dismiss,
                          ),
                          child: const SizedBox(
                            width: 32,
                            height: 32,
                            child: Icon(Icons.close, size: 18),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Gap(12),
                Text(
                  'Провести оплату за запись №$appointmentId?',
                  textAlign: TextAlign.center,
                  style: AppFonts.b2Medium.copyWith(color: muted),
                ),
                const Gap(16),
                Divider(height: 1, thickness: 1, color: divider),
                const Gap(12),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(dialogContext).pop(
                      ClientArrivedPaymentDialogResult.pay,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accent,
                      foregroundColor: AppColors.primaryWhite,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: AppDecoration.borderRadius300,
                      ),
                    ),
                    child: Text(
                      'Оплатить',
                      style: AppFonts.b2Semi.copyWith(
                        color: AppColors.primaryWhite,
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(
                    ClientArrivedPaymentDialogResult.saveOnly,
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: accent,
                  ),
                  child: Text(
                    'Нет',
                    style: AppFonts.b2Medium.copyWith(color: accent),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

/// Второй шаг: подтверждение суммы → «Да» / «Нет»; при «Да» — [onConfirm] с лоадером.
Future<bool> showPaymentAmountConfirmDialog({
  required BuildContext context,
  required double amount,
  required Future<void> Function() onConfirm,
}) async {
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withValues(alpha: 0.5),
    builder: (dialogContext) => _PaymentAmountConfirmDialog(
      amount: amount,
      onConfirm: onConfirm,
    ),
  );
  return result ?? false;
}

class _PaymentAmountConfirmDialog extends StatefulWidget {
  const _PaymentAmountConfirmDialog({
    required this.amount,
    required this.onConfirm,
  });

  final double amount;
  final Future<void> Function() onConfirm;

  @override
  State<_PaymentAmountConfirmDialog> createState() =>
      _PaymentAmountConfirmDialogState();
}

class _PaymentAmountConfirmDialogState extends State<_PaymentAmountConfirmDialog> {
  bool _isProcessing = false;
  String? _errorMessage;

  Future<void> _onConfirmPayment() async {
    setState(() {
      _isProcessing = true;
      _errorMessage = null;
    });
    try {
      await widget.onConfirm();
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isProcessing = false;
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? AppColors.primaryDark : Colors.white;
    final onSurface = isDark ? AppColors.primaryWhite : AppColors.primaryDark;
    final muted = isDark ? AppColors.grey : AppColors.tabbarGrey;
    final accent = AppColors.themeAccent(context);
    final divider = isDark ? AppColors.secondaryDarkDark : AppColors.secondaryDark;
    final priceLabel = formatPaymentPriceForDialog(widget.amount);

    return PopScope(
      canPop: !_isProcessing,
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 48),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 320),
          child: Container(
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                  child: Text(
                    'Подтверждение',
                    style: AppFonts.h4Medium.copyWith(color: onSurface),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                  child: Text(
                    'Вы подтверждаете оплату на сумму $priceLabel?',
                    textAlign: TextAlign.center,
                    style: AppFonts.b2Medium.copyWith(color: muted),
                  ),
                ),
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: Text(
                      _errorMessage!,
                      textAlign: TextAlign.center,
                      style: AppFonts.c1Regular.copyWith(color: AppColors.red),
                    ),
                  ),
                if (_isProcessing)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                    child: Column(
                      children: [
                        const LoadingWidget(side: 28),
                        const Gap(12),
                        Text(
                          'Проводим оплату…',
                          textAlign: TextAlign.center,
                          style: AppFonts.b2Medium.copyWith(color: muted),
                        ),
                      ],
                    ),
                  )
                else ...[
                  Divider(height: 1, thickness: 1, color: divider),
                  SizedBox(
                    height: 48,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: _onConfirmPayment,
                            style: TextButton.styleFrom(
                              foregroundColor: accent,
                              shape: const RoundedRectangleBorder(),
                            ),
                            child: Text(
                              'Да',
                              style: AppFonts.b2Semi.copyWith(color: accent),
                            ),
                          ),
                        ),
                        Container(width: 1, height: 48, color: divider),
                        Expanded(
                          child: TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.red,
                              shape: const RoundedRectangleBorder(),
                            ),
                            child: Text(
                              'Нет',
                              style: AppFonts.b2Semi.copyWith(color: AppColors.red),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
