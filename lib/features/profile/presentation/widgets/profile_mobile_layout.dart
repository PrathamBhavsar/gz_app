import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../auth/presentation/providers/auth_notifier.dart';

class ProfileMobileLayout extends ConsumerWidget {
  const ProfileMobileLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        _buildProfileHeader(context),
        const SizedBox(height: AppSpacing.xxl),
        _buildSectionTitle('Account Settings'),
        _buildListTile(HugeIcons.strokeRoundedUserEdit01, 'Edit Profile'),
        _buildListTile(HugeIcons.strokeRoundedLockPassword, 'Change Password'),
        _buildListTile(HugeIcons.strokeRoundedNotification03, 'Notifications'),
        const SizedBox(height: AppSpacing.xl),
        _buildSectionTitle('Support & Legal'),
        _buildListTile(HugeIcons.strokeRoundedCustomerService01, 'Help Center'),
        _buildListTile(
          HugeIcons.strokeRoundedDocumentValidation,
          'Terms of Service',
        ),
        _buildListTile(HugeIcons.strokeRoundedShield01, 'Privacy Policy'),
        const SizedBox(height: AppSpacing.xxl),
        ElevatedButton.icon(
          onPressed: () {
            ref.read(authNotifierProvider.notifier).logout();
            context.go(
              '/auth_landing',
            ); // Temporary hard redirect since GoRouter redirect logic might be stubbed
          },
          icon: const HugeIcon(
            icon: HugeIcons.strokeRoundedLogout01,
            color: AppColors.background,
            size: 24,
          ),
          label: Text('Log Out', style: AppTypography.button),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.error,
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
      ],
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Column(
      children: [
        const CircleAvatar(
          radius: 50,
          backgroundColor: AppColors.primary,
          child: HugeIcon(
            icon: HugeIcons.strokeRoundedUser,
            color: AppColors.background,
            size: 50,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Gamer One', style: AppTypography.headingLarge),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'gamer@gamingzone.com',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: AppColors.rose.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(AppSpacing.lg),
            border: Border.all(color: AppColors.rose.withValues(alpha: 0.5)),
          ),
          child: Text(
            'Gold Tier',
            style: AppTypography.bodyLarge.copyWith(color: AppColors.rose),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Text(title, style: AppTypography.headingMedium),
    );
  }

  Widget _buildListTile(dynamic icon, String title) {
    return ListTile(
      leading: HugeIcon(icon: icon, color: AppColors.textPrimary, size: 24),
      title: Text(title, style: AppTypography.bodyLarge),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
      contentPadding: EdgeInsets.zero,
      onTap: () {
        // Placeholder interaction
      },
    );
  }
}
