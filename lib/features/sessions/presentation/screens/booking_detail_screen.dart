import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/navigation/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/gz_button.dart';
import '../../../../shared/widgets/gz_meta_row.dart';
import '../../../../shared/widgets/gz_tag.dart';
import '../../../../shared/widgets/gz_top_bar.dart';
import 'cancel_booking_sheet.dart';

class BookingDetailScreen extends StatelessWidget {
  const BookingDetailScreen({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: GzTopBar(title: 'Booking'),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _Card(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const GzTag(kind: GzTagKind.ok, label: 'Confirmed'),
                        const SizedBox(height: 8),
                        Text(
                          id.isEmpty ? 'GZ-2406-4891' : id,
                          style: AppTypography.h3.copyWith(
                            fontFamily: 'GeistMono',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _Card(
              child: Column(
                children: const [
                  GzMetaRow(label: 'System', value: 'PC Station 01'),
                  GzMetaRow(label: 'Seat', value: 'Seat 3'),
                  GzMetaRow(label: 'Store', value: 'GameZone Koramangala'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _Card(
              child: Column(
                children: const [
                  GzMetaRow(label: 'Date', value: 'Wed, 4 Jun'),
                  GzMetaRow(label: 'Time', value: '6:00 PM – 8:00 PM'),
                  GzMetaRow(label: 'Duration', value: '2 hours'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _Card(
              child: Column(
                children: const [
                  GzMetaRow(label: 'Total', value: '₹160'),
                  GzMetaRow(label: 'Status', value: 'Unpaid'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            GzButton(
              label: 'Check in',
              onPressed: () => context.push(
                AppRoutes.checkInPath(id.isEmpty ? 'GZ-2406-4891' : id),
              ),
            ),
            const SizedBox(height: 12),
            GzButton(
              label: 'Cancel booking',
              variant: GzButtonVariant.dangerOutline,
              onPressed: () => showCancelBookingSheet(
                context,
                bookingId: id,
                systemName: 'PC Station 01',
                bookingTime: '09:00 – 11:00',
                hoursUntilBooking: 26.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
      ),
      child: child,
    );
  }
}
