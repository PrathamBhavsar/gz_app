import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../core/errors/app_exception.dart';
import '../../../../../core/errors/error_snackbar.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../shared/widgets/gz_avatar.dart';
import '../../../../../shared/widgets/gz_button.dart';
import '../../../../../shared/widgets/gz_card.dart';
import '../../../application/admin_command_state.dart';
import '../../../application/admin_credits_command_notifier.dart';

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

class AdjustCreditsSheet extends ConsumerStatefulWidget {
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
  ConsumerState<AdjustCreditsSheet> createState() => _AdjustCreditsSheetState();
}

class _AdjustCreditsSheetState extends ConsumerState<AdjustCreditsSheet> {
  final _amountController = TextEditingController();
  final _reasonController = TextEditingController();

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
    final commandState = ref.watch(adminCreditsCommandNotifierProvider);
    ref.listen<AdminCommandState>(adminCreditsCommandNotifierProvider, (
      _,
      next,
    ) {
      if (next is AdminCommandSuccess) {
        showSuccessSnackbar(context, next.message);
        ref.read(adminCreditsCommandNotifierProvider.notifier).reset();
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
                Text('Amount', style: AppTypography.small),
                const SizedBox(height: 6),
                _field(
                  controller: _amountController,
                  hintText: '0',
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                const SizedBox(height: 12),
                Text('Reason (required)', style: AppTypography.small),
                const SizedBox(height: 6),
                _field(
                  controller: _reasonController,
                  hintText: 'e.g. Compensation for technical issue',
                  maxLines: 2,
                ),
                const SizedBox(height: 18),
                GzButton(
                  label: isAdd ? 'Add Credits' : 'Deduct Credits',
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
    List<TextInputFormatter>? inputFormatters,
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
        maxLines: maxLines,
        keyboardType: TextInputType.number,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: AppTypography.bodyR,
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
        style: AppTypography.bodyR.copyWith(color: AppColors.textPrimary),
      ),
    );
  }

  void _submit() {
    final amount = int.tryParse(_amountController.text.trim());
    final reason = _reasonController.text.trim();
    if (amount == null || amount <= 0 || reason.isEmpty) {
      showErrorSnackbar(
        context,
        const ValidationException('Amount and reason are required'),
      );
      return;
    }
    ref
        .read(adminCreditsCommandNotifierProvider.notifier)
        .adjustCredits(
          userId: widget.userId,
          amount: amount,
          reason: reason,
          isAddition: widget.mode == 'add',
        );
  }
}
