import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/core/widgets/app_service_message.dart';
import 'package:rient_app/features/link/view/providers/widget_link_provider.dart';
import 'package:share_plus/share_plus.dart';

class WidgetLinkShare {
  static Future<void> open(BuildContext context, WidgetRef ref) async {
    if (!context.mounted) return;

    try {
      final url = await ref.read(widgetLinkUrlProvider.future);
      if (!context.mounted) return;
      await shareUrl(context, url);
    } catch (_) {
      if (!context.mounted) return;
      showAppServiceMessage(
        context,
        message: 'Не удалось получить ссылку',
        variant: AppServiceMessageVariant.error,
      );
    }
  }

  static Future<void> shareUrl(BuildContext context, String url) async {
    await Clipboard.setData(ClipboardData(text: url));
    if (!context.mounted) return;

    showAppServiceMessage(context, message: 'Ссылка скопирована');

    try {
      final box = context.findRenderObject() as RenderBox?;
      final origin = box != null
          ? box.localToGlobal(Offset.zero) & box.size
          : null;

      await SharePlus.instance.share(
        ShareParams(
          text: url,
          subject: 'Ссылка на онлайн-запись',
          sharePositionOrigin: origin,
        ),
      );
    } on MissingPluginException {
      if (context.mounted) _showShareUnavailable(context);
    } catch (_) {
      if (context.mounted) _showShareUnavailable(context);
    }
  }

  static void _showShareUnavailable(BuildContext context) {
    if (!context.mounted) return;
    showAppServiceMessage(
      context,
      message:
          'Меню «Поделиться» недоступно. Ссылка уже в буфере — вставьте вручную.',
      variant: AppServiceMessageVariant.info,
    );
  }
}
