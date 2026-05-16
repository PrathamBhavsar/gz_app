import 'package:flutter/material.dart';
import '../../../../core/responsive/responsive_builder.dart';
import '../../../../core/responsive/breakpoints.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/edit_profile_mobile_layout.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: ResponsiveBuilderWidget(
        builder: (context, deviceType) => switch (deviceType) {
          DeviceType.mobile  => const EditProfileMobileLayout(),
          DeviceType.tablet  => const EditProfileMobileLayout(),
          DeviceType.desktop => const EditProfileMobileLayout(),
        },
      ),
    );
  }
}
