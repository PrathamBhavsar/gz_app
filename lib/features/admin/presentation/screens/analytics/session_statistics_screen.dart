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
          icon: const HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft01,
            color: AppColors.textPrimary,
            size: 20,
          ),
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
    if (state is AnalyticsLoading<SessionStatsModel>) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xxl),
          child: CircularProgressIndicator(color: AppColors.rose),
        ),
      );
    }
    if (state is AnalyticsError<SessionStatsModel>) {
      return _StatsError(onRetry: _load);
    }
    if (state is AnalyticsLoaded<SessionStatsModel>) {
      return _SessionStatsContent(data: state.data);
    }
    return const SizedBox.shrink();
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

// ─── Error View ───────────────────────────────────────────────────────────────

class _StatsError extends StatelessWidget {
  const _StatsError({required this.onRetry});
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
              'Failed to load session stats',
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

// ─── Stats Content ────────────────────────────────────────────────────────────

class _SessionStatsContent extends StatelessWidget {
  const _SessionStatsContent({required this.data});
  final SessionStatsModel data;

  @override
  Widget build(BuildContext context) {
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
        Row(
          children: [
            _MetricTile(
              label: 'Avg Duration',
              value: '$avgDuration min',
              icon: HugeIcons.strokeRoundedTimer01,
              iconColor: AppColors.info,
            ),
            const SizedBox(width: AppSpacing.sm),
            _MetricTile(
              label: 'Completion',
              value: '$completionRate%',
              icon: HugeIcons.strokeRoundedCheckmarkCircle01,
              iconColor: AppColors.ok,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            _MetricTile(
              label: 'Total Hours',
              value: '${totalHours}h',
              icon: HugeIcons.strokeRoundedClock01,
              iconColor: AppColors.rose,
            ),
            const SizedBox(width: AppSpacing.sm),
            _MetricTile(
              label: 'Cancellation',
              value: '$cancellationRate%',
              icon: HugeIcons.strokeRoundedCancel01,
              iconColor: AppColors.error,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        Text('Session Breakdown', style: AppTypography.headingSmall),
        const SizedBox(height: AppSpacing.md),
        _BreakdownCard(
          total: totalSessions,
          completed: completed,
          cancelled: cancelled,
        ),
        const SizedBox(height: AppSpacing.xl),
        Text('Source Ratio', style: AppTypography.headingSmall),
        const SizedBox(height: AppSpacing.md),
        _SourceRatio(walkIn: walkInCount, booking: bookingCount),
      ],
    );
  }
}

// ─── Metric Tile ──────────────────────────────────────────────────────────────

class _MetricTile extends StatelessWidget {
  const _MetricTile({
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
}

// ─── Breakdown Card ───────────────────────────────────────────────────────────

class _BreakdownCard extends StatelessWidget {
  const _BreakdownCard({
    required this.total,
    required this.completed,
    required this.cancelled,
  });
  final int total;
  final int completed;
  final int cancelled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
      ),
      child: Column(
        children: [
          _row('Total Sessions', '$total', AppColors.textPrimary),
          const SizedBox(height: AppSpacing.sm),
          _row('Completed', '$completed', AppColors.ok),
          const SizedBox(height: AppSpacing.sm),
          _row('Cancelled', '$cancelled', AppColors.error),
          const SizedBox(height: AppSpacing.md),
          if (total > 0)
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: completed / total,
                backgroundColor: AppColors.surface2,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.ok),
              ),
            ),
        ],
      ),
    );
  }

  Widget _row(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTypography.bodyMedium),
        Text(
          value,
          style: AppTypography.bodyMedium.copyWith(color: valueColor),
        ),
      ],
    );
  }
}

// ─── Source Ratio ─────────────────────────────────────────────────────────────

class _SourceRatio extends StatelessWidget {
  const _SourceRatio({required this.walkIn, required this.booking});
  final int walkIn;
  final int booking;

  @override
  Widget build(BuildContext context) {
    final total = walkIn + booking;
    final walkInPct =
        total > 0 ? (walkIn / total * 100).toStringAsFixed(0) : '0';
    final bookingPct =
        total > 0 ? (booking / total * 100).toStringAsFixed(0) : '0';

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
              Expanded(
                flex: booking > 0 ? booking : 1,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.info,
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
              _label('Walk-in', '$walkIn ($walkInPct%)', AppColors.rose),
              _label('Booking', '$booking ($bookingPct%)', AppColors.info),
            ],
          ),
        ],
      ),
    );
  }

  Widget _label(String text, String value, Color color) {
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
        Text('$text: $value', style: AppTypography.bodySmall),
      ],
    );
  }
}
