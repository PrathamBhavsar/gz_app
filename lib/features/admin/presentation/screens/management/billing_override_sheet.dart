import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../shared/widgets/gz_button.dart';
import '../../../../../shared/widgets/gz_card.dart';
import '../../../../../shared/widgets/gz_meta_row.dart';

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

class BillingOverrideSheet extends StatefulWidget {
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
  State<BillingOverrideSheet> createState() => _BillingOverrideSheetState();
}

class _BillingOverrideSheetState extends State<BillingOverrideSheet> {
  final _overrideController = TextEditingController();
  final _reasonController = TextEditingController();
  bool _done = false;

  @override
  void dispose() {
    _overrideController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

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
                // Drag handle
                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.rule,
                      borderRadius: BorderRadius.circular(AppSpacing.borderRadiusPill),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Title + description
                Text('Override billing', style: AppTypography.h1),
                const SizedBox(height: 4),
                Text(widget.description, style: AppTypography.bodyR),
                const SizedBox(height: 16),

                // Info summary card
                GzCard(
                  variant: CardVariant.inset,
                  padding: 14,
                  child: Column(
                    children: [
                      GzMetaRow(label: 'Player', value: widget.playerName),
                      GzMetaRow(label: 'Original amount', value: widget.originalAmount),
                      GzMetaRow(label: 'Reference', value: widget.billingId),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Override amount field
                Text('Override amount (₹)', style: AppTypography.small),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.pillBg,
                    borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
                  ),
                  child: TextField(
                    controller: _overrideController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: widget.originalAmount,
                      hintStyle: AppTypography.bodyR,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: AppTypography.h1,
                  ),
                ),
                const SizedBox(height: 12),

                // Reason field
                Text('Reason (required for audit)', style: AppTypography.small),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.pillBg,
                    borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
                  ),
                  child: TextField(
                    controller: _reasonController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'e.g. System error during session',
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: AppTypography.bodyR.copyWith(color: AppColors.textPrimary),
                  ),
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

                // Success confirmation
                if (_done) ...[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GzCard(
                      variant: CardVariant.tint,
                      padding: 14,
                      child: Text(
                        'Billing overridden. Record updated.',
                        style: AppTypography.body.copyWith(color: AppColors.ok),
                      ),
                    ),
                  ),
                ],

                // Action button
                GzButton(
                  label: _done ? 'Done' : 'Confirm Override',
                  variant: _done ? GzButtonVariant.ghost : GzButtonVariant.primary,
                  onPressed: _done
                      ? () => Navigator.pop(context)
                      : () => setState(() => _done = true),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
