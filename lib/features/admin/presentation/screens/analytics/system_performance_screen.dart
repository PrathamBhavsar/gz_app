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
          icon: const HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft01,
            color: AppColors.textPrimary,
            size: 20,
          ),
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
    if (state is AnalyticsLoading<SystemPerformanceModel>) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xxl),
          child: CircularProgressIndicator(color: AppColors.rose),
        ),
      );
    }
    if (state is AnalyticsError<SystemPerformanceModel>) {
      return _PerfError(onRetry: _load);
    }
    if (state is AnalyticsLoaded<SystemPerformanceModel>) {
      return _PerformanceContent(data: state.data);
    }
    return const SizedBox.shrink();
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

// ─── Error View ───────────────────────────────────────────────────────────────

class _PerfError extends StatelessWidget {
  const _PerfError({required this.onRetry});
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
              'Failed to load system performance',
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

// ─── Performance Content ──────────────────────────────────────────────────────

class _PerformanceContent extends StatelessWidget {
  const _PerformanceContent({required this.data});
  final SystemPerformanceModel data;

  @override
  Widget build(BuildContext context) {
    final systems = data.systems ?? [];

    if (systems.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Text(
            'No system performance data available',
            style: AppTypography.bodyMedium
                .copyWith(color: AppColors.textSecondary),
          ),
        ),
      );
    }

    double totalUtil = 0;
    for (final s in systems) {
      totalUtil += double.tryParse(s.utilizationRate ?? '0') ?? 0;
    }
    final avgUtil = totalUtil / systems.length;

    final sorted = List<SystemPerformanceEntry>.from(systems)
      ..sort((a, b) {
        final aRate = double.tryParse(a.utilizationRate ?? '0') ?? 0;
        final bRate = double.tryParse(b.utilizationRate ?? '0') ?? 0;
        return bRate.compareTo(aRate);
      });

    final lowPerformers = sorted
        .where((s) =>
            (double.tryParse(s.utilizationRate ?? '0') ?? 0) < avgUtil * 0.6)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...lowPerformers.map((s) => _AlertCard(entry: s, avgUtil: avgUtil)),
        if (lowPerformers.isNotEmpty) const SizedBox(height: AppSpacing.lg),
        Text('All Systems', style: AppTypography.headingSmall),
        Text(
          '${systems.length} systems · Avg ${avgUtil.toStringAsFixed(0)}% utilization',
          style: AppTypography.caption,
        ),
        const SizedBox(height: AppSpacing.md),
        ...sorted.map((s) => _SystemCard(entry: s)),
      ],
    );
  }
}

// ─── Alert Card ───────────────────────────────────────────────────────────────

class _AlertCard extends StatelessWidget {
  const _AlertCard({required this.entry, required this.avgUtil});
  final SystemPerformanceEntry entry;
  final double avgUtil;

  @override
  Widget build(BuildContext context) {
    final rate = double.tryParse(entry.utilizationRate ?? '0') ?? 0;
    final diff = ((avgUtil - rate) / avgUtil * 100).toStringAsFixed(0);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
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
                  '${entry.name ?? 'Unknown'} utilization is $diff% lower than average',
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
}

// ─── System Card ──────────────────────────────────────────────────────────────

class _SystemCard extends StatelessWidget {
  const _SystemCard({required this.entry});
  final SystemPerformanceEntry entry;

  @override
  Widget build(BuildContext context) {
    final rate = double.tryParse(entry.utilizationRate ?? '0') ?? 0;
    final rateColor = rate > 75
        ? AppColors.ok
        : rate > 50
            ? AppColors.gold
            : rate > 25
                ? AppColors.warn
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(entry.name ?? 'Unknown', style: AppTypography.bodyMedium),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '${entry.platform ?? '--'} · Station ${entry.stationNumber ?? '--'}',
                      style: AppTypography.caption,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: rateColor.withValues(alpha: 0.15),
                  borderRadius:
                      BorderRadius.circular(AppSpacing.borderRadiusSm),
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
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (rate / 100).clamp(0.0, 1.0),
              backgroundColor: AppColors.surface2,
              valueColor: AlwaysStoppedAnimation<Color>(rateColor),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _stat('Sessions', '${entry.totalSessions ?? 0}'),
              _stat(
                  'Hours',
                  ((entry.totalMinutes ?? 0) / 60).toStringAsFixed(1)),
              _stat('Revenue', '₹${entry.totalRevenue ?? '0'}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _stat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: AppTypography.bodySmall),
        Text(label, style: AppTypography.caption),
      ],
    );
  }
}
