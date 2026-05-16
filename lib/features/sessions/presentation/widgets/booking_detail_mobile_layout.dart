import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/navigation/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../models/domain_systems.dart';
import '../../../../models/enums.dart';
import '../../../../shared/widgets/em_button.dart';
import '../../../../shared/widgets/em_card.dart';
import '../../../../shared/widgets/em_meta_row.dart';
import '../../../../shared/widgets/em_scroll_content.dart';
import '../../../../shared/widgets/em_tag.dart';
import '../../../../shared/widgets/em_top_bar.dart';
import '../../../../shared/widgets/page_error_display.dart';
import '../providers/booking_detail_notifier.dart';
import 'payment_sheet.dart';

class BookingDetailMobileLayout extends ConsumerWidget {
  final String id;
  const BookingDetailMobileLayout({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncBooking = ref.watch(bookingDetailNotifierProvider(id));

    return asyncBooking.when(
      loading: () => const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            EmTopBar(title: 'Booking'),
            Expanded(
              child: PageErrorDisplay(
                error: AppPageError.from(e),
                onRetry: () => ref
                    .read(bookingDetailNotifierProvider(id).notifier)
                    .refresh(id),
              ),
            ),
          ],
        ),
      ),
      data: (booking) => _BookingDetailBody(booking: booking, bookingId: id),
    );
  }
}

class _BookingDetailBody extends ConsumerWidget {
  final BookingModel booking;
  final String bookingId;

  const _BookingDetailBody({required this.booking, required this.bookingId});

  EmTagKind _tagKind(BookingStatus? status) => switch (status) {
    BookingStatus.confirmed => EmTagKind.ok,
    BookingStatus.pending => EmTagKind.warn,
    BookingStatus.checkedIn => EmTagKind.info,
    BookingStatus.cancelled => EmTagKind.err,
    BookingStatus.noShow => EmTagKind.err,
    null => EmTagKind.mute,
  };

  String _tagLabel(BookingStatus? status) => switch (status) {
    BookingStatus.confirmed => 'Confirmed',
    BookingStatus.pending => 'Payment pending',
    BookingStatus.checkedIn => 'Checked in',
    BookingStatus.cancelled => 'Cancelled',
    BookingStatus.noShow => 'No show',
    null => 'Unknown',
  };

  String _formatDate(DateTime? dt) {
    if (dt == null) return '—';
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  String _formatTime(DateTime? dt) {
    if (dt == null) return '—';
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  int _durationMinutes(DateTime? start, DateTime? end) {
    if (start == null || end == null) return 0;
    return end.difference(start).inMinutes;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = booking.status;
    final dur = _durationMinutes(booking.scheduledStart, booking.scheduledEnd);

    return SafeArea(
      child: Column(
        children: [
          EmTopBar(title: 'Booking'),
          Expanded(
            child: EmScrollContent(
              padded: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Status tag ──
                  Center(
                    child: EmTag(
                      kind: _tagKind(status),
                      label: _tagLabel(status),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // ── System card ──
                  EmCard(
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.pillBg,
                            borderRadius: BorderRadius.circular(
                              AppSpacing.borderRadiusChip,
                            ),
                          ),
                          child: const Center(
                            child: HugeIcon(
                              icon: HugeIcons.strokeRoundedComputerDesk01,
                              color: AppColors.textPrimary,
                              size: 22,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm + AppSpacing.xs),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                booking.storeId ?? '—',
                                style: AppTypography.small.copyWith(
                                  color: AppColors.textTertiary,
                                ),
                              ),
                              Text(
                                booking.systemId ?? '—',
                                style: AppTypography.h3,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // ── Booking time fields ──
                  EmCard(
                    child: Column(
                      children: [
                        EmMetaRow(
                          label: 'Date',
                          value: _formatDate(booking.scheduledStart),
                        ),
                        EmMetaRow(
                          label: 'Start',
                          value: _formatTime(booking.scheduledStart),
                        ),
                        EmMetaRow(
                          label: 'End',
                          value: _formatTime(booking.scheduledEnd),
                        ),
                        EmMetaRow(label: 'Duration', value: '${dur}m'),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // ── Pricing ──
                  EmCard(
                    child: Column(
                      children: [
                        EmMetaRow(
                          label: 'Amount',
                          value: booking.amount != null
                              ? '₹${booking.amount!.toStringAsFixed(2)}'
                              : '—',
                        ),
                        EmMetaRow(
                          label: 'Payment',
                          value: booking.isPaid == true ? 'Paid' : 'Unpaid',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          ),

          // ── Sticky bottom CTA ──
          _BottomCta(booking: booking, bookingId: bookingId),
        ],
      ),
    );
  }
}

class _BottomCta extends ConsumerWidget {
  final BookingModel booking;
  final String bookingId;
  const _BottomCta({required this.booking, required this.bookingId});

  bool _isInCheckInWindow() {
    final start = booking.scheduledStart;
    if (start == null) return false;
    final now = DateTime.now();
    final windowStart = start.subtract(const Duration(minutes: 15));
    final windowEnd = start.add(const Duration(minutes: 15));
    return now.isAfter(windowStart) && now.isBefore(windowEnd);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = booking.status;
    final inWindow = _isInCheckInWindow();

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.lg,
      ),
      child: switch (status) {
        BookingStatus.pending => Row(
          children: [
            Expanded(
              child: EmButton(
                label: 'Pay Now',
                onPressed: () => showPaymentSheet(context, ref, bookingId),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: EmButton(
                label: 'Cancel',
                variant: EmButtonVariant.ghost,
                onPressed: () => context.pop(),
              ),
            ),
          ],
        ),
        BookingStatus.confirmed when !inWindow => EmButtonFull(
          label: 'Cancel Booking',
          variant: EmButtonVariant.ghost,
          onPressed: () => context.pop(),
        ),
        BookingStatus.confirmed when inWindow => Row(
          children: [
            Expanded(
              child: EmButton(
                label: 'Check In',
                onPressed: () {
                  context.push(AppRoutes.checkInPath(bookingId));
                },
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: EmButton(
                label: 'Cancel',
                variant: EmButtonVariant.ghost,
                onPressed: () => context.pop(),
              ),
            ),
          ],
        ),
        BookingStatus.checkedIn => EmButtonFull(
          label: 'View Active Session',
          onPressed: () => context.push(AppRoutes.sessions),
        ),
        BookingStatus.cancelled || BookingStatus.noShow => EmButtonFull(
          label: 'File Dispute',
          variant: EmButtonVariant.ghost,
          onPressed: () => context.push(AppRoutes.disputeCreate),
        ),
        _ => const SizedBox.shrink(),
      },
    );
  }
}
