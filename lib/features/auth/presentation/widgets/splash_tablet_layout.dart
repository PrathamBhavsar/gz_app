import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../providers/auth_notifier.dart';
import '../../providers/auth_state.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/navigation/routes.dart';

class SplashTabletLayout extends ConsumerWidget {
  const SplashTabletLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      if (next is AuthUnauthenticated) {
        context.go(AppRoutes.onboarding);
      } else if (next is AuthAuthenticated) {
        context.go(AppRoutes.home);
      }
    });

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.gamepad,
            size: 120, // Larger for tablet
            color: AppColors.rose,
          ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'GAMING ZONE',
            style: AppTypography.headingLarge.copyWith(fontSize: 48), // Handled responsive sizes ideally but fixed here
          ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
        ],
      ),
    );
  }
}
