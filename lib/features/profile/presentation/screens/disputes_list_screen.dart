import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/navigation/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../models/domain_billing.dart';
import '../../../../models/enums.dart';
import '../../../disputes/application/my_disputes_notifier.dart';
import '../../../sessions/application/session_ui_models.dart';
import '../../../../shared/widgets/gz_chip.dart';
import '../../../../shared/widgets/gz_icon_btn.dart';
import '../../../../shared/widgets/gz_loading_view.dart';
import '../../../../shared/widgets/gz_tag.dart';
import '../../../../shared/widgets/gz_top_bar.dart';
import '../../../../shared/widgets/page_error_display.dart';

class DisputesListScreen extends ConsumerStatefulWidget {
  const DisputesListScreen({super.key});

  @override
  ConsumerState<DisputesListScreen> createState() => _DisputesListScreenState();
}

class _DisputesListScreenState extends ConsumerState<DisputesListScreen> {
  final List<String> _filters = const [
    'All',
    'Open',
    'In Review',
    'Resolved',
    'Withdrawn',
  ];
  int _selectedFilter = 0;

  @override
  Widget build(BuildContext context) {
    final disputesState = ref.watch(myDisputesNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: GzTopBar(
        title: 'My disputes',
        trailing: GzIconBtn(
          tooltip: 'Create dispute',
          onTap: () => context.push(AppRoutes.disputeCreate),
          child: const HugeIcon(
            icon: HugeIcons.strokeRoundedPlusSign,
            color: AppColors.textPrimary,
            size: 18,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: disputesState.when(
          loading: () => const GzLoadingView(message: 'Loading disputes...'),
          error: (error, _) => PageErrorDisplay(
            error: AppPageError.from(error),
            onRetry: () =>
                ref.read(myDisputesNotifierProvider.notifier).refresh(),
          ),
          data: (disputes) {
            if (disputes.isEmpty) {
              return PageErrorDisplay(
                error: const AppPageError(
                  title: 'No disputes filed',
                  message:
                      'Billing issues you raise for this store will appear here.',
                  icon: 'inbox',
                  kind: AppPageErrorKind.empty,
                ),
              );
            }

            final activeFilter = _filters[_selectedFilter];
            final visibleDisputes = activeFilter == 'All'
                ? disputes
                : disputes
                      .where(
                        (item) =>
                            _statusLabel(item).toLowerCase() ==
                            activeFilter.toLowerCase(),
                      )
                      .toList(growable: false);

            return RefreshIndicator(
              onRefresh: () =>
                  ref.read(myDisputesNotifierProvider.notifier).refresh(),
              child: Column(
                children: [
                  SizedBox(
                    height: 42,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => GzChip(
                        label: _filters[index],
                        active: _selectedFilter == index,
                        onTap: () => setState(() => _selectedFilter = index),
                      ),
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: AppSpacing.sm),
                      itemCount: _filters.length,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Expanded(
                    child: visibleDisputes.isEmpty
                        ? ListView(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                            children: const [_FilteredEmptyState()],
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                            itemBuilder: (context, index) {
                              final dispute = visibleDisputes[index];
                              return _DisputeCard(dispute: dispute);
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: AppSpacing.sm),
                            itemCount: visibleDisputes.length,
                          ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _DisputeCard extends StatelessWidget {
  const _DisputeCard({required this.dispute});

  final BillingDisputeModel dispute;

  @override
  Widget build(BuildContext context) {
    final sessionLabel = _sessionLabel(dispute);
    final disputeId = dispute.id;
    return GestureDetector(
      onTap: disputeId == null || disputeId.isEmpty
          ? null
          : () => context.push(AppRoutes.disputeDetailPath(disputeId)),
      child: Container(
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
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.pillBg,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(sessionLabel, style: AppTypography.small),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    dispute.reason ?? 'Billing dispute',
                    style: AppTypography.h3,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '${formatReadableDate(dispute.createdAt)} · ${_amountLabel(dispute)}',
                    style: AppTypography.small,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  GzTag(
                    kind: _tagKind(dispute.status),
                    label: _statusLabel(dispute),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            const HugeIcon(
              icon: HugeIcons.strokeRoundedArrowRight01,
              color: AppColors.textTertiary,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

class _FilteredEmptyState extends StatelessWidget {
  const _FilteredEmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
      ),
      child: Column(
        children: [
          Text('No disputes match this filter', style: AppTypography.h3),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Try a different status or create a new dispute from billing history.',
            style: AppTypography.small.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

String _sessionLabel(BillingDisputeModel dispute) {
  if (dispute.sessionId != null && dispute.sessionId!.isNotEmpty) {
    return 'Session ${dispute.sessionId!}';
  }
  if (dispute.billingId != null && dispute.billingId!.isNotEmpty) {
    return 'Billing ${dispute.billingId!}';
  }
  return 'Dispute';
}

String _amountLabel(BillingDisputeModel dispute) {
  final amount = dispute.disputeAmount;
  if (amount == null) {
    return 'Amount unavailable';
  }
  return formatCurrency(amount);
}

String _statusLabel(BillingDisputeModel dispute) {
  switch (dispute.status) {
    case DisputeStatus.underReview:
      return 'In Review';
    case DisputeStatus.resolved:
      return 'Resolved';
    case DisputeStatus.withdrawn:
      return 'Withdrawn';
    case DisputeStatus.open:
    case null:
      return 'Open';
  }
}

GzTagKind _tagKind(DisputeStatus? status) {
  switch (status) {
    case DisputeStatus.underReview:
      return GzTagKind.warn;
    case DisputeStatus.resolved:
      return GzTagKind.ok;
    case DisputeStatus.withdrawn:
      return GzTagKind.mute;
    case DisputeStatus.open:
    case null:
      return GzTagKind.err;
  }
}
