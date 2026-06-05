import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

const supportWhatsAppUrl = 'https://wa.me/79854230137';
const supportTelegramUrl = 'https://t.me/rientSupport';

final Uri supportWhatsAppUri = Uri.parse(supportWhatsAppUrl);
final Uri supportTelegramUri = Uri.parse(supportTelegramUrl);

/// Открывает WhatsApp / Telegram / другую внешнюю ссылку поддержки.
Future<bool> openSupportLink(
  Uri uri, {
  BuildContext? context,
}) async {
  try {
    final opened = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
    if (opened) return true;
  } catch (_) {}

  try {
    final opened = await launchUrl(uri, mode: LaunchMode.platformDefault);
    if (opened) return true;
  } catch (_) {}

  if (context != null && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Не удалось открыть ссылку')),
    );
  }
  return false;
}
