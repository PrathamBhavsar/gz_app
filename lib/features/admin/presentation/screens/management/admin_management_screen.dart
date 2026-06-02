import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../core/navigation/routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../shared/widgets/gz_admin_top_bar.dart';
import '../../../../../shared/widgets/gz_card.dart';
import '../../../../../shared/widgets/gz_scroll_content.dart';

class AdminManagementScreen extends StatelessWidget {
  const AdminManagementScreen({super.key});

  static const _tiles = [
    _ManagementTileData(
      label: 'Pricing Rules',
      route: AppRoutes.adminPricing,
      icon: HugeIcons.strokeRoundedBalanceScale,
      iconColor: AppColors.err,
    ),
    _ManagementTileData(
      label: 'Billing & Payments',
      route: AppRoutes.adminBilling,
      icon: HugeIcons.strokeRoundedCoinsDollar,
      iconColor: AppColors.info,
    ),
    _ManagementTileData(
      label: 'Campaigns',
      route: AppRoutes.adminCampaigns,
      icon: HugeIcons.strokeRoundedGift,
      iconColor: AppColors.ok,
    ),
    _ManagementTileData(
      label: 'Credits',
      route: AppRoutes.adminCredits,
      icon: HugeIcons.strokeRoundedStar,
      iconColor: AppColors.warn,
    ),
    _ManagementTileData(
      label: 'Disputes',
      route: AppRoutes.adminDisputes,
      icon: HugeIcons.strokeRoundedJusticeScale01,
      iconColor: AppColors.err,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const GzAdminTopBar(title: 'Management', disableBack: true),
      body: SafeArea(
        top: false,
        child: GzScrollContent(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: Column(
              children: _tiles
                  .map(
                    (tile) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _ManagementTile(data: tile),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class _ManagementTile extends StatelessWidget {
  const _ManagementTile({required this.data});

  final _ManagementTileData data;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
      onTap: () => context.go(data.route),
      child: GzCard(
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: data.iconColor.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
              ),
              alignment: Alignment.center,
              child: HugeIcon(icon: data.icon, color: data.iconColor, size: 20),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(child: Text(data.label, style: AppTypography.h3)),
            const HugeIcon(
              icon: HugeIcons.strokeRoundedArrowRight01,
              color: AppColors.textTertiary,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

class _ManagementTileData {
  const _ManagementTileData({
    required this.label,
    required this.route,
    required this.icon,
    required this.iconColor,
  });

  final String label;
  final String route;
  final dynamic icon;
  final Color iconColor;
}
