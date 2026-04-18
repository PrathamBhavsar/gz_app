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
  String _groupBy = 'day';

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _load());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(revenueProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: AppColors.textPrimary, size: 20),
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
              // Group by selector
              _buildGroupByChips(),
              const SizedBox(height: AppSpacing.lg),
              _buildContent(state),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGroupByChips() {
    return Row(
      children: [
        _buildChip('Daily', 'day'),
        const SizedBox(width: AppSpacing.sm),
        _buildChip('Weekly', 'week'),
        const SizedBox(width: AppSpacing.sm),
        _buildChip('Monthly', 'month'),
      ],
    );
  }

  Widget _buildChip(String label, String value) {
    final isActive = _groupBy == value;
    return GestureDetector(
      onTap: () {
        setState(() => _groupBy = value);
        _load();
      },
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

  Widget _buildContent(AnalyticsState<RevenueAnalyticsModel> state) {
    if (state is AnalyticsLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xxl),
          child: CircularProgressIndicator(color: AppColors.rose),
        ),
      );
    }

    if (state is AnalyticsError) {
      return _buildError(state.error);
    }

    if (state is AnalyticsLoaded) {
      return _buildRevenueContent(state.data);
    }

    return const SizedBox.shrink();
  }

  Widget _buildError(Object error) {
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
            Text('Failed to load revenue data',
                style: AppTypography.bodyMedium
                    .copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: AppSpacing.md),
            OutlinedButton(
              onPressed: _load,
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

  Widget _buildRevenueContent(RevenueAnalyticsModel data) {
    final rows = data.data ?? [];

    if (rows.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Text('No revenue data available',
              style: AppTypography.bodyMedium
                  .copyWith(color: AppColors.textSecondary)),
        ),
      );
    }

    // Summary totals
    String totalRevenue = '0';
    String totalNet = '0';
    int totalSessions = 0;
    for (final row in rows) {
      final rev = double.tryParse(row.revenue ?? '0') ?? 0;
      final net = double.tryParse(row.netRevenue ?? '0') ?? 0;
      totalRevenue = (double.parse(totalRevenue) + rev).toStringAsFixed(2);
      totalNet = (double.parse(totalNet) + net).toStringAsFixed(2);
      totalSessions += row.sessions ?? 0;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Summary cards
        Row(
          children: [
            _buildSummaryCard('Gross', '₹$totalRevenue'),
            const SizedBox(width: AppSpacing.sm),
            _buildSummaryCard('Net', '₹$totalNet'),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),

        // Revenue table
        Text('Revenue Breakdown', style: AppTypography.headingSmall),
        const SizedBox(height: AppSpacing.md),
        // Table header
        _buildTableRow('Date', 'Revenue', 'Net', 'Sessions', isHeader: true),
        const Divider(color: AppColors.border, height: 1),
        // Table rows
        ...rows.map((row) => _buildTableRow(
              row.date ?? '--',
              '₹${row.revenue ?? '0'}',
              '₹${row.netRevenue ?? '0'}',
              '${row.sessions ?? 0}',
            )),
      ],
    );
  }

  Widget _buildSummaryCard(String label, String value) {
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

  Widget _buildTableRow(
    String col1,
    String col2,
    String col3,
    String col4, {
    bool isHeader = false,
  }) {
    final style = isHeader
        ? AppTypography.caption.copyWith(
            color: AppColors.textSecondary, fontWeight: FontWeight.w600)
        : AppTypography.bodySmall;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(col1, style: style)),
          Expanded(flex: 2, child: Text(col2, style: style, textAlign: TextAlign.right)),
          Expanded(flex: 2, child: Text(col3, style: style, textAlign: TextAlign.right)),
          Expanded(child: Text(col4, style: style, textAlign: TextAlign.right)),
        ],
      ),
    );
  }

  Future<void> _load() async {
    final now = DateTime.now();
    ref.read(revenueProvider.notifier).load(
      dateFrom: _formatDate(now.subtract(const Duration(days: 30))),
      dateTo: _formatDate(now),
      groupBy: _groupBy,
    );
  }

  String _formatDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
