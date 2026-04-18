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

/// Session Statistics — Screen 49.
/// Average duration, completion rate, walk-in vs booking ratio.
class SessionStatisticsScreen extends ConsumerStatefulWidget {
  const SessionStatisticsScreen({super.key});

  @override
  ConsumerState<SessionStatisticsScreen> createState() =>
      _SessionStatisticsScreenState();
}

class _SessionStatisticsScreenState
    extends ConsumerState<SessionStatisticsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => _load());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sessionStatsProvider);

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
        title: Text('Session Stats', style: AppTypography.headingSmall),
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
              _buildContent(state),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(AnalyticsState<SessionStatsModel> state) {
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
      return _buildStats(state.data);
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
            Text('Failed to load session stats',
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

  Widget _buildStats(SessionStatsModel data) {
    final totalSessions = data.totalSessions ?? 0;
    final completed = data.completed ?? 0;
    final cancelled = data.cancelled ?? 0;
    final avgDuration = data.avgDurationMinutes ?? '0';
    final totalMinutes = data.totalMinutes ?? 0;
    final walkInCount = data.walkInCount ?? 0;
    final bookingCount = data.bookingCount ?? 0;

    final completionRate = totalSessions > 0
        ? ((completed / totalSessions) * 100).toStringAsFixed(1)
        : '0.0';
    final cancellationRate = totalSessions > 0
        ? ((cancelled / totalSessions) * 100).toStringAsFixed(1)
        : '0.0';
    final totalHours = (totalMinutes / 60).toStringAsFixed(1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Summary metric tiles — 2x2
        Row(
          children: [
            _buildMetricTile(
              'Avg Duration',
              '$avgDuration min',
              HugeIcons.strokeRoundedTimer01,
              const Color(0xFF2196F3),
            ),
            const SizedBox(width: AppSpacing.sm),
            _buildMetricTile(
              'Completion',
              '$completionRate%',
              HugeIcons.strokeRoundedCheckmarkCircle01,
              const Color(0xFF4CAF50),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            _buildMetricTile(
              'Total Hours',
              '${totalHours}h',
              HugeIcons.strokeRoundedClock01,
              AppColors.rose,
            ),
            const SizedBox(width: AppSpacing.sm),
            _buildMetricTile(
              'Cancellation',
              '$cancellationRate%',
              HugeIcons.strokeRoundedCancel01,
              AppColors.error,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),

        // Session breakdown
        Text('Session Breakdown', style: AppTypography.headingSmall),
        const SizedBox(height: AppSpacing.md),
        _buildBreakdownCard(
          total: totalSessions,
          completed: completed,
          cancelled: cancelled,
        ),
        const SizedBox(height: AppSpacing.xl),

        // Source ratio
        Text('Source Ratio', style: AppTypography.headingSmall),
        const SizedBox(height: AppSpacing.md),
        _buildSourceRatio(walkInCount, bookingCount),
      ],
    );
  }

  Widget _buildMetricTile(
    String label,
    String value,
    IconData icon,
    Color iconColor,
  ) {
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
            HugeIcon(icon: icon, color: iconColor, size: 20),
            const SizedBox(height: AppSpacing.sm),
            Text(value, style: AppTypography.headingSmall),
            const SizedBox(height: AppSpacing.xs),
            Text(label, style: AppTypography.caption),
          ],
        ),
      ),
    );
  }

  Widget _buildBreakdownCard({
    required int total,
    required int completed,
    required int cancelled,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
      ),
      child: Column(
        children: [
          _buildBreakdownRow('Total Sessions', '$total', AppColors.textPrimary),
          const SizedBox(height: AppSpacing.sm),
          _buildBreakdownRow('Completed', '$completed', const Color(0xFF4CAF50)),
          const SizedBox(height: AppSpacing.sm),
          _buildBreakdownRow('Cancelled', '$cancelled', AppColors.error),
          const SizedBox(height: AppSpacing.md),
          // Progress bar for completion rate
          if (total > 0)
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: completed / total,
                backgroundColor: AppColors.surface2,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBreakdownRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTypography.bodyMedium),
        Text(value,
            style: AppTypography.bodyMedium.copyWith(color: valueColor)),
      ],
    );
  }

  Widget _buildSourceRatio(int walkIn, int booking) {
    final total = walkIn + booking;
    final walkInPct = total > 0 ? (walkIn / total * 100).toStringAsFixed(0) : '0';
    final bookingPct = total > 0 ? (booking / total * 100).toStringAsFixed(0) : '0';

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Walk-in bar
              Expanded(
                flex: walkIn > 0 ? walkIn : 1,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.rose,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              // Booking bar
              Expanded(
                flex: booking > 0 ? booking : 1,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2196F3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSourceLabel('Walk-in', '$walkIn ($walkInPct%)', AppColors.rose),
              _buildSourceLabel('Booking', '$booking ($bookingPct%)', const Color(0xFF2196F3)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSourceLabel(String label, String value, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Text('$label: $value', style: AppTypography.bodySmall),
      ],
    );
  }

  Future<void> _load() async {
    final now = DateTime.now();
    ref.read(sessionStatsProvider.notifier).load(
          dateFrom: _formatDate(now.subtract(const Duration(days: 7))),
          dateTo: _formatDate(now),
        );
  }

  String _formatDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
