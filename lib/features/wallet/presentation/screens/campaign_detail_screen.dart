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

  static const _campaigns = {
    'welcome-bonus': _CampaignDetailData(
      title: 'Welcome Bonus',
      description: 'Earn 2× credits on your first booking',
      statusKind: GzTagKind.ok,
      statusLabel: 'Active',
      validUntil: 'Until Dec 31, 2025',
      redeemed: '142 times',
      minimumBooking: '1 hour',
      steps: [
        'Book your first session through the app.',
        'The 2× credit bonus is applied automatically after checkout.',
        'Use the extra credits on your next booking or redemption.',
      ],
    ),
    'happy-hours': _CampaignDetailData(
      title: 'Happy Hours',
      description: '50% off all systems 2 PM – 5 PM Mon–Thu',
      statusKind: GzTagKind.ok,
      statusLabel: 'Active',
      validUntil: 'Ongoing',
      redeemed: '318 times',
      minimumBooking: '1 hour',
      steps: [
        'Choose any system during the Happy Hours window.',
        'The offer is applied before payment confirmation.',
        'Discounted sessions still earn standard wallet credits.',
      ],
    ),
    'summer-blast': _CampaignDetailData(
      title: 'Summer Blast',
      description: 'Free hour with any 2-hour booking',
      statusKind: GzTagKind.mute,
      statusLabel: 'Expired',
      validUntil: 'Ended May 1',
      redeemed: '89 times',
      minimumBooking: '2 hours',
      steps: [
        'Book a two-hour session at any participating store.',
        'The bonus hour is added during booking review.',
        'Expired campaigns remain visible for past reference only.',
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
                  GzTag(
                    kind: campaign.statusKind,
                    label: campaign.statusLabel,
                  ),
                  const SizedBox(height: 10),
                  Text(campaign.description, style: AppTypography.bodyR),
                ],
              ),
            ),
            const SizedBox(height: 16),
            GzCard(
              child: Column(
                children: [
                  GzMetaRow(label: 'Valid', value: campaign.validUntil),
                  const Divider(height: 1, color: AppColors.divider),
                  GzMetaRow(label: 'Redeemed', value: campaign.redeemed),
                  const Divider(height: 1, color: AppColors.divider),
                  GzMetaRow(
                    label: 'Min. booking',
                    value: campaign.minimumBooking,
                  ),
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
                          decoration: BoxDecoration(
                            color: AppColors.pillBg,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          alignment: Alignment.center,
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
                  SnackBar(content: Text('${campaign.title} ready for checkout.')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _CampaignDetailData {
  const _CampaignDetailData({
    required this.title,
    required this.description,
    required this.statusKind,
    required this.statusLabel,
    required this.validUntil,
    required this.redeemed,
    required this.minimumBooking,
    required this.steps,
  });

  final String title;
  final String description;
  final GzTagKind statusKind;
  final String statusLabel;
  final String validUntil;
  final String redeemed;
  final String minimumBooking;
  final List<String> steps;
}
