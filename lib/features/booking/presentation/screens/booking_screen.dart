import 'package:flutter/material.dart';
import '../../../../core/theme/app_typography.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book a Slot')),
      body: Center(child: Text('Booking Feature Coming Soon', style: AppTypography.headingMedium)),
    );
  }
}
