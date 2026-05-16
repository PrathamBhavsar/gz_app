import 'package:flutter/material.dart';
import '../../../../core/responsive/responsive_builder.dart';
import '../../../../core/responsive/breakpoints.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/disputes_list_mobile_layout.dart';

class DisputesListScreen extends StatelessWidget {
  const DisputesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: ResponsiveBuilderWidget(
        builder: (context, deviceType) => switch (deviceType) {
          DeviceType.mobile  => const DisputesListMobileLayout(),
          DeviceType.tablet  => const DisputesListMobileLayout(),
          DeviceType.desktop => const DisputesListMobileLayout(),
        },
      ),
    );
  }
}
