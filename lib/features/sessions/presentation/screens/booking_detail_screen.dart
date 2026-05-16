import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/booking_detail_mobile_layout.dart';

class BookingDetailScreen extends StatelessWidget {
  final String id;
  const BookingDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BookingDetailMobileLayout(id: id),
    );
  }
}
