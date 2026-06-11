import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/error_snackbar.dart';
import '../../../../core/navigation/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../models/api_responses.dart';
import '../../../../shared/widgets/gz_button.dart';
import '../../../../shared/widgets/gz_card.dart';
import '../../../../shared/widgets/gz_loading_view.dart';
import '../../../../shared/widgets/gz_top_bar.dart';
import '../../../../shared/widgets/page_error_display.dart';
import '../../../disputes/application/create_dispute_notifier.dart';
import '../../../sessions/application/billing_notifier.dart';
import '../../../sessions/application/session_ui_models.dart';

class CreateDisputeScreen extends ConsumerStatefulWidget {
  const CreateDisputeScreen({super.key, this.prefilledBillingId});

  final String? prefilledBillingId;

  @override
  ConsumerState<CreateDisputeScreen> createState() =>
      _CreateDisputeScreenState();
}

class _CreateDisputeScreenState extends ConsumerState<CreateDisputeScreen> {
  late final TextEditingController _reasonController;
  late final TextEditingController _amountController;
  late final TextEditingController _notesController;
  String? _selectedBillingId;
  bool _didSeedSelection = false;

  @override
  void initState() {
    super.initState();
    _reasonController = TextEditingController();
    _amountController = TextEditingController();
    _notesController = TextEditingController();
    _reasonController.addListener(_handleReasonChanged);
  }

