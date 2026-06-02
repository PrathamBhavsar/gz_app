import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../shared/widgets/gz_admin_top_bar.dart';
import '../../../../../shared/widgets/gz_button.dart';
import '../../../../../shared/widgets/gz_card.dart';
import '../../../../../shared/widgets/gz_meta_row.dart';
import '../../../../../shared/widgets/gz_scroll_content.dart';
import '../../../../../shared/widgets/gz_tag.dart';

class CampaignManagementScreen extends StatelessWidget {
  const CampaignManagementScreen({super.key});

  static const _campaigns = [
    _CampaignData(
      name: 'Welcome Bonus',
      description: 'Earn 2× credits on first booking',
      redemptions: '142',
      expires: 'Dec 31, 2025',
      tag: GzTagKind.ok,
      tagLabel: 'Active',
    ),
    _CampaignData(
      name: 'Happy Hours',
      description: '50% off 2–5 PM Mon–Thu',
      redemptions: '89',
      expires: 'Dec 31, 2025',
      tag: GzTagKind.ok,
      tagLabel: 'Active',
    ),
    _CampaignData(
      name: 'Summer Blast',
      description: 'Free hour with 2-hour booking',
      redemptions: '234',
      expires: 'Sep 30, 2025',
      tag: GzTagKind.mute,
      tagLabel: 'Paused',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const GzAdminTopBar(title: 'Campaigns'),
      body: SafeArea(
        top: false,
        child: GzScrollContent(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: Column(
              children: _campaigns
                  .map(
                    (campaign) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _CampaignCard(campaign: campaign),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class _CampaignCard extends StatelessWidget {
  const _CampaignCard({required this.campaign});

  final _CampaignData campaign;

  @override
  Widget build(BuildContext context) {
    return GzCard(
      padding: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(campaign.name, style: AppTypography.h3)),
              GzTag(kind: campaign.tag, label: campaign.tagLabel),
            ],
          ),
          const SizedBox(height: 6),
          Text(campaign.description, style: AppTypography.small),
          const SizedBox(height: 10),
          GzMetaRow(label: 'Redemptions', value: campaign.redemptions),
          GzMetaRow(label: 'Expires', value: campaign.expires),
          const SizedBox(height: 12),
          const Row(
            children: [
              Expanded(
                child: GzButton(
                  label: 'Pause',
                  variant: GzButtonVariant.ghost,
                  small: true,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: GzButton(
                  label: 'Edit',
                  variant: GzButtonVariant.ghost,
                  small: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CampaignData {
  const _CampaignData({
    required this.name,
    required this.description,
    required this.redemptions,
    required this.expires,
    required this.tag,
    required this.tagLabel,
  });

  final String name;
  final String description;
  final String redemptions;
  final String expires;
  final GzTagKind tag;
  final String tagLabel;
}
