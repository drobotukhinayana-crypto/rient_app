/// Утилиты для POST /appointments/{id}/transactions/.
class AppointmentTransactionUtils {
  AppointmentTransactionUtils._();

  /// Как в других mobile-запросах (создание записи, расписание).
  static const String mobileCaptcha = 'dummy';

  static String formatPriceDisplay(dynamic value) {
    if (value == null) return '0.00';
    if (value is num) return value.toStringAsFixed(2);
    final normalized = value.toString().replaceAll(',', '.').trim();
    final parsed = num.tryParse(normalized);
    return (parsed ?? 0).toStringAsFixed(2);
  }

  static int? parseId(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toInt();
    if (value is Map) {
      return parseId(value['id']);
    }
    return int.tryParse(value.toString());
  }

  static double? parsePayDue(Map<String, dynamic> appointmentJson) {
    final payDue = appointmentJson['pay_due'] ?? appointmentJson['sum'];
    if (payDue is num) return payDue.toDouble();
    if (payDue != null) {
      return double.tryParse(payDue.toString().replaceAll(',', '.'));
    }
    return null;
  }

  static int resolvePayPrice(Map<String, dynamic> appointmentJson) {
    final payDue = parsePayDue(appointmentJson);
    if (payDue != null) return payDue.round();
    return 0;
  }

  /// Тело POST — как на сайте: price + captcha, не id/price_display.
  static Map<String, dynamic> buildMobilePayPostBody({
    required int price,
    String paymentMethod = 'cash',
    String captcha = mobileCaptcha,
  }) {
    return {
      'price': price,
      'payment_method': paymentMethod,
      'type': 'pay',
      'payment_status': 1,
      'captcha': captcha,
    };
  }
}