  @override
  void dispose() {
    _reasonController.removeListener(_handleReasonChanged);
    _reasonController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<CreateDisputeState>(createDisputeNotifierProvider, (
      previous,
      next,
    ) {
      if (next is CreateDisputeSuccess && next != previous) {
        ref.read(createDisputeNotifierProvider.notifier).reset();
        final disputeId = next.dispute.id;
        if (disputeId == null || disputeId.isEmpty) {
          showSuccessSnackbar(context, 'Dispute submitted.');
          if (context.mounted) {
            context.pop();
          }
          return;
        }
        showSuccessSnackbar(context, 'Dispute submitted.');
        if (context.mounted) {
          context.pushReplacement(AppRoutes.disputeDetailPath(disputeId));
        }
      } else if (next is CreateDisputeError && next != previous) {
        showErrorSnackbar(context, next.error);
        ref.read(createDisputeNotifierProvider.notifier).reset();
      }
    });

    final billingState = ref.watch(billingNotifierProvider);
    final createState = ref.watch(createDisputeNotifierProvider);
    final isSubmitting = createState is CreateDisputeLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const GzTopBar(title: 'File a dispute'),
      body: SafeArea(
        top: false,
        child: billingState.when(
          loading: () => const GzLoadingView(message: 'Loading billing...'),
          error: (error, _) => PageErrorDisplay(
            error: AppPageError.from(error),
            onRetry: () => ref.read(billingNotifierProvider.notifier).refresh(),
          ),
          data: (rows) {
            final eligibleRows = rows
                .where(
                  (row) => row.sessionId != null && row.sessionId!.isNotEmpty,
                )
                .toList(growable: false);

            if (eligibleRows.isEmpty) {
              return PageErrorDisplay(
                error: const AppPageError(
                  title: 'No disputable sessions',
                  message:
                      'Only billed sessions with a valid session reference can be disputed.',
                  icon: 'inbox',
                  kind: AppPageErrorKind.empty,
                ),
              );
            }

            if (!_didSeedSelection) {
              _didSeedSelection = true;
              final prefilled = widget.prefilledBillingId;
              final match = eligibleRows.any((row) => row.id == prefilled)
                  ? prefilled
                  : null;
              _selectedBillingId = match ?? eligibleRows.first.id;
            }

            final selectedRow = eligibleRows.firstWhere(
              (row) => row.id == _selectedBillingId,
              orElse: () => eligibleRows.first,
            );

            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              children: [
                Text('Select billing record', style: AppTypography.meta),
                const SizedBox(height: AppSpacing.sm),
                ...eligibleRows.map(
                  (row) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: _BillingSelectionCard(
                      row: row,
                      selected: row.id == selectedRow.id,
                      onTap: () => setState(() => _selectedBillingId = row.id),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                GzCard(
                  variant: CardVariant.inset,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Selected', style: AppTypography.meta),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        '${billingStoreName(selectedRow)} · ${billingSystemName(selectedRow)}',
                        style: AppTypography.h3,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        '${formatReadableDate(selectedRow.date)} · ${formatCurrency(selectedRow.amount)}',
                        style: AppTypography.small,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text('Reason', style: AppTypography.meta),
                const SizedBox(height: AppSpacing.sm),
                _InputCard(
                  child: TextField(
                    controller: _reasonController,
                    maxLines: 4,
                    maxLength: 500,
                    decoration: const InputDecoration(
                      hintText: 'Describe the issue clearly',
                      border: InputBorder.none,
                      counterText: '',
                    ),
                    style: AppTypography.body,
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '${_reasonController.text.length}/500',
                    style: AppTypography.small.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text('Disputed amount (optional)', style: AppTypography.meta),
                const SizedBox(height: AppSpacing.sm),
                _InputCard(
                  child: TextField(
                    controller: _amountController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'e.g. 240',
                      border: InputBorder.none,
                    ),
                    style: AppTypography.body,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text('Additional notes (optional)', style: AppTypography.meta),
                const SizedBox(height: AppSpacing.sm),
                _InputCard(
                  child: TextField(
                    controller: _notesController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: 'Anything else the store should review',
                      border: InputBorder.none,
                    ),
                    style: AppTypography.body,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                GzButton(
                  label: 'Submit dispute',
                  loading: isSubmitting,
                  onPressed: isSubmitting ? null : () => _submit(selectedRow),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _submit(BillingRow selectedRow) {
    final sessionId = selectedRow.sessionId;
    if (sessionId == null || sessionId.isEmpty) {
      showErrorSnackbar(
        context,
        const FormatException(
          'This billing record is missing a session reference.',
        ),
      );
      return;
    }

    final reason = _reasonController.text.trim();
    if (reason.isEmpty) {
      showErrorSnackbar(context, const FormatException('Reason is required'));
      return;
    }

    final amountText = _amountController.text.trim();
    final amount = amountText.isEmpty ? null : double.tryParse(amountText);
    if (amountText.isNotEmpty && amount == null) {
      showErrorSnackbar(
        context,
        const FormatException('Enter a valid disputed amount'),
      );
      return;
    }
    if (amount != null && amount <= 0) {
      showErrorSnackbar(
        context,
        const FormatException('Disputed amount must be greater than zero'),
      );
      return;
    }
    if (amount != null && amount > selectedRow.amount) {
      showErrorSnackbar(
        context,
        const FormatException(
          'Disputed amount cannot exceed the original charge',
        ),
      );
      return;
    }

    ref
        .read(createDisputeNotifierProvider.notifier)
        .submit(
          sessionId: sessionId,
          reason: reason,
          disputedAmount: amount,
          notes: _notesController.text.trim(),
        );
  }

  void _handleReasonChanged() {
    if (mounted) {
      setState(() {});
    }
  }
}

class _BillingSelectionCard extends StatelessWidget {
  const _BillingSelectionCard({
    required this.row,
    required this.selected,
    this.onTap,
  });

  final BillingRow row;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: selected ? AppColors.surfaceTint : AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
          border: Border.all(
            color: selected ? AppColors.textPrimary : AppColors.rule,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${billingStoreName(row)} · ${billingSystemName(row)}',
              style: AppTypography.h3,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              '${formatReadableDate(row.date)} · ${formatCurrency(row.amount)}',
              style: AppTypography.small,
            ),
            if (row.durationMinutes != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                formatShortDuration(Duration(minutes: row.durationMinutes!)),
                style: AppTypography.small.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _InputCard extends StatelessWidget {
  const _InputCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.pillBg,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
      ),
      child: child,
    );
  }
}
