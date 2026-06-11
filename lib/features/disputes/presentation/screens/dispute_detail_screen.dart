import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/error_snackbar.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../models/domain_billing.dart';
import '../../../../models/enums.dart';
import '../../../sessions/application/session_ui_models.dart';
import '../../../../shared/widgets/gz_button.dart';
import '../../../../shared/widgets/gz_card.dart';
import '../../../../shared/widgets/gz_loading_view.dart';
import '../../../../shared/widgets/gz_meta_row.dart';
import '../../../../shared/widgets/gz_tag.dart';
import '../../../../shared/widgets/gz_top_bar.dart';
import '../../../../shared/widgets/page_error_display.dart';
import '../../application/dispute_detail_notifier.dart';

class DisputeDetailScreen extends ConsumerWidget {
  const DisputeDetailScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<DisputeCommandState>(disputeCommandNotifierProvider(id), (
      previous,
      next,
    ) {
      if (next is DisputeCommandSuccess && next != previous) {
        showSuccessSnackbar(context, next.message);
        ref.read(disputeCommandNotifierProvider(id).notifier).reset();
      } else if (next is DisputeCommandError && next != previous) {
        showErrorSnackbar(context, next.error);
        ref.read(disputeCommandNotifierProvider(id).notifier).reset();
      }
    });

