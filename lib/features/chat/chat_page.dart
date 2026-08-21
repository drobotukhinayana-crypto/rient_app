import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:rient_app/core/keys/app_shell_scaffold_key.dart';
import 'package:rient_app/core/utils/app_exit_handler.dart';
import 'package:rient_app/core/utils/open_support_link.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_decoration.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/core/widgets/app_service_message.dart';
import 'package:rient_app/core/widgets/app_refresh_indicator.dart';
import 'package:rient_app/core/widgets/date_range_picker_dialog.dart';
import 'package:rient_app/core/widgets/default_container.dart';
import 'package:rient_app/core/network/app_connectivity_provider.dart';
import 'package:rient_app/core/network/app_offline.dart';
import 'package:rient_app/core/network/connectivity_recovery_listener.dart';
import 'package:rient_app/core/widgets/loading_widget.dart';
import 'package:rient_app/core/widgets/offline_message.dart';
import 'package:rient_app/core/widgets/schedule_offline_banner.dart';
import 'package:rient_app/features/auth/view/providers/organization_id_provider.dart';
import 'package:rient_app/features/chat/service/mobile_push_service.dart';
import 'package:rient_app/features/chat/view/components/message_notification_card.dart';
import 'package:rient_app/features/chat/view/components/message_notification_item.dart';
import 'package:rient_app/features/chat/view/components/messages_filter_segment.dart';
import 'package:rient_app/features/chat/service/notifications_websocket_service.dart';
import 'package:rient_app/features/chat/view/providers/push_history_provider.dart';
import 'package:rient_app/features/chat/view/push_history_mapper.dart';
import 'package:rient_app/features/create/view/add_new_entry_page.dart';
import 'package:rient_app/features/home/view/components/entity_selector_pill.dart';
import 'package:rient_app/features/home/view/providers/branches_provider.dart';
import 'package:rient_app/features/schedule/service/appointments_service.dart';
import 'package:rient_app/resources/resources.dart';

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({super.key});

  static const name = 'chat_page';
  static const path = '/chat_page';

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  MessagesFilter _filter = MessagesFilter.unread;
  AppDateRangePickerResult? _dateRange;
  final List<MessageNotificationItem> _items = [];
  final ScrollController _scrollController = ScrollController();

  int _page = 1;
  bool _hasMore = true;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _errorMessage;
  int? _openingNotificationId;
  int? _markingReadNotificationId;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.read(appNoConnectionProvider)) return;
      unawaited(_loadFirstPage());
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  PushHistoryListQuery get _listQuery => PushHistoryListQuery(
    isRead: _filter == MessagesFilter.read,
    datetimeGte: _dateRange?.start,
    datetimeLte: _dateRange?.end != null
        ? DateTime(
            _dateRange!.end!.year,
            _dateRange!.end!.month,
            _dateRange!.end!.day,
            23,
            59,
            59,
          )
        : null,
    page: _page,
  );

  void _onScroll() {
    if (!_hasMore || _isLoading || _isLoadingMore) return;
    if (_scrollController.position.pixels <
        _scrollController.position.maxScrollExtent - 200) {
      return;
    }
    unawaited(_loadNextPage());
  }

  Future<void> _loadFirstPage() async {
    if (ref.read(appNoConnectionProvider)) return;

    setState(() {
      _page = 1;
      _hasMore = true;
      _items.clear();
      _isLoading = true;
      _isLoadingMore = false;
      _errorMessage = null;
    });

    try {
      final response = await ref.read(
        pushHistoryListProvider(_listQuery.copyWith(page: 1)).future,
      );
      if (!mounted) return;
      setState(() {
        _items.addAll(response.results.map(messageNotificationItemFromPush));
        _hasMore = response.next != null && response.next!.isNotEmpty;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'Не удалось загрузить сообщения';
      });
    }
  }

  Future<void> _loadNextPage() async {
    if (!_hasMore || _isLoadingMore) return;
    setState(() => _isLoadingMore = true);
    final nextPage = _page + 1;

    try {
      final response = await ref.read(
        pushHistoryListProvider(_listQuery.copyWith(page: nextPage)).future,
      );
      if (!mounted) return;
      setState(() {
        _page = nextPage;
        _items.addAll(response.results.map(messageNotificationItemFromPush));
        _hasMore = response.next != null && response.next!.isNotEmpty;
        _isLoadingMore = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoadingMore = false);
    }
  }

  Future<void> _markNotificationRead(
    MessageNotificationItem item, {
    bool showCardLoader = true,
  }) async {
    if (!item.isUnread) return;
    if (showCardLoader &&
        (_markingReadNotificationId != null || _openingNotificationId != null)) {
      return;
    }

    if (showCardLoader) {
      setState(() => _markingReadNotificationId = item.id);
    }
    try {
      await ref
          .read(mobilePushServiceProvider)
          .markAsRead(id: item.id, isRead: true);
      if (!mounted) return;
      setState(() {
        if (_filter == MessagesFilter.unread) {
          _items.removeWhere((e) => e.id == item.id);
        } else {
          final index = _items.indexWhere((e) => e.id == item.id);
          if (index >= 0) {
            _items[index] = item.copyWith(
              isUnread: false,
              showAccent: false,
              accentIsWarning: false,
            );
          }
        }
      });
      invalidatePushHistory(ref);
    } catch (_) {
      if (!mounted) return;
      showAppServiceMessage(
        context,
        message: 'Не удалось отметить сообщение прочитанным',
        variant: AppServiceMessageVariant.error,
      );
    } finally {
      if (showCardLoader && mounted) {
        setState(() => _markingReadNotificationId = null);
      }
    }
  }

  Future<void> _markAllRead() async {
    try {
      await ref
          .read(mobilePushServiceProvider)
          .markAllAsRead(
            datetimeGte: _dateRange?.start,
            datetimeLte: _dateRange?.end != null
                ? DateTime(
                    _dateRange!.end!.year,
                    _dateRange!.end!.month,
                    _dateRange!.end!.day,
                    23,
                    59,
                    59,
                  )
                : null,
          );
      invalidatePushHistory(ref);
      if (!mounted) return;
      setState(() => _filter = MessagesFilter.read);
      await _loadFirstPage();
    } catch (_) {
      if (!mounted) return;
      showAppServiceMessage(
        context,
        message: 'Не удалось отметить все как прочитанные',
        variant: AppServiceMessageVariant.error,
      );
    }
  }

  Future<void> _openLicenseFromNotification(
    MessageNotificationItem item,
  ) async {
    if (_openingNotificationId != null) return;

    setState(() => _openingNotificationId = item.id);
    try {
      await _markNotificationRead(item, showCardLoader: false);
      if (!mounted) return;

      final paymentUrl = item.licensePaymentUrl;
      if (paymentUrl != null && paymentUrl.isNotEmpty) {
        final uri = Uri.tryParse(paymentUrl);
        if (uri != null) {
          await openExternalUrl(
            uri,
            context: context,
            failureMessage: 'Не удалось открыть страницу оплаты',
          );
        }
      }
    } finally {
      if (mounted) {
        setState(() => _openingNotificationId = null);
      }
    }
  }

  Future<void> _openAppointmentFromNotification(
    MessageNotificationItem item,
  ) async {
    final appointmentId = item.appointmentId;
    if (appointmentId == null || appointmentId <= 0) return;
    if (_openingNotificationId != null) return;

    setState(() => _openingNotificationId = item.id);
    try {
      await _markNotificationRead(item, showCardLoader: false);
      if (!mounted) return;

      final appointment = await ref
          .read(appointmentsServiceProvider)
          .getAppointmentById(appointmentId);
      if (!mounted) return;
      if (appointment == null) {
        showAppServiceMessage(
          context,
          message: 'Запись не найдена',
          variant: AppServiceMessageVariant.info,
        );
        return;
      }
      await context.pushNamed<bool>(AddNewEntryPage.name, extra: appointment);
    } catch (_) {
      if (!mounted) return;
      showAppServiceMessage(
        context,
        message: 'Не удалось открыть запись',
        variant: AppServiceMessageVariant.error,
      );
    } finally {
      if (mounted) {
        setState(() => _openingNotificationId = null);
      }
    }
  }

  Future<void> _openDateRangeDialog() async {
    final range = await AppDateRangePickerDialog.show(
      context,
      initialStart: _dateRange?.start,
      initialEnd: _dateRange?.end,
    );
    if (!mounted || range == null) return;
    setState(() {
      _dateRange = range.clearFilter ? null : range;
    });
    invalidatePushHistory(ref);
    await _loadFirstPage();
  }

  void _onFilterChanged(MessagesFilter value) {
    if (_filter == value) return;
    setState(() => _filter = value);
    unawaited(_loadFirstPage());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenBackground = isDark
        ? AppColors.secondaryDarkLight
        : AppColors.tabBarScreenBackground;
    final accent = AppColors.themeAccent(context);
    final noConnection = ref.watch(appNoConnectionProvider);

    ref.watch(connectivityRecoveryListenerProvider);

    ref.listen<bool>(appNoConnectionProvider, (previous, next) {
      if (previous == true && next == false) {
        unawaited(_loadFirstPage());
      }
    });

    ref.listen<int>(pushHistoryRefreshTokenProvider, (previous, next) {
      if (previous == null || previous == next) return;
      if (ref.read(appNoConnectionProvider)) return;
      unawaited(_loadFirstPage());
    });

    ref.listen<int>(organizationIdProvider, (previous, next) {
      if (previous == null || next <= 0 || previous == next) return;
      if (ref.read(appNoConnectionProvider)) return;
      invalidatePushHistory(ref);
      unawaited(_loadFirstPage());
    });

    ref.listen<int>(currentBranchIdProvider, (previous, next) {
      if (previous == null || previous <= 0 || next <= 0 || previous == next) {
        return;
      }
      if (ref.read(appNoConnectionProvider)) return;
      invalidatePushHistory(ref);
      unawaited(_loadFirstPage());
    });

    final countsAsync = ref.watch(pushHistoryCountProvider);

    final countsLoading = countsAsync.isLoading || countsAsync.isRefreshing;
    final unreadCount = countsAsync.maybeWhen(
      data: (c) => c.unread,
      orElse: () => 0,
    );
    final readCount = countsAsync.maybeWhen(
      data: (c) => (c.total - c.unread).clamp(0, c.total),
      orElse: () => 0,
    );

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        unawaited(handleAndroidBackButton(context));
      },
      child: Scaffold(
      backgroundColor: screenBackground,
      body: Column(
        children: [
          _MessagesHeader(
            isDark: isDark,
            onCalendarTap: noConnection ? null : _openDateRangeDialog,
            filter: _filter,
            unreadCount: unreadCount,
            readCount: readCount,
            countsLoading: countsLoading,
            onFilterChanged: noConnection ? null : _onFilterChanged,
          ),
          if (noConnection) const ScheduleOfflineBanner(message: appNoConnectionMessage),
          Expanded(
            child: noConnection
                ? const OfflineMessage()
                : _buildBody(isDark),
          ),
          if (!noConnection &&
              _filter == MessagesFilter.unread &&
              _items.isNotEmpty &&
              !_isLoading)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: _MessagesBottomActions(
                isDark: isDark,
                accent: accent,
                onMarkAllRead: _markAllRead,
              ),
            ),
        ],
      ),
    ),
    );
  }

  Future<void> _onPullToRefresh() async {
    invalidatePushHistory(ref);
    await _loadFirstPage();
    try {
      await ref.read(pushHistoryCountProvider.future);
    } catch (_) {}
  }

  Widget _buildBody(bool isDark) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final minHeight = constraints.maxHeight;

        if (_isLoading && _items.isEmpty) {
          return AppRefreshIndicator(
            onRefresh: _onPullToRefresh,
            child: ListView(
              physics: AppRefreshIndicator.scrollPhysics,
              children: [
                SizedBox(
                  height: minHeight,
                  child: const Center(child: LoadingWidget()),
                ),
              ],
            ),
          );
        }

        if (_errorMessage != null && _items.isEmpty) {
          return AppRefreshIndicator(
            onRefresh: _onPullToRefresh,
            child: ListView(
              physics: AppRefreshIndicator.scrollPhysics,
              children: [
                SizedBox(
                  height: minHeight,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _errorMessage!,
                          style: AppFonts.b2Regular.copyWith(
                            color: isDark
                                ? AppColors.tabbarGreyDark
                                : AppColors.primaryDark,
                          ),
                        ),
                        const Gap(12),
                        TextButton(
                          onPressed: _loadFirstPage,
                          child: const Text('Повторить'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        if (_items.isEmpty) {
          return AppRefreshIndicator(
            onRefresh: _onPullToRefresh,
            child: ListView(
              physics: AppRefreshIndicator.scrollPhysics,
              children: [
                SizedBox(
                  height: minHeight,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(AppImages.empty),
                        const Gap(12),
                        Text(
                          'Сообщений пока нет',
                          style: AppFonts.b2Regular.copyWith(
                            color: isDark
                                ? AppColors.tabbarGreyDark
                                : AppColors.primaryDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return AppRefreshIndicator(
          onRefresh: _onPullToRefresh,
          child: ListView.separated(
            controller: _scrollController,
            physics: AppRefreshIndicator.scrollPhysics,
            padding: AppDecoration.padding16.copyWith(top: 12),
            itemCount: _items.length + (_isLoadingMore ? 1 : 0),
            separatorBuilder: (_, __) => const Gap(10),
            itemBuilder: (context, index) {
              if (index >= _items.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Center(child: LoadingWidget(side: 24)),
                );
              }
              final item = _items[index];
              final appointmentId = item.appointmentId;
              final isOpening = _openingNotificationId == item.id;
              final isMarkingRead = _markingReadNotificationId == item.id;
              final isBusy = isOpening || isMarkingRead;
              return MessageNotificationCard(
                item: item,
                isOpening: isOpening,
                isMarkingRead: isMarkingRead,
                onView: item.isUnread && !isBusy
                    ? () => unawaited(_markNotificationRead(item))
                    : null,
                onOpenCard: appointmentId != null && !isBusy
                    ? () => unawaited(_openAppointmentFromNotification(item))
                    : null,
                onLicenseAction: item.isLicenseNotification &&
                        item.isUnread &&
                        !isBusy
                    ? () => unawaited(_openLicenseFromNotification(item))
                    : null,
              );
            },
          ),
        );
      },
    );
  }
}

class _MessagesHeader extends StatelessWidget {
  const _MessagesHeader({
    required this.isDark,
    required this.onCalendarTap,
    required this.filter,
    required this.unreadCount,
    required this.readCount,
    required this.countsLoading,
    required this.onFilterChanged,
  });

  final bool isDark;
  final VoidCallback? onCalendarTap;
  final MessagesFilter filter;
  final int unreadCount;
  final int readCount;
  final bool countsLoading;
  final ValueChanged<MessagesFilter>? onFilterChanged;

  @override
  Widget build(BuildContext context) {
    final accent = AppColors.themeAccent(context);

    return DefaultContainerWidget(
      borderRadius: BorderRadius.circular(24),
      hasShadow: false,
      padding: EdgeInsets.only(
        top: MediaQuery.paddingOf(context).top + 8,
        bottom: 12,
        left: 16,
        right: 16,
      ),
      color: isDark ? AppColors.primaryWhiteDark : Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => appShellScaffoldKey.currentState?.openDrawer(),
                behavior: HitTestBehavior.opaque,
                child: Image.asset(
                  isDark ? AppImages.burgerDark : AppImages.burger,
                ),
              ),
              const Gap(12),
              Expanded(
                child: Text(
                  'Сообщения',
                  style: AppFonts.h3Medium.copyWith(
                    color: isDark
                        ? AppColors.primaryWhite
                        : AppColors.primaryDark,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Gap(8),
              const Flexible(child: ProfileSelectorPill()),
              const Gap(8),
              GestureDetector(
                onTap: onCalendarTap,
                behavior: HitTestBehavior.opaque,
                child: Opacity(
                  opacity: onCalendarTap == null ? 0.45 : 1,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark
                          ? AppColors.secondaryDarkLight
                          : AppColors.secondaryLight,
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.calendar_today_outlined,
                      size: 18,
                      color: accent,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Gap(12),
          IgnorePointer(
            ignoring: onFilterChanged == null,
            child: Opacity(
              opacity: onFilterChanged == null ? 0.45 : 1,
              child: MessagesFilterSegment(
                value: filter,
                unreadCount: unreadCount,
                readCount: readCount,
                countsLoading: countsLoading,
                onChanged: onFilterChanged ?? (_) {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessagesBottomActions extends StatelessWidget {
  const _MessagesBottomActions({
    required this.isDark,
    required this.accent,
    required this.onMarkAllRead,
  });

  final bool isDark;
  final Color accent;
  final VoidCallback onMarkAllRead;

  @override
  Widget build(BuildContext context) {
    final barColor = isDark ? AppColors.primaryWhiteDark : Colors.white;
    final buttonFill = isDark
        ? AppColors.secondaryDarkLight
        : AppColors.secondaryLight;

    return Container(
      decoration: BoxDecoration(
        color: barColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: _ActionButton(
        title: 'Прочитать все',
        fillColor: buttonFill,
        textColor: accent,
        onTap: onMarkAllRead,
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.title,
    required this.fillColor,
    required this.textColor,
    required this.onTap,
  });

  final String title;
  final Color fillColor;
  final Color textColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: fillColor,
      borderRadius: BorderRadius.circular(300),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(300),
        child: Container(
          height: 44,
          alignment: Alignment.center,
          child: Text(
            title,
            style: AppFonts.medium14.copyWith(color: textColor),
          ),
        ),
      ),
    );
  }
}
