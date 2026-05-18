import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:rient_app/core/keys/app_shell_scaffold_key.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_decoration.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/core/widgets/default_container.dart';
import 'package:rient_app/features/chat/view/components/message_notification_card.dart';
import 'package:rient_app/features/chat/view/components/messages_date_range_dialog.dart';
import 'package:rient_app/features/chat/view/components/message_notification_item.dart';
import 'package:rient_app/features/chat/view/components/messages_filter_segment.dart';
import 'package:rient_app/features/chat/view/components/messages_mock_data.dart';
import 'package:rient_app/features/home/view/components/entity_selector_pill.dart';
import 'package:rient_app/resources/resources.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  static const name = 'chat_page';
  static const path = '/chat_page';

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  MessagesFilter _filter = MessagesFilter.unread;
  late List<MessageNotificationItem> _unread;
  late List<MessageNotificationItem> _read;
  MessagesDateRange? _dateRange;

  @override
  void initState() {
    super.initState();
    _unread = List.of(mockUnreadMessages);
    _read = List.of(mockReadMessages);
  }

  List<MessageNotificationItem> get _visibleItems =>
      _filter == MessagesFilter.unread ? _unread : _read;

  void _markAllRead() {
    setState(() {
      _read = [
        ..._read,
        ..._unread.map(
          (m) => MessageNotificationItem(
            id: m.id,
            title: m.title,
            description: m.description,
            timestamp: m.timestamp,
            isUnread: false,
            showAccent: false,
          ),
        ),
      ];
      _unread = [];
      _filter = MessagesFilter.read;
    });
  }

  void _deleteAll() {
    setState(() {
      if (_filter == MessagesFilter.unread) {
        _unread = [];
      } else {
        _read = [];
      }
    });
  }

  Future<void> _openDateRangeDialog() async {
    final range = await MessagesDateRangeDialog.show(
      context,
      initialStart: _dateRange?.start,
      initialEnd: _dateRange?.end,
    );
    if (!mounted || range == null) return;
    setState(() => _dateRange = range);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenBackground = isDark
        ? AppColors.secondaryDarkLight
        : AppColors.tabBarScreenBackground;
    final accent = AppColors.themeAccent(context);

    return Scaffold(
      backgroundColor: screenBackground,
      body: Column(
        children: [
          _MessagesHeader(
            isDark: isDark,
            onCalendarTap: _openDateRangeDialog,
          ),
          Padding(
            padding: AppDecoration.padding16.copyWith(top: 12, bottom: 12),
            child: MessagesFilterSegment(
              value: _filter,
              unreadCount: _unread.length,
              readCount: _read.length,
              onChanged: (value) => setState(() => _filter = value),
            ),
          ),
          Expanded(
            child: _visibleItems.isEmpty
                ? Center(
                    child: Text(
                      _filter == MessagesFilter.unread
                          ? 'Нет непросмотренных сообщений'
                          : 'Нет просмотренных сообщений',
                      style: AppFonts.b2Regular.copyWith(
                        color: AppColors.tabbarGrey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.separated(
                    padding: AppDecoration.padding16.copyWith(top: 0),
                    itemCount: _visibleItems.length,
                    separatorBuilder: (_, __) => const Gap(10),
                    itemBuilder: (context, index) {
                      final item = _visibleItems[index];
                      return MessageNotificationCard(
                        item: item,
                        onOpenCard: () {},
                      );
                    },
                  ),
          ),
          _MessagesBottomActions(
            isDark: isDark,
            accent: accent,
            onDeleteAll: _deleteAll,
            onMarkAllRead: _markAllRead,
          ),
        ],
      ),
    );
  }
}

class _MessagesHeader extends StatelessWidget {
  const _MessagesHeader({
    required this.isDark,
    required this.onCalendarTap,
  });

  final bool isDark;
  final VoidCallback onCalendarTap;

  @override
  Widget build(BuildContext context) {
    final accent = AppColors.themeAccent(context);

    return DefaultContainerWidget(
      borderRadius: BorderRadius.circular(24),
      hasShadow: false,
      padding: const EdgeInsets.only(top: 52, bottom: 8, left: 16, right: 16),
      color: isDark ? AppColors.primaryWhiteDark : Colors.white,
      child: Row(
        children: [
          GestureDetector(
            onTap: () => appShellScaffoldKey.currentState?.openDrawer(),
            behavior: HitTestBehavior.opaque,
            child: Image.asset(
              isDark ? AppImages.burgerDark : AppImages.burger,
            ),
          ),
          const Gap(12),
          Text(
            'Сообщения',
            style: AppFonts.h3Medium.copyWith(
              color: isDark ? AppColors.primaryWhite : AppColors.primaryDark,
            ),
          ),
          const Spacer(),
          const ProfileSelectorPill(),
          const Gap(8),
          GestureDetector(
            onTap: onCalendarTap,
            behavior: HitTestBehavior.opaque,
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
        ],
      ),
    );
  }
}

class _MessagesBottomActions extends StatelessWidget {
  const _MessagesBottomActions({
    required this.isDark,
    required this.accent,
    required this.onDeleteAll,
    required this.onMarkAllRead,
  });

  final bool isDark;
  final Color accent;
  final VoidCallback onDeleteAll;
  final VoidCallback onMarkAllRead;

  @override
  Widget build(BuildContext context) {
    final barColor = isDark ? AppColors.primaryWhiteDark : Colors.white;
    final buttonFill =
        isDark ? AppColors.secondaryDarkLight : AppColors.secondaryLight;

    return Container(
      decoration: BoxDecoration(
        color: barColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        children: [
          Expanded(
            child: _ActionButton(
              title: 'Удалить все',
              fillColor: buttonFill,
              textColor: AppColors.red,
              onTap: onDeleteAll,
            ),
          ),
          const Gap(12),
          Expanded(
            child: _ActionButton(
              title: 'Прочитать все',
              fillColor: buttonFill,
              textColor: accent,
              onTap: onMarkAllRead,
            ),
          ),
        ],
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
