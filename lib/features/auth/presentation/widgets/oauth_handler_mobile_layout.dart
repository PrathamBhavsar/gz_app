import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/theme/app_spacing.dart';

class OAuthHandlerMobileLayout extends StatelessWidget {
  const OAuthHandlerMobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: AppColors.rose),
          const SizedBox(height: AppSpacing.lg),
          Text('Signing you in...', style: AppTypography.headingSmall),
        ],
      ),
    );
  }
}
