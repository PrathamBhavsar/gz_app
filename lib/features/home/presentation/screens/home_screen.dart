import 'package:flutter/material.dart';
import '../../../../../core/responsive/breakpoints.dart';
import '../../../../../core/responsive/responsive_builder.dart';
import '../../../../../core/theme/app_colors.dart';
import '../widgets/home_mobile_layout.dart';
import '../widgets/home_tablet_layout.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: ResponsiveBuilderWidget(
        builder: (context, deviceType) => switch (deviceType) {
          DeviceType.mobile => const HomeMobileLayout(),
          DeviceType.tablet => const HomeTabletLayout(),
          DeviceType.desktop => const HomeTabletLayout(),
        },
      ),
    );
  }
}
