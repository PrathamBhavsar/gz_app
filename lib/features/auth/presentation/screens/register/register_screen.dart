import 'package:flutter/material.dart';
import '../../../../../core/responsive/breakpoints.dart';
import '../../../../../core/responsive/responsive_builder.dart';
import '../../../../../core/theme/app_colors.dart';
import '../widgets/register_mobile_layout.dart';
import '../widgets/register_tablet_layout.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: ResponsiveBuilderWidget(
        builder: (context, deviceType) => switch (deviceType) {
          DeviceType.mobile => const RegisterMobileLayout(),
          DeviceType.tablet => const RegisterTabletLayout(),
          DeviceType.desktop => const RegisterTabletLayout(),
        },
      ),
    );
  }
}
