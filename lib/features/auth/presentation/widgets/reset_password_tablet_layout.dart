import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/navigation/routes.dart';

class ResetPasswordTabletLayout extends StatelessWidget {
  const ResetPasswordTabletLayout({super.key});

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
              Text('Set new password', style: AppTypography.headingLarge.copyWith(fontSize: 40)),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Create a strong password that is at least 8 characters long.',
                style: AppTypography.bodyLarge.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.xxl),
              _buildTextField(label: 'New Password', obscureText: true),
              const SizedBox(height: AppSpacing.md),
              _buildTextField(label: 'Confirm New Password', obscureText: true),
              const SizedBox(height: AppSpacing.xl),
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
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.borderRadius)),
                  ),
                  child: Text('Update Password', style: AppTypography.button.copyWith(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
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
