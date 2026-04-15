import 'package:flutter/material.dart';
import '../../../../core/responsive/breakpoints.dart';
import '../../../../core/responsive/responsive_builder.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/sessions_mobile_layout.dart';
import '../widgets/sessions_tablet_layout.dart';

class SessionsScreen extends StatelessWidget {
  const SessionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Sessions'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false, // We're in a tab shell
      ),
      body: ResponsiveBuilderWidget(
        builder: (context, deviceType) => switch (deviceType) {
          DeviceType.mobile => const SessionsMobileLayout(),
          DeviceType.tablet => const SessionsTabletLayout(),
          DeviceType.desktop => const SessionsTabletLayout(),
        },
      ),
    );
  }
}