    final detailState = ref.watch(disputeDetailNotifierProvider(id));
    final commandState = ref.watch(disputeCommandNotifierProvider(id));
    final isWithdrawing = commandState is DisputeCommandLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: GzTopBar(title: 'Dispute ${id.isEmpty ? '' : '#$id'}'),
      body: SafeArea(
        top: false,
        child: detailState.when(
          loading: () => const GzLoadingView(message: 'Loading dispute...'),
          error: (error, _) => PageErrorDisplay(
            error: AppPageError.from(error),
            onRetry: () =>
                ref.read(disputeDetailNotifierProvider(id).notifier).refresh(),
          ),
          data: (detail) {
            final dispute = detail.dispute;
            final notes = _metadataString(dispute, ['notes']);
            final timeline = _timelineEntries(detail);

            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              children: [
                GzCard(child: _StatusCard(dispute: dispute)),
                const SizedBox(height: AppSpacing.md),
                GzCard(
                  child: Column(
                    children: [
                      GzMetaRow(
                        label: 'Session',
                        value: dispute.sessionId ?? 'Unknown',
                      ),
                      GzMetaRow(
                        label: 'Billing',
                        value: dispute.billingId ?? 'Unknown',
                      ),
                      GzMetaRow(
                        label: 'Store',
                        value:
                            detail.billing?.storeName ??
                            _metadataString(dispute, [
                              'storeName',
                              'store_name',
                            ]) ??
                            'Gaming Zone',
                      ),
                      GzMetaRow(
                        label: 'System',
                        value:
                            detail.billing?.systemName ??
                            _metadataString(dispute, [
                              'systemName',
                              'system_name',
                            ]) ??
                            'Session',
                      ),
                      GzMetaRow(
                        label: 'Date',
                        value: formatReadableDateLong(
                          detail.billing?.date ?? dispute.createdAt,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                GzCard(
                  child: Column(
                    children: [
                      GzMetaRow(
                        label: 'Original charge',
                        value: detail.billing == null
                            ? 'Unavailable'
                            : formatCurrency(detail.billing!.amount),
                      ),
                      GzMetaRow(
                        label: 'Disputed amount',
                        value: dispute.disputeAmount == null
                            ? 'Unavailable'
                            : formatCurrency(dispute.disputeAmount!),
                      ),
                      if (dispute.resolutionAmount != null)
                        GzMetaRow(
                          label: 'Resolution amount',
                          value: formatCurrency(dispute.resolutionAmount!),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                GzCard(
                  variant: CardVariant.inset,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Player description', style: AppTypography.meta),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        dispute.reason ?? 'No description provided.',
                        style: AppTypography.body,
                      ),
                      if (notes != null && notes.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.sm),
                        Text('Additional notes', style: AppTypography.meta),
                        const SizedBox(height: AppSpacing.xs),
                        Text(notes, style: AppTypography.body),
                      ],
                    ],
                  ),
                ),
                if (dispute.status == DisputeStatus.resolved ||
                    dispute.resolution != null ||
                    (dispute.resolutionNotes?.trim().isNotEmpty ?? false)) ...[
                  const SizedBox(height: AppSpacing.md),
                  GzCard(
                    variant: CardVariant.tint,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Resolution', style: AppTypography.meta),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          _resolutionLabel(dispute),
                          style: AppTypography.h3,
                        ),
                        if (dispute.resolutionNotes?.trim().isNotEmpty ??
                            false) ...[
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            dispute.resolutionNotes!,
                            style: AppTypography.body,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.md),
                GzCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Timeline', style: AppTypography.h3),
                      const SizedBox(height: AppSpacing.sm),
                      ...timeline.map(
                        (entry) => Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: Text(
                            '${entry.timeLabel} · ${entry.label}',
                            style: AppTypography.body,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (dispute.status == DisputeStatus.open) ...[
                  const SizedBox(height: AppSpacing.xl),
                  GzButton(
                    label: 'Withdraw dispute',
                    variant: GzButtonVariant.dangerOutline,
                    loading: isWithdrawing,
                    onPressed: isWithdrawing
                        ? null
                        : () => _confirmWithdraw(context, ref),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _confirmWithdraw(BuildContext context, WidgetRef ref) async {
    final shouldWithdraw = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Withdraw dispute?'),
        content: const Text(
          'This will close the dispute and return it to the store as withdrawn.',
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => context.pop(true),
            child: const Text('Withdraw'),
          ),
        ],
      ),
    );

    if (shouldWithdraw == true) {
      ref.read(disputeCommandNotifierProvider(id).notifier).withdraw();
    }
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.dispute});

  final BillingDisputeModel dispute;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GzTag(
          kind: _disputeTagKind(dispute.status),
          label: _disputeStatusLabel(dispute.status),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            dispute.reason ?? 'Billing dispute',
            style: AppTypography.h3,
          ),
        ),
      ],
    );
  }
}

class _TimelineEntry {
  const _TimelineEntry({required this.label, required this.timeLabel});

  final String label;
  final String timeLabel;
}

List<_TimelineEntry> _timelineEntries(DisputeDetailData detail) {
  final dispute = detail.dispute;
  final entries = <_TimelineEntry>[];

  if (dispute.createdAt != null) {
    entries.add(
      _TimelineEntry(
        label: 'Dispute filed',
        timeLabel: _timelineLabel(dispute.createdAt!),
      ),
    );
  }

  if (dispute.status == DisputeStatus.underReview &&
      dispute.updatedAt != null) {
    entries.add(
      _TimelineEntry(
        label: 'Under review',
        timeLabel: _timelineLabel(dispute.updatedAt!),
      ),
    );
  }

  if (dispute.status == DisputeStatus.withdrawn && dispute.updatedAt != null) {
    entries.add(
      _TimelineEntry(
        label: 'Dispute withdrawn',
        timeLabel: _timelineLabel(dispute.updatedAt!),
      ),
    );
  }

  if (dispute.resolvedAt != null) {
    entries.add(
      _TimelineEntry(
        label: 'Resolved',
        timeLabel: _timelineLabel(dispute.resolvedAt!),
      ),
    );
  }

  if (entries.isEmpty) {
    entries.add(
      const _TimelineEntry(
        label: 'Timeline unavailable',
        timeLabel: 'No timestamps',
      ),
    );
  }

  return entries;
}

String _timelineLabel(DateTime value) {
  final date = formatReadableDate(value);
  final time = formatReadableTime(value) ?? 'Unknown time';
  return '$date $time';
}

String _disputeStatusLabel(DisputeStatus? status) {
  switch (status) {
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

GzTagKind _disputeTagKind(DisputeStatus? status) {
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

String _resolutionLabel(BillingDisputeModel dispute) {
  switch (dispute.resolution) {
    case DisputeResolution.upheld:
      return 'Upheld';
    case DisputeResolution.partialRefund:
      return 'Partial refund';
    case DisputeResolution.fullRefund:
      return 'Full refund';
    case DisputeResolution.creditIssued:
      return 'Credit issued';
    case null:
      return 'Resolved';
  }
}

String? _metadataString(BillingDisputeModel dispute, List<String> keys) {
  final metadata = dispute.metadata;
  if (metadata == null) {
    return null;
  }

  for (final key in keys) {
    final value = metadata[key];
    final label = value?.toString().trim();
    if (label != null && label.isNotEmpty) {
      return label;
    }
  }
  return null;
}
