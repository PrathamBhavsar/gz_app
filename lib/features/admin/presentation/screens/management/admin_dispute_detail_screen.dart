import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/errors/app_exception.dart';
import '../../../../../core/errors/error_snackbar.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../models/domain_billing.dart';
import '../../../../../models/enums.dart';
import '../../../../../shared/widgets/gz_admin_top_bar.dart';
import '../../../../../shared/widgets/gz_button.dart';
import '../../../../../shared/widgets/gz_card.dart';
import '../../../../../shared/widgets/gz_loading_view.dart';
import '../../../../../shared/widgets/gz_meta_row.dart';
import '../../../../../shared/widgets/gz_scroll_content.dart';
import '../../../../../shared/widgets/gz_tag.dart';
import '../../../../../shared/widgets/page_error_display.dart';
import '../../../../admin/application/admin_command_state.dart';
import '../../../../admin/application/admin_dispute_command_notifier.dart';
import '../../../../admin/application/admin_dispute_detail_notifier.dart';

// Maps UI label → API resolution string
const _resolutionLabels = ['Full Refund', 'Partial Refund', 'Credit Issued', 'Upheld'];
const _resolutionApiValues = {
  'Full Refund': 'full_refund',
  'Partial Refund': 'partial_refund',
  'Credit Issued': 'credit_issued',
  'Upheld': 'upheld',
};

class AdminDisputeDetailScreen extends ConsumerWidget {
  const AdminDisputeDetailScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: GzAdminTopBar(
        title: 'Dispute #${id.toUpperCase()}',
        onBack: () => context.pop(),
      ),
      body: SafeArea(
        top: false,
        child: ref
            .watch(adminDisputeDetailNotifierProvider(id))
            .when(
              loading: () => const GzLoadingView(message: 'Loading dispute'),
              error: (e, _) => PageErrorDisplay(
                error: AppPageError.from(e),
                onRetry: () => ref
                    .read(adminDisputeDetailNotifierProvider(id).notifier)
                    .refresh(),
              ),
              data: (dispute) => _DetailBody(id: id, dispute: dispute),
            ),
      ),
    );
  }
}

class _DetailBody extends ConsumerStatefulWidget {
  const _DetailBody({required this.id, required this.dispute});

  final String id;
  final BillingDisputeModel dispute;

  @override
  ConsumerState<_DetailBody> createState() => _DetailBodyState();
}

