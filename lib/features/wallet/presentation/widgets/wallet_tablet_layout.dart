import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../providers/wallet_notifier.dart';
import '../../../../models/domain_billing.dart';
import '../../../../models/enums.dart';

class WalletTabletLayout extends ConsumerWidget {
  const WalletTabletLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(walletNotifierProvider);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Column: Balance & Actions
        Expanded(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBalanceCard(context, state.balance, ref),
                const SizedBox(height: AppSpacing.xxl),
                Text('Quick Actions', style: AppTypography.headingLarge),
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: AppSpacing.md,
                  runSpacing: AppSpacing.md,
                  children: [
                    _actionChip(context, ref, 'Top up \$10', 10.0),
                    _actionChip(context, ref, 'Top up \$25', 25.0),
                    _actionChip(context, ref, 'Top up \$50', 50.0),
                    _actionChip(context, ref, 'Top up \$100', 100.0),
                  ],
                ),
              ],
            ),
          ),
        ),
        const VerticalDivider(width: 1, color: AppColors.border),
        // Right Column: Transactions
        Expanded(
          flex: 6,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Transaction History',
                      style: AppTypography.headingLarge,
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh, color: AppColors.primary),
                      onPressed: () =>
                          ref.read(walletNotifierProvider.notifier).refresh(),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                Expanded(
                  child: state.isLoading && state.transactions.isEmpty
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        )
                      : state.transactions.isEmpty
                      ? Center(
                          child: Text(
                            'No transactions yet.',
                            style: AppTypography.bodyLarge.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: state.transactions.length,
                          itemBuilder: (context, index) =>
                              _buildTransactionItem(state.transactions[index]),
                        ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBalanceCard(
    BuildContext context,
    double balance,
    WidgetRef ref,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxl * 1.5),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.rose],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Available Balance',
                style: AppTypography.headingMedium.copyWith(
                  color: AppColors.background,
                ),
              ),
              const HugeIcon(
                icon: HugeIcons.strokeRoundedWallet01,
                color: AppColors.background,
                size: 40,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            '\$ ${balance.toStringAsFixed(2)}',
            style: AppTypography.headingLarge.copyWith(
              color: AppColors.background,
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionChip(
    BuildContext context,
    WidgetRef ref,
    String label,
    double amount,
  ) {
    return ActionChip(
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      backgroundColor: AppColors.surface,
      side: const BorderSide(color: AppColors.primary),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      onPressed: () {
        ref.read(walletNotifierProvider.notifier).topUp(amount);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Processing \$amount top-up...')),
        );
      },
    );
  }

  Widget _buildTransactionItem(TransactionModel tx) {
    final isCredit =
        tx.type == TransactionType.topUp || tx.type == TransactionType.refund;
    final icon = isCredit
        ? HugeIcons.strokeRoundedArrowDownLeft01
        : HugeIcons.strokeRoundedArrowUpRight01;
    final color = isCredit ? Colors.greenAccent : AppColors.error;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  shape: BoxShape.circle,
                ),
                child: HugeIcon(icon: icon, color: color, size: 24),
              ),
              const SizedBox(width: AppSpacing.md),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tx.type?.name ?? 'Transaction',
                    style: AppTypography.headingSmall,
                  ),
                  Text(
                    '${tx.createdAt?.toString().split(' ')[0] ?? 'Date N/A'}',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Text(
            '${isCredit ? '+' : '-'}\$ ${tx.amount?.abs().toStringAsFixed(2) ?? '0.00'}',
            style: AppTypography.headingMedium.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
