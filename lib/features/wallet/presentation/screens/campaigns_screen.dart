import 'package:flutter/material.dart';
import '../../../../core/responsive/breakpoints.dart';
import '../../../../core/responsive/responsive_builder.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/campaigns_mobile_layout.dart';

class CampaignsScreen extends StatelessWidget {
  const CampaignsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: ResponsiveBuilderWidget(
        builder: (context, deviceType) => switch (deviceType) {
          DeviceType.mobile  => const CampaignsMobileLayout(),
          DeviceType.tablet  => const CampaignsMobileLayout(),
          DeviceType.desktop => const CampaignsMobileLayout(),
        },
      ),
    );
  }
}
