import 'package:flutter/material.dart';
import '../../../../../core/responsive/breakpoints.dart';
import '../../../../../core/responsive/responsive_builder.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../widgets/forgot_password_mobile_layout.dart';
import '../../widgets/forgot_password_tablet_layout.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: ResponsiveBuilderWidget(
        builder: (context, deviceType) => switch (deviceType) {
          DeviceType.mobile => const ForgotPasswordMobileLayout(),
          DeviceType.tablet => const ForgotPasswordTabletLayout(),
          DeviceType.desktop => const ForgotPasswordTabletLayout(),
        },
      ),
    );
  }
}
