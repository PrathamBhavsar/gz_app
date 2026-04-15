import 'package:flutter/material.dart';
import '../../../../../core/responsive/breakpoints.dart';
import '../../../../../core/responsive/responsive_builder.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../widgets/reset_password_mobile_layout.dart';
import '../../widgets/reset_password_tablet_layout.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: ResponsiveBuilderWidget(
        builder: (context, deviceType) => switch (deviceType) {
          DeviceType.mobile => const ResetPasswordMobileLayout(),
          DeviceType.tablet => const ResetPasswordTabletLayout(),
          DeviceType.desktop => const ResetPasswordTabletLayout(),
        },
      ),
    );
  }
}
