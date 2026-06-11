import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/errors/app_exception.dart';
import '../../../../../core/errors/error_snackbar.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../shared/widgets/gz_admin_top_bar.dart';
import '../../../../../shared/widgets/gz_button.dart';
import '../../../../../shared/widgets/gz_card.dart';
import '../../../../../shared/widgets/gz_loading_view.dart';
import '../../../../../shared/widgets/gz_meta_row.dart';
import '../../../../../shared/widgets/gz_scroll_content.dart';
import '../../../../../shared/widgets/gz_tag.dart';
import '../../../../../shared/widgets/page_error_display.dart';
import '../../../application/admin_booking_command_notifier.dart';
import '../../../application/admin_booking_detail_notifier.dart';
import '../../../application/admin_command_state.dart';
import 'cancel_booking_sheet.dart';

class AdminBookingDetailScreen extends ConsumerStatefulWidget {
  const AdminBookingDetailScreen({super.key, required this.id});

  final String id;

  @override
  ConsumerState<AdminBookingDetailScreen> createState() =>
      _AdminBookingDetailScreenState();
}

class _AdminBookingDetailScreenState
    extends ConsumerState<AdminBookingDetailScreen> {
  @override
  Widget build(BuildContext context) {
    ref.listen(adminBookingCommandNotifierProvider(widget.id), (_, next) {
      if (next is AdminCommandSuccess) {
        showSuccessSnackbar(context, next.message);
        ref
            .read(adminBookingDetailNotifierProvider(widget.id).notifier)
            .refresh();
      } else if (next is AdminCommandError) {
        showErrorSnackbar(context, ValidationException(next.message));
      }
    });

    final booking = ref.watch(adminBookingDetailNotifierProvider(widget.id));
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: GzAdminTopBar(
        title: 'Booking Detail',
        onBack: () => context.pop(),
      ),
      body: booking.when(
        loading: () => const GzLoadingView(message: 'Loading booking'),
        error: (error, _) => PageErrorDisplay(
          error: AppPageError.from(error),
          onRetry: () => ref
              .read(adminBookingDetailNotifierProvider(widget.id).notifier)
              .refresh(),
        ),
        data: (data) => GzScrollContent(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: GzTag(
                    kind: _bookingTagKind(data.status?.name),
                    label: _bookingStatusLabel(data.status?.name),
                  ),
                ),
                const SizedBox(height: 20),
                GzCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.userName ??
                            data.userId ??
                            data.walkInPhone ??
                            'Player',
                        style: AppTypography.h3,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        data.walkInPhone ??
                            'User ID: ${data.userId ?? 'Unavailable'}',
                        style: AppTypography.bodyR,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                GzCard(
                  child: Column(
                    children: [
                      GzMetaRow(
                        label: 'System',
                        value:
                            data.systemName ?? data.systemId ?? 'Unavailable',
                      ),
                      GzMetaRow(
                        label: 'Start',
                        value: _dateTimeLabel(data.scheduledStart),
                      ),
                      GzMetaRow(
                        label: 'End',
                        value: _dateTimeLabel(data.scheduledEnd),
                      ),
                      GzMetaRow(
                        label: 'Type',
                        value: data.bookingType?.name ?? 'Unknown',
                      ),
                      GzMetaRow(
                        label: 'Duration',
                        value: _durationLabel(
                          data.durationMinutes,
                          data.scheduledStart,
                          data.scheduledEnd,
                        ),
                      ),
                      GzMetaRow(
                        label: 'Total',
                        value: _currencyLabel(data.amount),
                        valueBold: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                GzCard(
                  child: Column(
                    children: [
                      GzMetaRow(
                        label: 'Payment',
                        value: data.paymentMethod ?? 'Not specified',
                      ),
                      GzMetaRow(
                        label: 'Status',
                        value:
                            data.paymentStatus ??
                            (data.isPaid == true ? 'paid' : 'pending'),
                      ),
                      GzMetaRow(
                        label: 'Reference',
                        value: data.paymentReference ?? 'Unavailable',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                GzButton(
                  label: 'Check In',
                  onPressed: data.id == null
                      ? null
                      : () => ref
                            .read(
                              adminBookingCommandNotifierProvider(
                                data.id!,
                              ).notifier,
                            )
                            .checkIn(),
                ),
                const SizedBox(height: 10),
                GzButton(
                  label: 'Cancel Booking',
                  variant: GzButtonVariant.dangerOutline,
                  onPressed: data.id == null
                      ? null
                      : () => showAdminCancelBookingSheet(
                          context,
                          id: data.id!,
                          playerLabel: data.userName ?? data.userId ?? 'Player',
                          systemLabel:
                              data.systemName ?? data.systemId ?? 'System',
                          timeLabel: _timeRange(
                            data.scheduledStart,
                            data.scheduledEnd,
                          ),
                          onCompleted: () => ref
                              .read(
                                adminBookingDetailNotifierProvider(
                                  widget.id,
                                ).notifier,
                              )
                              .refresh(),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String _dateTimeLabel(DateTime? value) {
  if (value == null) {
    return 'Unavailable';
  }
  final hour = value.hour > 12
      ? value.hour - 12
      : (value.hour == 0 ? 12 : value.hour);
  final minute = value.minute.toString().padLeft(2, '0');
  final suffix = value.hour >= 12 ? 'PM' : 'AM';
  return '${value.day}/${value.month}/${value.year} $hour:$minute $suffix';
}

String _timeRange(DateTime? start, DateTime? end) {
  if (start == null || end == null) {
    return 'Unavailable';
  }
  return '${_dateTimeLabel(start)} - ${_dateTimeLabel(end)}';
}

String _durationLabel(int? minutes, DateTime? start, DateTime? end) {
  if (minutes != null) {
    final hours = minutes ~/ 60;
    final remainder = minutes % 60;
    if (hours == 0) {
      return '${remainder}m';
    }
    if (remainder == 0) {
      return '${hours}h';
    }
    return '${hours}h ${remainder}m';
  }
  if (start != null && end != null) {
    final diff = end.difference(start).inMinutes;
    return _durationLabel(diff, null, null);
  }
  return 'Unavailable';
}

String _currencyLabel(double? amount) {
  if (amount == null) {
    return 'Pending';
  }
  return '₹${amount.toStringAsFixed(amount.truncateToDouble() == amount ? 0 : 2)}';
}

GzTagKind _bookingTagKind(String? status) {
  switch (status) {
    case 'checkedIn':
      return GzTagKind.ok;
    case 'cancelled':
      return GzTagKind.err;
    case 'noShow':
      return GzTagKind.warn;
    default:
      return GzTagKind.mute;
  }
}

String _bookingStatusLabel(String? status) {
  switch (status) {
    case 'checkedIn':
      return 'Checked In';
    case 'confirmed':
      return 'Confirmed';
    case 'cancelled':
      return 'Cancelled';
    case 'noShow':
      return 'No Show';
    case 'pending':
      return 'Pending';
    default:
      return 'Booked';
  }
}
