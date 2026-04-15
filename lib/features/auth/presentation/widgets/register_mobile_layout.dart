import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/navigation/routes.dart';

class RegisterMobileLayout extends StatelessWidget {
  const RegisterMobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Create an account', style: AppTypography.headingLarge),
          const SizedBox(height: AppSpacing.xxl),
          _buildTextField(label: 'Full Name'),
          const SizedBox(height: AppSpacing.md),
          _buildTextField(label: 'Phone Number (Optional)'),
          const SizedBox(height: AppSpacing.md),
          _buildTextField(label: 'Email Address (Optional)'),
          const SizedBox(height: AppSpacing.md),
          _buildTextField(label: 'Password (Optional)', obscureText: true),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // If phone provided context.push(AppRoutes.otpVerification)
                context.push(AppRoutes.otpVerification);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.background,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.borderRadius)),
              ),
              child: Text('Register', style: AppTypography.button),
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
