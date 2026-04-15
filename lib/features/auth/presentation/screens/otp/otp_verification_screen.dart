import 'package:flutter/material.dart';
import '../../../../../core/responsive/breakpoints.dart';
import '../../../../../core/responsive/responsive_builder.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../widgets/otp_verification_mobile_layout.dart';
import '../../widgets/otp_verification_tablet_layout.dart';

class OtpVerificationScreen extends StatelessWidget {
  const OtpVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: ResponsiveBuilderWidget(
        builder: (context, deviceType) => switch (deviceType) {
          DeviceType.mobile => const OtpVerificationMobileLayout(),
          DeviceType.tablet => const OtpVerificationTabletLayout(),
          DeviceType.desktop => const OtpVerificationTabletLayout(),
        },
      ),
    );
  }
}
