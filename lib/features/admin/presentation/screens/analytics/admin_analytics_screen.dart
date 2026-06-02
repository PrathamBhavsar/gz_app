import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../core/navigation/routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../shared/widgets/gz_admin_top_bar.dart';

class AdminAnalyticsScreen extends StatefulWidget {
  const AdminAnalyticsScreen({super.key});

  @override
  State<AdminAnalyticsScreen> createState() => _AdminAnalyticsScreenState();
}

class _AdminAnalyticsScreenState extends State<AdminAnalyticsScreen> {
  static const _filters = ['Today', '7 Days', 'Custom'];
  static const _kpis = [
    _KpiData(
      label: 'Revenue',
      value: '₹18,420',
      icon: HugeIcons.strokeRoundedCoinsDollar,
      accent: AppColors.ok,
    ),
    _KpiData(
      label: 'Sessions',
      value: '142',
      icon: HugeIcons.strokeRoundedClock01,
      accent: AppColors.info,
    ),
    _KpiData(
      label: 'Avg. Duration',
      value: '87m',
      icon: HugeIcons.strokeRoundedCalendar03,
      accent: AppColors.textTertiary,
    ),
    _KpiData(
      label: 'Walk-ins',
      value: '34',
      icon: HugeIcons.strokeRoundedGameboy,
      accent: AppColors.rose,
    ),
  ];
  static const _quickLinks = [
    _QuickLinkData(
      label: 'Revenue',
      route: AppRoutes.adminRevenue,
      icon: HugeIcons.strokeRoundedCoinsDollar,
    ),
    _QuickLinkData(
      label: 'Utilization',
      route: AppRoutes.adminUtilization,
      icon: HugeIcons.strokeRoundedCalendar03,
    ),
    _QuickLinkData(
      label: 'Sessions',
      route: AppRoutes.adminSessionStats,
      icon: HugeIcons.strokeRoundedClock01,
    ),
    _QuickLinkData(
      label: 'Players',
      route: AppRoutes.adminPlayers,
      icon: HugeIcons.strokeRoundedUserGroup,
    ),
    _QuickLinkData(
      label: 'Systems',
      route: AppRoutes.adminSystems,
      icon: HugeIcons.strokeRoundedComputer,
    ),
  ];
  static const _barHeights = [0.40, 0.55, 0.35, 0.60, 0.70, 0.50, 0.80];
  static const _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  int _activeFilter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const GzAdminTopBar(title: 'Analytics', disableBack: true),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: List.generate(
                  _filters.length,
                  (index) => Padding(
                    padding: EdgeInsets.only(
                      right: index == _filters.length - 1 ? 0 : 8,
                    ),
                    child: _RoseChip(
                      label: _filters[index],
                      active: _activeFilter == index,
                      onTap: () => setState(() => _activeFilter = index),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.25,
                ),
                itemCount: _kpis.length,
                itemBuilder: (context, index) => _AnalyticsKpiCard(data: _kpis[index]),
              ),
              const SizedBox(height: 14),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _quickLinks
                      .map(
                        (link) => Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: _QuickNavCard(data: link),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 14),
              _SurfaceCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Today's revenue", style: AppTypography.h3),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 100,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: List.generate(_barHeights.length, (index) {
                          final isLast = index == _barHeights.length - 1;
                          return Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: index == _barHeights.length - 1 ? 0 : 8,
                              ),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: FractionallySizedBox(
                                  heightFactor: _barHeights[index],
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
                      children: List.generate(
                        _days.length,
                        (index) => Expanded(
                          child: Text(
                            _days[index],
                            textAlign: TextAlign.center,
                            style: AppTypography.small.copyWith(fontSize: 10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Text(
                          'Total: ₹18,420',
                          style: AppTypography.body.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'vs ₹15,200 yesterday ↑',
                          style: AppTypography.small.copyWith(
                            color: AppColors.ok,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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

class _AnalyticsKpiCard extends StatelessWidget {
  const _AnalyticsKpiCard({required this.data});

  final _KpiData data;

  @override
  Widget build(BuildContext context) {
    return _SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HugeIcon(icon: data.icon, color: data.accent, size: 18),
          const Spacer(),
          Text(data.value, style: AppTypography.h1.copyWith(fontFamily: 'GeistMono')),
          const SizedBox(height: 4),
          Text(
            data.label,
            style: AppTypography.small.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _QuickNavCard extends StatelessWidget {
  const _QuickNavCard({required this.data});

  final _QuickLinkData data;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go(data.route),
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
            HugeIcon(
              icon: data.icon,
              color: AppColors.textTertiary,
              size: 18,
            ),
            const SizedBox(height: 6),
            Text(
              data.label,
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

class _KpiData {
  const _KpiData({
    required this.label,
    required this.value,
    required this.icon,
    required this.accent,
  });

  final String label;
  final String value;
  final List<List<dynamic>> icon;
  final Color accent;
}

class _QuickLinkData {
  const _QuickLinkData({
    required this.label,
    required this.route,
    required this.icon,
  });

  final String label;
  final String route;
  final List<List<dynamic>> icon;
}
