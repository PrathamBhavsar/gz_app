import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/navigation/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../models/domain_misc.dart';
import '../../../../shared/widgets/gz_button.dart';
import '../../../../shared/widgets/page_error_display.dart';
import '../../application/notification_detail_notifier.dart';

Future<void> showNotificationDetailSheet(
  BuildContext context, {
  required String notificationId,
  required NotificationModel initialNotification,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => NotificationDetailSheet(
      notificationId: notificationId,
      initialNotification: initialNotification,
    ),
  );
}

class NotificationDetailSheet extends ConsumerWidget {
  const NotificationDetailSheet({
    super.key,
    required this.notificationId,
    required this.initialNotification,
  });

  final String notificationId;
  final NotificationModel initialNotification;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final detail = ref.watch(
      notificationDetailNotifierProvider(notificationId),
    );
    final notification = detail.valueOrNull ?? initialNotification;
    final type = _typeKeyFor(notification);
    final actionLabel = _actionLabelFor(notification);
    final actionRoute = _actionRouteFor(notification);

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(12, 12, 12, 12 + bottomInset),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.rule,
                      borderRadius: BorderRadius.circular(
                        AppSpacing.borderRadiusPill,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: _iconBg(type),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: HugeIcon(
                          icon: _icon(type),
                          size: 22,
                          color: _iconColor(type),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(type.toUpperCase(), style: AppTypography.meta),
                          const SizedBox(height: 2),
                          Text(
                            _formatTimestamp(_timestampFor(notification)),
                            style: AppTypography.small,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  notification.title ?? 'Notification',
                  style: AppTypography.h2,
                ),
                const SizedBox(height: 10),
                detail.when(
                  loading: () => Text(
                    notification.body ?? 'Loading details...',
                    style: AppTypography.bodyR,
                  ),
                  error: (error, _) => SizedBox(
                    height: 180,
                    child: PageErrorDisplay(
                      error: AppPageError.from(error),
                      onRetry: () => ref
                          .read(
                            notificationDetailNotifierProvider(
                              notificationId,
                            ).notifier,
                          )
                          .refresh(),
                    ),
                  ),
                  data: (loaded) => Text(
                    loaded.body ?? 'No additional details available.',
                    style: AppTypography.bodyR,
                  ),
                ),
                const SizedBox(height: 20),
                if (actionLabel != null && actionRoute != null) ...[
                  GzButton(
                    label: actionLabel,
                    onPressed: () {
                      context.pop();
                      context.push(actionRoute);
                    },
                  ),
                  const SizedBox(height: 8),
                ],
                GzButton(
                  label: 'Dismiss',
                  variant: GzButtonVariant.ghost,
                  onPressed: () => context.pop(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Color _iconBg(String type) => switch (type) {
  'booking' => AppColors.infoBg,
  'session' => AppColors.okBg,
  'credit' => AppColors.warnBg,
  'dispute' => AppColors.errBg,
  _ => AppColors.pillBg,
};

Color _iconColor(String type) => switch (type) {
  'booking' => AppColors.info,
  'session' => AppColors.ok,
  'credit' => AppColors.warn,
  'dispute' => AppColors.err,
  _ => AppColors.textSecondary,
};

List<List<dynamic>> _icon(String type) => switch (type) {
  'booking' => HugeIcons.strokeRoundedCalendar02,
  'session' => HugeIcons.strokeRoundedGameController01,
  'credit' => HugeIcons.strokeRoundedCoins01,
  'dispute' => HugeIcons.strokeRoundedShield01,
  _ => HugeIcons.strokeRoundedNotification01,
};

DateTime _timestampFor(NotificationModel item) =>
    item.createdAt ?? item.sentAt ?? item.deliveredAt ?? DateTime.now();

String _formatTimestamp(DateTime timestamp) {
  final hour = timestamp.hour > 12 ? timestamp.hour - 12 : timestamp.hour;
  final normalizedHour = hour == 0 ? 12 : hour;
  final minute = timestamp.minute.toString().padLeft(2, '0');
  final suffix = timestamp.hour >= 12 ? 'PM' : 'AM';
  return '${timestamp.day}/${timestamp.month}/${timestamp.year} • '
      '$normalizedHour:$minute $suffix';
}

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

String? _actionLabelFor(NotificationModel item) => switch (_typeKeyFor(item)) {
  'booking' when item.referenceId != null => 'View Booking',
  'session' when item.referenceId != null => 'View Session',
  _ => null,
};

String? _actionRouteFor(NotificationModel item) => switch (_typeKeyFor(item)) {
  'booking' when item.referenceId != null => AppRoutes.bookingDetailPath(
    item.referenceId!,
  ),
  'session' when item.referenceId != null => AppRoutes.sessionHistoryDetailPath(
    item.referenceId!,
  ),
  _ => null,
};
