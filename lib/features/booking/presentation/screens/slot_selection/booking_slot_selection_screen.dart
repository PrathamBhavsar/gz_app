import 'package:flutter/material.dart';
import '../../../../../core/responsive/breakpoints.dart';
import '../../../../../core/responsive/responsive_builder.dart';
import '../../../../../core/theme/app_colors.dart';
import '../widgets/booking_slot_selection_mobile_layout.dart';
import '../widgets/booking_slot_selection_tablet_layout.dart';

class BookingSlotSelectionScreen extends StatelessWidget {
  const BookingSlotSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Book a Slot'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
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
