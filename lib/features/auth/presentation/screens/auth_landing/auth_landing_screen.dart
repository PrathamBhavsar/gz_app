import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/navigation/routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../shared/widgets/gz_button.dart';
import '../../../../../shared/widgets/gz_logo.dart';

class AuthLandingScreen extends StatelessWidget {
  const AuthLandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(child: GzLogo()),
              const Spacer(),
              Text('Welcome back', style: AppTypography.h1),
              const SizedBox(height: 8),
              Text('Sign in to continue', style: AppTypography.bodyR),
              const SizedBox(height: 24),
              GzButton(
                label: 'Continue with Google',
                variant: GzButtonVariant.ghost,
                icon: const _CircleTextIcon(
                  label: 'G',
                  background: AppColors.surface,
                ),
                onPressed: () => context.go(AppRoutes.oauthHandler),
              ),
              const SizedBox(height: 12),
              GzButton(
                label: 'Continue with Apple',
                variant: GzButtonVariant.ghost,
                icon: const _CircleTextIcon(
                  label: 'A',
                  background: AppColors.textPrimary,
                  foreground: AppColors.surface,
                ),
                onPressed: () => context.go(AppRoutes.oauthHandler),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  const Expanded(child: Divider(color: AppColors.rule)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text('or', style: AppTypography.small),
                  ),
                  const Expanded(child: Divider(color: AppColors.rule)),
                ],
              ),
              const SizedBox(height: 18),
              GzButton(
                label: 'Continue with email',
                variant: GzButtonVariant.ghost,
                onPressed: () => context.go(AppRoutes.emailLogin),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => context.go(AppRoutes.register),
                child: Text(
                  'New here? Create account →',
                  style: AppTypography.body.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => context.go(AppRoutes.adminLogin),
                child: Text(
                  'Admin? Sign in →',
                  style: AppTypography.small.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CircleTextIcon extends StatelessWidget {
  const _CircleTextIcon({
    required this.label,
    required this.background,
    this.foreground = AppColors.textPrimary,
  });

  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.rule),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: AppTypography.small.copyWith(
          color: foreground,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
