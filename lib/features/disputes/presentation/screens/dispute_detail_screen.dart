import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/gz_button.dart';
import '../../../../shared/widgets/gz_card.dart';
import '../../../../shared/widgets/gz_collapse.dart';
import '../../../../shared/widgets/gz_meta_row.dart';
import '../../../../shared/widgets/gz_tag.dart';
import '../../../../shared/widgets/gz_top_bar.dart';

class DisputeDetailScreen extends StatelessWidget {
  const DisputeDetailScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: GzTopBar(title: 'Dispute #$id'),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            const GzCard(
              child: _StatusCard(),
            ),
            const SizedBox(height: AppSpacing.md),
            GzCollapse(
              title: 'Timeline',
              initiallyOpen: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Jun 02 09:41 · Dispute filed', style: AppTypography.body),
                  const SizedBox(height: AppSpacing.sm),
                  Text('Jun 02 11:00 · Under review', style: AppTypography.body),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            const GzCard(
              child: Column(
                children: [
                  GzMetaRow(label: 'Session', value: 'GZ-2406-4891'),
                  GzMetaRow(label: 'Amount', value: '₹1,740'),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            GzButton(
              label: 'Add comment',
              variant: GzButtonVariant.ghost,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Comment composer is not part of this phase.')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const GzTag(kind: GzTagKind.err, label: 'Open'),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            'Overcharged for session duration',
            style: AppTypography.h3,
          ),
        ),
      ],
    );
  }
}
