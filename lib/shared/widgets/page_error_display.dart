import 'package:flutter/material.dart';
import 'package:gz_app/core/theme/app_colors.dart';
import 'package:gz_app/core/theme/app_spacing.dart';
import 'package:gz_app/core/theme/app_typography.dart';
import 'package:gz_app/shared/widgets/huge_icon_widget.dart';
import 'package:gz_app/core/errors/app_exception.dart';

class PageErrorDisplay extends StatelessWidget {
  const PageErrorDisplay({
    super.key,
    required this.error,
    required this.onRetry,
  });

  final AppPageError error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: ColoredBox(
        color: AppColors.background,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HugeIconWidget(
                icon: error.icon,
                size: 80,
                color: AppColors.textSecondary,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                error.title,
                style: AppTypography.headingSmall.copyWith(
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                error.message,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: onRetry,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    side: const BorderSide(color: AppColors.border),
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.md,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
                    ),
                  ),
                  child: Text('Retry', style: AppTypography.button),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
