import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/gz_chip.dart';
import '../../../../shared/widgets/gz_top_bar.dart';

class CreditHistoryScreen extends StatefulWidget {
  const CreditHistoryScreen({super.key});

  @override
  State<CreditHistoryScreen> createState() => _CreditHistoryScreenState();
}

class _CreditHistoryScreenState extends State<CreditHistoryScreen> {
  int _selectedFilter = 0;

  static const _filters = ['All', 'Earned', 'Spent'];

  static const _transactions = [
    _CreditTransaction(amount: '+200', label: 'Booking credit', date: 'Jun 02', earned: true),
    _CreditTransaction(amount: '−150', label: 'Session deduct', date: 'Jun 01', earned: false),
    _CreditTransaction(amount: '+500', label: 'Welcome bonus', date: 'May 28', earned: true),
    _CreditTransaction(amount: '−80', label: 'Redemption', date: 'May 20', earned: false),
    _CreditTransaction(amount: '+300', label: 'Referral bonus', date: 'May 15', earned: true),
    _CreditTransaction(amount: '−200', label: 'Session deduct', date: 'May 10', earned: false),
  ];

  List<_CreditTransaction> get _visibleTransactions {
    return switch (_selectedFilter) {
      1 => _transactions.where((item) => item.earned).toList(),
      2 => _transactions.where((item) => !item.earned).toList(),
      _ => _transactions,
    };
  }

  @override
  Widget build(BuildContext context) {
    final transactions = _visibleTransactions;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const GzTopBar(title: 'Credit history'),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: SizedBox(
                height: 36,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _filters.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    return GzChip(
                      label: _filters[index],
                      active: _selectedFilter == index,
                      onTap: () => setState(() => _selectedFilter = index),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                itemCount: transactions.length,
                separatorBuilder: (_, _) => const Divider(
                  height: 1,
                  color: AppColors.divider,
                ),
                itemBuilder: (context, index) {
                  final transaction = transactions[index];
                  return _CreditHistoryRow(transaction: transaction);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CreditHistoryRow extends StatelessWidget {
  const _CreditHistoryRow({required this.transaction});

  final _CreditTransaction transaction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: RichText(
              text: TextSpan(
                style: AppTypography.body.copyWith(color: AppColors.textPrimary),
                children: [
                  TextSpan(
                    text: transaction.amount,
                    style: AppTypography.num.copyWith(
                      color: transaction.earned ? AppColors.ok : AppColors.err,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const TextSpan(text: ' · '),
                  TextSpan(text: transaction.label),
                  const TextSpan(text: ' · '),
                  TextSpan(
                    text: transaction.date,
                    style: AppTypography.bodyR,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CreditTransaction {
  const _CreditTransaction({
    required this.amount,
    required this.label,
    required this.date,
    required this.earned,
  });

  final String amount;
  final String label;
  final String date;
  final bool earned;
}
