import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/errors/app_exception.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../models/domain_billing.dart';
import '../../../../../shared/widgets/gz_button.dart';
import '../../../../../shared/widgets/gz_card.dart';
import '../../../../../shared/widgets/gz_loading_view.dart';
import '../../../../../shared/widgets/gz_meta_row.dart';
import '../../../../../shared/widgets/page_error_display.dart';
import '../../../application/admin_billing_detail_notifier.dart';
import 'payment_detail_sheet.dart';

Future<void> showBillingDetailSheet(
  BuildContext context, {
  required String billingId,
  String? paymentId,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) =>
        BillingDetailSheet(billingId: billingId, paymentId: paymentId),
  );
}

class BillingDetailSheet extends ConsumerWidget {
  const BillingDetailSheet({
    super.key,
    required this.billingId,
    this.paymentId,
  });

  final String billingId;
  final String? paymentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(adminBillingDetailNotifierProvider(billingId));

    return _SheetFrame(
      title: 'Billing detail',
      child: state.when(
        loading: () => const GzLoadingView(message: 'Loading billing detail'),
        error: (error, _) => PageErrorDisplay(
          error: AppPageError.from(error),
          onRetry: () => ref
              .read(adminBillingDetailNotifierProvider(billingId).notifier)
              .refresh(),
        ),
        data: (detail) =>
            _BillingDetailContent(detail: detail, paymentId: paymentId),
      ),
    );
  }
}

class _BillingDetailContent extends StatelessWidget {
  const _BillingDetailContent({required this.detail, this.paymentId});

  final BillingLedgerDetailModel detail;
  final String? paymentId;

  @override
  Widget build(BuildContext context) {
    final billing = detail.billing;

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        GzCard(
          padding: AppSpacing.md,
          child: Column(
            children: [
              GzMetaRow(
                label: 'Billing ID',
                value: billing.id ?? 'Unavailable',
              ),
              GzMetaRow(
                label: 'Session ID',
                value: billing.sessionId ?? 'Unavailable',
              ),
              GzMetaRow(label: 'User ID', value: billing.userId ?? 'Guest'),
              GzMetaRow(
                label: 'System ID',
                value: billing.systemId ?? 'Unavailable',
              ),
              GzMetaRow(
                label: 'Period',
                value:
                    '${_dateTimeLabel(billing.billedFrom)} to ${_dateTimeLabel(billing.billedUntil)}',
              ),
              GzMetaRow(
                label: 'Minutes',
                value: '${billing.billedMinutes ?? 0}',
              ),
              GzMetaRow(label: 'Base rate', value: _money(billing.baseRate)),
              GzMetaRow(
                label: 'Multiplier',
                value: billing.appliedMultiplier?.toString() ?? '—',
              ),
              GzMetaRow(label: 'Gross', value: _money(billing.grossAmount)),
              GzMetaRow(
                label: 'Discount',
                value: _money(billing.discountAmount),
              ),
              GzMetaRow(label: 'Net', value: _money(billing.netAmount)),
              GzMetaRow(
                label: 'Reason',
                value: billing.billingReason ?? 'Unavailable',
              ),
              if ((billing.notes ?? '').isNotEmpty)
                GzMetaRow(label: 'Notes', value: billing.notes!),
              GzMetaRow(
                label: 'Created',
                value: _dateTimeLabel(billing.createdAt),
              ),
            ],
          ),
        ),
        if (paymentId != null && paymentId!.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          GzButton(
            label: 'View payment detail',
            variant: GzButtonVariant.ghost,
            onPressed: () =>
                showPaymentDetailSheet(context, paymentId: paymentId!),
          ),
        ],
        const SizedBox(height: AppSpacing.md),
        Text('Overrides', style: AppTypography.h3),
        const SizedBox(height: AppSpacing.sm),
        if (detail.overrides.isEmpty)
          GzCard(
            variant: CardVariant.inset,
            padding: AppSpacing.md,
            child: const Text(
              'No admin overrides were applied to this billing record.',
              style: AppTypography.bodyR,
            ),
          )
        else
          ...detail.overrides.map(
            (override) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: GzCard(
                variant: CardVariant.inset,
                padding: AppSpacing.md,
                child: Column(
                  children: [
                    GzMetaRow(
                      label: 'Override ID',
                      value: override.id ?? 'Unavailable',
                    ),
                    GzMetaRow(
                      label: 'Admin ID',
                      value: override.adminId ?? 'Unavailable',
                    ),
                    GzMetaRow(
                      label: 'Type',
                      value: override.overrideType?.name ?? 'Unavailable',
                    ),
                    GzMetaRow(
                      label: 'Original',
                      value: _money(override.originalValue),
                    ),
                    GzMetaRow(
                      label: 'Override',
                      value: _money(override.overrideValue),
                    ),
                    GzMetaRow(
                      label: 'Reason',
                      value: override.reason ?? 'Unavailable',
                    ),
                    GzMetaRow(
                      label: 'Created',
                      value: _dateTimeLabel(override.createdAt),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _SheetFrame extends StatelessWidget {
  const _SheetFrame({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.82,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.md,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.lg,
                AppSpacing.lg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 42,
                      height: AppSpacing.xs,
                      decoration: BoxDecoration(
                        color: AppColors.rule,
                        borderRadius: BorderRadius.circular(
                          AppSpacing.borderRadiusPill,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(title, style: AppTypography.h1),
                  const SizedBox(height: AppSpacing.md),
                  Expanded(child: child),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

String _money(double? amount) {
  if (amount == null) {
    return '₹0';
  }
  final formatted = amount.truncateToDouble() == amount
      ? amount.toStringAsFixed(0)
      : amount.toStringAsFixed(2);
  return '₹$formatted';
}

String _dateTimeLabel(DateTime? value) {
  if (value == null) {
    return 'Unavailable';
  }
  final local = value.toLocal();
  final minute = local.minute.toString().padLeft(2, '0');
  return '${local.day}/${local.month}/${local.year} ${local.hour}:$minute';
}
