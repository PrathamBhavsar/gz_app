import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/navigation/routes.dart';

class EmailVerificationPendingTabletLayout extends StatelessWidget {
  const EmailVerificationPendingTabletLayout({super.key});

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
              Icon(Icons.mark_email_unread_outlined, size: 100, color: AppColors.rose),
              const SizedBox(height: AppSpacing.xl),
              Text('Check your inbox', style: AppTypography.headingLarge.copyWith(fontSize: 40)),
              const SizedBox(height: AppSpacing.md),
              Text(
                'We have sent a verification link. Please verify your email to continue.',
                style: AppTypography.bodyLarge.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xxl),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Check verification API Call
                    context.go(AppRoutes.home);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.background,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.borderRadius)),
                  ),
                  child: Text("I've verified, continue", style: AppTypography.button.copyWith(fontSize: 16)),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              TextButton(
                onPressed: () {
                  // Resend email
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Verification email resent.')),
                  );
                },
                child: Text('Resend verification email', style: AppTypography.button.copyWith(color: AppColors.textSecondary, fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
