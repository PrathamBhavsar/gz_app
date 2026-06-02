import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../models/domain_misc.dart';
import '../../../../shared/widgets/gz_card.dart';
import '../../../../shared/widgets/page_error_display.dart';
import 'package:gz_app/core/errors/app_exception.dart';
import '../providers/notifications_notifier.dart';
import 'notification_detail_sheet.dart';

void showNotificationCenter(BuildContext context) {
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
    builder: (ctx) => const NotificationCenterContent(),
  );
}

class NotificationCenterContent extends ConsumerWidget {
  const NotificationCenterContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateAsync = ref.watch(notificationsNotifierProvider);

    return stateAsync.when(
      loading: () => const _SheetShell(
        title: 'Notifications',
        trailing: null,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => _SheetShell(
        title: 'Notifications',
        trailing: null,
        child: PageErrorDisplay(
          error: AppPageError.from(e),
          onRetry: () =>
              ref.read(notificationsNotifierProvider.notifier).refresh(),
        ),
      ),
      data: (data) => _SheetShell(
        title: 'Notifications',
        trailing: GestureDetector(
          onTap: data.hasUnread
              ? () =>
                  ref.read(notificationsNotifierProvider.notifier).markAllRead()
              : null,
          child: Text(
            'Mark all read',
            style: AppTypography.small.copyWith(
              color: data.hasUnread
                  ? AppColors.textPrimary
                  : AppColors.textMuted,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        child: data.items.isEmpty
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.xl),
                  child: GzCard(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        HugeIcon(
                          icon: HugeIcons.strokeRoundedCheckmarkCircle01,
                          color: AppColors.textTertiary,
                          size: 32,
                        ),
                        SizedBox(height: AppSpacing.sm),
                        Text(
                          "You're all caught up",
                          style: AppTypography.h3,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : ListView.builder(
                itemCount: data.items.length,
                itemBuilder: (ctx, i) => _NotifRow(
                  notification: data.items[i],
                  isLast: i == data.items.length - 1,
                  onTap: () => showNotificationDetail(
                    context,
                    ref,
                    data.items[i],
                  ),
                )
                    .animate(delay: (i * 40).ms)
                    .fadeIn(duration: 220.ms)
                    .slideY(begin: 0.04, end: 0, duration: 220.ms),
              ),
      ),
    );
  }
}

class _SheetShell extends StatelessWidget {
  const _SheetShell({
    required this.title,
    required this.trailing,
    required this.child,
  });

  final String title;
  final Widget? trailing;
  final Widget child;

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
            borderRadius:
                BorderRadius.circular(AppSpacing.borderRadiusPill),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Padding(
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.md, AppSpacing.xs, AppSpacing.md, 0),
          child: Row(
            children: [
              Text(title, style: AppTypography.h2),
              const Spacer(),
              ?trailing,
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Expanded(child: child),
      ],
    );
  }
}

class _NotifRow extends StatelessWidget {
  const _NotifRow({
    required this.notification,
    required this.isLast,
    required this.onTap,
  });

  final NotificationModel notification;
  final bool isLast;
  final VoidCallback onTap;

  static ({Color bg, Color fg}) _palette(String? ref) {
    return switch (ref) {
      'booking' => (bg: AppColors.infoBg, fg: AppColors.info),
      'session' => (bg: AppColors.okBg, fg: AppColors.ok),
      'dispute' => (bg: AppColors.errBg, fg: AppColors.err),
      'credit' || 'campaign' => (bg: AppColors.warnBg, fg: AppColors.warn),
      _ => (bg: AppColors.pillBg, fg: AppColors.textSecondary),
    };
  }

  static List<List<dynamic>> _iconFor(String? ref) => switch (ref) {
        'booking' => HugeIcons.strokeRoundedCalendar01,
        'session' => HugeIcons.strokeRoundedGameboy,
        'dispute' => HugeIcons.strokeRoundedAlertCircle,
        'credit' || 'campaign' => HugeIcons.strokeRoundedStar,
        _ => HugeIcons.strokeRoundedNotification01,
      };

  @override
  Widget build(BuildContext context) {
    final isUnread = notification.readAt == null;
    final p = _palette(notification.referenceType);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isUnread
              ? AppColors.infoBg.withValues(alpha: 0.35)
              : Colors.transparent,
          border: Border(
            top: BorderSide(color: AppColors.rule),
            bottom: isLast
                ? BorderSide(color: AppColors.rule)
                : BorderSide.none,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Unread dot
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(top: 14),
                decoration: BoxDecoration(
                  color: isUnread ? AppColors.info : Colors.transparent,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              // Icon circle
              Container(
                width: 36,
                height: 36,
                decoration:
                    BoxDecoration(color: p.bg, shape: BoxShape.circle),
                child: Center(
                  child: HugeIcon(
                    icon: _iconFor(notification.referenceType),
                    color: p.fg,
                    size: 17,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm + AppSpacing.xs),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Expanded(
                          child: Text(
                            notification.title ?? '',
                            style: AppTypography.body.copyWith(
                              fontWeight: isUnread
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          _relativeTime(notification.createdAt),
                          style: AppTypography.small,
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      notification.body ?? '',
                      style: AppTypography.bodyR.copyWith(fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              const HugeIcon(
                icon: HugeIcons.strokeRoundedArrowRight01,
                color: AppColors.textMuted,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _relativeTime(DateTime? dt) {
    if (dt == null) return '';
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    return '${diff.inDays}d ago';
  }
}
