import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../shared/widgets/gz_admin_top_bar.dart';
import '../../../../../shared/widgets/gz_button.dart';
import '../../../../../shared/widgets/gz_card.dart';
import '../../../../../shared/widgets/gz_meta_row.dart';
import '../../../../../shared/widgets/gz_scroll_content.dart';
import '../../../../../shared/widgets/gz_tag.dart';
import 'cancel_booking_sheet.dart';

class AdminBookingDetailScreen extends StatelessWidget {
  const AdminBookingDetailScreen({super.key, required this.id});

  final String id;

  static const _status = GzTagKind.ok;
  static const _statusLabel = 'Paid';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: GzAdminTopBar(
        title: 'Booking Detail',
        onBack: () => context.pop(),
      ),
      body: GzScrollContent(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section 1 — Status banner
              const Center(
                child: GzTag(kind: _status, label: _statusLabel),
              ),
              const SizedBox(height: 20),

              // Section 2 — Player info card
              GzCard(
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceTint,
                        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusPill),
                      ),
                      alignment: Alignment.center,
                      child: const Text('R', style: AppTypography.h3),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Rahul Mehra', style: AppTypography.h3),
                        SizedBox(height: 2),
                        Text('+91 98765 43210', style: AppTypography.bodyR),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Section 3 — Booking info card
              const GzCard(
                child: Column(
                  children: [
                    GzMetaRow(label: 'System', value: 'PC Station 01'),
                    GzMetaRow(label: 'Date', value: 'Wed, 4 Jun 2025'),
                    GzMetaRow(label: 'Time', value: '09:00 – 11:00'),
                    GzMetaRow(label: 'Duration', value: '2 hours'),
                    GzMetaRow(label: 'Rate', value: '₹80/hr'),
                    GzMetaRow(label: 'Total', value: '₹160', valueBold: true),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Section 4 — Payment card
              const GzCard(
                child: Column(
                  children: [
                    GzMetaRow(label: 'Method', value: 'UPI'),
                    GzMetaRow(label: 'Status', value: 'Paid'),
                    GzMetaRow(label: 'Reference', value: 'PAY-8821'),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Section 5 — Actions
              GzButton(
                label: 'Check In',
                variant: GzButtonVariant.primary,
                onPressed: () {},
              ),
              const SizedBox(height: 10),
              GzButton(
                label: 'Cancel Booking',
                variant: GzButtonVariant.dangerOutline,
                onPressed: () => showAdminCancelBookingSheet(context, id: id),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
