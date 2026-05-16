import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/navigation/routes.dart';

/// Store Hub — Tab 4 root.
class AdminStoreScreen extends StatelessWidget {
  const AdminStoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Store', style: AppTypography.headingSmall),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        child: Column(
          children: const [
            SizedBox(height: AppSpacing.md),
            _StoreTile(
              title: 'System Management',
              icon: HugeIcons.strokeRoundedComputer,
              route: AppRoutes.adminSystemsMgmt,
            ),
            SizedBox(height: AppSpacing.sm),
            _StoreTile(
              title: 'Staff Management',
              icon: HugeIcons.strokeRoundedUserGroup,
              route: AppRoutes.adminStaff,
            ),
            SizedBox(height: AppSpacing.sm),
            _StoreTile(
              title: 'Store Config',
              icon: HugeIcons.strokeRoundedSettings01,
              route: AppRoutes.adminConfig,
            ),
            SizedBox(height: AppSpacing.sm),
            _StoreTile(
              title: 'Notifications',
              icon: HugeIcons.strokeRoundedNotification01,
              route: AppRoutes.adminNotifications,
            ),
          ],
        ),
      ),
    );
  }
}

class _StoreTile extends StatelessWidget {
  const _StoreTile({
    required this.title,
    required this.icon,
    required this.route,
  });

  final String title;
  final dynamic icon;
  final String route;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
      ),
      leading: HugeIcon(icon: icon, color: AppColors.textPrimary, size: 22),
      title: Text(title, style: AppTypography.bodyLarge),
      trailing: const HugeIcon(
        icon: HugeIcons.strokeRoundedArrowRight01,
        color: AppColors.textSecondary,
        size: 20,
      ),
      onTap: () => context.go(route),
    );
  }
}
