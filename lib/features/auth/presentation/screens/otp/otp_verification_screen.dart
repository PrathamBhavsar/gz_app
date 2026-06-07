import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';


import '../../../../../core/navigation/routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../shared/widgets/gz_button.dart';
import '../../../../../shared/widgets/gz_top_bar.dart';

class OtpVerificationScreen extends StatelessWidget {
  const OtpVerificationScreen({super.key});

  void _verify(BuildContext context) {
    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    const digits = ['4', '2', '1', '8', '', ''];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const GzTopBar(title: ''),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Verify your number', style: AppTypography.h1),
              const SizedBox(height: 8),
              Text(
                'We sent a 6-digit code to +91 98765 43210',
                style: AppTypography.bodyR,
              ),
              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) {
                  final isActive = index == 4;
                  final isFilled = digits[index].isNotEmpty;
                  return Container(
                    width: 48,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(
                        AppSpacing.borderRadius,
                      ),
                      border: Border.all(
                        color: isActive
                            ? AppColors.textPrimary
                            : AppColors.rule,
                        width: isActive ? 1.5 : 1,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: isFilled
                        ? Text(digits[index], style: AppTypography.h2)
                        : (isActive
                            ? Container(
                                width: 2,
                                height: 22,
                                color: AppColors.textPrimary,
                              )
                            : null),
                  );
                }),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  'Resend in 0:42',
                  style: AppTypography.small.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const Spacer(),
              GzButton(
                label: 'Verify',
                onPressed: () => _verify(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
