import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../core/navigation/routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../shared/widgets/gz_button.dart';
import '../../../../../shared/widgets/gz_card.dart';
import '../../../../../shared/widgets/gz_meta_row.dart';
import '../../../../../shared/widgets/gz_top_bar.dart';

class BookingSummaryScreen extends StatelessWidget {
  const BookingSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const GzTopBar(title: 'Booking summary'),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
              child: Column(
                children: const [
                  _SystemInfoCard(),
                  SizedBox(height: 12),
                  _SessionDetailsCard(),
                  SizedBox(height: 12),
                  _CostBreakdownCard(),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 16 + bottomInset),
            decoration: const BoxDecoration(
              color: AppColors.background,
              border: Border(top: BorderSide(color: AppColors.divider)),
            ),
            child: GzButton(
              label: 'Confirm booking',
              onPressed: () => context.go(AppRoutes.bookSuccess),
            ),
          ),
        ],
      ),
    );
  }
}

class _SystemInfoCard extends StatelessWidget {
  const _SystemInfoCard();

  @override
  Widget build(BuildContext context) {
    return GzCard(
      padding: 16,
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: AppColors.buttonBg,
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
            ),
            child: const Center(
              child: HugeIcon(
                icon: HugeIcons.strokeRoundedComputerDesk01,
                color: AppColors.buttonFg,
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('RTX 4090 Gaming PC', style: AppTypography.h2),
                const SizedBox(height: 4),
                Text(
                  'Seat 3',
                  style: AppTypography.small.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'GameZone Koramangala',
                  style: AppTypography.small.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SessionDetailsCard extends StatelessWidget {
  const _SessionDetailsCard();

  @override
  Widget build(BuildContext context) {
    return GzCard(
      padding: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Session details', style: AppTypography.h3),
          SizedBox(height: 10),
          GzMetaRow(label: 'Date', value: 'Wed, 4 Jun'),
          GzMetaRow(label: 'Time', value: '6:00 PM – 8:00 PM'),
          GzMetaRow(label: 'Duration', value: '2 hours'),
          GzMetaRow(label: 'Rate', value: '₹80/hr'),
        ],
      ),
    );
  }
}

class _CostBreakdownCard extends StatelessWidget {
  const _CostBreakdownCard();

  @override
  Widget build(BuildContext context) {
    return GzCard(
      padding: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Cost breakdown', style: AppTypography.h3),
          const SizedBox(height: 10),
          const GzMetaRow(label: 'Session', value: '₹160'),
          const GzMetaRow(label: 'Convenience fee', value: '₹0'),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Divider(height: 1, color: AppColors.rule),
          ),
          GzMetaRow(
            label: 'Total',
            value: '₹160',
            valueBold: true,
            valueStyle: AppTypography.num.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
