import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/navigation/routes.dart';
import '../../../../shared/widgets/gz_top_bar.dart';
import '../../../../shared/widgets/gz_card.dart';
import '../../../../shared/widgets/gz_tag.dart';
import '../../../../shared/widgets/gz_chip.dart';
import '../../../../shared/widgets/gz_button.dart';
import '../../../../shared/widgets/page_error_display.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../models/domain_billing.dart';
import '../../../../models/enums.dart';
import '../../../../features/disputes/presentation/providers/disputes_list_notifier.dart';

class DisputesListMobileLayout extends ConsumerWidget {
  const DisputesListMobileLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(disputesListProvider);

    return Column(
      children: [
        GzTopBar(
          title: 'My Disputes',
          trailing: GestureDetector(
            onTap: () => context.push(AppRoutes.disputeCreate),
            child: const HugeIcon(
              icon: HugeIcons.strokeRoundedPlusSign,
              color: AppColors.textPrimary,
              size: 22,
            ),
          ),
        ),
        Expanded(
          child: state.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => PageErrorDisplay(
              error: AppPageError.from(e),
              onRetry: () =>
                  ref.read(disputesListProvider.notifier).refresh(),
            ),
            data: (disputes) => disputes.isEmpty
                ? _EmptyState(
                    onFile: () => context.push(AppRoutes.disputeCreate))
                : _DisputesList(disputes: disputes),
          ),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onFile});
  final VoidCallback onFile;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: GzCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const HugeIcon(
                icon: HugeIcons.strokeRoundedAlert01,
                color: AppColors.textTertiary,
                size: 36,
              ),
              const SizedBox(height: AppSpacing.md),
              Text('No disputes filed',
                  style: AppTypography.h3
                      .copyWith(color: AppColors.textSecondary)),
              const SizedBox(height: AppSpacing.xs),
              Text('File a dispute if you were billed incorrectly.',
                  style: AppTypography.bodyR
                      .copyWith(color: AppColors.textTertiary),
                  textAlign: TextAlign.center),
              const SizedBox(height: AppSpacing.md),
              GzButton(
                label: 'File a Dispute',
                small: true,
                onPressed: onFile,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DisputesList extends ConsumerWidget {
  const _DisputesList({required this.disputes});
  final List<BillingDisputeModel> disputes;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      onRefresh: () => ref.read(disputesListProvider.notifier).refresh(),
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.md),
        itemCount: disputes.length,
        separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
        itemBuilder: (ctx, i) => _DisputeRow(dispute: disputes[i]),
      ),
    );
  }
}

class _DisputeRow extends StatelessWidget {
  const _DisputeRow({required this.dispute});
  final BillingDisputeModel dispute;

  static GzTagKind _tagKind(DisputeStatus? s) => switch (s) {
    DisputeStatus.open      => GzTagKind.warn,
    DisputeStatus.underReview => GzTagKind.info,
    DisputeStatus.resolved  => GzTagKind.ok,
    DisputeStatus.withdrawn => GzTagKind.mute,
    null                    => GzTagKind.mute,
  };

  static String _statusLabel(DisputeStatus? s) => switch (s) {
    DisputeStatus.open        => 'Open',
    DisputeStatus.underReview => 'Under Review',
    DisputeStatus.resolved    => 'Resolved',
    DisputeStatus.withdrawn   => 'Withdrawn',
    null                      => '—',
  };

  @override
  Widget build(BuildContext context) {
    final id = dispute.id ?? '';
    final amount = dispute.disputeAmount;
    final createdAt = dispute.createdAt;
    final dateStr = createdAt != null
        ? '${createdAt.day} ${_month(createdAt.month)} ${createdAt.year}'
        : '—';

    return GestureDetector(
      onTap: () => context.push(AppRoutes.disputeDetailPath(id)),
      child: GzCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Dispute #${id.length > 8 ? id.substring(0, 8).toUpperCase() : id.toUpperCase()}',
                    style:
                        AppTypography.body.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                GzTag(
                  kind: _tagKind(dispute.status),
                  label: _statusLabel(dispute.status),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Wrap(spacing: AppSpacing.xs, runSpacing: AppSpacing.xs, children: [
              GzChip(keyLabel: 'DATE', value: dateStr),
              if (amount != null)
                GzChip(keyLabel: 'DISPUTED', value: '₹${amount.toStringAsFixed(0)}'),
            ]),
          ],
        ),
      ),
    );
  }

  static String _month(int m) => const [
    '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ][m];
}
