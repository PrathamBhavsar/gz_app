import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/gz_button.dart';
import '../../../../shared/widgets/gz_card.dart';
import '../../../../shared/widgets/gz_meta_row.dart';

Future<void> showCancelBookingSheet(
  BuildContext context, {
  required String bookingId,
  required String systemName,
  required String bookingTime,
  required double hoursUntilBooking,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => CancelBookingSheet(
      bookingId: bookingId,
      systemName: systemName,
      bookingTime: bookingTime,
      hoursUntilBooking: hoursUntilBooking,
    ),
  );
}

class CancelBookingSheet extends StatefulWidget {
  const CancelBookingSheet({
    super.key,
    required this.bookingId,
    required this.systemName,
    required this.bookingTime,
    required this.hoursUntilBooking,
  });

  final String bookingId;
  final String systemName;
  final String bookingTime;
  final double hoursUntilBooking;

  @override
  State<CancelBookingSheet> createState() => _CancelBookingSheetState();
}

class _CancelBookingSheetState extends State<CancelBookingSheet> {
  bool _confirmed = false;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final isFree = widget.hoursUntilBooking >= 24;
    final shortId =
        widget.bookingId.substring(0, widget.bookingId.length.clamp(0, 6)).toUpperCase();

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(12, 12, 12, 12 + bottomInset),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius:
                BorderRadius.circular(AppSpacing.borderRadiusCard),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Drag handle
                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.rule,
                      borderRadius: BorderRadius.circular(
                          AppSpacing.borderRadiusPill),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Header
                Row(
                  children: [
                    const HugeIcon(
                      icon: HugeIcons.strokeRoundedAlertCircle,
                      size: 24,
                      color: AppColors.warn,
                    ),
                    const SizedBox(width: 12),
                    Text('Cancel booking', style: AppTypography.h1),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Booking #$shortId',
                  style: AppTypography.bodyR,
                ),
                const SizedBox(height: 16),

                // Details card
                GzCard(
                  variant: CardVariant.inset,
                  child: Column(
                    children: [
                      GzMetaRow(
                        label: 'System',
                        value: widget.systemName,
                      ),
                      GzMetaRow(label: 'Time', value: widget.bookingTime),
                      GzMetaRow(
                        label: 'Cancellation fee',
                        value: isFree
                            ? 'None — free cancellation'
                            : 'No refund (< 24h notice)',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Refund policy banner
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isFree ? AppColors.okBg : AppColors.warnBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      HugeIcon(
                        icon: isFree
                            ? HugeIcons.strokeRoundedCheckmarkCircle02
                            : HugeIcons.strokeRoundedAlertDiamond,
                        size: 16,
                        color: isFree ? AppColors.ok : AppColors.warn,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          isFree
                              ? 'Free cancellation — your payment will be refunded.'
                              : 'Cancellation within 24 hours — no refund will be issued.',
                          style: AppTypography.small.copyWith(
                            color: isFree ? AppColors.ok : AppColors.warn,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Confirmed message
                if (_confirmed)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GzCard(
                      variant: CardVariant.tint,
                      child: Text(
                        'Booking cancelled.',
                        style: AppTypography.body.copyWith(
                          color: AppColors.ok,
                        ),
                      ),
                    ),
                  ),

                // Primary action button
                GzButton(
                  label: _confirmed ? 'Done' : 'Confirm Cancellation',
                  variant: _confirmed
                      ? GzButtonVariant.ghost
                      : GzButtonVariant.dangerOutline,
                  onPressed: _confirmed
                      ? () => Navigator.pop(context)
                      : () => setState(() => _confirmed = true),
                ),
                const SizedBox(height: 8),

                // Keep booking button
                if (!_confirmed)
                  GzButton(
                    label: 'Keep booking',
                    variant: GzButtonVariant.ghost,
                    onPressed: () => Navigator.pop(context),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
