import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/errors/app_exception.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../models/domain_analytics.dart';
import '../../../../../shared/widgets/gz_admin_top_bar.dart';
import '../../../../../shared/widgets/gz_loading_view.dart';
import '../../../../../shared/widgets/page_error_display.dart';
import '../../../../admin/application/admin_analytics_notifier.dart';
import '../../../../admin/application/admin_management_models.dart';

class RevenueAnalyticsScreen extends ConsumerWidget {
  const RevenueAnalyticsScreen({super.key});

  static const _filters = ['Daily', 'Weekly', 'Monthly'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const GzAdminTopBar(title: 'Revenue'),
      body: SafeArea(
        top: false,
        child: ref
            .watch(adminRevenueAnalyticsNotifierProvider)
            .when(
              loading: () =>
                  const GzLoadingView(message: 'Loading revenue data'),
              error: (e, _) => PageErrorDisplay(
                error: AppPageError.from(e),
                onRetry: () => ref
                    .read(adminRevenueAnalyticsNotifierProvider.notifier)
                    .refresh(),
              ),
              data: (data) => _Body(data: data, filters: _filters),
            ),
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.data, required this.filters});

  final AdminRevenueData data;
  final List<String> filters;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: filters.map((f) {
              final isLast = f == filters.last;
              return Padding(
                padding: EdgeInsets.only(right: isLast ? 0 : 8),
                child: _RoseChip(
                  label: f,
                  active: data.selectedFilter == f,
                  onTap: () => ref
                      .read(adminRevenueAnalyticsNotifierProvider.notifier)
                      .selectFilter(f),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          _Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total Revenue', style: AppTypography.meta),
                const SizedBox(height: 6),
                Text(data.totalRevenue, style: AppTypography.heroMd),
                const SizedBox(height: 6),
                Text(
                  data.model.dateFrom != null && data.model.dateTo != null
                      ? '${_shortDate(data.model.dateFrom)} – ${_shortDate(data.model.dateTo)}'
                      : 'Last period',
                  style: AppTypography.small,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Breakdown', style: AppTypography.h3),
                const SizedBox(height: 12),
                if (data.rows.isEmpty)
                  Text('No data available', style: AppTypography.small)
                else ...[
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
                  ...List.generate(data.rows.length, (index) {
                    final row = data.rows[index];
                    final isLast = index == data.rows.length - 1;
                    return _RevenueTableRow(
                      row: row,
                      isLast: isLast,
                    );
                  }),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RevenueTableRow extends StatelessWidget {
  const _RevenueTableRow({required this.row, required this.isLast});

  final RevenueAnalyticsRow row;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(bottom: BorderSide(color: AppColors.rule)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              _shortDate(row.date),
              style: AppTypography.num,
            ),
          ),
          SizedBox(
            width: 70,
            child: Text(
              '${row.sessions ?? 0}',
              textAlign: TextAlign.right,
              style: AppTypography.num,
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 80,
            child: Text(
              _fmtAmt(row.revenue),
              textAlign: TextAlign.right,
              style: AppTypography.num,
            ),
          ),
        ],
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

String _fmtAmt(String? s) {
  if (s == null) return '—';
  final v = double.tryParse(s);
  if (v == null) return s;
  return '₹${v.toStringAsFixed(0)}';
}

String _shortDate(String? isoDate) {
  if (isoDate == null) return '—';
  try {
    final d = DateTime.parse(isoDate);
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[d.month]} ${d.day}';
  } catch (_) {
    return isoDate;
  }
}
