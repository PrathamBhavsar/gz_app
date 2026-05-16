import 'package:flutter/material.dart';
import '../../../../core/responsive/responsive_builder.dart';
import '../../../../core/responsive/breakpoints.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/change_phone_mobile_layout.dart';

class ChangePhoneScreen extends StatelessWidget {
  const ChangePhoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: ResponsiveBuilderWidget(
        builder: (context, deviceType) => switch (deviceType) {
          DeviceType.mobile  => const ChangePhoneMobileLayout(),
          DeviceType.tablet  => const ChangePhoneMobileLayout(),
          DeviceType.desktop => const ChangePhoneMobileLayout(),
        },
      ),
    );
  }
}
