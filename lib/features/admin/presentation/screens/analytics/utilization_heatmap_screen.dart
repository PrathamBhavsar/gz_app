import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/errors/app_exception.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../shared/widgets/gz_admin_top_bar.dart';
import '../../../../../shared/widgets/gz_loading_view.dart';
import '../../../../../shared/widgets/gz_meta_row.dart';
import '../../../../../shared/widgets/page_error_display.dart';
import '../../../../admin/application/admin_analytics_notifier.dart';
import '../../../../admin/application/admin_management_models.dart';

class UtilizationHeatmapScreen extends ConsumerWidget {
  const UtilizationHeatmapScreen({super.key});

  static const _filters = ['Day', 'Week'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const GzAdminTopBar(title: 'Utilization'),
      body: SafeArea(
        top: false,
        child: ref
            .watch(adminUtilizationNotifierProvider)
            .when(
              loading: () =>
                  const GzLoadingView(message: 'Loading utilization'),
              error: (e, _) => PageErrorDisplay(
                error: AppPageError.from(e),
                onRetry: () => ref
                    .read(adminUtilizationNotifierProvider.notifier)
                    .refresh(),
              ),
              data: (data) => _Body(data: data, filters: _filters),
            ),
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.data, required this.filters});

  final AdminUtilizationData data;
  final List<String> filters;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hours = data.sortedHours;
    final peak = data.peakHour;
    final avgOcc = data.avgOccupancy;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: filters.map((f) {
              final isLast = f == filters.last;
              return Padding(
                padding: EdgeInsets.only(right: isLast ? 0 : 8),
                child: _RoseChip(
                  label: f,
                  active: data.selectedFilter == f,
                  onTap: () => ref
                      .read(adminUtilizationNotifierProvider.notifier)
                      .selectFilter(f),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          _Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  peak != null
                      ? 'Peak hour: ${_hourLabel(peak.hourOfDay)}'
                      : 'Peak hour',
                  style: AppTypography.h3,
                ),
                const SizedBox(height: 4),
                Text(
                  '${(avgOcc * 100).toStringAsFixed(0)}% average occupancy',
                  style: const TextStyle(
                    fontFamily: 'Geist',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    height: 1.35,
                    color: AppColors.ok,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hourly occupancy', style: AppTypography.h3),
                const SizedBox(height: 14),
                if (hours.isEmpty)
                  Text('No data available', style: AppTypography.small)
                else ...[
                  Row(
                    children: hours
                        .map(
                          (h) => Expanded(
                            child: Text(
                              '${h.hourOfDay ?? ''}',
                              textAlign: TextAlign.center,
                              style: AppTypography.meta.copyWith(
                                fontSize: 8,
                                letterSpacing: 0,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: hours.map((h) {
                      final total = (h.totalSystems ?? 1).clamp(1, 999);
                      final intensity = (h.systemsInUse ?? 0) / total;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 2),
                          child: Container(
                            height: 18,
                            decoration: BoxDecoration(
                              color: _colorFor(intensity),
                              borderRadius: BorderRadius.circular(3),
                              border: intensity < 0.05
                                  ? Border.all(color: AppColors.rule)
                                  : null,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '0%',
                        style: AppTypography.small.copyWith(fontSize: 10),
                      ),
                      const SizedBox(width: 6),
                      ...[
                        AppColors.surface,
                        AppColors.surfaceTint,
                        AppColors.surfaceTintStrong,
                        AppColors.buttonBg,
                      ].map(
                        (color) => Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(2),
                              border: color == AppColors.surface
                                  ? Border.all(color: AppColors.rule)
                                  : null,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        '100%',
                        style: AppTypography.small.copyWith(fontSize: 10),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          _Card(
            child: Column(
              children: [
                GzMetaRow(
                  label: 'Avg occupancy',
                  value: '${(avgOcc * 100).toStringAsFixed(0)}%',
                ),
                if (peak != null)
                  GzMetaRow(
                    label: 'Peak time',
                    value: _hourLabel(peak.hourOfDay),
                  ),
                GzMetaRow(
                  label: 'Data points',
                  value: '${hours.length} hrs',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Color _colorFor(double value) {
  if (value < 0.15) return AppColors.surface;
  if (value < 0.40) return AppColors.surfaceTint;
  if (value < 0.65) return AppColors.surfaceTintStrong;
  if (value < 0.85) return const Color(0xFF7BA87B);
  return AppColors.buttonBg;
}

String _hourLabel(int? hour) {
  if (hour == null) return '—';
  final h12 = hour % 12 == 0 ? 12 : hour % 12;
  final suffix = hour < 12 ? 'AM' : 'PM';
  return '$h12 $suffix';
}

class _RoseChip extends StatelessWidget {
  const _RoseChip({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 30,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: active ? AppColors.rose : AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: active ? null : Border.all(color: AppColors.rule),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppTypography.num.copyWith(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: active ? AppColors.surface : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}
