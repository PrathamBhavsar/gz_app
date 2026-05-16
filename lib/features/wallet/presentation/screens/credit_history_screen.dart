import 'package:flutter/material.dart';
import '../../../../core/responsive/breakpoints.dart';
import '../../../../core/responsive/responsive_builder.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/credit_history_mobile_layout.dart';

class CreditHistoryScreen extends StatelessWidget {
  const CreditHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: ResponsiveBuilderWidget(
        builder: (context, deviceType) => switch (deviceType) {
          DeviceType.mobile  => const CreditHistoryMobileLayout(),
          DeviceType.tablet  => const CreditHistoryMobileLayout(),
          DeviceType.desktop => const CreditHistoryMobileLayout(),
        },
      ),
    );
  }
}
