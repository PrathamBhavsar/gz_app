import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../core/navigation/routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../shared/widgets/gz_button.dart';

class EmailVerificationPendingScreen extends StatelessWidget {
  const EmailVerificationPendingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const HugeIcon(
                  icon: HugeIcons.strokeRoundedMail01,
                  color: AppColors.textPrimary,
                  size: 64,
                ),
                const SizedBox(height: 20),
                Text('Check your inbox', style: AppTypography.h1),
                const SizedBox(height: 10),
                Text(
                  'We sent a verification link to rahul@example.com',
                  style: AppTypography.bodyR,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                const GzButton(
                  label: 'Resend email',
                  variant: GzButtonVariant.ghost,
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => context.go(AppRoutes.emailLogin),
                  child: Text(
                    'Wrong email? Go back',
                    style: AppTypography.body.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
