import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/navigation/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../models/domain_loyalty.dart';
import '../../../../models/enums.dart';
import '../../../../shared/widgets/gz_card.dart';
import '../../../../shared/widgets/gz_chip.dart';
import '../../../../shared/widgets/gz_loading_view.dart';
import '../../../../shared/widgets/gz_tag.dart';
import '../../../../shared/widgets/page_error_display.dart';
import '../../application/campaigns_notifier.dart';
import '../../application/wallet_ui_models.dart';

class CampaignsScreen extends ConsumerStatefulWidget {
  const CampaignsScreen({super.key});

  @override
  ConsumerState<CampaignsScreen> createState() => _CampaignsScreenState();
}

class _CampaignsScreenState extends ConsumerState<CampaignsScreen> {
  static const List<String> _filters = [
    'All',
    'Discounts',
    'Bonus credits',
    'Happy hour',
    'First visit',
  ];

  int _selectedFilter = 0;

  List<CampaignModel> _visibleCampaigns(List<CampaignModel> campaigns) {
    return campaigns
        .where((campaign) {
          return switch (_selectedFilter) {
            1 =>
              campaign.campaignType == CampaignType.percentageOff ||
                  campaign.campaignType == CampaignType.fixedOff,
            2 => campaign.campaignType == CampaignType.bonusCredits,
            3 => campaign.campaignType == CampaignType.happyHour,
            4 => campaign.campaignType == CampaignType.firstVisit,
            _ => true,
          };
        })
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    final campaignsState = ref.watch(campaignsNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text('Campaigns', style: AppTypography.h2),
      ),
      body: SafeArea(
        top: false,
        child: campaignsState.when(
          loading: () => const GzLoadingView(),
          error: (error, _) => PageErrorDisplay(
            error: AppPageError.from(error),
            onRetry: () =>
                ref.read(campaignsNotifierProvider.notifier).refresh(),
          ),
          data: (campaigns) {
            if (campaigns.isEmpty) {
              return const PageErrorDisplay(error: AppPageError.empty);
            }
            final visibleCampaigns = _visibleCampaigns(campaigns);
            return Column(
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
                  child: visibleCampaigns.isEmpty
                      ? const PageErrorDisplay(error: AppPageError.empty)
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                          itemCount: visibleCampaigns.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            return _CampaignListCard(
                              campaign: visibleCampaigns[index],
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _CampaignListCard extends StatelessWidget {
  const _CampaignListCard({required this.campaign});

  final CampaignModel campaign;

  @override
  Widget build(BuildContext context) {
    final campaignId = campaign.id;

    final currentRedemptions = campaign.currentRedemptions;
    final maxRedemptions = campaign.maxRedemptions;
    final progress =
        currentRedemptions != null &&
            maxRedemptions != null &&
            maxRedemptions > 0
        ? (currentRedemptions / maxRedemptions).clamp(0, 1).toDouble()
        : null;

    return GestureDetector(
      onTap: campaignId == null || campaignId.isEmpty
          ? null
          : () => context.push(AppRoutes.campaignDetailPath(campaignId)),
      child: GzCard(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
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
                  Text(campaign.name ?? 'Campaign', style: AppTypography.h3),
                  const SizedBox(height: 6),
                  Text(
                    campaign.description ?? campaignBenefitLabel(campaign),
                    style: AppTypography.bodyR,
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      GzTag(
                        kind: campaignTagKind(campaign),
                        label: campaignStatusLabel(campaign),
                      ),
                      GzTag(
                        kind: GzTagKind.info,
                        label: campaignBenefitLabel(campaign),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    campaignValidityLabel(campaign),
                    style: AppTypography.small,
                  ),
                  if (progress != null) ...[
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                      backgroundColor: AppColors.pillBg,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '$currentRedemptions / $maxRedemptions redeemed',
                      style: AppTypography.small,
                    ),
                  ],
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
