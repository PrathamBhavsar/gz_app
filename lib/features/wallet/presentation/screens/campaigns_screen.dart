import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../core/navigation/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/gz_card.dart';
import '../../../../shared/widgets/gz_chip.dart';
import '../../../../shared/widgets/gz_tag.dart';
import '../../../../shared/widgets/gz_top_bar.dart';

class CampaignsScreen extends StatefulWidget {
  const CampaignsScreen({super.key});

  @override
  State<CampaignsScreen> createState() => _CampaignsScreenState();
}

class _CampaignsScreenState extends State<CampaignsScreen> {
  int _selectedFilter = 0;

  static const _filters = ['All', 'Active', 'Expired'];

  static const _campaigns = [
    _CampaignCardData(
      id: 'welcome-bonus',
      title: 'Welcome Bonus',
      description: 'Earn 2× credits on your first booking',
      statusKind: GzTagKind.ok,
      statusLabel: 'Active',
      expiryLabel: 'Expires Dec 31, 2025',
      active: true,
    ),
    _CampaignCardData(
      id: 'happy-hours',
      title: 'Happy Hours',
      description: '50% off all systems 2 PM – 5 PM Mon–Thu',
      statusKind: GzTagKind.ok,
      statusLabel: 'Active',
      expiryLabel: 'Ongoing',
      active: true,
    ),
    _CampaignCardData(
      id: 'summer-blast',
      title: 'Summer Blast',
      description: 'Free hour with any 2-hour booking',
      statusKind: GzTagKind.mute,
      statusLabel: 'Expired',
      expiryLabel: 'Ended May 1',
      active: false,
    ),
  ];

  List<_CampaignCardData> get _visibleCampaigns {
    return switch (_selectedFilter) {
      1 => _campaigns.where((item) => item.active).toList(),
      2 => _campaigns.where((item) => !item.active).toList(),
      _ => _campaigns,
    };
  }

  @override
  Widget build(BuildContext context) {
    final campaigns = _visibleCampaigns;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const GzTopBar(title: 'Campaigns'),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: SizedBox(
                height: 36,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _filters.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    return GzChip(
                      label: _filters[index],
                      active: _selectedFilter == index,
                      onTap: () => setState(() => _selectedFilter = index),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                itemCount: campaigns.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final campaign = campaigns[index];
                  return _CampaignListCard(campaign: campaign);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CampaignListCard extends StatelessWidget {
  const _CampaignListCard({required this.campaign});

  final _CampaignCardData campaign;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.campaignDetailPath(campaign.id)),
      child: GzCard(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.surfaceTint,
                borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
              ),
              child: const HugeIcon(
                icon: HugeIcons.strokeRoundedGift,
                color: AppColors.textPrimary,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(campaign.title, style: AppTypography.h3),
                  const SizedBox(height: 6),
                  Text(campaign.description, style: AppTypography.bodyR),
                  const SizedBox(height: 10),
                  GzTag(
                    kind: campaign.statusKind,
                    label: campaign.statusLabel,
                  ),
                  const SizedBox(height: 10),
                  Text(campaign.expiryLabel, style: AppTypography.small),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Padding(
              padding: EdgeInsets.only(top: 2),
              child: HugeIcon(
                icon: HugeIcons.strokeRoundedArrowRight01,
                color: AppColors.textTertiary,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CampaignCardData {
  const _CampaignCardData({
    required this.id,
    required this.title,
    required this.description,
    required this.statusKind,
    required this.statusLabel,
    required this.expiryLabel,
    required this.active,
  });

  final String id;
  final String title;
  final String description;
  final GzTagKind statusKind;
  final String statusLabel;
  final String expiryLabel;
  final bool active;
}
