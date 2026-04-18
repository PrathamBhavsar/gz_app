import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/navigation/routes.dart';

/// Store Hub — Tab 4 root.
/// Placeholder screen with navigation tiles to Systems, Staff, Config, Notifications.
/// Full implementation in Phase 7.
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
          children: [
            const SizedBox(height: AppSpacing.md),
            _buildTile(
              context,
              'System Management',
              Icons.computer_outlined,
              AppRoutes.adminSystemsMgmt,
            ),
            const SizedBox(height: AppSpacing.sm),
            _buildTile(
              context,
              'Staff Management',
              Icons.people_outlined,
              AppRoutes.adminStaff,
            ),
            const SizedBox(height: AppSpacing.sm),
            _buildTile(
              context,
              'Store Config',
              Icons.settings_outlined,
              AppRoutes.adminConfig,
            ),
            const SizedBox(height: AppSpacing.sm),
            _buildTile(
              context,
              'Notifications',
              Icons.notifications_outlined,
              AppRoutes.adminNotifications,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTile(
    BuildContext context,
    String title,
    IconData icon,
    String route,
  ) {
    return ListTile(
      tileColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
      ),
      leading: Icon(icon, color: AppColors.textPrimary),
      title: Text(title, style: AppTypography.bodyLarge),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
      onTap: () => context.go(route),
    );
  }
}
