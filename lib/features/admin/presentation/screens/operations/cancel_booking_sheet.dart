import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../core/errors/app_exception.dart';
import '../../../../../core/errors/error_snackbar.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../shared/widgets/gz_button.dart';
import '../../../../../shared/widgets/gz_card.dart';
import '../../../../../shared/widgets/gz_meta_row.dart';
import '../../../application/admin_booking_command_notifier.dart';
import '../../../application/admin_command_state.dart';

Future<void> showAdminCancelBookingSheet(
  BuildContext context, {
  required String id,
  required String playerLabel,
  required String systemLabel,
  required String timeLabel,
  VoidCallback? onCompleted,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => AdminCancelBookingSheet(
      id: id,
      playerLabel: playerLabel,
      systemLabel: systemLabel,
      timeLabel: timeLabel,
      onCompleted: onCompleted,
    ),
  );
}

class AdminCancelBookingSheet extends ConsumerStatefulWidget {
  const AdminCancelBookingSheet({
    super.key,
    required this.id,
    required this.playerLabel,
    required this.systemLabel,
    required this.timeLabel,
    this.onCompleted,
  });

  final String id;
  final String playerLabel;
  final String systemLabel;
  final String timeLabel;
  final VoidCallback? onCompleted;

  @override
  ConsumerState<AdminCancelBookingSheet> createState() =>
      _AdminCancelBookingSheetState();
}

class _AdminCancelBookingSheetState
    extends ConsumerState<AdminCancelBookingSheet> {
  final _reasonController = TextEditingController(text: 'Admin override');

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(adminBookingCommandNotifierProvider(widget.id), (_, next) {
      if (next is AdminCommandSuccess) {
        showSuccessSnackbar(context, next.message);
        widget.onCompleted?.call();
        Navigator.of(context).pop();
      } else if (next is AdminCommandError) {
        showErrorSnackbar(context, ValidationException(next.message));
      }
    });

    final state = ref.watch(adminBookingCommandNotifierProvider(widget.id));
    final loading = state is AdminCommandLoading;
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
                const Row(
                  children: [
                    HugeIcon(
                      icon: HugeIcons.strokeRoundedAlertCircle,
                      color: AppColors.err,
                      size: 24,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text('Cancel booking', style: AppTypography.h1),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(widget.id, style: AppTypography.bodyR),
                const SizedBox(height: 16),
                GzCard(
                  variant: CardVariant.inset,
                  child: Column(
                    children: [
                      GzMetaRow(label: 'Player', value: widget.playerLabel),
                      GzMetaRow(label: 'Time', value: widget.timeLabel),
                      GzMetaRow(label: 'System', value: widget.systemLabel),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _reasonController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    hintText: 'Cancellation reason',
                    filled: true,
                    fillColor: AppColors.pillBg,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                GzButton(
                  label: 'Confirm Cancel',
                  loading: loading,
                  variant: GzButtonVariant.dangerOutline,
                  onPressed: () => ref
                      .read(
                        adminBookingCommandNotifierProvider(widget.id).notifier,
                      )
                      .cancel(reason: _reasonController.text.trim()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
