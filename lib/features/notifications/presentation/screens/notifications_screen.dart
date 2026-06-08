import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../core/navigation/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../providers/notification_feed_notifier.dart';
import '../../../../shared/widgets/gz_card.dart';
import '../../../../shared/widgets/gz_chip.dart';
import '../../../../shared/widgets/gz_top_bar.dart';
import 'notification_detail_sheet.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  static const _filters = <String>[
    'All',
    'Unread',
    'Bookings',
    'Sessions',
    'Promo',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationFeedProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: GzTopBar(
        title: 'Notifications',
        trailingWidth: 104,
        trailing: GestureDetector(
          onTap: () =>
              ref.read(notificationFeedProvider.notifier).markAllRead(),
          child: Text(
            'Mark all read',
            textAlign: TextAlign.right,
            style: AppTypography.small.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          children: [
            SizedBox(
              height: 30,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return GzChip(label: _filters[index], active: index == 0);
                },
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemCount: _filters.length,
              ),
            ),
            const SizedBox(height: 16),
            ...notifications.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: GestureDetector(
                  onTap: () {
                    ref
                        .read(notificationFeedProvider.notifier)
                        .markRead(item.id);
                    showNotificationDetailSheet(
                      context,
                      notifId: item.id,
                      title: item.title,
                      body: item.subtitle,
                      type: item.type.name,
                      time: _formatTimestamp(item.timestamp),
                      actionLabel: _actionLabelFor(item),
                      actionRoute: _actionRouteFor(item),
                    );
                  },
                  child: _NotificationRow(item: item),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationRow extends StatelessWidget {
  const _NotificationRow({required this.item});

  final NotificationFeedItem item;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GzCard(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.pillBg,
                  borderRadius: BorderRadius.circular(
                    AppSpacing.borderRadiusLg,
                  ),
                ),
                child: HugeIcon(
                  icon: _iconFor(item.type),
                  color: AppColors.textPrimary,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.title, style: AppTypography.h3),
                    const SizedBox(height: 4),
                    Text(
                      item.subtitle,
                      style: AppTypography.bodyR.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                _formatTimestamp(item.timestamp),
                style: AppTypography.small,
              ),
            ],
          ),
        ),
        if (item.isUnread)
          Positioned(
            left: 0,
            top: 12,
            bottom: 12,
            child: Container(
              width: 3,
              decoration: BoxDecoration(
                color: AppColors.textPrimary,
                borderRadius: BorderRadius.circular(
                  AppSpacing.borderRadiusPill,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

List<List<dynamic>> _iconFor(NotificationFeedType type) => switch (type) {
  NotificationFeedType.booking => HugeIcons.strokeRoundedCalendar03,
  NotificationFeedType.session => HugeIcons.strokeRoundedClock01,
  NotificationFeedType.credit => HugeIcons.strokeRoundedGift,
  NotificationFeedType.dispute => HugeIcons.strokeRoundedShield01,
  NotificationFeedType.general => HugeIcons.strokeRoundedNotification03,
};

String _formatTimestamp(DateTime timestamp) {
  final now = DateTime.now();
  final difference = now.difference(timestamp);

  if (difference.inMinutes < 1) {
    return 'Just now';
  }
  if (difference.inHours < 1) {
    return '${difference.inMinutes}m ago';
  }
  if (difference.inHours < 24 &&
      now.day == timestamp.day &&
      now.month == timestamp.month &&
      now.year == timestamp.year) {
    final hour = timestamp.hour > 12 ? timestamp.hour - 12 : timestamp.hour;
    final normalizedHour = hour == 0 ? 12 : hour;
    final minute = timestamp.minute.toString().padLeft(2, '0');
    final suffix = timestamp.hour >= 12 ? 'PM' : 'AM';
    return '$normalizedHour:$minute $suffix';
  }
  if (difference.inDays == 1) {
    return 'Yesterday';
  }

  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${timestamp.day} ${months[timestamp.month - 1]}';
}

String? _actionLabelFor(NotificationFeedItem item) => switch (item.type) {
  NotificationFeedType.booking =>
    item.referenceId != null ? 'View Booking' : null,
  NotificationFeedType.session =>
    item.referenceId != null ? 'View Session' : null,
  NotificationFeedType.credit => null,
  NotificationFeedType.dispute => null,
  NotificationFeedType.general => null,
};

String? _actionRouteFor(NotificationFeedItem item) => switch (item.type) {
  NotificationFeedType.booking when item.referenceId != null =>
    AppRoutes.bookingDetailPath(item.referenceId!),
  NotificationFeedType.session when item.referenceId != null =>
    AppRoutes.sessionHistoryDetailPath(item.referenceId!),
  _ => null,
};
