import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../core/navigation/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/gz_avatar.dart';
import '../../../../shared/widgets/gz_button.dart';
import '../../../../shared/widgets/gz_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            Text('Profile', style: AppTypography.h1),
            const SizedBox(height: AppSpacing.md),
            GzCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      GzAvatar(letter: 'R', size: GzAvatarSize.xl),
                      SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: _ProfileIdentity(),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  GestureDetector(
                    onTap: () => context.push(AppRoutes.editProfile),
                    child: Text(
                      'Edit profile →',
                      style: AppTypography.body.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            _ProfileNavTile(
              icon: HugeIcons.strokeRoundedTime04,
              label: 'Sessions',
              onTap: () => context.go(AppRoutes.sessions),
            ),
            const SizedBox(height: AppSpacing.sm),
            _ProfileNavTile(
              icon: HugeIcons.strokeRoundedWallet01,
              label: 'Wallet',
              onTap: () => context.go(AppRoutes.wallet),
            ),
            const SizedBox(height: AppSpacing.sm),
            _ProfileNavTile(
              icon: HugeIcons.strokeRoundedShield01,
              label: 'Disputes',
              onTap: () => context.push(AppRoutes.disputesList),
            ),
            const SizedBox(height: AppSpacing.sm),
            _ProfileNavTile(
              icon: HugeIcons.strokeRoundedNotification03,
              label: 'Notification preferences',
              onTap: () => context.push(AppRoutes.notifPrefs),
            ),
            const SizedBox(height: AppSpacing.sm),
            _ProfileNavTile(
              icon: HugeIcons.strokeRoundedCall02,
              label: 'Change phone',
              onTap: () => context.push(AppRoutes.changePhone),
            ),
            const SizedBox(height: AppSpacing.xl),
            GzButton(
              label: 'Sign out',
              variant: GzButtonVariant.dangerOutline,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Sign out is not wired in this UI phase.')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileIdentity extends StatelessWidget {
  const _ProfileIdentity();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Rahul Mehra', style: AppTypography.h2),
        const SizedBox(height: AppSpacing.xs),
        Text('rahul@example.com', style: AppTypography.small),
      ],
    );
  }
}

class _ProfileNavTile extends StatelessWidget {
  const _ProfileNavTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final dynamic icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
        ),
        child: Row(
          children: [
            Container(
              width: AppSpacing.xl + AppSpacing.xs,
              height: AppSpacing.xl + AppSpacing.xs,
              decoration: BoxDecoration(
                color: AppColors.pillBg,
                borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
              ),
              child: HugeIcon(
                icon: icon,
                color: AppColors.textSecondary,
                size: 18,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(child: Text(label, style: AppTypography.h3)),
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
