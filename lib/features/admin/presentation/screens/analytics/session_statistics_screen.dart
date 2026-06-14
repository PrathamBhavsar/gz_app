import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../core/errors/app_exception.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../models/domain_analytics.dart';
import '../../../../../shared/widgets/gz_admin_top_bar.dart';
import '../../../../../shared/widgets/gz_loading_view.dart';
import '../../../../../shared/widgets/gz_progress_bar.dart';
import '../../../../../shared/widgets/page_error_display.dart';
import '../../../../admin/application/admin_analytics_notifier.dart';

class SessionStatisticsScreen extends ConsumerWidget {
  const SessionStatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const GzAdminTopBar(title: 'Session Stats'),
      body: SafeArea(
        top: false,
        child: ref
            .watch(adminSessionStatsNotifierProvider)
            .when(
              loading: () =>
                  const GzLoadingView(message: 'Loading session stats'),
              error: (e, _) => PageErrorDisplay(
                error: AppPageError.from(e),
                onRetry: () => ref
                    .read(adminSessionStatsNotifierProvider.notifier)
                    .refresh(),
              ),
              data: (stats) => _Body(stats: stats),
            ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.stats});

  final SessionStatsModel stats;

  double get _completionRate {
    final total = stats.totalSessions ?? 0;
    if (total == 0) return 0;
    return ((stats.completed ?? 0) / total).clamp(0.0, 1.0);
  }

  double get _walkInRate {
    final total = stats.totalSessions ?? 0;
    if (total == 0) return 0;
    return ((stats.walkInCount ?? 0) / total).clamp(0.0, 1.0);
  }

  double get _bookingRate {
    final total = stats.totalSessions ?? 0;
    if (total == 0) return 0;
    return ((stats.bookingCount ?? 0) / total).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.25,
            children: [
              _KpiCard(
                label: 'Avg Duration',
                value: '${stats.avgDurationMinutes ?? 0} min',
                icon: HugeIcons.strokeRoundedClock01,
                accent: AppColors.info,
              ),
              _KpiCard(
                label: 'Completion',
                value: '${(_completionRate * 100).toStringAsFixed(0)}%',
                icon: HugeIcons.strokeRoundedCheckmarkCircle01,
                accent: AppColors.ok,
              ),
              _KpiCard(
                label: 'Walk-ins',
                value: '${stats.walkInCount ?? 0}',
                icon: HugeIcons.strokeRoundedGameboy,
                accent: AppColors.rose,
              ),
              _KpiCard(
                label: 'Bookings',
                value: '${stats.bookingCount ?? 0}',
                icon: HugeIcons.strokeRoundedCalendar03,
                accent: AppColors.textTertiary,
              ),
            ],
          ),
          const SizedBox(height: 14),
          _Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Session types', style: AppTypography.h3),
                const SizedBox(height: 14),
                _TypeBreakdownRow(
                  label: 'Walk-in',
                  percent: (_walkInRate * 100).round(),
                  color: AppColors.rose,
                ),
                const SizedBox(height: 8),
                _TypeBreakdownRow(
                  label: 'Booking',
                  percent: (_bookingRate * 100).round(),
                  color: AppColors.info,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TypeBreakdownRow extends StatelessWidget {
  const _TypeBreakdownRow({
    required this.label,
    required this.percent,
    required this.color,
  });

  final String label;
  final int percent;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(label, style: AppTypography.body)),
        SizedBox(
          width: 100,
          child: GzProgressBar(
            value: percent / 100,
            height: 6,
            fillColor: color,
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 30,
          child: Text(
            '$percent%',
            textAlign: TextAlign.right,
            style: AppTypography.small.copyWith(fontFamily: 'GeistMono'),
          ),
        ),
      ],
    );
  }
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.accent,
  });

  final String label;
  final String value;
  final List<List<dynamic>> icon;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HugeIcon(icon: icon, color: accent, size: 18),
          const Spacer(),
          Text(
            value,
            style: AppTypography.h1.copyWith(fontFamily: 'GeistMono'),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTypography.small.copyWith(color: AppColors.textSecondary),
          ),
        ],
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
