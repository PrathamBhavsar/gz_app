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
import '../../../../../shared/widgets/gz_tag.dart';
import '../../../../../shared/widgets/page_error_display.dart';
import '../../../../admin/application/admin_analytics_notifier.dart';

class SystemPerformanceScreen extends ConsumerWidget {
  const SystemPerformanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const GzAdminTopBar(title: 'System Performance'),
      body: SafeArea(
        top: false,
        child: ref
            .watch(adminSystemPerformanceNotifierProvider)
            .when(
              loading: () =>
                  const GzLoadingView(message: 'Loading system data'),
              error: (e, _) => PageErrorDisplay(
                error: AppPageError.from(e),
                onRetry: () => ref
                    .read(adminSystemPerformanceNotifierProvider.notifier)
                    .refresh(),
              ),
              data: (perf) {
                final systems = perf.systems ?? const [];
                if (systems.isEmpty) {
                  return const PageErrorDisplay(error: AppPageError.empty);
                }
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  itemBuilder: (context, index) =>
                      _SystemCard(system: systems[index]),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                  itemCount: systems.length,
                );
              },
            ),
      ),
    );
  }
}

class _SystemCard extends StatelessWidget {
  const _SystemCard({required this.system});

  final SystemPerformanceEntry system;

  bool get _lowUsage {
    final rate = double.tryParse(system.utilizationRate ?? '');
    return rate != null && rate < 40;
  }

  double get _utilizationValue {
    final rate = double.tryParse(system.utilizationRate ?? '');
    return (rate ?? 0.0).clamp(0.0, 100.0) / 100;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.pillBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: const HugeIcon(
                  icon: HugeIcons.strokeRoundedComputer,
                  color: AppColors.textTertiary,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      system.name ?? 'System ${system.stationNumber ?? ''}',
                      style: AppTypography.h3,
                    ),
                    const SizedBox(height: 2),
                    Text(system.platform ?? '—', style: AppTypography.small),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _fmtAmt(system.totalRevenue),
                    style: AppTypography.body.copyWith(
                      fontFamily: 'GeistMono',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text('revenue', style: AppTypography.small),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Utilization: ${system.utilizationRate ?? 0}%',
            style: AppTypography.small,
          ),
          const SizedBox(height: 4),
          GzProgressBar(
            value: _utilizationValue,
            height: 6,
            fillColor: AppColors.surfaceTintStrong,
          ),
          if (_lowUsage) ...[
            const SizedBox(height: 8),
            const GzTag(
              kind: GzTagKind.warn,
              label: 'Low usage - consider promotion',
            ),
          ],
        ],
      ),
    );
  }
}

String _fmtAmt(String? s) {
  if (s == null) return '—';
  final v = double.tryParse(s);
  if (v == null) return s;
  return '₹${v.toStringAsFixed(0)}';
}
