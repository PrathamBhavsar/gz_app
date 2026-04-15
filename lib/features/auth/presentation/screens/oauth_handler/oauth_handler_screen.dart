import 'package:flutter/material.dart';
import '../../../../../core/responsive/breakpoints.dart';
import '../../../../../core/responsive/responsive_builder.dart';
import '../../../../../core/theme/app_colors.dart';
import '../widgets/oauth_handler_mobile_layout.dart';
import '../widgets/oauth_handler_tablet_layout.dart';

class OAuthHandlerScreen extends StatelessWidget {
  const OAuthHandlerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: ResponsiveBuilderWidget(
        builder: (context, deviceType) => switch (deviceType) {
          DeviceType.mobile => const OAuthHandlerMobileLayout(),
          DeviceType.tablet => const OAuthHandlerTabletLayout(),
          DeviceType.desktop => const OAuthHandlerTabletLayout(),
        },
      ),
    );
  }
}
