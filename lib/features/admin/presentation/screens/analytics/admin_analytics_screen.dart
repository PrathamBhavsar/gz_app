import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../core/errors/app_exception.dart';
import '../../../../../core/navigation/routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../shared/widgets/gz_admin_top_bar.dart';
import '../../../../../shared/widgets/gz_loading_view.dart';
import '../../../../../shared/widgets/page_error_display.dart';
import '../../../../admin/application/admin_analytics_notifier.dart';
import '../../../../admin/application/admin_management_models.dart';

class AdminAnalyticsScreen extends ConsumerWidget {
  const AdminAnalyticsScreen({super.key});

  static const _filters = ['Today', '7 Days'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const GzAdminTopBar(title: 'Analytics', disableBack: true),
      body: SafeArea(
        top: false,
        child: ref
            .watch(adminAnalyticsDashboardNotifierProvider)
            .when(
              loading: () => const GzLoadingView(message: 'Loading analytics'),
              error: (e, _) => PageErrorDisplay(
                error: AppPageError.from(e),
                onRetry: () => ref
                    .read(adminAnalyticsDashboardNotifierProvider.notifier)
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

  final AdminAnalyticsDashboardData data;
  final List<String> filters;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bars = data.barHeights;
    final rows = data.revenueRows;
    final d = data.dashboard;

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
                  active: data.selectedPeriod == f,
                  onTap: () => ref
                      .read(adminAnalyticsDashboardNotifierProvider.notifier)
                      .selectFilter(f),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.25,
            children: [
              _KpiCard(
                label: 'Revenue',
                value: _fmtAmt(d.totalRevenue),
                icon: HugeIcons.strokeRoundedCoinsDollar,
                accent: AppColors.ok,
              ),
              _KpiCard(
                label: 'Sessions',
                value: '${d.totalSessions ?? 0}',
                icon: HugeIcons.strokeRoundedClock01,
                accent: AppColors.info,
              ),
              _KpiCard(
                label: 'Avg. Duration',
                value: '${d.avgSessionDurationMinutes ?? 0}m',
                icon: HugeIcons.strokeRoundedCalendar03,
                accent: AppColors.textTertiary,
              ),
              _KpiCard(
                label: 'Occupancy',
                value: d.occupancyRate != null
                    ? '${double.tryParse(d.occupancyRate!)?.toStringAsFixed(0) ?? d.occupancyRate}%'
                    : '—',
                icon: HugeIcons.strokeRoundedGameboy,
                accent: AppColors.rose,
              ),
            ],
          ),
          const SizedBox(height: 14),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _QuickNavCard(
                  label: 'Revenue',
                  route: AppRoutes.adminRevenue,
                  icon: HugeIcons.strokeRoundedCoinsDollar,
                ),
                const SizedBox(width: 10),
                _QuickNavCard(
                  label: 'Utilization',
                  route: AppRoutes.adminUtilization,
                  icon: HugeIcons.strokeRoundedCalendar03,
                ),
                const SizedBox(width: 10),
                _QuickNavCard(
                  label: 'Sessions',
                  route: AppRoutes.adminSessionStats,
                  icon: HugeIcons.strokeRoundedClock01,
                ),
                const SizedBox(width: 10),
                _QuickNavCard(
                  label: 'Players',
                  route: AppRoutes.adminPlayers,
                  icon: HugeIcons.strokeRoundedUserGroup,
                ),
                const SizedBox(width: 10),
                _QuickNavCard(
                  label: 'Systems',
                  route: AppRoutes.adminSystems,
                  icon: HugeIcons.strokeRoundedComputer,
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          if (bars.isNotEmpty)
            _SurfaceCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Revenue trend', style: AppTypography.h3),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 100,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: List.generate(bars.length, (i) {
                        final isLast = i == bars.length - 1;
                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(right: isLast ? 0 : 6),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: FractionallySizedBox(
                                heightFactor: bars[i],
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isLast
                                        ? AppColors.buttonBg
                                        : AppColors.surfaceTint,
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(4),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: rows.map((r) {
                      return Expanded(
                        child: Text(
                          _dayLabel(r.date),
                          textAlign: TextAlign.center,
                          style: AppTypography.small.copyWith(fontSize: 10),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Total: ${data.totalRevenue}',
                    style: AppTypography.body.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
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
    return _SurfaceCard(
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
            style: AppTypography.small.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickNavCard extends StatelessWidget {
  const _QuickNavCard({
    required this.label,
    required this.route,
    required this.icon,
  });

  final String label;
  final String route;
  final List<List<dynamic>> icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(route),
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HugeIcon(icon: icon, color: AppColors.textTertiary, size: 18),
            const SizedBox(height: 6),
            Text(
              label,
              style: AppTypography.small.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SurfaceCard extends StatelessWidget {
  const _SurfaceCard({required this.child});

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

String _fmtAmt(String? s) {
  if (s == null) return '—';
  final v = double.tryParse(s);
  if (v == null) return s;
  return '₹${v.toStringAsFixed(0)}';
}

String _dayLabel(String? isoDate) {
  if (isoDate == null) return '';
  try {
    final d = DateTime.parse(isoDate);
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[d.weekday - 1];
  } catch (_) {
    return isoDate.length > 5 ? isoDate.substring(5) : isoDate;
  }
}
