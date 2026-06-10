import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/errors/error_snackbar.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/gz_button.dart';
import '../../../../shared/widgets/gz_card.dart';
import '../../../../shared/widgets/gz_loading_view.dart';
import '../../application/redeem_credits_notifier.dart';
import '../../application/wallet_notifier.dart';
import '../../application/wallet_ui_models.dart';

Future<void> showRedeemCreditsSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const RedeemCreditsSheet(),
  );
}

class RedeemCreditsSheet extends ConsumerStatefulWidget {
  const RedeemCreditsSheet({super.key});

  @override
  ConsumerState<RedeemCreditsSheet> createState() => _RedeemCreditsSheetState();
}

class _RedeemCreditsSheetState extends ConsumerState<RedeemCreditsSheet> {
  double _selectedCredits = 0;
  bool _showConfirmation = false;

  @override
  Widget build(BuildContext context) {
    ref.listen<RedeemCreditsState>(redeemCreditsNotifierProvider, (_, next) {
      if (next is RedeemCreditsSuccess) {
        showSuccessSnackbar(context, next.message);
        ref.read(redeemCreditsNotifierProvider.notifier).reset();
        context.pop();
      } else if (next is RedeemCreditsError) {
        showErrorSnackbar(context, next.error);
        ref.read(redeemCreditsNotifierProvider.notifier).reset();
      }
    });

    final walletState = ref.watch(walletNotifierProvider);
    final actionState = ref.watch(redeemCreditsNotifierProvider);
    final isLoading = actionState is RedeemCreditsLoading;
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
          child: walletState.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(24),
              child: SizedBox(height: 200, child: GzLoadingView()),
            ),
            error: (error, _) => Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                error.toString(),
                style: AppTypography.body.copyWith(color: AppColors.err),
              ),
            ),
            data: (wallet) {
              final maxCredits =
                  wallet.balance.availableBalance ??
                  wallet.balance.currentBalance ??
                  0;
              final safeSelected = _selectedCredits
                  .clamp(0, maxCredits)
                  .toDouble();
              if (safeSelected != _selectedCredits) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {
                    setState(() => _selectedCredits = safeSelected);
                  }
                });
              }
              final redeemValue = safeSelected / 10;
              final remainingCredits = (maxCredits - safeSelected)
                  .clamp(0, maxCredits)
                  .toDouble();
              final canRedeem =
                  safeSelected > 0 && maxCredits > 0 && !isLoading;

              return Padding(
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
                    Text('Redeem credits', style: AppTypography.h1),
                    const SizedBox(height: 4),
                    Text(
                      '10 credits = ₹1 at ${wallet.balance.storeName ?? 'your selected store'}',
                      style: AppTypography.bodyR,
                    ),
                    const SizedBox(height: 16),
                    GzCard(
                      variant: CardVariant.tint,
                      child: _RedeemBalanceCard(balance: maxCredits),
                    ),
                    if (_showConfirmation) ...[
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.warnBg,
                          borderRadius: BorderRadius.circular(
                            AppSpacing.borderRadiusLg,
                          ),
                        ),
                        child: Text(
                          'Confirm to apply ₹${redeemValue.toStringAsFixed(2)} off your next booking.',
                          style: AppTypography.body.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 18),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: AppColors.textPrimary,
                        inactiveTrackColor: AppColors.pillBg,
                        thumbColor: AppColors.textPrimary,
                        overlayColor: AppColors.textPrimary.withValues(
                          alpha: 0.08,
                        ),
                        trackHeight: 6,
                      ),
                      child: Slider(
                        min: 0,
                        max: maxCredits <= 0 ? 1 : maxCredits,
                        divisions: maxCredits <= 0
                            ? 1
                            : maxCredits.round().clamp(1, 1000),
                        value: maxCredits <= 0 ? 0 : safeSelected.toDouble(),
                        onChanged: maxCredits <= 0
                            ? null
                            : (value) {
                                setState(() {
                                  _selectedCredits = value.roundToDouble();
                                  _showConfirmation = false;
                                });
                              },
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Redeem: ${safeSelected.round()} credits = ₹${redeemValue.toStringAsFixed(2)}',
                      style: AppTypography.h3,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Remaining: ${remainingCredits.round()} credits',
                      style: AppTypography.bodyR,
                    ),
                    const SizedBox(height: 18),
                    GzButton(
                      label: _showConfirmation
                          ? 'Confirm redemption'
                          : 'Redeem ${safeSelected.round()} credits',
                      loading: isLoading,
                      onPressed: !canRedeem
                          ? null
                          : () {
                              if (!_showConfirmation) {
                                setState(() => _showConfirmation = true);
                                return;
                              }
                              ref
                                  .read(redeemCreditsNotifierProvider.notifier)
                                  .redeem(safeSelected.round());
                            },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _RedeemBalanceCard extends StatelessWidget {
  const _RedeemBalanceCard({required this.balance});

  final double balance;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('BALANCE', style: AppTypography.meta),
        const SizedBox(height: 10),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: walletCreditsLabel(balance),
                style: AppTypography.heroMd,
              ),
              TextSpan(
                text: ' credits available',
                style: AppTypography.body.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
