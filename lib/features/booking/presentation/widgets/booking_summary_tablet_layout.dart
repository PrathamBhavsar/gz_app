import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'booking_summary_mobile_layout.dart';

class BookingSummaryTabletLayout extends ConsumerWidget {
  const BookingSummaryTabletLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const BookingSummaryMobileLayout();
  }
}
