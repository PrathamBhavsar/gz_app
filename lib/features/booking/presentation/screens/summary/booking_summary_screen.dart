import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/responsive/breakpoints.dart';
import '../../../../../core/responsive/responsive_builder.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../shared/widgets/gz_top_bar.dart';
import '../../widgets/booking_summary_mobile_layout.dart';
import '../../widgets/booking_summary_tablet_layout.dart';

class BookingSummaryScreen extends StatelessWidget {
  const BookingSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: ResponsiveBuilderWidget(
        builder: (context, deviceType) => switch (deviceType) {
          DeviceType.mobile  => const BookingSummaryMobileLayout(),
          DeviceType.tablet  => const BookingSummaryTabletLayout(),
          DeviceType.desktop => const BookingSummaryTabletLayout(),
        },
      ),
    );
  }
}
