import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

const supportWhatsAppUrl = 'https://wa.me/79854230137';
const supportTelegramUrl = 'https://t.me/rientSupport';

final Uri supportWhatsAppUri = Uri.parse(supportWhatsAppUrl);
final Uri supportTelegramUri = Uri.parse(supportTelegramUrl);

/// Открывает внешнюю https-ссылку (PDF, сайт, deep link).
Future<bool> openExternalUrl(
  Uri uri, {
  BuildContext? context,
  String? failureMessage,
}) async {
  const modes = <LaunchMode>[
    LaunchMode.inAppBrowserView,
    LaunchMode.externalApplication,
    LaunchMode.platformDefault,
  ];

  for (final mode in modes) {
    try {
      final opened = await launchUrl(uri, mode: mode);
      if (opened) return true;
    } catch (_) {}
  }

  if (context != null && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(failureMessage ?? 'Не удалось открыть ссылку'),
      ),
    );
  }
  return false;
}

/// Открывает WhatsApp / Telegram / другую внешнюю ссылку поддержки.
Future<bool> openSupportLink(
  Uri uri, {
  BuildContext? context,
}) async {
  return openExternalUrl(uri, context: context);
}
