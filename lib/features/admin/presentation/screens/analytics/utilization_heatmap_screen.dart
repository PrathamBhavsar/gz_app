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
  int _viewMode = 0; // 0=Day, 1=Week

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _load());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(utilizationProvider);

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
              _buildViewModeChips(),
              const SizedBox(height: AppSpacing.lg),
              _buildContent(state),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildViewModeChips() {
    return Row(
      children: [
        _buildChip('Day', 0),
        const SizedBox(width: AppSpacing.sm),
        _buildChip('Week', 1),
      ],
    );
  }

  Widget _buildChip(String label, int index) {
    final isActive = _viewMode == index;
    return GestureDetector(
      onTap: () {
        setState(() => _viewMode = index);
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

  Widget _buildContent(AnalyticsState<UtilizationModel> state) {
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
      return _buildHeatmap(state.data);
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
            Text('Failed to load utilization data',
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

  Widget _buildHeatmap(UtilizationModel data) {
    final hours = data.data ?? [];

    if (hours.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Text('No utilization data available',
              style: AppTypography.bodyMedium
                  .copyWith(color: AppColors.textSecondary)),
        ),
      );
    }

    // Find peak hour
    UtilizationHourModel? peak;
    for (final h in hours) {
      if (peak == null || (h.activeSessionsPeak ?? 0) > (peak.activeSessionsPeak ?? 0)) {
        peak = h;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Peak hour indicator
        if (peak != null && peak.hourOfDay != null)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
              border: Border.all(color: AppColors.rose.withOpacity(0.3)),
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

        // Hourly grid
        Text('Hourly Breakdown', style: AppTypography.headingSmall),
        const SizedBox(height: AppSpacing.md),
        // Table header
        _buildGridHeader(),
        const Divider(color: AppColors.border, height: 1),
        ...hours.map((h) => _buildHourRow(h)),
      ],
    );
  }

  Widget _buildGridHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          const Expanded(flex: 2, child: Text('Hour', style: AppTypography.caption)),
          const Expanded(flex: 2, child: Text('Active', style: AppTypography.caption, textAlign: TextAlign.center)),
          const Expanded(flex: 2, child: Text('Started', style: AppTypography.caption, textAlign: TextAlign.center)),
          const Expanded(flex: 2, child: Text('Usage', style: AppTypography.caption, textAlign: TextAlign.right)),
        ],
      ),
    );
  }

  Widget _buildHourRow(UtilizationHourModel h) {
    final peakSessions = _maxPeakFromData();
    final utilizationPct = peakSessions > 0
        ? (h.activeSessionsPeak ?? 0) / peakSessions
        : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          // Hour label
          Expanded(
            flex: 2,
            child: Text(
              _formatHour(h.hourOfDay ?? 0),
              style: AppTypography.bodySmall,
            ),
          ),
          // Active sessions peak
          Expanded(
            flex: 2,
            child: Text(
              '${h.activeSessionsPeak ?? 0}',
              style: AppTypography.bodySmall,
              textAlign: TextAlign.center,
            ),
          ),
          // Sessions started
          Expanded(
            flex: 2,
            child: Text(
              '${h.sessionsStarted ?? 0}',
              style: AppTypography.bodySmall,
              textAlign: TextAlign.center,
            ),
          ),
          // Usage bar
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

  int _maxPeakFromData() {
    final state = ref.read(utilizationProvider);
    if (state is AnalyticsLoaded) {
      final hours = state.data.data ?? [];
      int max = 0;
      for (final h in hours) {
        if ((h.activeSessionsPeak ?? 0) > max) {
          max = h.activeSessionsPeak!;
        }
      }
      return max;
    }
    return 1;
  }

  Color _heatColor(double pct) {
    if (pct > 0.75) return AppColors.rose;
    if (pct > 0.5) return AppColors.gold;
    if (pct > 0.25) return const Color(0xFF4CAF50);
    return AppColors.textSecondary;
  }

  String _formatHour(int hour) {
    if (hour == 0) return '12 AM';
    if (hour < 12) return '$hour AM';
    if (hour == 12) return '12 PM';
    return '${hour - 12} PM';
  }

  Future<void> _load() async {
    final now = DateTime.now();
    String dateFrom;
    String dateTo;

    if (_viewMode == 0) {
      // Day view — today
      dateFrom = _formatDate(now);
      dateTo = _formatDate(now);
    } else {
      // Week view — last 7 days
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
