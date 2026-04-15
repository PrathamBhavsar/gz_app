import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/navigation/routes.dart';

class OnboardingTabletLayout extends StatelessWidget {
  const OnboardingTabletLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Icon(Icons.sports_esports, size: 150, color: AppColors.primary),
              const SizedBox(height: AppSpacing.xl),
              Text(
                'Book Gaming Slots',
                style: AppTypography.headingLarge.copyWith(fontSize: 48),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Reserve PCs and Consoles instantly.',
                style: AppTypography.bodyLarge.copyWith(color: AppColors.textSecondary, fontSize: 20),
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
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
                    ),
                  ),
                  child: Text('Get Started', style: AppTypography.button.copyWith(fontSize: 18)),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              TextButton(
                onPressed: () => context.go(AppRoutes.authLanding),
                child: Text('Skip', style: AppTypography.button.copyWith(color: AppColors.textSecondary, fontSize: 18)),
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }
}
