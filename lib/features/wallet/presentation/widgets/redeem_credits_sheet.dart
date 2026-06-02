import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/gz_button.dart';
import '../../../../shared/widgets/gz_card.dart';
import '../../../../shared/widgets/gz_tag.dart';
import '../providers/redeem_credits_notifier.dart';

final _redeemAmountProvider = StateProvider.autoDispose<double>((ref) => 0);

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
    ref.read(_redeemAmountProvider.notifier).state = clamped;
    _controller.text = clamped.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(redeemCreditsNotifierProvider, (_, next) {
      if (next is RedeemCreditsSuccess) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Credits redeemed successfully!')),
        );
      }
    });

    final amount = ref.watch(_redeemAmountProvider);
    final state = ref.watch(redeemCreditsNotifierProvider);
    final notifier = ref.read(redeemCreditsNotifierProvider.notifier);
    final isConfirming = state is RedeemCreditsConfirming;
    final isLoading = state is RedeemCreditsLoading;
    final errorState = state is RedeemCreditsError ? state : null;
    final rupees = (amount / 10).toStringAsFixed(2);

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
          GzCard(
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
                            amount.toStringAsFixed(0),
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
              GzButton(
                label: 'Max',
                small: true,
                variant: GzButtonVariant.ghost,
                onPressed: () => _setAmount(widget.balance),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '500 credits = ₹50 off your next booking',
            style: AppTypography.small.copyWith(color: AppColors.textTertiary),
          ),

          if (errorState != null) ...[
            const SizedBox(height: AppSpacing.sm),
            GzTag(kind: GzTagKind.err, label: errorState.message),
          ],
          const SizedBox(height: AppSpacing.lg),

          // CTA
          if (!isConfirming)
            GzButton(
              label: 'Redeem',
              onPressed: amount > 0 ? () => notifier.requestConfirm(amount) : null,
            )
          else
            Column(
              children: [
                Text(
                  'Are you sure? This will apply ${amount.toStringAsFixed(0)} credits.',
                  style: AppTypography.bodyR,
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: GzButton(
                        label: 'Cancel',
                        variant: GzButtonVariant.ghost,
                        onPressed: notifier.cancelConfirm,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: GzButton(
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
