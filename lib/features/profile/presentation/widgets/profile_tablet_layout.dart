import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../auth/presentation/providers/auth_notifier.dart';

class ProfileTabletLayout extends ConsumerWidget {
  const ProfileTabletLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Column: Profile Card & High Level Stats
        Expanded(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            child: Column(
              children: [
                _buildProfileCard(context),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ref.read(authNotifierProvider.notifier).logout();
                      context.go('/auth_landing');
                    },
                    icon: const HugeIcon(
                      icon: HugeIcons.strokeRoundedLogout01,
                      color: AppColors.error,
                      size: 28,
                    ),
                    label: Text(
                      'Log Out',
                      style: AppTypography.headingSmall.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.error, width: 2),
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.lg,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppSpacing.borderRadius,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const VerticalDivider(width: 1, color: AppColors.border),
        // Right Column: Settings Lists
        Expanded(
          flex: 6,
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            children: [
              Text('Account Settings', style: AppTypography.headingLarge),
              const SizedBox(height: AppSpacing.lg),
              _buildTabletListTile(
                HugeIcons.strokeRoundedUserEdit01,
                'Edit Profile',
                'Update your personal details',
              ),
              _buildTabletListTile(
                HugeIcons.strokeRoundedLockPassword,
                'Change Password',
                'Secure your account',
              ),
              _buildTabletListTile(
                HugeIcons.strokeRoundedNotification03,
                'Notifications',
                'Manage alerts and emails',
              ),
              const SizedBox(height: AppSpacing.xxl),
              Text('Support & Legal', style: AppTypography.headingLarge),
              const SizedBox(height: AppSpacing.lg),
              _buildTabletListTile(
                HugeIcons.strokeRoundedCustomerService01,
                'Help Center',
                'Get support and FAQs',
              ),
              _buildTabletListTile(
                HugeIcons.strokeRoundedDocumentValidation,
                'Terms of Service',
                'Read our rules',
              ),
              _buildTabletListTile(
                HugeIcons.strokeRoundedShield01,
                'Privacy Policy',
                'Understand how we use your data',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 70,
            backgroundColor: AppColors.primary,
            child: HugeIcon(
              icon: HugeIcons.strokeRoundedUser,
              color: AppColors.background,
              size: 70,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text('Gamer One', style: AppTypography.headingLarge),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'gamer@gamingzone.com',
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            decoration: BoxDecoration(
              color: AppColors.rose.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppSpacing.xxl),
              border: Border.all(color: AppColors.rose.withValues(alpha: 0.5)),
            ),
            child: Text(
              'Gold Tier Member',
              style: AppTypography.headingMedium.copyWith(
                color: AppColors.rose,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabletListTile(dynamic icon, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.background,
            shape: BoxShape.circle,
          ),
          child: HugeIcon(icon: icon, color: AppColors.primary, size: 24),
        ),
        title: Text(title, style: AppTypography.headingSmall),
        subtitle: Text(
          subtitle,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: AppColors.textSecondary,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        onTap: () {
          // Placeholder
        },
      ),
    );
  }
}
