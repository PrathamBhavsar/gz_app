import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/auth/token_storage.dart';
import '../../../../../core/navigation/routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../shared/widgets/gz_logo.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 2), _navigate);
  }

  Future<void> _navigate() async {
    if (!mounted) return;
    final storage = ref.read(tokenStorageProvider);

    final hasSeenOnboarding = await storage.getHasSeenOnboarding();
    if (!hasSeenOnboarding) {
      if (mounted) context.go(AppRoutes.onboarding);
      return;
    }

    final refreshToken = await storage.getRefreshToken();
    if (refreshToken == null) {
      if (mounted) context.go(AppRoutes.authLanding);
      return;
    }

    final userType = await storage.getUserType();
    if (mounted) {
      context.go(userType == 'admin' ? AppRoutes.adminDashboard : AppRoutes.home);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 72,
              height: 72,
              child: FittedBox(child: GzLogo()),
            ),
            const SizedBox(height: 20),
            Text('Gaming Zone', style: AppTypography.h2),
          ],
        ),
      ),
    );
  }
}
