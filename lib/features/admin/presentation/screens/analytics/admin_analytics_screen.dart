import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/theme/app_spacing.dart';

/// Analytics Dashboard — Screen 46.
/// Placeholder screen. Full implementation in Phase 5.
class AdminAnalyticsScreen extends StatelessWidget {
  const AdminAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Analytics', style: AppTypography.headingSmall),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.md),
            // Date range chips placeholder
            Row(
              children: [
                _buildChip('Today', true),
                const SizedBox(width: AppSpacing.sm),
                _buildChip('7 Days', false),
                const SizedBox(width: AppSpacing.sm),
                _buildChip('Custom', false),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            // KPI cards
            Row(
              children: [
                _buildKpiCard('Revenue', '--'),
                const SizedBox(width: AppSpacing.sm),
                _buildKpiCard('Sessions', '--'),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                _buildKpiCard('Occupancy', '--'),
                const SizedBox(width: AppSpacing.sm),
                _buildKpiCard('Players', '--'),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            Text('Revenue Trend', style: AppTypography.headingSmall),
            const SizedBox(height: AppSpacing.md),
            // Chart placeholder
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.show_chart,
                      color: AppColors.textSecondary,
                      size: 64,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Charts will appear here',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
      ),
      child: Text(
        label,
        style: AppTypography.bodySmall.copyWith(
          color: isActive ? AppColors.background : AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildKpiCard(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: AppTypography.headingSmall),
            Text(label, style: AppTypography.caption),
          ],
        ),
      ),
    );
  }
}
