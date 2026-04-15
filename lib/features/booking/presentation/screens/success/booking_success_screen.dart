import 'package:flutter/material.dart';
import '../../../../../core/responsive/breakpoints.dart';
import '../../../../../core/responsive/responsive_builder.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../widgets/booking_success_mobile_layout.dart';
import '../../widgets/booking_success_tablet_layout.dart';

class BookingSuccessScreen extends StatelessWidget {
  const BookingSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: ResponsiveBuilderWidget(
        builder: (context, deviceType) => switch (deviceType) {
          DeviceType.mobile => const BookingSuccessMobileLayout(),
          DeviceType.tablet => const BookingSuccessTabletLayout(),
          DeviceType.desktop => const BookingSuccessTabletLayout(),
        },
      ),
    );
  }
}
