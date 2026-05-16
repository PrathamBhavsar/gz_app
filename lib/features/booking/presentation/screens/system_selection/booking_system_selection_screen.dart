import 'package:flutter/material.dart';
import '../../../../../core/responsive/breakpoints.dart';
import '../../../../../core/responsive/responsive_builder.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../widgets/booking_system_selection_mobile_layout.dart';
import '../../widgets/booking_system_selection_tablet_layout.dart';

/// S-16 — System Picker `/book/systems`
/// Pushed from Availability Calendar (S-15). Not inside the player shell.
class BookingSystemSelectionScreen extends StatelessWidget {
  const BookingSystemSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: ResponsiveBuilderWidget(
        builder: (context, deviceType) => switch (deviceType) {
          DeviceType.mobile => const BookingSystemSelectionMobileLayout(),
          DeviceType.tablet => const BookingSystemSelectionTabletLayout(),
          DeviceType.desktop => const BookingSystemSelectionTabletLayout(),
        },
      ),
    );
  }
}
