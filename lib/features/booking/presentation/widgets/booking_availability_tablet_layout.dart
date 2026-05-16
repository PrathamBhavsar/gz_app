import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'booking_availability_mobile_layout.dart';

class BookingAvailabilityTabletLayout extends ConsumerWidget {
  const BookingAvailabilityTabletLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const BookingAvailabilityMobileLayout();
  }
}
