import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../models/domain_misc.dart';
import '../../../../shared/widgets/em_button.dart';
import '../../../../shared/widgets/em_scroll_content.dart';
import '../providers/notifications_notifier.dart';

void showNotificationDetail(
  BuildContext context,
  WidgetRef ref,
  NotificationModel notification,
) {
  if (notification.id != null && notification.readAt == null) {
    ref.read(notificationsNotifierProvider.notifier).markRead(notification.id!);
  }
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: AppColors.background,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppSpacing.borderRadiusCard),
      ),
    ),
    builder: (_) => NotificationDetailSheet(notification: notification),
  );
}

class NotificationDetailSheet extends StatelessWidget {
  const NotificationDetailSheet({super.key, required this.notification});

  final NotificationModel notification;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: AppSpacing.sm),
        Container(
          width: 36,
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.textMuted,
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusPill),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Padding(
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.md, AppSpacing.xs, AppSpacing.md, 0),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => context.pop(),
                child: const SizedBox(
                  width: 38,
                  height: 38,
                  child: Center(
                    child: HugeIcon(
                      icon: HugeIcons.strokeRoundedArrowLeft01,
                      color: AppColors.textPrimary,
                      size: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  notification.title ?? 'Notification',
                  style: AppTypography.h2,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: EmScrollContent(
            padded: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.md),
                Text(
                  notification.body ?? '',
                  style: AppTypography.bodyR.copyWith(fontSize: 15),
                ),
                const SizedBox(height: AppSpacing.sm),
                if (notification.createdAt != null)
                  Text(
                    _formatDateTime(notification.createdAt!),
                    style: AppTypography.meta.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                const SizedBox(height: AppSpacing.xl),
                if (notification.referenceType != null &&
                    notification.referenceId != null)
                  EmButtonFull(
                    label: _actionLabel(notification.referenceType),
                    onPressed: () => context.pop(),
                  ),
                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static String _actionLabel(String? ref) => switch (ref) {
        'booking' => 'View Booking',
        'session' => 'View Session',
        'dispute' => 'View Dispute',
        'credit' || 'campaign' => 'Open Wallet',
        _ => 'View Details',
      };

  static String _formatDateTime(DateTime dt) {
    final months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[dt.month]} ${dt.day}, ${dt.year} · ${_pad(dt.hour)}:${_pad(dt.minute)}';
  }

  static String _pad(int n) => n.toString().padLeft(2, '0');
}
