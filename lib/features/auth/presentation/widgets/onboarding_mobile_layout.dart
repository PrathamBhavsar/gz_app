import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/navigation/routes.dart';

class OnboardingMobileLayout extends StatelessWidget {
  const OnboardingMobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Icon(Icons.sports_esports, size: 100, color: AppColors.primary),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Book Gaming Slots',
            style: AppTypography.headingLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Reserve PCs and Consoles instantly.',
            style: AppTypography.bodyLarge.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => context.go(AppRoutes.authLanding),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.background,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
                ),
              ),
              child: Text('Get Started', style: AppTypography.button),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextButton(
            onPressed: () => context.go(AppRoutes.authLanding),
            child: Text('Skip', style: AppTypography.button.copyWith(color: AppColors.textSecondary)),
          ),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }
}
