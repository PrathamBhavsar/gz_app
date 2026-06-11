import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/errors/app_exception.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../models/domain_billing.dart';
import '../../../../../shared/widgets/gz_admin_top_bar.dart';
import '../../../../../shared/widgets/gz_button.dart';
import '../../../../../shared/widgets/gz_card.dart';
import '../../../../../shared/widgets/gz_chip.dart';
import '../../../../../shared/widgets/gz_loading_view.dart';
import '../../../../../shared/widgets/gz_tag.dart';
import '../../../../../shared/widgets/page_error_display.dart';
import '../../../application/admin_billing_notifier.dart';
import '../../../application/admin_management_models.dart';
import 'billing_override_sheet.dart';

class BillingPaymentsScreen extends ConsumerWidget {
  const BillingPaymentsScreen({super.key});

  static const _filters = ['All', 'Unpaid', 'Paid', 'Overridden'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final billingState = ref.watch(adminBillingNotifierProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const GzAdminTopBar(title: 'Billing'),
      body: billingState.when(
        loading: () => const GzLoadingView(message: 'Loading billing'),
        error: (error, _) => PageErrorDisplay(
          error: AppPageError.from(error),
          onRetry: () =>
              ref.read(adminBillingNotifierProvider.notifier).refresh(),
        ),
        data: (data) {
          final records = _filteredRecords(data);
          return SafeArea(
            top: false,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                  child: _BillingSummary(data: data),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                  child: Row(
                    children: List.generate(
                      _filters.length,
                      (index) => Padding(
                        padding: EdgeInsets.only(
                          right: index == _filters.length - 1 ? 0 : 8,
                        ),
                        child: GzChip(
                          label: _filters[index],
                          active: _filters[index] == data.selectedFilter,
                          onTap: () => ref
                              .read(adminBillingNotifierProvider.notifier)
                              .selectFilter(_filters[index]),
                        ),
                      ),
                    ),
                  ),
                ),
                const Divider(height: 1, color: AppColors.rule),
                Expanded(
                  child: records.isEmpty
                      ? const PageErrorDisplay(error: AppPageError.empty)
                      : RefreshIndicator(
                          onRefresh: () => ref
                              .read(adminBillingNotifierProvider.notifier)
                              .refresh(),
                          child: ListView.separated(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                            itemBuilder: (context, index) =>
                                _BillingCard(record: records[index]),
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: 10),
                            itemCount: records.length,
                          ),
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<_BillingRecordData> _filteredRecords(AdminBillingData data) {
    final paymentByBillingId = <String, PaymentModel>{};
    for (final payment in data.payments) {
      final billingId = payment.billingId;
      if (billingId != null && billingId.isNotEmpty) {
        paymentByBillingId[billingId] = payment;
      }
    }

    return data.ledger
        .map((ledger) {
          final payment = paymentByBillingId[ledger.id];
          final isOverridden = (ledger.notes ?? '').toLowerCase().contains(
            'override',
          );
          final tagLabel = isOverridden
              ? 'Overridden'
              : _paymentStatusLabel(payment?.status?.name);
          final tag = isOverridden
              ? GzTagKind.mute
              : _paymentStatusKind(payment?.status?.name);

          return _BillingRecordData(
            id: ledger.id ?? '',
            name: ledger.userId ?? 'Player',
            detail:
                '${ledger.systemId ?? 'System'} · ${_durationLabel(ledger.billedMinutes)}',
            amount: _money(ledger.netAmount ?? ledger.grossAmount),
            tag: tag,
            tagLabel: tagLabel,
            showOverride: !isOverridden && payment?.status?.name != 'completed',
          );
        })
        .where((record) {
          switch (data.selectedFilter) {
            case 'Paid':
              return record.tagLabel == 'Paid';
            case 'Unpaid':
              return record.tagLabel == 'Unpaid';
            case 'Overridden':
              return record.tagLabel == 'Overridden';
            default:
              return true;
          }
        })
        .toList(growable: false);
  }
}

class _BillingSummary extends StatelessWidget {
  const _BillingSummary({required this.data});

  final AdminBillingData data;

  @override
  Widget build(BuildContext context) {
    final summary = data.summary;
    final reconciliation = data.reconciliation;
    return Row(
      children: [
        Expanded(
          child: GzCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Net Revenue', style: AppTypography.small),
                const SizedBox(height: 4),
                Text(
                  _money(double.tryParse(summary?.totalNetRevenue ?? '')),
                  style: AppTypography.h2,
                ),
                const SizedBox(height: 2),
                Text(
                  '${summary?.totalSessions ?? 0} sessions',
                  style: AppTypography.small,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: GzCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Matched Payments', style: AppTypography.small),
                const SizedBox(height: 4),
                Text(
                  '${reconciliation?.matchedPayments ?? 0}',
                  style: AppTypography.h2,
                ),
                const SizedBox(height: 2),
                Text(
                  '${reconciliation?.outstandingItems ?? 0} outstanding',
                  style: AppTypography.small,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _BillingCard extends StatelessWidget {
  const _BillingCard({required this.record});

  final _BillingRecordData record;

  @override
  Widget build(BuildContext context) {
    return GzCard(
      padding: 14,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(record.name, style: AppTypography.h3)),
              GzTag(kind: record.tag, label: record.tagLabel),
            ],
          ),
          const SizedBox(height: 4),
          Text(record.detail, style: AppTypography.small),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                record.amount,
                style: AppTypography.num.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              if (record.showOverride)
                SizedBox(
                  width: 104,
                  child: GzButton(
                    label: 'Override',
                    variant: GzButtonVariant.ghost,
                    small: true,
                    onPressed: () => showBillingOverrideSheet(
                      context,
                      billingId: record.id,
                      playerName: record.name,
                      originalAmount: record.amount,
                      description: record.detail,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BillingRecordData {
  const _BillingRecordData({
    required this.id,
    required this.name,
    required this.detail,
    required this.amount,
    required this.tag,
    required this.tagLabel,
    this.showOverride = false,
  });

  final String id;
  final String name;
  final String detail;
  final String amount;
  final GzTagKind tag;
  final String tagLabel;
  final bool showOverride;
}

String _paymentStatusLabel(String? status) {
  switch (status) {
    case 'completed':
      return 'Paid';
    case 'refunded':
      return 'Overridden';
    default:
      return 'Unpaid';
  }
}

GzTagKind _paymentStatusKind(String? status) {
  switch (status) {
    case 'completed':
      return GzTagKind.ok;
    case 'refunded':
      return GzTagKind.mute;
    default:
      return GzTagKind.warn;
  }
}

String _durationLabel(int? minutes) {
  if (minutes == null || minutes <= 0) {
    return 'Duration unavailable';
  }
  final hours = minutes ~/ 60;
  final remainder = minutes % 60;
  if (hours == 0) {
    return '${remainder}m';
  }
  return '${hours}h ${remainder}m';
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
