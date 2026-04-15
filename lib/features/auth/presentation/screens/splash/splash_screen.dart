import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/responsive/breakpoints.dart';
import '../../../../../core/responsive/responsive_builder.dart';
import '../../../../../core/theme/app_colors.dart';
import '../widgets/splash_mobile_layout.dart';
import '../widgets/splash_tablet_layout.dart';
import '../../providers/auth_notifier.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Start auth check on boot
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authNotifierProvider.notifier).checkAuthStatus();
    });
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
