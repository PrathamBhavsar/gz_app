import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/theme/app_spacing.dart';

class OAuthHandlerTabletLayout extends StatelessWidget {
  const OAuthHandlerTabletLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: AppColors.rose),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'Signing you in...',
            style: AppTypography.headingMedium,
          ),
        ],
      ),
    );
  }
}
