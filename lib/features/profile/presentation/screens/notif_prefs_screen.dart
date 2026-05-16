import 'package:flutter/material.dart';
import '../../../../core/responsive/responsive_builder.dart';
import '../../../../core/responsive/breakpoints.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/notif_prefs_mobile_layout.dart';

class NotifPrefsScreen extends StatelessWidget {
  const NotifPrefsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: ResponsiveBuilderWidget(
        builder: (context, deviceType) => switch (deviceType) {
          DeviceType.mobile  => const NotifPrefsMobileLayout(),
          DeviceType.tablet  => const NotifPrefsMobileLayout(),
          DeviceType.desktop => const NotifPrefsMobileLayout(),
        },
      ),
    );
  }
}
