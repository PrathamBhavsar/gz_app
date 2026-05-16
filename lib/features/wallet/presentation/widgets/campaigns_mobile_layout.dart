import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/navigation/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../models/domain_loyalty.dart';
import '../../../../models/enums.dart';
import '../../../../shared/widgets/em_top_bar.dart';
import '../../../../shared/widgets/em_tag.dart';
import '../../../../shared/widgets/em_progress_bar.dart';
import '../../../../shared/widgets/em_button.dart';
import '../../../../shared/widgets/em_card.dart';
import '../../../../shared/widgets/page_error_display.dart';
import '../providers/campaigns_notifier.dart';

const _filterOptions = <({String label, CampaignType? value})>[
  (label: 'All', value: null),
  (label: 'Discounts', value: CampaignType.percentageOff),
  (label: 'Bonus Credits', value: CampaignType.bonusCredits),
  (label: 'Happy Hour', value: CampaignType.happyHour),
  (label: 'First Visit', value: CampaignType.firstVisit),
];

class CampaignsMobileLayout extends ConsumerWidget {
  const CampaignsMobileLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(campaignsNotifierProvider);
    final notifier = ref.read(campaignsNotifierProvider.notifier);

    return SafeArea(
      child: Column(
        children: [
          const EmTopBar(title: 'Campaigns'),
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              itemCount: _filterOptions.length,
              separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.xs),
              itemBuilder: (_, i) {
                final opt = _filterOptions[i];
                final selected = state.selectedFilter == opt.value;
                return GestureDetector(
                  onTap: () => notifier.setFilter(opt.value),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.buttonBg : AppColors.surface,
                      borderRadius: BorderRadius.circular(AppSpacing.borderRadiusPill),
                      border: Border.all(
                        color: selected ? AppColors.buttonBg : AppColors.rule,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      opt.label,
                      style: AppTypography.small.copyWith(
                        color: selected ? AppColors.buttonFg : AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            child: state.data.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => PageErrorDisplay(
                error: AppPageError.from(e),
                onRetry: notifier.refresh,
              ),
              data: (_) {
                final campaigns = state.filtered;
                if (campaigns.isEmpty) {
                  return _EmptyState(
                    message: state.selectedFilter == null
                        ? 'No active campaigns at this store'
                        : 'No campaigns in this category',
                  );
                }
                return RefreshIndicator(
                  onRefresh: notifier.refresh,
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(
                        AppSpacing.md, AppSpacing.xs, AppSpacing.md, AppSpacing.lg),
                    itemCount: campaigns.length,
                    separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (_, i) => _CampaignCard(
                      campaign: campaigns[i],
                      onTap: () {
                        final id = campaigns[i].id ?? '';
                        context.push(
                          AppRoutes.campaignDetail.replaceAll(':id', id),
                          extra: campaigns[i],
                        );
                      },
                    )
                        .animate(delay: (i * 60).ms)
                        .fadeIn(duration: 220.ms)
                        .slideY(begin: 0.05, end: 0, duration: 220.ms),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CampaignCard extends StatelessWidget {
  const _CampaignCard({required this.campaign, required this.onTap});
  final CampaignModel campaign;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final hasProgress = (campaign.maxRedemptions ?? 0) > 0;
    final progress = hasProgress
        ? ((campaign.currentRedemptions ?? 0) / campaign.maxRedemptions!).clamp(0.0, 1.0)
        : 0.0;

    return EmCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.surfaceTint,
                  borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
                ),
                child: const Center(
                  child: HugeIcon(
                    icon: HugeIcons.strokeRoundedGift,
                    color: AppColors.ok,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      campaign.name ?? 'Campaign',
                      style: AppTypography.h3,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    EmTag(
                      kind: _tagKindFor(campaign.campaignType),
                      label: _typeLabel(campaign.campaignType),
                    ),
                  ],
                ),
              ),
              EmButton(
                label: 'View',
                small: true,
                variant: EmButtonVariant.ghost,
                onPressed: onTap,
              ),
            ],
          ),
          if (campaign.description != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(campaign.description!, style: AppTypography.small),
          ],
          if (campaign.validUntil != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Valid until ${_dateLabel(campaign.validUntil!)}',
              style: AppTypography.small.copyWith(color: AppColors.textTertiary),
            ),
          ],
          if (hasProgress) ...[
            const SizedBox(height: AppSpacing.sm),
            EmProgressBar(
              value: progress,
              height: 4,
              fillColor: AppColors.warn,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              '${campaign.currentRedemptions} / ${campaign.maxRedemptions} redeemed',
              style: AppTypography.small.copyWith(color: AppColors.textTertiary),
            ),
          ],
        ],
      ),
    );
  }

  static EmTagKind _tagKindFor(CampaignType? type) => switch (type) {
        CampaignType.percentageOff || CampaignType.fixedOff => EmTagKind.ok,
        CampaignType.bonusCredits || CampaignType.bonusMinutes => EmTagKind.purple,
        CampaignType.happyHour => EmTagKind.warn,
        CampaignType.firstVisit => EmTagKind.info,
        null => EmTagKind.mute,
      };

  static String _typeLabel(CampaignType? type) => switch (type) {
        CampaignType.percentageOff => 'Discount',
        CampaignType.fixedOff => 'Fixed Off',
        CampaignType.bonusCredits => 'Bonus Credits',
        CampaignType.bonusMinutes => 'Bonus Time',
        CampaignType.happyHour => 'Happy Hour',
        CampaignType.firstVisit => 'First Visit',
        null => 'Campaign',
      };

  static String _dateLabel(DateTime dt) {
    const m = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${dt.day} ${m[dt.month - 1]} ${dt.year}';
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Center(
        child: EmCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  color: AppColors.pillBg,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: HugeIcon(
                    icon: HugeIcons.strokeRoundedGift,
                    color: AppColors.textTertiary,
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              const Text('No campaigns', style: AppTypography.h2),
              const SizedBox(height: AppSpacing.xs),
              Text(message, style: AppTypography.bodyR, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
