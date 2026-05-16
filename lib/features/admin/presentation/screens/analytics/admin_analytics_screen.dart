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

final _analyticsDateRangeProvider = StateProvider.autoDispose<int>((ref) => 0);

/// Analytics Dashboard — Screen 46.
/// High-level store health overview with KPI widgets and quick navigation.
class AdminAnalyticsScreen extends ConsumerStatefulWidget {
  const AdminAnalyticsScreen({super.key});

  @override
  ConsumerState<AdminAnalyticsScreen> createState() =>
      _AdminAnalyticsScreenState();
}

class _AdminAnalyticsScreenState extends ConsumerState<AdminAnalyticsScreen> {
  @override
  Widget build(BuildContext context) {
    final dateRangeIndex = ref.watch(_analyticsDateRangeProvider);
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
              Row(
                children: [
                  _FilterChip(
                    label: 'Today',
                    isActive: dateRangeIndex == 0,
                    onTap: () => _selectRange(0),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  _FilterChip(
                    label: '7 Days',
                    isActive: dateRangeIndex == 1,
                    onTap: () => _selectRange(1),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  _FilterChip(
                    label: 'Custom',
                    isActive: dateRangeIndex == 2,
                    onTap: () => _selectRange(2),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              _buildContent(state, perms),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }

  void _selectRange(int index) {
    ref.read(_analyticsDateRangeProvider.notifier).state = index;
    _loadForRange(index);
  }

  Widget _buildContent(
    AnalyticsState<AnalyticsDashboardModel> state,
    AdminPermissions perms,
  ) {
    if (state is AnalyticsLoading<AnalyticsDashboardModel>) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xxl),
          child: CircularProgressIndicator(color: AppColors.rose),
        ),
      );
    }
    if (state is AnalyticsError<AnalyticsDashboardModel>) {
      return _AnalyticsError(
        message: 'Failed to load analytics',
        onRetry: _loadForRange,
      );
    }
    if (state is AnalyticsLoaded<AnalyticsDashboardModel>) {
      return _AnalyticsDashboard(data: state.data, perms: perms);
    }
    return const SizedBox.shrink();
  }

  Future<void> _loadForRange([int? overrideIndex]) async {
    final now = DateTime.now();
    final rangeIndex = overrideIndex ?? ref.read(_analyticsDateRangeProvider);
    String? dateFrom;
    String? dateTo;

    switch (rangeIndex) {
      case 0:
        dateFrom = _formatDate(now);
        dateTo = _formatDate(now);
      case 1:
        dateFrom = _formatDate(now.subtract(const Duration(days: 6)));
        dateTo = _formatDate(now);
      case 2:
        dateFrom = _formatDate(now.subtract(const Duration(days: 30)));
        dateTo = _formatDate(now);
    }

    ref
        .read(dashboardProvider.notifier)
        .load(dateFrom: dateFrom, dateTo: dateTo);
  }

  String _formatDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}

// ─── Filter Chip ──────────────────────────────────────────────────────────────

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isActive,
    required this.onTap,
  });
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
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
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

// ─── Analytics Error ──────────────────────────────────────────────────────────

class _AnalyticsError extends StatelessWidget {
  const _AnalyticsError({required this.message, required this.onRetry});
  final String message;
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
              message,
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

// ─── Analytics Dashboard ──────────────────────────────────────────────────────

class _AnalyticsDashboard extends StatelessWidget {
  const _AnalyticsDashboard({required this.data, required this.perms});
  final AnalyticsDashboardModel data;
  final AdminPermissions perms;

  @override
  Widget build(BuildContext context) {
    final canViewRevenue = perms.canViewRevenueTotals;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (canViewRevenue)
              _KpiCard(
                label: 'Revenue',
                value: '₹${data.totalRevenue ?? '--'}',
                icon: HugeIcons.strokeRoundedCoinsDollar,
                iconColor: AppColors.rose,
              )
            else
              _KpiCard(
                label: 'Sessions',
                value: '${data.totalSessions ?? '--'}',
                icon: HugeIcons.strokeRoundedTimer01,
                iconColor: AppColors.success,
              ),
            const SizedBox(width: AppSpacing.sm),
            _KpiCard(
              label: 'Net Revenue',
              value: '₹${data.totalNetRevenue ?? '--'}',
              icon: HugeIcons.strokeRoundedWallet01,
              iconColor: AppColors.ok,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            _KpiCard(
              label: 'Occupancy',
              value: '${data.occupancyRate ?? '--'}%',
              icon: HugeIcons.strokeRoundedDashboardSpeed01,
              iconColor: AppColors.info,
            ),
            const SizedBox(width: AppSpacing.sm),
            _KpiCard(
              label: 'Sessions',
              value: '${data.totalSessions ?? '--'}',
              icon: HugeIcons.strokeRoundedGameboy,
              iconColor: AppColors.primary,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
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
        Text('Detailed Reports', style: AppTypography.headingSmall),
        const SizedBox(height: AppSpacing.md),
        if (canViewRevenue)
          _NavTile(
            title: 'Revenue Analytics',
            icon: HugeIcons.strokeRoundedCoinsDollar,
            route: AppRoutes.adminRevenue,
          ),
        _NavTile(
          title: 'Utilization Heatmap',
          icon: HugeIcons.strokeRoundedDashboardSpeed01,
          route: AppRoutes.adminUtilization,
        ),
        _NavTile(
          title: 'Session Statistics',
          icon: HugeIcons.strokeRoundedTimer01,
          route: AppRoutes.adminSessionStats,
        ),
        _NavTile(
          title: 'Player Analytics',
          icon: HugeIcons.strokeRoundedUserCircle,
          route: AppRoutes.adminPlayers,
        ),
        _NavTile(
          title: 'System Performance',
          icon: HugeIcons.strokeRoundedGameboy,
          route: AppRoutes.adminSystems,
        ),
      ],
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
}

// ─── KPI Card ─────────────────────────────────────────────────────────────────

class _KpiCard extends StatelessWidget {
  const _KpiCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
  });
  final String label;
  final String value;
  final List<List<dynamic>> icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
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
}

// ─── Nav Tile ─────────────────────────────────────────────────────────────────

class _NavTile extends StatelessWidget {
  const _NavTile({
    required this.title,
    required this.icon,
    required this.route,
  });
  final String title;
  final List<List<dynamic>> icon;
  final String route;

  @override
  Widget build(BuildContext context) {
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
              Expanded(child: Text(title, style: AppTypography.bodyMedium)),
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
}
