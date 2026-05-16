import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/navigation/routes.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../shared/widgets/em_gz_logo.dart';
import '../../../../../shared/widgets/em_live_dot.dart';
import '../providers/splash_notifier.dart';

class SplashTabletLayout extends ConsumerWidget {
  const SplashTabletLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<SplashState>(splashNotifierProvider, (_, next) {
      switch (next) {
        case SplashToHome():
          context.go(AppRoutes.home);
        case SplashToAdmin():
          context.go(AppRoutes.adminDashboard);
        case SplashToAuth():
          context.go(AppRoutes.authLanding);
        case SplashToOnboarding():
          context.go(AppRoutes.onboarding);
        case SplashChecking():
          break;
      }
    });

    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          EmGzLogo(),
          SizedBox(height: AppSpacing.sm),
          EmLiveDot(),
        ],
      ),
    );
  }
}
