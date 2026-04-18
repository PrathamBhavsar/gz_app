import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/responsive/breakpoints.dart';
import '../../../../../core/responsive/responsive_builder.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/navigation/routes.dart';
import '../../../../../core/auth/token_storage.dart';
import '../../../../auth/data/repositories/auth_repository.dart';
import '../../widgets/splash_mobile_layout.dart';
import '../../widgets/splash_tablet_layout.dart';
import '../../providers/auth_notifier.dart';
import '../../providers/auth_state.dart';
import '../../../../admin/presentation/providers/admin_auth_provider.dart';
import '../../../../admin/presentation/providers/admin_auth_state.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleSplash();
    });
  }

  void _go(String location) {
    if (_navigated || !mounted) return;
    _navigated = true;
    context.go(location);
  }

  Future<void> _handleSplash() async {
    if (_navigated) return;

    final tokenStorage = ref.read(tokenStorageProvider);

    // Phase 1: Check if any tokens exist
    final refreshToken = await tokenStorage.getRefreshToken();
    final accessToken = ref.read(accessTokenProvider);

    if (accessToken == null && refreshToken == null) {
      _go(AppRoutes.authLanding);
      return;
    }

    // Check user type to decide player vs admin flow
    final userType = await tokenStorage.getUserType();

    if (userType == 'admin') {
      // Admin flow: validate admin token with GET /auth/admin/me
      if (accessToken == null && refreshToken != null) {
        try {
          final newAccessToken = await ref
              .read(authRepositoryProvider)
              .refreshAccessToken();

          if (newAccessToken == null) {
            await tokenStorage.clearAll();
            _go(AppRoutes.authLanding);
            return;
          }
        } catch (_) {
          await tokenStorage.clearAll();
          _go(AppRoutes.authLanding);
          return;
        }
      }

      if (_navigated || !mounted) return;

      // Validate admin session
      await ref.read(adminAuthNotifierProvider.notifier).checkAdminStatus();

      if (_navigated || !mounted) return;

      final adminState = ref.read(adminAuthNotifierProvider);
      if (adminState is AdminAuthAuthenticated) {
        _go(AppRoutes.adminDashboard);
      } else {
        _go(AppRoutes.authLanding);
      }
      return;
    }

    // Player flow (original logic)

    // Phase 2: If we have no access token but have a refresh token,
    // attempt a silent refresh before trying /auth/me.
    if (accessToken == null && refreshToken != null) {
      try {
        final newAccessToken = await ref
            .read(authRepositoryProvider)
            .refreshAccessToken();

        if (newAccessToken == null) {
          await tokenStorage.clearAll();
          _go(AppRoutes.authLanding);
          return;
        }
      } catch (_) {
        await tokenStorage.clearAll();
        _go(AppRoutes.authLanding);
        return;
      }
    }

    if (_navigated || !mounted) return;

    // Phase 3: Validate session with server.
    // accessTokenProvider now has a token, so GET /auth/me includes Bearer.
    // If it 401s, the interceptor will attempt one more refresh automatically.
    await ref.read(authNotifierProvider.notifier).checkAuthStatus();

    if (_navigated || !mounted) return;

    final authState = ref.read(authNotifierProvider);
    if (authState is AuthAuthenticated) {
      _go(AppRoutes.home);
    } else {
      _go(AppRoutes.authLanding);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: ResponsiveBuilderWidget(
        builder: (context, deviceType) => switch (deviceType) {
          DeviceType.mobile => const SplashMobileLayout(),
          DeviceType.tablet => const SplashTabletLayout(),
          DeviceType.desktop => const SplashTabletLayout(),
        },
      ),
    );
  }
}
