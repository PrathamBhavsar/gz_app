import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/theme/app_spacing.dart';

class ForgotPasswordTabletLayout extends StatelessWidget {
  const ForgotPasswordTabletLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Forgot Password', style: AppTypography.headingLarge.copyWith(fontSize: 40)),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Enter your registered email address securely. We will send you a link to reset your password.',
                style: AppTypography.bodyLarge.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.xxl),
              TextField(
                style: AppTypography.bodyLarge,
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  labelStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('If that email is registered, a reset link has been sent.')),
                    );
                    context.pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.background,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.borderRadius)),
                  ),
                  child: Text('Reset Password', style: AppTypography.button.copyWith(fontSize: 16)),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Center(
                child: TextButton(
                  onPressed: () => context.pop(),
                  child: Text('Back to Login', style: AppTypography.button.copyWith(color: AppColors.textSecondary, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
