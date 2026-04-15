import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/theme/app_spacing.dart';

class BookingSuccessMobileLayout extends StatelessWidget {
  const BookingSuccessMobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const HugeIcon(icon: HugeIcons.strokeRoundedTick01, color: AppColors.primary, size: 80),
          ),
          const SizedBox(height: AppSpacing.xxl),
          Text('Booking Confirmed!', style: AppTypography.headingLarge),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Your gaming session has been reserved successfully. You can manage your upcoming sessions in the Sessions tab.',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                context.go('/sessions');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.borderRadius)),
              ),
              child: Text('View Sessions', style: AppTypography.button),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextButton(
            onPressed: () => context.go('/home'),
            child: Text('Back to Home', style: AppTypography.button.copyWith(color: AppColors.textSecondary)),
          ),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }
}