class _DetailBodyState extends ConsumerState<_DetailBody> {
  String? _selectedResolution;
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Pre-select existing resolution if already resolved
    if (widget.dispute.resolution != null) {
      final apiVal = widget.dispute.resolution!.name
          .replaceAllMapped(RegExp(r'[A-Z]'), (m) => '_${m.group(0)!.toLowerCase()}');
      _selectedResolution = _resolutionLabels.firstWhere(
        (l) => _resolutionApiValues[l] == apiVal,
        orElse: () => _resolutionLabels.first,
      );
    }
    if (widget.dispute.resolutionNotes != null) {
      _notesController.text = widget.dispute.resolutionNotes!;
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  bool get _isResolved =>
      widget.dispute.status == DisputeStatus.resolved ||
      widget.dispute.status == DisputeStatus.withdrawn;

  @override
  Widget build(BuildContext context) {
    ref.listen<AdminCommandState>(adminDisputeCommandNotifierProvider, (
      _,
      next,
    ) {
      if (!context.mounted) return;
      if (next is AdminCommandSuccess) {
        showSuccessSnackbar(context, next.message);
        ref.read(adminDisputeCommandNotifierProvider.notifier).reset();
      }
      if (next is AdminCommandError) showErrorSnackbar(context, next.message);
    });

    final cmdState = ref.watch(adminDisputeCommandNotifierProvider);
    final isBusy = cmdState is AdminCommandLoading;
    final dispute = widget.dispute;

    return GzScrollContent(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Section 1 — Status + info
            GzCard(
              padding: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          dispute.reason ?? 'Dispute',
                          style: AppTypography.h3,
                        ),
                      ),
                      _statusTag(dispute.status),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (dispute.sessionId != null)
                    GzMetaRow(label: 'Session', value: '#${dispute.sessionId!}'),
                  if (dispute.billingId != null)
                    GzMetaRow(label: 'Billing', value: '#${dispute.billingId!}'),
                  if (dispute.createdAt != null)
                    GzMetaRow(
                      label: 'Date',
                      value: _formatDate(dispute.createdAt!),
                    ),
                  if (dispute.disputeAmount != null)
                    GzMetaRow(
                      label: 'Disputed',
                      value: '₹${dispute.disputeAmount!.toStringAsFixed(2)}',
                    ),
                  if (dispute.resolutionAmount != null)
                    GzMetaRow(
                      label: 'Resolved',
                      value: '₹${dispute.resolutionAmount!.toStringAsFixed(2)}',
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Section 2 — Timeline (synthesized from status)
            GzCard(
              padding: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('TIMELINE', style: AppTypography.meta),
                  const SizedBox(height: 12),
                  ..._buildTimeline(dispute),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Section 3 — Resolution form
            GzCard(
              padding: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Resolution', style: AppTypography.h3),
                  const SizedBox(height: 12),
                  Text('Select outcome', style: AppTypography.small),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _resolutionLabels.map((option) {
                      final selected = _selectedResolution == option;
                      return GestureDetector(
                        onTap: _isResolved || isBusy
                            ? null
                            : () => setState(
                                  () => _selectedResolution = option,
                                ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: selected
                                ? AppColors.textPrimary
                                : AppColors.pillBg,
                            borderRadius: BorderRadius.circular(
                              AppSpacing.borderRadiusPill,
                            ),
                          ),
                          child: Text(
                            option,
                            style: AppTypography.body.copyWith(
                              color: selected
                                  ? AppColors.surface
                                  : AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 14),
                  Text('Admin notes', style: AppTypography.small),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.pillBg,
                      borderRadius: BorderRadius.circular(
                        AppSpacing.borderRadiusLg,
                      ),
                    ),
                    child: TextField(
                      controller: _notesController,
                      enabled: !_isResolved && !isBusy,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Add notes for player...',
                        hintStyle: AppTypography.bodyR,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      maxLines: 3,
                      style: AppTypography.bodyR,
                    ),
                  ),
                  const SizedBox(height: 18),
                  if (!_isResolved) ...[
                    GzButton(
                      label: 'Mark as Resolved',
                      variant: GzButtonVariant.primary,
                      loading: isBusy,
                      onPressed: _selectedResolution == null || isBusy
                          ? null
                          : () {
                              final apiVal = _resolutionApiValues[_selectedResolution!]!;
                              ref
                                  .read(adminDisputeCommandNotifierProvider.notifier)
                                  .resolve(
                                    widget.id,
                                    resolution: apiVal,
                                    notes: _notesController.text.trim().isEmpty
                                        ? null
                                        : _notesController.text.trim(),
                                  );
                            },
                    ),
                    const SizedBox(height: 8),
                    GzButton(
                      label: 'Mark as Under Review',
                      variant: GzButtonVariant.ghost,
                      loading: isBusy,
                      onPressed: isBusy
                          ? null
                          : () => ref
                              .read(adminDisputeCommandNotifierProvider.notifier)
                              .review(
                                widget.id,
                                notes: _notesController.text.trim().isEmpty
                                    ? null
                                    : _notesController.text.trim(),
                              ),
                    ),
                  ] else
                    GzButton(
                      label: 'Resolved ✓',
                      variant: GzButtonVariant.primary,
                      onPressed: null,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildTimeline(BillingDisputeModel dispute) {
    final steps = <({String event, String time, Color color})>[];

    if (dispute.createdAt != null) {
      steps.add((
        event: 'Dispute opened',
        time: _formatDateTime(dispute.createdAt!),
        color: AppColors.err,
      ));
    }

    if (dispute.status == DisputeStatus.underReview ||
        dispute.status == DisputeStatus.resolved) {
      steps.add((
        event: 'Under review',
        time: dispute.updatedAt != null
            ? _formatDateTime(dispute.updatedAt!)
            : '',
        color: AppColors.warn,
      ));
    }

    if (dispute.status == DisputeStatus.resolved && dispute.resolvedAt != null) {
      steps.add((
        event: 'Resolved',
        time: _formatDateTime(dispute.resolvedAt!),
        color: AppColors.ok,
      ));
    } else if (steps.length < 2) {
      steps.add((
        event: 'Pending resolution',
        time: '',
        color: AppColors.textMuted,
      ));
    }

    return steps.asMap().entries.map((entry) {
      final idx = entry.key;
      final step = entry.value;
      return Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: step.color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.event,
                    style: AppTypography.body.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (step.time.isNotEmpty)
                    Text(step.time, style: AppTypography.small),
                ],
              ),
            ],
          ),
          if (idx < steps.length - 1)
            const Divider(height: 20, color: AppColors.rule),
        ],
      );
    }).toList();
  }

  GzTag _statusTag(DisputeStatus? status) {
    return switch (status) {
      DisputeStatus.open => const GzTag(kind: GzTagKind.err, label: 'Open'),
      DisputeStatus.underReview =>
        const GzTag(kind: GzTagKind.warn, label: 'In Review'),
      DisputeStatus.resolved =>
        const GzTag(kind: GzTagKind.ok, label: 'Resolved'),
      DisputeStatus.withdrawn =>
        const GzTag(kind: GzTagKind.mute, label: 'Withdrawn'),
      _ => const GzTag(kind: GzTagKind.mute, label: 'Unknown'),
    };
  }

  String _formatDate(DateTime dt) =>
      '${_month(dt.month)} ${dt.day.toString().padLeft(2, '0')}, ${dt.year}';

  String _formatDateTime(DateTime dt) {
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final m = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour < 12 ? 'AM' : 'PM';
    return '${_month(dt.month)} ${dt.day} at $h:$m $period';
  }

  String _month(int m) => const [
        '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
      ][m];
}
