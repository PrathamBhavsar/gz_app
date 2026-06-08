import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/gz_button.dart';

Future<void> showNotificationDetailSheet(
  BuildContext context, {
  required String notifId,
  required String title,
  required String body,
  required String type,
  required String time,
  String? actionLabel,
  String? actionRoute,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => NotificationDetailSheet(
      notifId: notifId,
      title: title,
      body: body,
      type: type,
      time: time,
      actionLabel: actionLabel,
      actionRoute: actionRoute,
    ),
  );
}

class NotificationDetailSheet extends StatelessWidget {
  const NotificationDetailSheet({
    super.key,
    required this.notifId,
    required this.title,
    required this.body,
    required this.type,
    required this.time,
    this.actionLabel,
    this.actionRoute,
  });

  final String notifId, title, body, type, time;
  final String? actionLabel, actionRoute;

  Color _iconBg() => switch (type) {
    'booking' => AppColors.infoBg,
    'session' => AppColors.okBg,
    'credit' => AppColors.warnBg,
    'dispute' => AppColors.errBg,
    _ => AppColors.pillBg,
  };

  Color _iconColor() => switch (type) {
    'booking' => AppColors.info,
    'session' => AppColors.ok,
    'credit' => AppColors.warn,
    'dispute' => AppColors.err,
    _ => AppColors.textSecondary,
  };

  List<List<dynamic>> _icon() => switch (type) {
    'booking' => HugeIcons.strokeRoundedCalendar02,
    'session' => HugeIcons.strokeRoundedGameController01,
    'credit' => HugeIcons.strokeRoundedCoins01,
    'dispute' => HugeIcons.strokeRoundedShield01,
    _ => HugeIcons.strokeRoundedNotification01,
  };

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

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
                // Drag handle
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
                        color: _iconBg(),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: HugeIcon(
                          icon: _icon(),
                          size: 22,
                          color: _iconColor(),
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
                          Text(time, style: AppTypography.small),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(title, style: AppTypography.h2),
                const SizedBox(height: 10),
                Text(body, style: AppTypography.bodyR),
                const SizedBox(height: 20),
                if (actionLabel != null && actionRoute != null) ...[
                  GzButton(
                    label: actionLabel!,
                    onPressed: () {
                      context.pop();
                      context.push(actionRoute!);
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
