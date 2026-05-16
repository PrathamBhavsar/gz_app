import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../models/api_responses.dart';
import '../../../../shared/widgets/em_card.dart';
import '../../../../shared/widgets/em_section_head.dart';
import '../../../../shared/widgets/em_tag.dart';
import '../../../../shared/widgets/em_top_bar.dart';
import '../../../../shared/widgets/page_error_display.dart';
import '../providers/billing_notifier.dart';

class BillingHistoryMobileLayout extends ConsumerWidget {
  const BillingHistoryMobileLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncBilling = ref.watch(billingNotifierProvider);

    return SafeArea(
      child: Column(
        children: [
          const EmTopBar(title: 'Billing History'),
          Expanded(
            child: asyncBilling.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => PageErrorDisplay(
                error: AppPageError.from(e),
                onRetry: () =>
                    ref.read(billingNotifierProvider.notifier).refresh(),
              ),
              data: (rows) => rows.isEmpty
                  ? const _EmptyState()
                  : _BillingList(rows: rows),
            ),
          ),
        ],
      ),
    );
  }
}

class _BillingList extends StatelessWidget {
  final List<BillingRow> rows;
  const _BillingList({required this.rows});

  /// Group rows by month string e.g. "May 2026"
  Map<String, List<BillingRow>> _groupByMonth() {
    final grouped = <String, List<BillingRow>>{};
    for (final row in rows) {
      final dt = row.date;
      final key = dt != null ? _monthLabel(dt) : 'Unknown';
      (grouped[key] ??= []).add(row);
    }
    return grouped;
  }

  String _monthLabel(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[dt.month - 1]} ${dt.year}';
  }

  double _monthTotal(List<BillingRow> rows) =>
      rows.fold(0.0, (sum, r) => sum + r.amount);

  @override
  Widget build(BuildContext context) {
    final grouped = _groupByMonth();

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.xs,
        AppSpacing.md,
        AppSpacing.lg,
      ),
      children: [
        for (final entry in grouped.entries) ...[
          EmSectionHead(
            entry.key,
            subtitle: 'Total ₹${_monthTotal(entry.value).toStringAsFixed(2)}',
          ),
          ...entry.value.asMap().entries.map(
                (e) => _BillingRowWidget(row: e.value)
                    .animate(delay: (e.key * 60).ms)
                    .fadeIn(duration: 220.ms)
                    .slideY(begin: 0.05, end: 0, duration: 220.ms),
              ),
          const SizedBox(height: AppSpacing.sm),
        ],
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: EmCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  color: AppColors.pillBg,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: HugeIcon(
                    icon: HugeIcons.strokeRoundedCoins01,
                    color: AppColors.textTertiary,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              const Text('No billing records', style: AppTypography.h2),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Completed session bills will appear here',
                style: AppTypography.bodyR,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BillingRowWidget extends StatelessWidget {
  final BillingRow row;
  const _BillingRowWidget({required this.row});

  EmTagKind _statusKind(String? status) => switch (status) {
        'completed' || 'paid' => EmTagKind.ok,
        'pending' => EmTagKind.warn,
        'failed' => EmTagKind.err,
        _ => EmTagKind.mute,
      };

  String _statusLabel(String? status) =>
      status != null && status.isNotEmpty
          ? status[0].toUpperCase() + status.substring(1)
          : '—';

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.xs),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  row.storeName ?? row.storeId,
                  style: AppTypography.body.copyWith(fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${row.systemName ?? '—'} · '
                  '${row.durationMinutes != null ? '${row.durationMinutes}m' : '—'} · '
                  '${row.method ?? '—'}',
                  style: AppTypography.small,
                ),
                const SizedBox(height: 2),
                Text(
                  row.date != null
                      ? '${row.date!.day}/${row.date!.month}/${row.date!.year}'
                      : '—',
                  style: AppTypography.small.copyWith(
                    color: AppColors.textTertiary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹${row.amount.toStringAsFixed(2)}',
                style: AppTypography.num.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              EmTag(
                kind: _statusKind(row.status),
                label: _statusLabel(row.status),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
