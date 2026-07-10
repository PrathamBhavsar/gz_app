import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/error_snackbar.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/gz_button.dart';
import '../../../../shared/widgets/gz_card.dart';
import '../../../../shared/widgets/gz_meta_row.dart';
import '../../../../shared/widgets/gz_loading_view.dart';
import '../../../../shared/widgets/gz_tag.dart';
import '../../../../shared/widgets/gz_top_bar.dart';
import '../../../../shared/widgets/page_error_display.dart';
import '../../application/campaign_detail_notifier.dart';
import '../../application/wallet_ui_models.dart';

class CampaignDetailScreen extends ConsumerWidget {
  const CampaignDetailScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<CampaignRedeemState>(campaignRedeemNotifierProvider(id), (
      _,
      next,
    ) {
      if (next is CampaignRedeemSuccess) {
        showSuccessSnackbar(context, next.message);
        ref.read(campaignRedeemNotifierProvider(id).notifier).reset();
        if (context.mounted) {
          context.pop();
        }
      } else if (next is CampaignRedeemError) {
        showErrorSnackbar(context, next.error);
        ref.read(campaignRedeemNotifierProvider(id).notifier).reset();
      }
    });

    final detailState = ref.watch(campaignDetailNotifierProvider(id));
    final redeemState = ref.watch(campaignRedeemNotifierProvider(id));
    final isRedeeming = redeemState is CampaignRedeemLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const GzTopBar(title: 'Campaign detail'),
      body: SafeArea(
        top: false,
        child: detailState.when(
          loading: () => const GzLoadingView(),
          error: (error, _) => PageErrorDisplay(
            error: AppPageError.from(error),
            onRetry: () =>
                ref.read(campaignDetailNotifierProvider(id).notifier).refresh(),
          ),
          data: (campaign) {
            final steps = campaignHowItWorks(campaign);
            final canRedeem = campaignCanRedeem(campaign);

            return ListView(
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
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
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
                      Text(
                        campaign.name ?? 'Campaign',
                        style: AppTypography.h1,
                      ),
                      const SizedBox(height: 8),
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
                      if (campaign.description != null &&
                          campaign.description!.trim().isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Text(campaign.description!, style: AppTypography.bodyR),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                GzCard(
                  child: Column(
                    children: [
                      GzMetaRow(
                        label: 'Validity',
                        value: campaignLongValidityLabel(campaign),
                      ),
                      const Divider(height: 1, color: AppColors.divider),
                      GzMetaRow(
                        label: 'Eligibility',
                        value: campaignEligibilityLabel(campaign),
                      ),
                      const Divider(height: 1, color: AppColors.divider),
                      GzMetaRow(
                        label: 'Eligible systems',
                        value: campaignApplicableSystemsLabel(campaign),
                      ),
                      const Divider(height: 1, color: AppColors.divider),
                      GzMetaRow(
                        label: 'Redeemed',
                        value:
                            '${campaign.currentRedemptions ?? 0}${campaign.maxRedemptions != null ? ' / ${campaign.maxRedemptions}' : ''}',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                Text('How it works', style: AppTypography.h2),
                const SizedBox(height: 12),
                GzCard(
                  child: Column(
                    children: List.generate(steps.length, (index) {
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: index == steps.length - 1 ? 0 : 14,
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
                                borderRadius: BorderRadius.circular(
                                  AppSpacing.borderRadiusPill,
                                ),
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
                                  steps[index],
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
                  label: canRedeem ? 'Redeem now' : 'Unavailable',
                  loading: isRedeeming,
                  onPressed: canRedeem && !isRedeeming
                      ? () => ref
                            .read(campaignRedeemNotifierProvider(id).notifier)
                            .redeem()
                      : null,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
