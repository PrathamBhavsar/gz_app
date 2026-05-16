import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'booking_slot_selection_mobile_layout.dart';

/// Tablet layout reuses the mobile layout (single-column is fine for booking flow).
class BookingSlotSelectionTabletLayout extends ConsumerWidget {
  const BookingSlotSelectionTabletLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const BookingSlotSelectionMobileLayout();
  }
}
