import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/navigation/routes.dart';
import '../../providers/admin_analytics_provider.dart';
import '../../../../../../models/domain_analytics.dart';

final _revenueGroupByProvider = StateProvider.autoDispose<String>((ref) => 'day');

/// Revenue Analytics — Screen 47.
/// Detailed financial breakdown with revenue table and payment breakdown.
class RevenueAnalyticsScreen extends ConsumerStatefulWidget {
  const RevenueAnalyticsScreen({super.key});

  @override
  ConsumerState<RevenueAnalyticsScreen> createState() =>
      _RevenueAnalyticsScreenState();
}

class _RevenueAnalyticsScreenState
    extends ConsumerState<RevenueAnalyticsScreen> {
  @override
  Widget build(BuildContext context) {
    final groupBy = ref.watch(_revenueGroupByProvider);
    final state = ref.watch(revenueProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft01,
            color: AppColors.textPrimary,
            size: 20,
          ),
          onPressed: () => context.go(AppRoutes.adminAnalytics),
        ),
        title: Text('Revenue', style: AppTypography.headingSmall),
      ),
      body: RefreshIndicator(
        color: AppColors.rose,
        backgroundColor: AppColors.surface,
        onRefresh: () => _load(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  _GroupByChip(
                    label: 'Daily',
                    value: 'day',
                    activeGroupBy: groupBy,
                    onTap: () => _selectGroupBy('day'),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  _GroupByChip(
                    label: 'Weekly',
                    value: 'week',
                    activeGroupBy: groupBy,
                    onTap: () => _selectGroupBy('week'),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  _GroupByChip(
                    label: 'Monthly',
                    value: 'month',
                    activeGroupBy: groupBy,
                    onTap: () => _selectGroupBy('month'),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              _buildContent(state),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }

  void _selectGroupBy(String value) {
    ref.read(_revenueGroupByProvider.notifier).state = value;
    _load(value);
  }

  Widget _buildContent(AnalyticsState<RevenueAnalyticsModel> state) {
    if (state is AnalyticsLoading<RevenueAnalyticsModel>) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xxl),
          child: CircularProgressIndicator(color: AppColors.rose),
        ),
      );
    }
    if (state is AnalyticsError<RevenueAnalyticsModel>) {
      return _RevenueError(onRetry: _load);
    }
    if (state is AnalyticsLoaded<RevenueAnalyticsModel>) {
      return _RevenueContent(data: state.data);
    }
    return const SizedBox.shrink();
  }

  Future<void> _load([String? overrideGroupBy]) async {
    final now = DateTime.now();
    ref.read(revenueProvider.notifier).load(
          dateFrom: _formatDate(now.subtract(const Duration(days: 30))),
          dateTo: _formatDate(now),
          groupBy: overrideGroupBy ?? ref.read(_revenueGroupByProvider),
        );
  }

  String _formatDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}

// ─── Group By Chip ────────────────────────────────────────────────────────────

class _GroupByChip extends StatelessWidget {
  const _GroupByChip({
    required this.label,
    required this.value,
    required this.activeGroupBy,
    required this.onTap,
  });
  final String label;
  final String value;
  final String activeGroupBy;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isActive = activeGroupBy == value;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: isActive ? AppColors.rose : AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
        ),
        child: Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            color: isActive ? AppColors.background : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

// ─── Error View ───────────────────────────────────────────────────────────────

class _RevenueError extends StatelessWidget {
  const _RevenueError({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          children: [
            const HugeIcon(
              icon: HugeIcons.strokeRoundedAlert01,
              color: AppColors.error,
              size: 48,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Failed to load revenue data',
              style: AppTypography.bodyMedium
                  .copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.md),
            OutlinedButton(
              onPressed: onRetry,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textPrimary,
                side: const BorderSide(color: AppColors.border),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
                ),
              ),
              child: Text('Retry', style: AppTypography.button),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Revenue Content ──────────────────────────────────────────────────────────

class _RevenueContent extends StatelessWidget {
  const _RevenueContent({required this.data});
  final RevenueAnalyticsModel data;

  @override
  Widget build(BuildContext context) {
    final rows = data.data ?? [];

    if (rows.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Text(
            'No revenue data available',
            style: AppTypography.bodyMedium
                .copyWith(color: AppColors.textSecondary),
          ),
        ),
      );
    }

    String totalRevenue = '0';
    String totalNet = '0';
    for (final row in rows) {
      final rev = double.tryParse(row.revenue ?? '0') ?? 0;
      final net = double.tryParse(row.netRevenue ?? '0') ?? 0;
      totalRevenue = (double.parse(totalRevenue) + rev).toStringAsFixed(2);
      totalNet = (double.parse(totalNet) + net).toStringAsFixed(2);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _SummaryCard(label: 'Gross', value: '₹$totalRevenue'),
            const SizedBox(width: AppSpacing.sm),
            _SummaryCard(label: 'Net', value: '₹$totalNet'),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        Text('Revenue Breakdown', style: AppTypography.headingSmall),
        const SizedBox(height: AppSpacing.md),
        _tableRow('Date', 'Revenue', 'Net', 'Sessions', isHeader: true),
        const Divider(color: AppColors.border, height: 1),
        ...rows.map(
          (row) => _tableRow(
            row.date ?? '--',
            '₹${row.revenue ?? '0'}',
            '₹${row.netRevenue ?? '0'}',
            '${row.sessions ?? 0}',
          ),
        ),
      ],
    );
  }

  Widget _tableRow(
    String col1,
    String col2,
    String col3,
    String col4, {
    bool isHeader = false,
  }) {
    final style = isHeader
        ? AppTypography.caption.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          )
        : AppTypography.bodySmall;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(col1, style: style)),
          Expanded(
              flex: 2,
              child: Text(col2, style: style, textAlign: TextAlign.right)),
          Expanded(
              flex: 2,
              child: Text(col3, style: style, textAlign: TextAlign.right)),
          Expanded(child: Text(col4, style: style, textAlign: TextAlign.right)),
        ],
      ),
    );
  }
}

// ─── Summary Card ─────────────────────────────────────────────────────────────

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: AppTypography.headingSmall),
            const SizedBox(height: AppSpacing.xs),
            Text(label, style: AppTypography.caption),
          ],
        ),
      ),
    );
  }
}
