import 'package:flutter/material.dart';
import '../../../../../core/responsive/breakpoints.dart';
import '../../../../../core/responsive/responsive_builder.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../widgets/store_search_mobile_layout.dart';
import '../../widgets/store_search_tablet_layout.dart';

class StoreSearchScreen extends StatelessWidget {
  const StoreSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: ResponsiveBuilderWidget(
        builder: (context, deviceType) => switch (deviceType) {
          DeviceType.mobile => const StoreSearchMobileLayout(),
          DeviceType.tablet => const StoreSearchTabletLayout(),
          DeviceType.desktop => const StoreSearchTabletLayout(),
        },
      ),
    );
  }
}
