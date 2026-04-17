import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../providers/wallet_notifier.dart';
import '../../../../models/domain_loyalty.dart';
import '../../../../models/enums.dart';

class WalletMobileLayout extends ConsumerWidget {
  const WalletMobileLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(walletNotifierProvider);

    if (state.isLoading && state.transactions.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    return RefreshIndicator(
      onRefresh: () =>
          ref.read(walletNotifierProvider.notifier).refresh('placeholder'),
      color: AppColors.primary,
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          _buildBalanceCard(context, state.balance, ref),
          const SizedBox(height: AppSpacing.xl),
          Text('Recent Transactions', style: AppTypography.headingMedium),
          const SizedBox(height: AppSpacing.md),
          if (state.transactions.isEmpty)
            _buildEmptyState()
          else
            ...state.transactions.map((tx) => _buildTransactionItem(tx)),
        ],
      ),
    );
  }

  Widget _buildBalanceCard(
    BuildContext context,
    double balance,
    WidgetRef ref,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.rose],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Available Balance',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.background,
                ),
              ),
              const HugeIcon(
                icon: HugeIcons.strokeRoundedWallet01,
                color: AppColors.background,
                size: 28,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '\$ ${balance.toStringAsFixed(2)}',
            style: AppTypography.headingLarge.copyWith(
              color: AppColors.background,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _showRedeemDialog(context, ref),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.background,
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    AppSpacing.borderRadiusSm,
                  ),
                ),
              ),
              child: const Text(
                'Redeem Credits',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(CreditLedgerModel tx) {
    final isCredit =
        tx.transactionType == CreditTransactionType.earned ||
        tx.transactionType == CreditTransactionType.bonus ||
        tx.transactionType == CreditTransactionType.refund;
    final icon = isCredit
        ? HugeIcons.strokeRoundedArrowDownLeft01
        : HugeIcons.strokeRoundedArrowUpRight01;
    final color = isCredit ? Colors.greenAccent : AppColors.error;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          shape: BoxShape.circle,
        ),
        child: HugeIcon(icon: icon, color: color, size: 20),
      ),
      title: Text(
        tx.description ?? tx.transactionType?.name ?? 'Transaction',
        style: AppTypography.bodyLarge,
      ),
      subtitle: Text(
        tx.createdAt?.toString().split(' ')[0] ?? 'Date N/A',
        style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
      ),
      trailing: Text(
        '${isCredit ? '+' : '-'}\$ ${tx.amount?.abs().toStringAsFixed(2) ?? '0.00'}',
        style: AppTypography.headingSmall.copyWith(color: color),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
        child: Text(
          'No transactions found',
          style: AppTypography.bodyLarge.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  void _showRedeemDialog(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.borderRadius),
        ),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Redeem Credits', style: AppTypography.headingMedium),
            const SizedBox(height: AppSpacing.xl),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _redeemBtn(ctx, ref, 10),
                _redeemBtn(ctx, ref, 25),
                _redeemBtn(ctx, ref, 50),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _redeemBtn(BuildContext ctx, WidgetRef ref, double amount) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pop(ctx);
        ref
            .read(walletNotifierProvider.notifier)
            .redeemCredits('placeholder', amount);
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(content: Text('Redeeming \$$amount credits...')),
        );
      },
      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
      child: Text('\$$amount'),
    );
  }
}
