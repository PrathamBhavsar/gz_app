import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/navigation/routes.dart';

/// Management Hub — Tab 3 root.
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
          children: const [
            SizedBox(height: AppSpacing.md),
            _ManagementTile(
              title: 'Pricing Rules',
              icon: HugeIcons.strokeRoundedTags,
              route: AppRoutes.adminPricing,
            ),
            SizedBox(height: AppSpacing.sm),
            _ManagementTile(
              title: 'Billing & Payments',
              icon: HugeIcons.strokeRoundedInvoice01,
              route: AppRoutes.adminBilling,
            ),
            SizedBox(height: AppSpacing.sm),
            _ManagementTile(
              title: 'Campaigns',
              icon: HugeIcons.strokeRoundedMegaphone01,
              route: AppRoutes.adminCampaigns,
            ),
            SizedBox(height: AppSpacing.sm),
            _ManagementTile(
              title: 'Credits',
              icon: HugeIcons.strokeRoundedStar,
              route: AppRoutes.adminCredits,
            ),
            SizedBox(height: AppSpacing.sm),
            _ManagementTile(
              title: 'Disputes',
              icon: HugeIcons.strokeRoundedJusticeScale01,
              route: AppRoutes.adminDisputes,
            ),
          ],
        ),
      ),
    );
  }
}

class _ManagementTile extends StatelessWidget {
  const _ManagementTile({
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
