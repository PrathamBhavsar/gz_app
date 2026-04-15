import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/navigation/routes.dart';

class EmailVerificationPendingMobileLayout extends StatelessWidget {
  const EmailVerificationPendingMobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Icon(Icons.mark_email_unread_outlined, size: 80, color: AppColors.rose),
          const SizedBox(height: AppSpacing.lg),
          Text('Check your inbox', style: AppTypography.headingLarge),
          const SizedBox(height: AppSpacing.md),
          Text(
            'We have sent a verification link. Please verify your email to continue.',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
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
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.borderRadius)),
              ),
              child: Text("I've verified, continue", style: AppTypography.button),
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
            child: Text('Resend verification email', style: AppTypography.button.copyWith(color: AppColors.textSecondary)),
          ),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }
}
