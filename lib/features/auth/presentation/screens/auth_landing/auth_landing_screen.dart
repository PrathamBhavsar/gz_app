import 'package:flutter/material.dart';
import '../../../../../core/responsive/breakpoints.dart';
import '../../../../../core/responsive/responsive_builder.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../widgets/auth_landing_mobile_layout.dart';
import '../../widgets/auth_landing_tablet_layout.dart';

class AuthLandingScreen extends StatelessWidget {
  const AuthLandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: ResponsiveBuilderWidget(
        builder: (context, deviceType) => switch (deviceType) {
          DeviceType.mobile => const AuthLandingMobileLayout(),
          DeviceType.tablet => const AuthLandingTabletLayout(),
          DeviceType.desktop => const AuthLandingTabletLayout(),
        },
      ),
    );
  }
}
