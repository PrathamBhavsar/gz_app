import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/error_snackbar.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../models/domain_misc.dart';
import '../../../../shared/widgets/gz_card.dart';
import '../../../../shared/widgets/gz_chip.dart';
import '../../../../shared/widgets/gz_loading_view.dart';
import '../../../../shared/widgets/gz_top_bar.dart';
import '../../../../shared/widgets/page_error_display.dart';
import '../../application/notifications_notifier.dart';
import '../../application/notifications_ui_models.dart';
import 'notification_detail_sheet.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  static const filters = <String>[
    'All',
    'Unread',
    'Bookings',
    'Sessions',
    'Promo',
  ];

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  String _activeFilter = NotificationsScreen.filters.first;

  @override
  Widget build(BuildContext context) {
    final notifications = ref.watch(notificationsNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: GzTopBar(
        title: 'Notifications',
        trailingWidth: 104,
        trailing: notifications.maybeWhen(
          data: (data) => GestureDetector(
            onTap: data.hasUnread ? () => _markAllRead(context) : null,
            child: Text(
              'Mark all read',
              textAlign: TextAlign.right,
              style: AppTypography.small.copyWith(
                color: data.hasUnread
                    ? AppColors.textSecondary
                    : AppColors.textSecondary.withValues(alpha: 0.55),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          orElse: () => const SizedBox.shrink(),
        ),
      ),
      body: SafeArea(
        top: false,
        child: notifications.when(
          loading: () => const GzLoadingView(message: 'Loading notifications'),
          error: (error, _) => PageErrorDisplay(
            error: AppPageError.from(error),
            onRetry: () =>
                ref.read(notificationsNotifierProvider.notifier).refresh(),
          ),
          data: (data) {
            final items = _filteredItems(data);
            if (items.isEmpty) {
              return PageErrorDisplay(
                error: _activeFilter == 'All'
                    ? AppPageError.empty
                    : const AppPageError(
                        title: 'No matches',
                        message: 'There are no notifications for this filter.',
                        icon: 'inbox',
                        kind: AppPageErrorKind.empty,
                      ),
              );
            }

            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              children: [
                SizedBox(
                  height: 30,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final filter = NotificationsScreen.filters[index];
                      return GestureDetector(
                        onTap: () => setState(() => _activeFilter = filter),
                        child: GzChip(
                          label: filter,
                          active: filter == _activeFilter,
                        ),
                      );
                    },
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemCount: NotificationsScreen.filters.length,
                  ),
                ),
                const SizedBox(height: 16),
                ...items.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: GestureDetector(
                      onTap: () => _openDetail(context, item),
                      child: _NotificationRow(item: item),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  List<NotificationModel> _filteredItems(NotificationsData data) {
    return data.items
        .where((item) {
          switch (_activeFilter) {
            case 'Unread':
              return isUnreadNotification(item);
            case 'Bookings':
              return _typeKeyFor(item) == 'booking';
            case 'Sessions':
              return _typeKeyFor(item) == 'session';
            case 'Promo':
              return _typeKeyFor(item) == 'credit';
            default:
              return true;
          }
        })
        .toList(growable: false);
  }

  Future<void> _openDetail(BuildContext context, NotificationModel item) async {
    final id = item.id;
    if (id == null || id.isEmpty) {
      return;
    }

    try {
      await ref.read(notificationsNotifierProvider.notifier).markRead(id);
    } catch (error) {
      if (context.mounted) {
        showErrorSnackbar(context, error);
      }
    }
    if (!context.mounted) {
      return;
    }

    await showNotificationDetailSheet(
      context,
      notificationId: id,
      initialNotification: item,
    );
  }

  Future<void> _markAllRead(BuildContext context) async {
    try {
      await ref.read(notificationsNotifierProvider.notifier).markAllRead();
    } catch (error) {
      if (context.mounted) {
        showErrorSnackbar(context, error);
      }
    }
  }
}

class _NotificationRow extends StatelessWidget {
  const _NotificationRow({required this.item});

  final NotificationModel item;

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
                  icon: _iconFor(_typeKeyFor(item)),
                  color: AppColors.textPrimary,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.title ?? 'Notification', style: AppTypography.h3),
                    const SizedBox(height: 4),
                    Text(
                      item.body ?? 'Open notification for details',
                      style: AppTypography.bodyR.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                _formatTimestamp(_timestampFor(item)),
                style: AppTypography.small,
              ),
            ],
          ),
        ),
        if (isUnreadNotification(item))
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

List<List<dynamic>> _iconFor(String type) => switch (type) {
  'booking' => HugeIcons.strokeRoundedCalendar03,
  'session' => HugeIcons.strokeRoundedClock01,
  'credit' => HugeIcons.strokeRoundedGift,
  'dispute' => HugeIcons.strokeRoundedShield01,
  _ => HugeIcons.strokeRoundedNotification03,
};

DateTime _timestampFor(NotificationModel item) =>
    item.createdAt ?? item.sentAt ?? item.deliveredAt ?? DateTime.now();

String _typeKeyFor(NotificationModel item) {
  final raw = item.referenceType?.trim().toLowerCase();
  switch (raw) {
    case 'booking':
      return 'booking';
    case 'session':
      return 'session';
    case 'credit':
    case 'campaign':
    case 'promotion':
      return 'credit';
    case 'dispute':
      return 'dispute';
    default:
      return 'general';
  }
}

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
