import 'package:flutter/material.dart';
import '../../../../../core/responsive/breakpoints.dart';
import '../../../../../core/responsive/responsive_builder.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../widgets/booking_slot_selection_mobile_layout.dart';
import '../../widgets/booking_slot_selection_tablet_layout.dart';

/// S-14 — Systems Browser `/book`
/// Root tab screen; no EmTopBar (lives inside the player shell).
class BookingSlotSelectionScreen extends StatelessWidget {
  const BookingSlotSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: ResponsiveBuilderWidget(
        builder: (context, deviceType) => switch (deviceType) {
          DeviceType.mobile => const BookingSlotSelectionMobileLayout(),
          DeviceType.tablet => const BookingSlotSelectionTabletLayout(),
          DeviceType.desktop => const BookingSlotSelectionTabletLayout(),
        },
      ),
    );
  }
}
