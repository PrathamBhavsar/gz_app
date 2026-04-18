import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/navigation/routes.dart';

class AuthLandingMobileLayout extends StatelessWidget {
  const AuthLandingMobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Text(
            'Welcome to',
            style: AppTypography.headingSmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          Text('GAMING ZONE', style: AppTypography.headingLarge),
          const SizedBox(height: AppSpacing.xxl),
          _buildAuthButton(
            context: context,
            icon: HugeIcons.strokeRoundedMessage01,
            label: 'Continue with Phone',
            onTap: () {
              // Open bottom sheet
            },
            isPrimary: true,
          ),
          const SizedBox(height: AppSpacing.md),
          _buildAuthButton(
            context: context,
            icon: HugeIcons.strokeRoundedMail01,
            label: 'Continue with Email',
            onTap: () => context.go(AppRoutes.emailLogin),
          ),
          const SizedBox(height: AppSpacing.md),
          _buildAuthButton(
            context: context,
            icon: HugeIcons.strokeRoundedApple,
            label: 'Continue with Apple',
            onTap: () {},
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Don't have an account?", style: AppTypography.bodyMedium),
              TextButton(
                onPressed: () => context.go(AppRoutes.register),
                child: Text(
                  'Create one',
                  style: AppTypography.button.copyWith(color: AppColors.rose),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          // Admin login link
          const Divider(color: AppColors.border, thickness: 1),
          const SizedBox(height: AppSpacing.sm),
          TextButton(
            onPressed: () => context.go(AppRoutes.adminLogin),
            child: Text(
              'Store Admin / Staff Login',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }

  Widget _buildAuthButton({
    required BuildContext context,
    required dynamic icon,
    required String label,
    required VoidCallback onTap,
    bool isPrimary = false,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: HugeIcon(
          icon: icon,
          color: isPrimary ? AppColors.background : AppColors.textPrimary,
          size: 20,
        ),
        label: Text(label, style: AppTypography.button),
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? AppColors.primary : AppColors.surface,
          foregroundColor: isPrimary
              ? AppColors.background
              : AppColors.textPrimary,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
            side: isPrimary
                ? BorderSide.none
                : const BorderSide(color: AppColors.border),
          ),
        ),
      ),
    );
  }
}
