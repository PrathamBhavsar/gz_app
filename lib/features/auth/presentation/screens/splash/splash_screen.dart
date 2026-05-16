import 'package:flutter/material.dart';
import '../../../../../core/responsive/breakpoints.dart';
import '../../../../../core/responsive/responsive_builder.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../widgets/splash_mobile_layout.dart';
import '../../widgets/splash_tablet_layout.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: ResponsiveBuilderWidget(
        builder: (context, deviceType) => switch (deviceType) {
          DeviceType.mobile  => const SplashMobileLayout(),
          DeviceType.tablet  => const SplashTabletLayout(),
          DeviceType.desktop => const SplashTabletLayout(),
        },
      ),
    );
  }
}
