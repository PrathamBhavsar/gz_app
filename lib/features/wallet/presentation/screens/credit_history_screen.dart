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
  static const List<String> _filters = ['All', 'Earned', 'Spent'];
  static const List<_CreditEntry> _entries = [
    _CreditEntry(amount: '+200', label: 'Booking credit', date: 'Jun 02'),
    _CreditEntry(amount: '−150', label: 'Session deduct', date: 'Jun 01'),
    _CreditEntry(amount: '+500', label: 'Welcome bonus', date: 'May 28'),
    _CreditEntry(amount: '−80', label: 'Redemption', date: 'May 20'),
    _CreditEntry(amount: '+300', label: 'Referral bonus', date: 'May 15'),
    _CreditEntry(amount: '−200', label: 'Session deduct', date: 'May 10'),
  ];

  int _selectedFilter = 0;

  List<_CreditEntry> get _visibleEntries {
    return switch (_selectedFilter) {
      1 => _entries.where((entry) => entry.isCredit).toList(),
      2 => _entries.where((entry) => !entry.isCredit).toList(),
      _ => _entries,
    };
  }

  @override
  Widget build(BuildContext context) {
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
                itemCount: _visibleEntries.length,
                separatorBuilder: (_, _) =>
                    const Divider(height: 1, color: AppColors.divider),
                itemBuilder: (context, index) {
                  return _CreditRow(entry: _visibleEntries[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CreditRow extends StatelessWidget {
  const _CreditRow({required this.entry});

  final _CreditEntry entry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: RichText(
        text: TextSpan(
          style: AppTypography.body.copyWith(color: AppColors.textPrimary),
          children: [
            TextSpan(
              text: entry.amount,
              style: AppTypography.num.copyWith(
                color: entry.isCredit ? AppColors.ok : AppColors.err,
                fontWeight: FontWeight.w700,
              ),
            ),
            const TextSpan(text: ' · '),
            TextSpan(text: entry.label),
            const TextSpan(text: ' · '),
            TextSpan(text: entry.date, style: AppTypography.bodyR),
          ],
        ),
      ),
    );
  }
}

class _CreditEntry {
  const _CreditEntry({
    required this.amount,
    required this.label,
    required this.date,
  });

  final String amount;
  final String label;
  final String date;

  bool get isCredit => amount.startsWith('+');
}
