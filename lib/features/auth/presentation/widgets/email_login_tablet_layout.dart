import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/navigation/routes.dart';

class EmailLoginTabletLayout extends StatelessWidget {
  const EmailLoginTabletLayout({super.key});

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
              Text('Welcome back,', style: AppTypography.headingSmall.copyWith(color: AppColors.textSecondary)),
              Text('Log in', style: AppTypography.headingLarge.copyWith(fontSize: 40)),
              const SizedBox(height: AppSpacing.xxl),
              TextField(
                style: AppTypography.bodyLarge,
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  labelStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                obscureText: true,
                style: AppTypography.bodyLarge,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm), borderSide: BorderSide.none),
                  suffixIcon: const Icon(Icons.visibility_off, color: AppColors.textSecondary),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => context.push(AppRoutes.forgotPassword),
                  child: Text('Forgot Password?', style: AppTypography.button.copyWith(color: AppColors.rose)),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.background,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.borderRadius)),
                  ),
                  child: Text('Log in with Email', style: AppTypography.button.copyWith(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
