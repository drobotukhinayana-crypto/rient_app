import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/features/link/service/widget_links_service.dart';

final widgetLinkUrlProvider = FutureProvider<String>((ref) async {
  final service = ref.watch(widgetLinksServiceProvider);
  return service.getWidgetUrl();
});
