import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/gz_button.dart';
import '../../../../shared/widgets/gz_card.dart';
import '../../../../shared/widgets/gz_meta_row.dart';
import '../../../../shared/widgets/gz_tag.dart';
import '../../../../shared/widgets/gz_top_bar.dart';

class CampaignDetailScreen extends StatelessWidget {
  const CampaignDetailScreen({super.key, required this.id});

  final String id;

  static const Map<String, _CampaignDetail> _campaigns = {
    'welcome-bonus': _CampaignDetail(
      title: 'Welcome Bonus',
      description: 'Earn 2× credits on your first booking',
      statusKind: GzTagKind.ok,
      statusLabel: 'Active',
      valid: 'Until Dec 31, 2025',
      redeemed: '142 times',
      minBooking: '1 hour',
      steps: [
        'Complete your first booking in the app.',
        'The wallet bonus is added automatically after checkout.',
        'Use the earned credits on your next booking or redemption.',
      ],
    ),
    'happy-hours': _CampaignDetail(
      title: 'Happy Hours',
      description: '50% off all systems 2 PM – 5 PM Mon–Thu',
      statusKind: GzTagKind.ok,
      statusLabel: 'Active',
      valid: 'Ongoing',
      redeemed: '318 times',
      minBooking: '1 hour',
      steps: [
        'Choose a participating slot during the campaign window.',
        'The discount is applied before final payment.',
        'Credits continue to accrue from eligible spend.',
      ],
    ),
    'summer-blast': _CampaignDetail(
      title: 'Summer Blast',
      description: 'Free hour with any 2-hour booking',
      statusKind: GzTagKind.mute,
      statusLabel: 'Expired',
      valid: 'Ended May 1',
      redeemed: '89 times',
      minBooking: '2 hours',
      steps: [
        'Book any qualifying two-hour session.',
        'The extra hour is added in the booking flow.',
        'This campaign is no longer redeemable.',
      ],
    ),
  };

  @override
  Widget build(BuildContext context) {
    final campaign = _campaigns[id] ?? _campaigns['welcome-bonus']!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const GzTopBar(title: 'Campaign detail'),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          children: [
            GzCard(
              variant: CardVariant.tint,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.overlayLight,
                      borderRadius: BorderRadius.circular(
                        AppSpacing.borderRadiusLg,
                      ),
                    ),
                    child: const HugeIcon(
                      icon: HugeIcons.strokeRoundedGift,
                      color: AppColors.textPrimary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(campaign.title, style: AppTypography.h1),
                  const SizedBox(height: 8),
                  GzTag(kind: campaign.statusKind, label: campaign.statusLabel),
                  const SizedBox(height: 10),
                  Text(campaign.description, style: AppTypography.bodyR),
                ],
              ),
            ),
            const SizedBox(height: 16),
            GzCard(
              child: Column(
                children: [
                  GzMetaRow(label: 'Valid', value: campaign.valid),
                  const Divider(height: 1, color: AppColors.divider),
                  GzMetaRow(label: 'Redeemed', value: campaign.redeemed),
                  const Divider(height: 1, color: AppColors.divider),
                  GzMetaRow(label: 'Min. booking', value: campaign.minBooking),
                ],
              ),
            ),
            const SizedBox(height: 22),
            Text('How it works', style: AppTypography.h2),
            const SizedBox(height: 12),
            GzCard(
              child: Column(
                children: List.generate(campaign.steps.length, (index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: index == campaign.steps.length - 1 ? 0 : 14,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 26,
                          height: 26,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.pillBg,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            '${index + 1}',
                            style: AppTypography.num.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              campaign.steps[index],
                              style: AppTypography.bodyR,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 24),
            GzButton(
              label: 'Apply to next booking',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${campaign.title} applied for the next flow.',
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _CampaignDetail {
  const _CampaignDetail({
    required this.title,
    required this.description,
    required this.statusKind,
    required this.statusLabel,
    required this.valid,
    required this.redeemed,
    required this.minBooking,
    required this.steps,
  });

  final String title;
  final String description;
  final GzTagKind statusKind;
  final String statusLabel;
  final String valid;
  final String redeemed;
  final String minBooking;
  final List<String> steps;
}
