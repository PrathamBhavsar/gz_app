import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/navigation/routes.dart';

class AuthLandingTabletLayout extends StatelessWidget {
  const AuthLandingTabletLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Welcome to', style: AppTypography.headingSmall.copyWith(color: AppColors.textSecondary)),
              Text('GAMING ZONE', style: AppTypography.headingLarge.copyWith(fontSize: 48)),
              const SizedBox(height: AppSpacing.xxl),
              _buildAuthButton(
                context: context,
                icon: HugeIcons.strokeRoundedMessage01,
                label: 'Continue with Phone',
                onTap: () {},
                isPrimary: true,
              ),
              const SizedBox(height: AppSpacing.md),
              _buildAuthButton(
                context: context,
                icon: HugeIcons.strokeRoundedMail01,
                label: 'Continue with Email',
                onTap: () => context.go(AppRoutes.emailLogin),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?", style: AppTypography.bodyMedium),
                  TextButton(
                    onPressed: () => context.go(AppRoutes.register),
                    child: Text('Create one', style: AppTypography.button.copyWith(color: AppColors.rose)),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAuthButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isPrimary = false,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: HugeIcon(icon: icon, color: isPrimary ? AppColors.background : AppColors.textPrimary, size: 24),
        label: Text(label, style: AppTypography.button.copyWith(fontSize: 16)),
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? AppColors.primary : AppColors.surface,
          foregroundColor: isPrimary ? AppColors.background : AppColors.textPrimary,
          padding: const EdgeInsets.symmetric(vertical: 20),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
            side: isPrimary ? BorderSide.none : const BorderSide(color: AppColors.border),
          ),
        ),
      ),
    );
  }
}
