import 'package:flutter/material.dart';
import '../../../../../core/responsive/breakpoints.dart';
import '../../../../../core/responsive/responsive_builder.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../widgets/booking_availability_mobile_layout.dart';
import '../../widgets/booking_availability_tablet_layout.dart';

/// S-15 — Availability Calendar `/book/availability`
/// Pushed from Systems Browser (S-14). Not inside the player shell.
class BookingAvailabilityScreen extends StatelessWidget {
  const BookingAvailabilityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: ResponsiveBuilderWidget(
        builder: (context, deviceType) => switch (deviceType) {
          DeviceType.mobile => const BookingAvailabilityMobileLayout(),
          DeviceType.tablet => const BookingAvailabilityTabletLayout(),
          DeviceType.desktop => const BookingAvailabilityTabletLayout(),
        },
      ),
    );
  }
}
