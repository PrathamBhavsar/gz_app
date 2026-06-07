import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../shared/widgets/gz_button.dart';
import '../../../../../shared/widgets/gz_card.dart';
import '../../../../../shared/widgets/gz_meta_row.dart';

Future<void> showAdminCancelBookingSheet(
  BuildContext context, {
  required String id,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => AdminCancelBookingSheet(id: id),
  );
}

class AdminCancelBookingSheet extends StatefulWidget {
  const AdminCancelBookingSheet({super.key, required this.id});

  final String id;

  @override
  State<AdminCancelBookingSheet> createState() =>
      _AdminCancelBookingSheetState();
}

class _AdminCancelBookingSheetState extends State<AdminCancelBookingSheet> {
  bool _confirmed = false;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(12, 12, 12, 12 + bottomInset),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // drag handle
                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.rule,
                      borderRadius: BorderRadius.circular(
                        AppSpacing.borderRadiusPill,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    const HugeIcon(
                      icon: HugeIcons.strokeRoundedAlertCircle,
                      color: AppColors.err,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: const Text(
                        'Cancel booking',
                        style: AppTypography.h1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Booking #${widget.id.substring(0, widget.id.length >= 6 ? 6 : widget.id.length).toUpperCase()}',
                  style: AppTypography.bodyR,
                ),
                const SizedBox(height: 16),
                GzCard(
                  variant: CardVariant.inset,
                  child: Column(
                    children: const [
                      GzMetaRow(label: 'Player', value: 'Rahul Mehra'),
                      GzMetaRow(label: 'Time', value: '09:00 – 11:00'),
                      GzMetaRow(label: 'System', value: 'PC Station 01'),
                      GzMetaRow(
                        label: 'Refund',
                        value: 'None (admin cancel)',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'This will immediately cancel the booking. The player will be notified.',
                  style: AppTypography.bodyR,
                ),
                const SizedBox(height: 18),
                if (_confirmed) ...[
                  GzCard(
                    variant: CardVariant.tint,
                    child: Text(
                      'Booking cancelled.',
                      style: AppTypography.body.copyWith(
                        color: AppColors.ok,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                GzButton(
                  label: _confirmed ? 'Done' : 'Confirm Cancel',
                  variant: GzButtonVariant.dangerOutline,
                  onPressed: _confirmed
                      ? () => Navigator.pop(context)
                      : () => setState(() => _confirmed = true),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
