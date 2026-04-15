import 'package:flutter/material.dart';
import '../../../../../core/responsive/breakpoints.dart';
import '../../../../../core/responsive/responsive_builder.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../widgets/email_verification_pending_mobile_layout.dart';
import '../../widgets/email_verification_pending_tablet_layout.dart';

class EmailVerificationPendingScreen extends StatelessWidget {
  const EmailVerificationPendingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: ResponsiveBuilderWidget(
        builder: (context, deviceType) => switch (deviceType) {
          DeviceType.mobile => const EmailVerificationPendingMobileLayout(),
          DeviceType.tablet => const EmailVerificationPendingTabletLayout(),
          DeviceType.desktop => const EmailVerificationPendingTabletLayout(),
        },
      ),
    );
  }
}
