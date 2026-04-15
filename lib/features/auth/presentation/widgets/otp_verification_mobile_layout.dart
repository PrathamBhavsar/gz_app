import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/navigation/routes.dart';

class OtpVerificationMobileLayout extends StatelessWidget {
  const OtpVerificationMobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Enter OTP', style: AppTypography.headingLarge),
          const SizedBox(height: AppSpacing.sm),
          Text('Sent to +91 ••••• 67890', style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: AppSpacing.xxl),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(6, (index) => _buildOtpBox()),
          ),
          const SizedBox(height: AppSpacing.xl),
          Center(
            child: Text('Resend in 0:45', style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Submit and go home
                context.go(AppRoutes.home);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.background,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.borderRadius)),
              ),
              child: Text('Verify & Continue', style: AppTypography.button),
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }

  Widget _buildOtpBox() {
    return Container(
      width: 48,
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
      ),
      child: Center(
        child: TextField(
          textAlign: TextAlign.center,
          style: AppTypography.headingMedium,
          keyboardType: TextInputType.number,
          maxLength: 1,
          decoration: const InputDecoration(
            counterText: '',
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
