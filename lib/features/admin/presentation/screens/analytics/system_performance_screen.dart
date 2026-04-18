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

/// System Performance — Screen 51.
/// Per-system utilization rates, revenue, and low-usage alerts.
class SystemPerformanceScreen extends ConsumerStatefulWidget {
  const SystemPerformanceScreen({super.key});

  @override
  ConsumerState<SystemPerformanceScreen> createState() =>
      _SystemPerformanceScreenState();
}

class _SystemPerformanceScreenState
    extends ConsumerState<SystemPerformanceScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => _load());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(systemPerformanceProvider);

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
        title: Text('System Performance', style: AppTypography.headingSmall),
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

  Widget _buildContent(AnalyticsState<SystemPerformanceModel> state) {
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
      return _buildPerformance(state.data);
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
            Text('Failed to load system performance',
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

  Widget _buildPerformance(SystemPerformanceModel data) {
    final systems = data.systems ?? [];

    if (systems.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Text('No system performance data available',
              style: AppTypography.bodyMedium
                  .copyWith(color: AppColors.textSecondary)),
        ),
      );
    }

    // Calculate averages for alerts
    double totalUtil = 0;
    for (final s in systems) {
      totalUtil += double.tryParse(s.utilizationRate ?? '0') ?? 0;
    }
    final avgUtil = totalUtil / systems.length;

    // Sort by utilization rate descending
    final sorted = List<SystemPerformanceEntry>.from(systems)
      ..sort((a, b) {
        final aRate = double.tryParse(a.utilizationRate ?? '0') ?? 0;
        final bRate = double.tryParse(b.utilizationRate ?? '0') ?? 0;
        return bRate.compareTo(aRate);
      });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Low utilization alerts
        ...sorted
            .where((s) =>
                (double.tryParse(s.utilizationRate ?? '0') ?? 0) <
                avgUtil * 0.6)
            .map((s) => _buildAlertCard(s, avgUtil)),
        if (sorted.any((s) =>
            (double.tryParse(s.utilizationRate ?? '0') ?? 0) < avgUtil * 0.6))
          const SizedBox(height: AppSpacing.lg),

        // Summary header
        Text('All Systems', style: AppTypography.headingSmall),
        Text('${systems.length} systems · Avg ${(avgUtil).toStringAsFixed(0)}% utilization',
            style: AppTypography.caption),
        const SizedBox(height: AppSpacing.md),

        // System list sorted by utilization (ROI)
        ...sorted.map((s) => _buildSystemCard(s)),
      ],
    );
  }

  Widget _buildAlertCard(SystemPerformanceEntry s, double avgUtil) {
    final rate = double.tryParse(s.utilizationRate ?? '0') ?? 0;
    final diff = ((avgUtil - rate) / avgUtil * 100).toStringAsFixed(0);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
        border: Border.all(color: AppColors.error.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const HugeIcon(
            icon: HugeIcons.strokeRoundedAlert02,
            color: AppColors.error,
            size: 20,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${s.name ?? 'Unknown'} utilization is ${diff}% lower than average',
                  style: AppTypography.bodySmall,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Current: ${rate.toStringAsFixed(0)}% · Avg: ${avgUtil.toStringAsFixed(0)}%',
                  style: AppTypography.caption,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSystemCard(SystemPerformanceEntry s) {
    final rate = double.tryParse(s.utilizationRate ?? '0') ?? 0;
    final rateColor = rate > 75
        ? const Color(0xFF4CAF50)
        : rate > 50
            ? AppColors.gold
            : rate > 25
                ? const Color(0xFFFF9800)
                : AppColors.error;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // System info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.name ?? 'Unknown',
                      style: AppTypography.bodyMedium,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '${s.platform ?? '--'} · Station ${s.stationNumber ?? '--'}',
                      style: AppTypography.caption,
                    ),
                  ],
                ),
              ),
              // Utilization badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: rateColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
                ),
                child: Text(
                  '${rate.toStringAsFixed(0)}%',
                  style: AppTypography.bodySmall.copyWith(
                    color: rateColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          // Utilization bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (rate / 100).clamp(0.0, 1.0),
              backgroundColor: AppColors.surface2,
              valueColor: AlwaysStoppedAnimation<Color>(rateColor),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          // Stats row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMiniStat('Sessions', '${s.totalSessions ?? 0}'),
              _buildMiniStat('Hours', '${((s.totalMinutes ?? 0) / 60).toStringAsFixed(1)}'),
              _buildMiniStat('Revenue', '₹${s.totalRevenue ?? '0'}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: AppTypography.bodySmall),
        Text(label, style: AppTypography.caption),
      ],
    );
  }

  Future<void> _load() async {
    final now = DateTime.now();
    ref.read(systemPerformanceProvider.notifier).load(
          dateFrom: _formatDate(now.subtract(const Duration(days: 7))),
          dateTo: _formatDate(now),
        );
  }

  String _formatDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
