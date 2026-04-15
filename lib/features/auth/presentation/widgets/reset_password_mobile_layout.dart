import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/navigation/routes.dart';

class ResetPasswordMobileLayout extends StatelessWidget {
  const ResetPasswordMobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Set new password', style: AppTypography.headingLarge),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Create a strong password that is at least 8 characters long.',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.xxl),
          _buildTextField(label: 'New Password', obscureText: true),
          const SizedBox(height: AppSpacing.md),
          _buildTextField(label: 'Confirm New Password', obscureText: true),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Password updated successfully')),
                );
                context.go(AppRoutes.authLanding);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.background,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.borderRadius)),
              ),
              child: Text('Update Password', style: AppTypography.button),
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }

  Widget _buildTextField({required String label, bool obscureText = false}) {
    return TextField(
      obscureText: obscureText,
      style: AppTypography.bodyLarge,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm), borderSide: BorderSide.none),
      ),
    );
  }
}
