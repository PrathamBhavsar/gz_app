import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/navigation/routes.dart';

/// Management Hub — Tab 3 root.
/// Placeholder screen with navigation tiles to Pricing, Billing, Campaigns, Credits, Disputes.
/// Full implementation in Phase 6.
class AdminManagementScreen extends StatelessWidget {
  const AdminManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Management', style: AppTypography.headingSmall),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.md),
            _buildTile(
              context,
              'Pricing Rules',
              Icons.sell_outlined,
              AppRoutes.adminPricing,
            ),
            const SizedBox(height: AppSpacing.sm),
            _buildTile(
              context,
              'Billing & Payments',
              Icons.receipt_long_outlined,
              AppRoutes.adminBilling,
            ),
            const SizedBox(height: AppSpacing.sm),
            _buildTile(
              context,
              'Campaigns',
              Icons.campaign_outlined,
              AppRoutes.adminCampaigns,
            ),
            const SizedBox(height: AppSpacing.sm),
            _buildTile(
              context,
              'Credits',
              Icons.stars_outlined,
              AppRoutes.adminCredits,
            ),
            const SizedBox(height: AppSpacing.sm),
            _buildTile(
              context,
              'Disputes',
              Icons.gavel_outlined,
              AppRoutes.adminDisputes,
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
