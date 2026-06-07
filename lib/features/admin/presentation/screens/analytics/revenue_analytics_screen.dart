import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../shared/widgets/gz_admin_top_bar.dart';
import '../../../../../shared/widgets/gz_meta_row.dart';

class RevenueAnalyticsScreen extends StatefulWidget {
  const RevenueAnalyticsScreen({super.key});

  @override
  State<RevenueAnalyticsScreen> createState() => _RevenueAnalyticsScreenState();
}

class _RevenueAnalyticsScreenState extends State<RevenueAnalyticsScreen> {
  static const _filters = ['Daily', 'Weekly', 'Monthly'];
  static const _rows = [
    _RevenueRow(date: 'Jun 01', sessions: '28', revenue: '₹8,400'),
    _RevenueRow(date: 'Jun 02', sessions: '31', revenue: '₹9,300'),
    _RevenueRow(date: 'Jun 03', sessions: '25', revenue: '₹7,500'),
    _RevenueRow(date: 'Jun 04', sessions: '29', revenue: '₹8,700'),
    _RevenueRow(date: 'Jun 05', sessions: '33', revenue: '₹9,900'),
    _RevenueRow(date: 'Jun 06', sessions: '34', revenue: '₹10,200'),
  ];

  int _activeFilter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: GzAdminTopBar(
        title: 'Revenue',
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: List.generate(
                  _filters.length,
                  (index) => Padding(
                    padding: EdgeInsets.only(
                      right: index == _filters.length - 1 ? 0 : 8,
                    ),
                    child: _RoseChip(
                      label: _filters[index],
                      active: _activeFilter == index,
                      onTap: () => setState(() => _activeFilter = index),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const _Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Revenue', style: AppTypography.meta),
                    SizedBox(height: 6),
                    Text('₹1,84,200', style: AppTypography.heroMd),
                    SizedBox(height: 6),
                    Text('Last 30 days', style: AppTypography.small),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const _Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Payment breakdown', style: AppTypography.h3),
                    SizedBox(height: 14),
                    GzMetaRow(label: 'Cash', value: '₹72,400'),
                    GzMetaRow(label: 'UPI', value: '₹89,200'),
                    GzMetaRow(label: 'Credits', value: '₹22,600'),
                    Divider(height: 16, color: AppColors.rule),
                    GzMetaRow(
                      label: 'Total',
                      value: '₹1,84,200',
                      valueStyle: TextStyle(
                        fontFamily: 'Geist',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Daily breakdown', style: AppTypography.h3),
                    const SizedBox(height: 12),
                    const Row(
                      children: [
                        Expanded(
                          child: Text('DATE', style: AppTypography.meta),
                        ),
                        SizedBox(
                          width: 70,
                          child: Text(
                            'SESSIONS',
                            textAlign: TextAlign.right,
                            style: AppTypography.meta,
                          ),
                        ),
                        SizedBox(width: 10),
                        SizedBox(
                          width: 80,
                          child: Text(
                            'REVENUE',
                            textAlign: TextAlign.right,
                            style: AppTypography.meta,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Divider(height: 1, color: AppColors.rule),
                    ...List.generate(_rows.length, (index) {
                      final row = _rows[index];
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          border: index == _rows.length - 1
                              ? null
                              : const Border(
                                  bottom: BorderSide(color: AppColors.rule),
                                ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(row.date, style: AppTypography.num),
                            ),
                            SizedBox(
                              width: 70,
                              child: Text(
                                row.sessions,
                                textAlign: TextAlign.right,
                                style: AppTypography.num,
                              ),
                            ),
                            const SizedBox(width: 10),
                            SizedBox(
                              width: 80,
                              child: Text(
                                row.revenue,
                                textAlign: TextAlign.right,
                                style: AppTypography.num,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoseChip extends StatelessWidget {
  const _RoseChip({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 30,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: active ? AppColors.rose : AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: active ? null : Border.all(color: AppColors.rule),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppTypography.num.copyWith(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: active ? AppColors.surface : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}

class _RevenueRow {
  const _RevenueRow({
    required this.date,
    required this.sessions,
    required this.revenue,
  });

  final String date;
  final String sessions;
  final String revenue;
}
