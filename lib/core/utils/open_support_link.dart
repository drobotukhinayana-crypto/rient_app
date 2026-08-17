import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

const supportWhatsAppUrl = 'https://wa.me/79854230137';
const supportTelegramUrl = 'https://t.me/rientSupport';
const userAgreementUrl = 'https://rient.ru/doc/agreement_use_mobile_app.pdf';

final Uri supportWhatsAppUri = Uri.parse(supportWhatsAppUrl);
final Uri supportTelegramUri = Uri.parse(supportTelegramUrl);
final Uri userAgreementUri = Uri.parse(userAgreementUrl);

bool _pendingExternalLinkResumeRefresh = false;

/// После возврата из Safari/PDF на iOS Flutter-view иногда не перерисовывается.
void refreshAfterExternalLinkResume(VoidCallback refresh) {
  if (!_pendingExternalLinkResumeRefresh) return;
  _pendingExternalLinkResumeRefresh = false;
  refresh();
}

List<LaunchMode> _launchModesForUri(Uri uri) {
  // На iOS inAppBrowserView (SFSafariViewController) после закрытия PDF
  // иногда оставляет чёрный экран Flutter — открываем во внешнем Safari.
  if (defaultTargetPlatform == TargetPlatform.iOS) {
    return const [
      LaunchMode.externalApplication,
      LaunchMode.platformDefault,
    ];
  }

  return const [
    LaunchMode.inAppBrowserView,
    LaunchMode.externalApplication,
    LaunchMode.platformDefault,
  ];
}

/// Открывает внешнюю https-ссылку (PDF, сайт, deep link).
Future<bool> openExternalUrl(
  Uri uri, {
  BuildContext? context,
  String? failureMessage,
}) async {
  for (final mode in _launchModesForUri(uri)) {
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

/// Открывает пользовательское соглашение (PDF) во внешнем браузере на iOS.
Future<bool> openUserAgreement({BuildContext? context}) async {
  _pendingExternalLinkResumeRefresh = true;
  final opened = await openExternalUrl(
    userAgreementUri,
    context: context,
    failureMessage: 'Не удалось открыть пользовательское соглашение',
  );
  if (!opened) {
    _pendingExternalLinkResumeRefresh = false;
  }
  return opened;
}
