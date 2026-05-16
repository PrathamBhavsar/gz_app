import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/em_button.dart';
import '../../../../shared/widgets/em_card.dart';
import '../../../../shared/widgets/em_tag.dart';
import '../providers/redeem_credits_notifier.dart';

void showRedeemCreditsSheet(BuildContext context, double balance) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (_) => _RedeemCreditsSheet(balance: balance),
  );
}

class _RedeemCreditsSheet extends ConsumerStatefulWidget {
  const _RedeemCreditsSheet({required this.balance});
  final double balance;

  @override
  ConsumerState<_RedeemCreditsSheet> createState() => _RedeemCreditsSheetState();
}

class _RedeemCreditsSheetState extends ConsumerState<_RedeemCreditsSheet> {
  late final TextEditingController _controller;
  double _amount = 0;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: '0');
    ref.read(redeemCreditsNotifierProvider.notifier).reset();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _setAmount(double v) {
    final clamped = v.clamp(0.0, widget.balance);
    setState(() => _amount = clamped);
    _controller.text = clamped.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(redeemCreditsNotifierProvider, (_, next) {
      if (next is RedeemCreditsSuccess) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Credits redeemed successfully!')),
        );
      }
    });

    final state = ref.watch(redeemCreditsNotifierProvider);
    final notifier = ref.read(redeemCreditsNotifierProvider.notifier);
    final isConfirming = state is RedeemCreditsConfirming;
    final isLoading = state is RedeemCreditsLoading;
    final isError = state is RedeemCreditsError;
    final rupees = (_amount / 10).toStringAsFixed(2);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        MediaQuery.viewInsetsOf(context).bottom + AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 38,
              height: 4,
              margin: const EdgeInsets.only(bottom: AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.rule,
                borderRadius: BorderRadius.circular(AppSpacing.borderRadiusPill),
              ),
            ),
          ),

          Text('Redeem Credits', style: AppTypography.h1),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '${widget.balance.toStringAsFixed(0)} credits available · 10 credits = ₹1',
            style: AppTypography.bodyR,
          ),
          const SizedBox(height: AppSpacing.md),

          // Balance display
          EmCard(
            variant: CardVariant.inset,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('REDEEM', style: AppTypography.meta),
                      const SizedBox(height: AppSpacing.xs),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            _amount.toStringAsFixed(0),
                            style: AppTypography.heroMd,
                          ),
                          const SizedBox(width: 8),
                          Text('= ₹$rupees off', style: AppTypography.bodyR),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Amount input row
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  style: AppTypography.h2,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.pillBg,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                    hintText: '0',
                    hintStyle: AppTypography.h2.copyWith(color: AppColors.textTertiary),
                  ),
                  onChanged: (v) {
                    final parsed = double.tryParse(v) ?? 0;
                    _setAmount(parsed);
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              EmButton(
                label: 'Max',
                small: true,
                variant: EmButtonVariant.ghost,
                onPressed: () => _setAmount(widget.balance),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '500 credits = ₹50 off your next booking',
            style: AppTypography.small.copyWith(color: AppColors.textTertiary),
          ),

          if (isError) ...[
            const SizedBox(height: AppSpacing.sm),
            EmTag(
              kind: EmTagKind.err,
              label: (state as RedeemCreditsError).message,
            ),
          ],
          const SizedBox(height: AppSpacing.lg),

          // CTA
          if (!isConfirming)
            EmButtonFull(
              label: 'Redeem',
              onPressed: _amount > 0 ? () => notifier.requestConfirm(_amount) : null,
            )
          else
            Column(
              children: [
                Text(
                  'Are you sure? This will apply ${_amount.toStringAsFixed(0)} credits.',
                  style: AppTypography.bodyR,
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: EmButton(
                        label: 'Cancel',
                        variant: EmButtonVariant.ghost,
                        onPressed: notifier.cancelConfirm,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: EmButton(
                        label: 'Confirm',
                        loading: isLoading,
                        onPressed: isLoading ? null : notifier.confirm,
                      ),
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }
}
