import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../shared/widgets/gz_avatar.dart';
import '../../../../../shared/widgets/gz_button.dart';
import '../../../../../shared/widgets/gz_card.dart';

Future<void> showAdjustCreditsSheet(
  BuildContext context, {
  required String userId,
  required String userName,
  required int balance,
  required String mode,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => AdjustCreditsSheet(
      userId: userId,
      userName: userName,
      balance: balance,
      mode: mode,
    ),
  );
}

class AdjustCreditsSheet extends StatefulWidget {
  const AdjustCreditsSheet({
    super.key,
    required this.userId,
    required this.userName,
    required this.balance,
    required this.mode,
  });

  final String userId;
  final String userName;
  final int balance;
  final String mode;

  @override
  State<AdjustCreditsSheet> createState() => _AdjustCreditsSheetState();
}

class _AdjustCreditsSheetState extends State<AdjustCreditsSheet> {
  final _amountController = TextEditingController();
  final _reasonController = TextEditingController();
  bool _done = false;

  @override
  void dispose() {
    _amountController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final isAdd = widget.mode == 'add';

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
                      borderRadius: BorderRadius.circular(
                        AppSpacing.borderRadiusPill,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Avatar + name row
                Row(
                  children: [
                    GzAvatar(letter: widget.userName[0], size: GzAvatarSize.lg),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.userName, style: AppTypography.h2),
                        Text(
                          'Balance: ${widget.balance} credits',
                          style: AppTypography.bodyR,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Mode indicator card
                GzCard(
                  variant: CardVariant.inset,
                  padding: 12,
                  child: Row(
                    children: [
                      HugeIcon(
                        icon: isAdd
                            ? HugeIcons.strokeRoundedAdd01
                            : HugeIcons.strokeRoundedRemoveCircle,
                        size: 18,
                        color: isAdd ? AppColors.ok : AppColors.err,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isAdd ? 'Add Credits' : 'Deduct Credits',
                        style: AppTypography.h3.copyWith(
                          color: isAdd ? AppColors.ok : AppColors.err,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Amount field
                Text('Amount', style: AppTypography.small),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.pillBg,
                    borderRadius: BorderRadius.circular(
                      AppSpacing.borderRadiusLg,
                    ),
                  ),
                  child: TextField(
                    controller: _amountController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: false,
                    ),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '0',
                      hintStyle: AppTypography.bodyR,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: AppTypography.h1,
                  ),
                ),
                const SizedBox(height: 12),

                // Reason field
                Text('Reason (required)', style: AppTypography.small),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.pillBg,
                    borderRadius: BorderRadius.circular(
                      AppSpacing.borderRadiusLg,
                    ),
                  ),
                  child: TextField(
                    controller: _reasonController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'e.g. Compensation for technical issue',
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: AppTypography.bodyR.copyWith(
                      color: AppColors.textPrimary,
                    ),
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
                        '${isAdd ? '+' : '−'}${_amountController.text} credits '
                        '${isAdd ? 'added to' : 'deducted from'} ${widget.userName}.',
                        style: AppTypography.body.copyWith(color: AppColors.ok),
                      ),
                    ),
                  ),
                ],

                // Action button
                GzButton(
                  label: _done
                      ? 'Done'
                      : (isAdd ? 'Add Credits' : 'Deduct Credits'),
                  variant: _done
                      ? GzButtonVariant.ghost
                      : GzButtonVariant.primary,
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
