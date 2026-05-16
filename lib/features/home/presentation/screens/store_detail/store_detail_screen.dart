import 'package:flutter/material.dart';
import '../../../../../core/responsive/breakpoints.dart';
import '../../../../../core/responsive/responsive_builder.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../widgets/store_detail_mobile_layout.dart';
import '../../widgets/store_detail_tablet_layout.dart';

class StoreDetailScreen extends StatelessWidget {
  final String slug;

  const StoreDetailScreen({super.key, required this.slug});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: ResponsiveBuilderWidget(
        builder: (context, deviceType) => switch (deviceType) {
          DeviceType.mobile => StoreDetailMobileLayout(slug: slug),
          DeviceType.tablet => StoreDetailTabletLayout(slug: slug),
          DeviceType.desktop => StoreDetailTabletLayout(slug: slug),
        },
      ),
    );
  }
}
