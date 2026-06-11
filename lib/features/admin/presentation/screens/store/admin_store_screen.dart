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

class AdminStoreScreen extends StatelessWidget {
  const AdminStoreScreen({super.key});

  static const _tiles = [
    _StoreTileData(
      title: 'System Management',
      subtitle: 'Layouts, availability, hardware',
      route: AppRoutes.adminSystemsList,
      icon: HugeIcons.strokeRoundedInformationCircle,
      iconColor: AppColors.info,
    ),
    _StoreTileData(
      title: 'Staff Management',
      subtitle: 'Roles, access and team roster',
      route: AppRoutes.adminStaff,
      icon: HugeIcons.strokeRoundedUserGroup,
      iconColor: AppColors.purple,
    ),
    _StoreTileData(
      title: 'Store Config',
      subtitle: 'Hours, booking windows and ops',
      route: AppRoutes.adminConfig,
      icon: HugeIcons.strokeRoundedSettings02,
      iconColor: AppColors.textSecondary,
    ),
    _StoreTileData(
      title: 'Notifications',
      subtitle: 'Compose player-wide announcements',
      route: AppRoutes.adminNotifications,
      icon: HugeIcons.strokeRoundedNotification03,
      iconColor: AppColors.warn,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const GzAdminTopBar(title: 'Store', disableBack: true),
      body: SafeArea(
        top: false,
        child: GzScrollContent(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: Column(
              children: _tiles
                  .map(
                    (tile) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _StoreTile(tile: tile),
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

class _StoreTile extends StatelessWidget {
  const _StoreTile({required this.tile});

  final _StoreTileData tile;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
      onTap: () => context.push(tile.route),
      child: GzCard(
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: tile.iconColor.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
              ),
              alignment: Alignment.center,
              child: HugeIcon(icon: tile.icon, color: tile.iconColor, size: 22),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tile.title, style: AppTypography.h3),
                  const SizedBox(height: 2),
                  Text(tile.subtitle, style: AppTypography.small),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
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

class _StoreTileData {
  const _StoreTileData({
    required this.title,
    required this.subtitle,
    required this.route,
    required this.icon,
    required this.iconColor,
  });

  final String title;
  final String subtitle;
  final String route;
  final dynamic icon;
  final Color iconColor;
}
