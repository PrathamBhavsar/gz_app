import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'booking_system_selection_mobile_layout.dart';

class BookingSystemSelectionTabletLayout extends ConsumerWidget {
  const BookingSystemSelectionTabletLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const BookingSystemSelectionMobileLayout();
  }
}
