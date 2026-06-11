import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/errors/app_exception.dart';
import '../../../../../core/errors/error_snackbar.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../shared/widgets/gz_button.dart';
import '../../../../../shared/widgets/gz_card.dart';
import '../../../../../shared/widgets/gz_meta_row.dart';
import '../../../application/admin_command_state.dart';
import '../../../application/billing_override_notifier.dart';

Future<void> showBillingOverrideSheet(
  BuildContext context, {
  required String billingId,
  required String playerName,
  required String originalAmount,
  required String description,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => BillingOverrideSheet(
      billingId: billingId,
      playerName: playerName,
      originalAmount: originalAmount,
      description: description,
    ),
  );
}

class BillingOverrideSheet extends ConsumerStatefulWidget {
  const BillingOverrideSheet({
    super.key,
    required this.billingId,
    required this.playerName,
    required this.originalAmount,
    required this.description,
  });

  final String billingId;
  final String playerName;
  final String originalAmount;
  final String description;

  @override
  ConsumerState<BillingOverrideSheet> createState() =>
      _BillingOverrideSheetState();
}

class _BillingOverrideSheetState extends ConsumerState<BillingOverrideSheet> {
  final _overrideController = TextEditingController();
  final _reasonController = TextEditingController();

  @override
  void dispose() {
    _overrideController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final commandState = ref.watch(billingOverrideNotifierProvider);
    ref.listen<AdminCommandState>(billingOverrideNotifierProvider, (_, next) {
      if (next is AdminCommandSuccess) {
        showSuccessSnackbar(context, next.message);
        ref.read(billingOverrideNotifierProvider.notifier).reset();
        context.pop();
      } else if (next is AdminCommandError) {
        showErrorSnackbar(context, ValidationException(next.message));
      }
    });

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
                const SizedBox(height: 16),
                Text('Override billing', style: AppTypography.h1),
                const SizedBox(height: 4),
                Text(widget.description, style: AppTypography.bodyR),
                const SizedBox(height: 16),
                GzCard(
                  variant: CardVariant.inset,
                  padding: 14,
                  child: Column(
                    children: [
                      GzMetaRow(label: 'Player', value: widget.playerName),
                      GzMetaRow(
                        label: 'Original amount',
                        value: widget.originalAmount,
                      ),
                      GzMetaRow(label: 'Reference', value: widget.billingId),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Text('Override amount (₹)', style: AppTypography.small),
                const SizedBox(height: 6),
                _field(
                  controller: _overrideController,
                  hintText: widget.originalAmount,
                  keyboardType: TextInputType.number,
                  textStyle: AppTypography.h1,
                ),
                const SizedBox(height: 12),
                Text('Reason (required for audit)', style: AppTypography.small),
                const SizedBox(height: 6),
                _field(
                  controller: _reasonController,
                  hintText: 'e.g. System error during session',
                  maxLines: 2,
                ),
                const SizedBox(height: 8),
                Text(
                  'This will mark the billing record as overridden.',
                  style: AppTypography.bodyR.copyWith(
                    fontSize: 12,
                    color: AppColors.textTertiary,
                  ),
                ),
                const SizedBox(height: 18),
                GzButton(
                  label: 'Confirm Override',
                  loading: commandState is AdminCommandLoading,
                  onPressed: _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String hintText,
    TextInputType? keyboardType,
    TextStyle? textStyle,
    int maxLines = 1,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.pillBg,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: AppTypography.bodyR,
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
        style: textStyle ?? AppTypography.bodyR,
      ),
    );
  }

  void _submit() {
    final amount = double.tryParse(_overrideController.text.trim());
    final reason = _reasonController.text.trim();
    if (amount == null || reason.isEmpty) {
      showErrorSnackbar(
        context,
        const ValidationException('Override amount and reason are required'),
      );
      return;
    }
    ref
        .read(billingOverrideNotifierProvider.notifier)
        .submit(billingId: widget.billingId, amount: amount, reason: reason);
  }
}
