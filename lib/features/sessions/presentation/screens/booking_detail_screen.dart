import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/navigation/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../providers/session_runtime_providers.dart';
import '../../../../shared/widgets/gz_button.dart';
import '../../../../shared/widgets/gz_meta_row.dart';
import '../../../../shared/widgets/gz_tag.dart';
import '../../../../shared/widgets/gz_top_bar.dart';
import 'cancel_booking_sheet.dart';

class BookingDetailScreen extends ConsumerWidget {
  const BookingDetailScreen({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booking = ref.watch(bookingDetailStateNotifierProvider(id));

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
                        GzTag(
                          kind: _bookingTagKind(booking.status),
                          label: _bookingTagLabel(booking.status),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          booking.id,
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
                children: [
                  GzMetaRow(label: 'System', value: booking.system),
                  GzMetaRow(label: 'Seat', value: booking.seat),
                  GzMetaRow(label: 'Store', value: booking.store),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _Card(
              child: Column(
                children: [
                  GzMetaRow(label: 'Date', value: booking.date),
                  GzMetaRow(label: 'Time', value: booking.time),
                  GzMetaRow(label: 'Duration', value: booking.duration),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _Card(
              child: Column(
                children: [
                  GzMetaRow(label: 'Total', value: booking.total),
                  GzMetaRow(label: 'Status', value: booking.paymentStatus),
                ],
              ),
            ),
            const SizedBox(height: 24),
            GzButton(
              label: booking.primaryActionLabel,
              onPressed: booking.status == SessionUiStatus.checkedIn
                  ? null
                  : () => booking.paymentStatus == 'Unpaid'
                        ? context.push(AppRoutes.paymentSheetPath(booking.id))
                        : context.push(AppRoutes.checkInPath(booking.id)),
            ),
            const SizedBox(height: 12),
            GzButton(
              label: 'Cancel booking',
              variant: GzButtonVariant.dangerOutline,
              onPressed: () => showCancelBookingSheet(
                context,
                bookingId: booking.id,
                systemName: booking.system,
                bookingTime: booking.time,
                hoursUntilBooking: 26.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

GzTagKind _bookingTagKind(SessionUiStatus status) => switch (status) {
  SessionUiStatus.confirmed => GzTagKind.ok,
  SessionUiStatus.unpaid => GzTagKind.warn,
  SessionUiStatus.checkedIn => GzTagKind.info,
  SessionUiStatus.active => GzTagKind.ok,
  SessionUiStatus.completed => GzTagKind.info,
};

String _bookingTagLabel(SessionUiStatus status) => switch (status) {
  SessionUiStatus.confirmed => 'Confirmed',
  SessionUiStatus.unpaid => 'Unpaid',
  SessionUiStatus.checkedIn => 'Checked in',
  SessionUiStatus.active => 'Active',
  SessionUiStatus.completed => 'Completed',
};

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
