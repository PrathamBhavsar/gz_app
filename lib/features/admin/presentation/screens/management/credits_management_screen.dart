import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../core/theme/app_colors.dart';
import 'adjust_credits_sheet.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../shared/widgets/gz_admin_top_bar.dart';
import '../../../../../shared/widgets/gz_avatar.dart';
import '../../../../../shared/widgets/gz_button.dart';
import '../../../../../shared/widgets/gz_card.dart';
import '../../../../../shared/widgets/gz_scroll_content.dart';

class CreditsManagementScreen extends StatelessWidget {
  const CreditsManagementScreen({super.key});

  static const _transactions = [
    _CreditTransactionData(
      label: 'Booking credit',
      amount: '+200',
      date: 'Jun 02',
      isPositive: true,
    ),
    _CreditTransactionData(
      label: 'Session deduct',
      amount: '-150',
      date: 'Jun 01',
      isPositive: false,
    ),
    _CreditTransactionData(
      label: 'Welcome bonus',
      amount: '+500',
      date: 'May 28',
      isPositive: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const GzAdminTopBar(title: 'Credits'),
      body: SafeArea(
        top: false,
        child: GzScrollContent(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SearchBar(),
                const SizedBox(height: 14),
                const _CreditsPlayerCard(transactions: _transactions),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.pillBg,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
      ),
      child: const Row(
        children: [
          HugeIcon(
            icon: HugeIcons.strokeRoundedSearch01,
            color: AppColors.textTertiary,
            size: 18,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Search by phone, email, or name…',
              style: AppTypography.bodyR,
            ),
          ),
        ],
      ),
    );
  }
}

class _CreditsPlayerCard extends StatelessWidget {
  const _CreditsPlayerCard({required this.transactions});

  final List<_CreditTransactionData> transactions;

  @override
  Widget build(BuildContext context) {
    return GzCard(
      padding: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              GzAvatar(letter: 'R', size: GzAvatarSize.lg),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Rahul Mehra', style: AppTypography.h3),
                    SizedBox(height: 2),
                    Text('+91 98765 43210', style: AppTypography.small),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const GzCard(
            variant: CardVariant.tint,
            padding: 14,
            child: Column(
              children: [
                Text('CREDIT BALANCE', style: AppTypography.meta),
                SizedBox(height: 4),
                Text('850', style: AppTypography.heroMd),
                SizedBox(height: 2),
                Text('credits', style: AppTypography.small),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Text('Recent transactions', style: AppTypography.h3),
              const Spacer(),
              Text(
                'See all →',
                style: AppTypography.small.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...transactions.map((tx) => _TransactionRow(transaction: tx)),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: GzButton(
                  label: 'Deduct credits',
                  variant: GzButtonVariant.ghost,
                  small: true,
                  onPressed: () => showAdjustCreditsSheet(context,
                      userId: 'USR-001',
                      userName: 'Rahul Mehra',
                      balance: 850,
                      mode: 'deduct'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GzButton(
                  label: 'Add credits',
                  small: true,
                  onPressed: () => showAdjustCreditsSheet(context,
                      userId: 'USR-001',
                      userName: 'Rahul Mehra',
                      balance: 850,
                      mode: 'add'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TransactionRow extends StatelessWidget {
  const _TransactionRow({required this.transaction});

  final _CreditTransactionData transaction;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.rule)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.label,
                  style: AppTypography.body.copyWith(fontSize: 13),
                ),
                const SizedBox(height: 2),
                Text(transaction.date, style: AppTypography.small),
              ],
            ),
          ),
          Text(
            transaction.amount,
            style: AppTypography.num.copyWith(
              fontWeight: FontWeight.w600,
              color: transaction.isPositive ? AppColors.ok : AppColors.err,
            ),
          ),
        ],
      ),
    );
  }
}

class _CreditTransactionData {
  const _CreditTransactionData({
    required this.label,
    required this.amount,
    required this.date,
    required this.isPositive,
  });

  final String label;
  final String amount;
  final String date;
  final bool isPositive;
}
