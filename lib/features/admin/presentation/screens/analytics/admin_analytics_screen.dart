import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/navigation/routes.dart';
import '../../providers/admin_analytics_provider.dart';
import '../../providers/admin_permissions.dart';
import '../../../../../../models/domain_analytics.dart';

/// Analytics Dashboard — Screen 46.
/// High-level store health overview with KPI widgets and quick navigation.
class AdminAnalyticsScreen extends ConsumerStatefulWidget {
  const AdminAnalyticsScreen({super.key});

  @override
  ConsumerState<AdminAnalyticsScreen> createState() =>
      _AdminAnalyticsScreenState();
}

class _AdminAnalyticsScreenState extends ConsumerState<AdminAnalyticsScreen> {
  int _dateRangeIndex = 0; // 0=Today, 1=7 Days, 2=Custom

  @override
  Widget build(BuildContext context) {
    final perms = ref.watch(adminPermissionsProvider);
    final state = ref.watch(dashboardProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Analytics', style: AppTypography.headingSmall),
        actions: [
          if (perms.canViewRevenueTotals)
            IconButton(
              icon: const HugeIcon(
                icon: HugeIcons.strokeRoundedArrowUpRight01,
                color: AppColors.textSecondary,
              ),
              onPressed: () => context.go(AppRoutes.adminRevenue),
            ),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.rose,
        backgroundColor: AppColors.surface,
        onRefresh: () => _loadForRange(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.md),
              // Date range selector
              _buildDateRangeChips(),
              const SizedBox(height: AppSpacing.lg),
              // Content based on state
              _buildContent(state, perms),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateRangeChips() {
    return Row(
      children: [
        _buildChip('Today', 0),
        const SizedBox(width: AppSpacing.sm),
        _buildChip('7 Days', 1),
        const SizedBox(width: AppSpacing.sm),
        _buildChip('Custom', 2),
      ],
    );
  }

  Widget _buildChip(String label, int index) {
    final isActive = _dateRangeIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() => _dateRangeIndex = index);
        _loadForRange();
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
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildContent(AnalyticsState<AnalyticsDashboardModel> state, AdminPermissions perms) {
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
      return _buildDashboard(state.data, perms);
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
            Text(
              'Failed to load analytics',
              style: AppTypography.bodyMedium
                  .copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.md),
            OutlinedButton(
              onPressed: _loadForRange,
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

  Widget _buildDashboard(AnalyticsDashboardModel data, AdminPermissions perms) {
    final canViewRevenue = perms.canViewRevenueTotals;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // KPI grid — 2x2
        Row(
          children: [
            if (canViewRevenue)
              _buildKpiCard('Revenue', '₹${data.totalRevenue ?? '--'}',
                  HugeIcons.strokeRoundedCoin, AppColors.rose)
            else
              _buildKpiCard('Sessions', '${data.totalSessions ?? '--'}',
                  HugeIcons.strokeRoundedTimer01, AppColors.success),
            const SizedBox(width: AppSpacing.sm),
            _buildKpiCard(
              'Net Revenue',
              '₹${data.totalNetRevenue ?? '--'}',
              HugeIcons.strokeRoundedWallet01,
              const Color(0xFF4CAF50),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            _buildKpiCard(
              'Occupancy',
              '${data.occupancyRate ?? '--'}%',
              HugeIcons.strokeRoundedDashboard,
              const Color(0xFF2196F3),
            ),
            const SizedBox(width: AppSpacing.sm),
            _buildKpiCard(
              'Sessions',
              '${data.totalSessions ?? '--'}',
              HugeIcons.strokeRoundedGameboy,
              AppColors.primary,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),

        // Player insights
        Text('Players', style: AppTypography.headingSmall),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            _buildMiniStat('Unique', '${data.uniquePlayers ?? '--'}'),
            const SizedBox(width: AppSpacing.md),
            _buildMiniStat('New', '${data.newPlayers ?? '--'}'),
            const SizedBox(width: AppSpacing.md),
            _buildMiniStat(
              'Returning',
              '${(data.uniquePlayers ?? 0) - (data.newPlayers ?? 0)}',
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),

        // Quick navigation tiles
        Text('Detailed Reports', style: AppTypography.headingSmall),
        const SizedBox(height: AppSpacing.md),
        if (canViewRevenue)
          _buildNavTile('Revenue Analytics', HugeIcons.strokeRoundedCoin,
              AppRoutes.adminRevenue),
        _buildNavTile('Utilization Heatmap',
            HugeIcons.strokeRoundedDashboard, AppRoutes.adminUtilization),
        _buildNavTile('Session Statistics',
            HugeIcons.strokeRoundedTimer01, AppRoutes.adminSessionStats),
        _buildNavTile('Player Analytics', HugeIcons.strokeRoundedUserCircle,
            AppRoutes.adminPlayers),
        _buildNavTile('System Performance',
            HugeIcons.strokeRoundedGameboy, AppRoutes.adminSystems),
      ],
    );
  }

  Widget _buildKpiCard(
    String label,
    String value,
    IconData icon,
    Color iconColor,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HugeIcon(icon: icon, color: iconColor, size: 20),
              const SizedBox(height: AppSpacing.sm),
              Text(value, style: AppTypography.headingSmall),
              const SizedBox(height: AppSpacing.xs),
              Text(label, style: AppTypography.caption),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMiniStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: AppTypography.headingSmall),
        Text(label, style: AppTypography.caption),
      ],
    );
  }

  Widget _buildNavTile(String title, IconData icon, String route) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: GestureDetector(
        onTap: () => context.go(route),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
          ),
          child: Row(
            children: [
              HugeIcon(icon: icon, color: AppColors.textSecondary, size: 20),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(title, style: AppTypography.bodyMedium),
              ),
              const HugeIcon(
                icon: HugeIcons.strokeRoundedArrowUpRight01,
                color: AppColors.textSecondary,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _loadForRange() async {
    final now = DateTime.now();
    String? dateFrom;
    String? dateTo;

    switch (_dateRangeIndex) {
      case 0: // Today
        dateFrom = _formatDate(now);
        dateTo = _formatDate(now);
      case 1: // 7 Days
        dateFrom = _formatDate(now.subtract(const Duration(days: 6)));
        dateTo = _formatDate(now);
      case 2: // Custom — for now default to last 30 days
        dateFrom = _formatDate(now.subtract(const Duration(days: 30)));
        dateTo = _formatDate(now);
    }

    ref.read(dashboardProvider.notifier).load(dateFrom: dateFrom, dateTo: dateTo);
  }

  String _formatDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
