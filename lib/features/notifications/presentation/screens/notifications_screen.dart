import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/gz_card.dart';
import '../../../../shared/widgets/gz_chip.dart';
import '../../../../shared/widgets/gz_top_bar.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  static const _filters = <String>[
    'All',
    'Unread',
    'Bookings',
    'Sessions',
    'Promo',
  ];

  static const _notifications = <_NotificationItem>[
    _NotificationItem(
      title: 'Booking confirmed',
      subtitle: 'PC Station 01',
      time: 'Just now',
      isUnread: true,
      icon: HugeIcons.strokeRoundedCalendar03,
    ),
    _NotificationItem(
      title: 'Session ending in 10 min',
      subtitle: 'Wrap up or extend your time',
      time: '2:38 PM',
      isUnread: true,
      icon: HugeIcons.strokeRoundedClock01,
    ),
    _NotificationItem(
      title: 'Welcome Bonus campaign applied',
      subtitle: 'Credits added to your wallet',
      time: 'Yesterday',
      icon: HugeIcons.strokeRoundedGift,
    ),
    _NotificationItem(
      title: 'Session receipt ready',
      subtitle: 'GZ-2406-4891',
      time: '3 Jun',
      icon: HugeIcons.strokeRoundedInvoice01,
    ),
    _NotificationItem(
      title: 'New campaign: Happy Hours',
      subtitle: 'Check today’s discounted slots',
      time: '2 Jun',
      icon: HugeIcons.strokeRoundedMegaphone01,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: GzTopBar(
        title: 'Notifications',
        trailingWidth: 104,
        trailing: Text(
          'Mark all read',
          textAlign: TextAlign.right,
          style: AppTypography.small.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
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
                  return GzChip(
                    label: _filters[index],
                    active: index == 0,
                  );
                },
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemCount: _filters.length,
              ),
            ),
            const SizedBox(height: 16),
            ..._notifications.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _NotificationRow(item: item),
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

  final _NotificationItem item;

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
                  icon: item.icon,
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
                item.time,
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

class _NotificationItem {
  const _NotificationItem({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.icon,
    this.isUnread = false,
  });

  final String title;
  final String subtitle;
  final String time;
  final List<List<dynamic>> icon;
  final bool isUnread;
}
