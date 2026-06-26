import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/errors/app_exception.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../models/domain_billing.dart';
import '../../../../../shared/widgets/gz_card.dart';
import '../../../../../shared/widgets/gz_loading_view.dart';
import '../../../../../shared/widgets/gz_meta_row.dart';
import '../../../../../shared/widgets/page_error_display.dart';
import '../../../application/admin_payment_detail_notifier.dart';

Future<void> showPaymentDetailSheet(
  BuildContext context, {
  required String paymentId,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => PaymentDetailSheet(paymentId: paymentId),
  );
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

class PaymentDetailSheet extends ConsumerWidget {
  const PaymentDetailSheet({super.key, required this.paymentId});

  final String paymentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(adminPaymentDetailNotifierProvider(paymentId));

    return _SheetFrame(
      title: 'Payment detail',
      child: state.when(
        loading: () => const GzLoadingView(message: 'Loading payment detail'),
        error: (error, _) => PageErrorDisplay(
          error: AppPageError.from(error),
          onRetry: () => ref
              .read(adminPaymentDetailNotifierProvider(paymentId).notifier)
              .refresh(),
        ),
        data: (payment) => _PaymentDetailContent(payment: payment),
      ),
    );
  }
}

class _PaymentDetailContent extends StatelessWidget {
  const _PaymentDetailContent({required this.payment});

  final PaymentModel payment;

  @override
  Widget build(BuildContext context) {
    final gatewayResponse = payment.gatewayResponse;

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        GzCard(
          padding: AppSpacing.md,
          child: Column(
            children: [
              GzMetaRow(
                label: 'Payment ID',
                value: payment.id ?? 'Unavailable',
              ),
              if ((payment.billingId ?? '').isNotEmpty)
                GzMetaRow(label: 'Billing ID', value: payment.billingId!),
              GzMetaRow(label: 'User ID', value: payment.userId ?? 'Guest'),
              GzMetaRow(label: 'Amount', value: _money(payment.amount)),
              GzMetaRow(
                label: 'Method',
                value: payment.method?.name ?? 'Unavailable',
              ),
              GzMetaRow(
                label: 'Status',
                value: payment.status?.name ?? 'Unavailable',
              ),
              GzMetaRow(
                label: 'Transaction ref',
                value: payment.transactionRef ?? 'Unavailable',
              ),
              GzMetaRow(
                label: 'Idempotency key',
                value: payment.idempotencyKey ?? 'Unavailable',
              ),
              GzMetaRow(
                label: 'Gateway ID',
                value: payment.gatewayId ?? 'Unavailable',
              ),
              GzMetaRow(
                label: 'Paid at',
                value: _dateTimeLabel(payment.paidAt),
              ),
              if ((payment.notes ?? '').isNotEmpty)
                GzMetaRow(label: 'Notes', value: payment.notes!),
              GzMetaRow(
                label: 'Created',
                value: _dateTimeLabel(payment.createdAt),
              ),
              GzMetaRow(
                label: 'Updated',
                value: _dateTimeLabel(payment.updatedAt),
              ),
            ],
          ),
        ),
        if (gatewayResponse != null && gatewayResponse.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          GzCard(
            variant: CardVariant.inset,
            padding: AppSpacing.md,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Gateway response', style: AppTypography.h3),
                const SizedBox(height: AppSpacing.sm),
                SelectableText(
                  const JsonEncoder.withIndent('  ').convert(gatewayResponse),
                  style: AppTypography.small,
                ),
              ],
            ),
          ),
        ],
      ],
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
