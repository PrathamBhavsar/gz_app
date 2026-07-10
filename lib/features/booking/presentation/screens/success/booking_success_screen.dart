import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../core/errors/app_exception.dart';
import '../../../../../core/errors/error_snackbar.dart';
import '../../../../../core/navigation/routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../shared/widgets/gz_button.dart';
import '../../../../../shared/widgets/gz_card.dart';
import '../../../../../shared/widgets/gz_tag.dart';
import '../../../../../shared/widgets/page_error_display.dart';
import '../../../application/booking_notifier.dart';
import '../../../application/booking_form_notifier.dart';
import '../../../application/booking_payment_notifier.dart';
import '../../booking_presenters.dart';

class BookingSuccessScreen extends ConsumerStatefulWidget {
  const BookingSuccessScreen({super.key});

  @override
  ConsumerState<BookingSuccessScreen> createState() =>
      _BookingSuccessScreenState();
}

class _BookingSuccessScreenState extends ConsumerState<BookingSuccessScreen> {
  @override
  Widget build(BuildContext context) {
    ref.listen<BookingPaymentState>(bookingPaymentNotifierProvider, (
      previous,
      next,
    ) {
      if (next is BookingPaymentError) {
        showErrorSnackbar(context, next.error);
      }
      if (next is BookingPaymentSuccess) {
        final bookingId = ref.read(bookingNotifierProvider).createdBooking?.id;
        if (bookingId != null && bookingId.isNotEmpty) {
          context.go(AppRoutes.bookingDetailPath(bookingId));
        }
      }
    });

    final bookingState = ref.watch(bookingNotifierProvider);
    final paymentState = ref.watch(bookingPaymentNotifierProvider);
    final booking = bookingState.createdBooking;
    final system = bookingState.selectedSystem;
    final start =
        parseSlotTime(booking?.scheduledStart?.toIso8601String()) ??
        parseSlotTime(bookingState.selectedSlot?.startTime);

    if (booking == null || system == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: const SafeArea(
          child: PageErrorDisplay(
            error: AppPageError(
              title: 'No booking found',
              message:
                  'Return to the booking summary and confirm a booking first.',
              icon: 'alert_circle',
            ),
          ),
        ),
      );
    }

    final bookingId = booking.id ?? 'Pending';
    final isPaid = booking.isPaid == true;
    final isPaying = paymentState is BookingPaymentLoading;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 24, 16, 16 + bottomInset),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const HugeIcon(
                icon: HugeIcons.strokeRoundedCheckmarkCircle02,
                color: AppColors.ok,
                size: 72,
              ),
              const SizedBox(height: 20),
              Text(
                isPaid ? 'Booking confirmed!' : 'Booking reserved!',
                style: AppTypography.h1,
              ),
              const SizedBox(height: 8),
              Text(
                'Booking ID: $bookingId',
                style: AppTypography.num.copyWith(
                  fontSize: 12,
                  color: AppColors.textTertiary,
                ),
              ),
              const SizedBox(height: 24),
              GzCard(
                padding: 16,
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceTint,
                        borderRadius: BorderRadius.circular(
                          AppSpacing.borderRadiusLg,
                        ),
                      ),
                      child: Center(
                        child: HugeIcon(
                          icon: platformIcon(system.platform),
                          color: AppColors.textPrimary,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '${system.name ?? 'System'} · ${start != null ? formatBookingDate(start) : 'Date TBD'}',
                        style: AppTypography.body.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    GzTag(
                      kind: isPaid ? GzTagKind.ok : GzTagKind.warn,
                      label: isPaid ? 'Paid' : 'Pending payment',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              GzButton(
                label: isPaid ? 'View booking' : 'Complete payment',
                loading: isPaying,
                onPressed: isPaying
                    ? null
                    : () {
                        if (isPaid) {
                          context.push(AppRoutes.bookingDetailPath(bookingId));
                          return;
                        }
                        ref
                            .read(bookingPaymentNotifierProvider.notifier)
                            .submit();
                      },
              ),
              const SizedBox(height: 10),
              GzButton(
                label: 'Back to home',
                variant: GzButtonVariant.ghost,
                onPressed: () {
                  ref.read(bookingNotifierProvider.notifier).reset();
                  ref.read(bookingPaymentNotifierProvider.notifier).reset();
                  ref.read(bookingFormNotifierProvider.notifier).reset();
                  context.go(AppRoutes.home);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
