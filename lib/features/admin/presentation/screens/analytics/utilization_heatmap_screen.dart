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

final _utilizationViewModeProvider = StateProvider.autoDispose<int>((ref) => 0);

/// Utilization Heatmap — Screen 48.
/// Hourly grid showing occupancy density with peak hour indicator.
class UtilizationHeatmapScreen extends ConsumerStatefulWidget {
  const UtilizationHeatmapScreen({super.key});

  @override
  ConsumerState<UtilizationHeatmapScreen> createState() =>
      _UtilizationHeatmapScreenState();
}

class _UtilizationHeatmapScreenState
    extends ConsumerState<UtilizationHeatmapScreen> {
  @override
  Widget build(BuildContext context) {
    final viewMode = ref.watch(_utilizationViewModeProvider);
    final state = ref.watch(utilizationProvider);

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
        title: Text('Utilization', style: AppTypography.headingSmall),
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
                  _ViewModeChip(
                    label: 'Day',
                    index: 0,
                    activeIndex: viewMode,
                    onTap: () => _selectMode(0),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  _ViewModeChip(
                    label: 'Week',
                    index: 1,
                    activeIndex: viewMode,
                    onTap: () => _selectMode(1),
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

  void _selectMode(int index) {
    ref.read(_utilizationViewModeProvider.notifier).state = index;
    _load(index);
  }

  Widget _buildContent(AnalyticsState<UtilizationModel> state) {
    if (state is AnalyticsLoading<UtilizationModel>) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xxl),
          child: CircularProgressIndicator(color: AppColors.rose),
        ),
      );
    }
    if (state is AnalyticsError<UtilizationModel>) {
      return _UtilizationError(onRetry: _load);
    }
    if (state is AnalyticsLoaded<UtilizationModel>) {
      return _UtilizationHeatmap(data: state.data);
    }
    return const SizedBox.shrink();
  }

  Future<void> _load([int? overrideMode]) async {
    final now = DateTime.now();
    final viewMode = overrideMode ?? ref.read(_utilizationViewModeProvider);
    final String dateFrom;
    final String dateTo;

    if (viewMode == 0) {
      dateFrom = _formatDate(now);
      dateTo = _formatDate(now);
    } else {
      dateFrom = _formatDate(now.subtract(const Duration(days: 6)));
      dateTo = _formatDate(now);
    }

    ref.read(utilizationProvider.notifier).load(
          dateFrom: dateFrom,
          dateTo: dateTo,
        );
  }

  String _formatDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}

// ─── View Mode Chip ───────────────────────────────────────────────────────────

class _ViewModeChip extends StatelessWidget {
  const _ViewModeChip({
    required this.label,
    required this.index,
    required this.activeIndex,
    required this.onTap,
  });
  final String label;
  final int index;
  final int activeIndex;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isActive = activeIndex == index;
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

class _UtilizationError extends StatelessWidget {
  const _UtilizationError({required this.onRetry});
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
              'Failed to load utilization data',
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

// ─── Heatmap Content ──────────────────────────────────────────────────────────

class _UtilizationHeatmap extends StatelessWidget {
  const _UtilizationHeatmap({required this.data});
  final UtilizationModel data;

  @override
  Widget build(BuildContext context) {
    final hours = data.data ?? [];

    if (hours.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Text(
            'No utilization data available',
            style: AppTypography.bodyMedium
                .copyWith(color: AppColors.textSecondary),
          ),
        ),
      );
    }

    UtilizationHourModel? peak;
    for (final h in hours) {
      if (peak == null ||
          (h.activeSessionsPeak ?? 0) > (peak.activeSessionsPeak ?? 0)) {
        peak = h;
      }
    }

    int maxPeak = 1;
    for (final h in hours) {
      if ((h.activeSessionsPeak ?? 0) > maxPeak) {
        maxPeak = h.activeSessionsPeak!;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (peak != null && peak.hourOfDay != null)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
              border: Border.all(
                color: AppColors.rose.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                const HugeIcon(
                  icon: HugeIcons.strokeRoundedFire,
                  color: AppColors.rose,
                  size: 20,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    'Peak hour: ${_formatHour(peak.hourOfDay!)} — ${peak.activeSessionsPeak ?? 0} active sessions',
                    style: AppTypography.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: AppSpacing.lg),
        Text('Hourly Breakdown', style: AppTypography.headingSmall),
        const SizedBox(height: AppSpacing.md),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Row(
            children: [
              Expanded(
                  flex: 2, child: Text('Hour', style: AppTypography.caption)),
              Expanded(
                  flex: 2,
                  child: Text('Active',
                      style: AppTypography.caption,
                      textAlign: TextAlign.center)),
              Expanded(
                  flex: 2,
                  child: Text('Started',
                      style: AppTypography.caption,
                      textAlign: TextAlign.center)),
              Expanded(
                  flex: 2,
                  child: Text('Usage',
                      style: AppTypography.caption,
                      textAlign: TextAlign.right)),
            ],
          ),
        ),
        const Divider(color: AppColors.border, height: 1),
        ...hours.map((h) => _HourRow(h: h, maxPeak: maxPeak)),
      ],
    );
  }

  static String _formatHour(int hour) {
    if (hour == 0) return '12 AM';
    if (hour < 12) return '$hour AM';
    if (hour == 12) return '12 PM';
    return '${hour - 12} PM';
  }
}

// ─── Hour Row ─────────────────────────────────────────────────────────────────

class _HourRow extends StatelessWidget {
  const _HourRow({required this.h, required this.maxPeak});
  final UtilizationHourModel h;
  final int maxPeak;

  @override
  Widget build(BuildContext context) {
    final utilizationPct =
        maxPeak > 0 ? (h.activeSessionsPeak ?? 0) / maxPeak : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              _formatHour(h.hourOfDay ?? 0),
              style: AppTypography.bodySmall,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '${h.activeSessionsPeak ?? 0}',
              style: AppTypography.bodySmall,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '${h.sessionsStarted ?? 0}',
              style: AppTypography.bodySmall,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 48,
                  height: 6,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: utilizationPct.clamp(0.0, 1.0),
                      backgroundColor: AppColors.surface2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _heatColor(utilizationPct),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _formatHour(int hour) {
    if (hour == 0) return '12 AM';
    if (hour < 12) return '$hour AM';
    if (hour == 12) return '12 PM';
    return '${hour - 12} PM';
  }

  static Color _heatColor(double pct) {
    if (pct > 0.75) return AppColors.rose;
    if (pct > 0.5) return AppColors.gold;
    if (pct > 0.25) return AppColors.ok;
    return AppColors.textSecondary;
  }
}
