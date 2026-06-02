import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/gz_chip.dart';
import '../../../../shared/widgets/gz_tag.dart';
import '../../../../shared/widgets/gz_top_bar.dart';

class BillingHistoryScreen extends StatefulWidget {
  const BillingHistoryScreen({super.key});

  @override
  State<BillingHistoryScreen> createState() => _BillingHistoryScreenState();
}

class _BillingHistoryScreenState extends State<BillingHistoryScreen> {
  int _filterIndex = 0;
  final _filters = ['All', 'Paid', 'Unpaid', 'Overdue'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: GzTopBar(title: 'Billing history'),
      body: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: SizedBox(
                height: 36,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _filters.length,
                  separatorBuilder: (_, index) => const SizedBox(width: 8),
                  itemBuilder: (context, i) => GzChip(
                    label: _filters[i],
                    active: _filterIndex == i,
                    onTap: () => setState(() => _filterIndex = i),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: const [
                  _BillingRow(
                    store: 'GameZone Koramangala',
                    date: '4 Jun',
                    duration: '2h 07m',
                    amount: '₹1,740',
                    tag: GzTag(kind: GzTagKind.ok, label: 'Paid'),
                  ),
                  SizedBox(height: 10),
                  _BillingRow(
                    store: 'GameZone Indiranagar',
                    date: '28 May',
                    duration: '1h 30m',
                    amount: '₹1,200',
                    tag: GzTag(kind: GzTagKind.ok, label: 'Paid'),
                  ),
                  SizedBox(height: 10),
                  _BillingRow(
                    store: 'GameZone Koramangala',
                    date: '20 May',
                    duration: '3h 00m',
                    amount: '₹2,400',
                    tag: GzTag(kind: GzTagKind.warn, label: 'Unpaid'),
                  ),
                  SizedBox(height: 10),
                  _BillingRow(
                    store: 'GameZone Whitefield',
                    date: '15 May',
                    duration: '2h 00m',
                    amount: '₹1,600',
                    tag: GzTag(kind: GzTagKind.ok, label: 'Paid'),
                  ),
                  SizedBox(height: 10),
                  _BillingRow(
                    store: 'GameZone HSR',
                    date: '10 May',
                    duration: '1h 00m',
                    amount: '₹800',
                    tag: GzTag(kind: GzTagKind.ok, label: 'Paid'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BillingRow extends StatelessWidget {
  const _BillingRow({
    required this.store,
    required this.date,
    required this.duration,
    required this.amount,
    required this.tag,
  });

  final String store;
  final String date;
  final String duration;
  final String amount;
  final Widget tag;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(store, style: AppTypography.h3),
                const SizedBox(height: 4),
                Text('$date · $duration',
                    style: AppTypography.small
                        .copyWith(color: AppColors.textSecondary)),
                const SizedBox(height: 6),
                tag,
              ],
            ),
          ),
          Text(amount,
              style: AppTypography.num.copyWith(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
