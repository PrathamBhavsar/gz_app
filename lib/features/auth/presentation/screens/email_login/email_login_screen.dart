import 'package:flutter/material.dart';
import '../../../../../core/responsive/breakpoints.dart';
import '../../../../../core/responsive/responsive_builder.dart';
import '../../../../../core/theme/app_colors.dart';
import '../widgets/email_login_mobile_layout.dart';
import '../widgets/email_login_tablet_layout.dart';

class EmailLoginScreen extends StatelessWidget {
  const EmailLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: ResponsiveBuilderWidget(
        builder: (context, deviceType) => switch (deviceType) {
          DeviceType.mobile => const EmailLoginMobileLayout(),
          DeviceType.tablet => const EmailLoginTabletLayout(),
          DeviceType.desktop => const EmailLoginTabletLayout(),
        },
      ),
    );
  }
}
