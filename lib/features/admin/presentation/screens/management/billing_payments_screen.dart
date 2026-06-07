import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import 'billing_override_sheet.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../shared/widgets/gz_admin_top_bar.dart';
import '../../../../../shared/widgets/gz_button.dart';
import '../../../../../shared/widgets/gz_card.dart';
import '../../../../../shared/widgets/gz_chip.dart';
import '../../../../../shared/widgets/gz_scroll_content.dart';
import '../../../../../shared/widgets/gz_tag.dart';

class BillingPaymentsScreen extends StatelessWidget {
  const BillingPaymentsScreen({super.key});

  static const _filters = ['All', 'Unpaid', 'Paid', 'Overridden'];
  static const _records = [
    _BillingRecordData(
      id: 'BIL-001',
      name: 'Rahul Mehra',
      detail: 'PC Station 01 · 2h 10m',
      amount: '₹1,740',
      tag: GzTagKind.ok,
      tagLabel: 'Paid',
    ),
    _BillingRecordData(
      id: 'BIL-002',
      name: 'Priya Singh',
      detail: 'PS5 Console · 1h 30m',
      amount: '₹1,200',
      tag: GzTagKind.warn,
      tagLabel: 'Unpaid',
      showOverride: true,
    ),
    _BillingRecordData(
      id: 'BIL-003',
      name: 'Amit Kumar',
      detail: 'Xbox Series X · 45m',
      amount: '₹600',
      tag: GzTagKind.mute,
      tagLabel: 'Overridden',
    ),
    _BillingRecordData(
      id: 'BIL-004',
      name: 'Neha Reddy',
      detail: 'VR Pod 01 · 2h 00m',
      amount: '₹3,000',
      tag: GzTagKind.ok,
      tagLabel: 'Paid',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const GzAdminTopBar(title: 'Billing'),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
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
                    child: GzChip(label: _filters[index], active: index == 0),
                  ),
                ),
              ),
            ),
            const Expanded(child: _BillingList(records: _records)),
          ],
        ),
      ),
    );
  }
}

class _BillingList extends StatelessWidget {
  const _BillingList({required this.records});

  final List<_BillingRecordData> records;

  @override
  Widget build(BuildContext context) {
    return GzScrollContent(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          children: records
              .map(
                (record) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _BillingCard(record: record),
                ),
              )
              .toList(),
        ),
      ),
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
