import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../models/domain_loyalty.dart';
import '../../../../models/enums.dart';
import '../../../../shared/widgets/em_top_bar.dart';
import '../../../../shared/widgets/em_scroll_content.dart';
import '../../../../shared/widgets/em_card.dart';
import '../../../../shared/widgets/em_tag.dart';
import '../../../../shared/widgets/em_button.dart';
import '../../../../shared/widgets/em_chip.dart';
import '../providers/campaign_detail_notifier.dart';
import '../providers/campaigns_notifier.dart';

class CampaignDetailMobileLayout extends ConsumerWidget {
  const CampaignDetailMobileLayout({
    super.key,
    required this.id,
    this.campaign,
  });

  final String id;
  final CampaignModel? campaign;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailState = ref.watch(campaignDetailNotifierProvider(id));
    final campaignsState = ref.watch(campaignsNotifierProvider);
    final notifier = ref.read(campaignDetailNotifierProvider(id).notifier);

    // Resolve campaign: prefer passed-in, fall back to provider lookup
    final c = campaign ??
        campaignsState.data.asData?.value.cast<CampaignModel?>().firstWhere(
              (x) => x?.id == id,
              orElse: () => null,
            );

    if (c == null) {
      return SafeArea(
        child: Column(
          children: [
            const EmTopBar(title: 'Campaign'),
            const Expanded(
              child: Center(child: CircularProgressIndicator()),
            ),
          ],
        ),
      );
    }

    ref.listen(campaignDetailNotifierProvider(id), (_, next) {
      if (next is CampaignDetailSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Campaign redeemed!')),
        );
      } else if (next is CampaignDetailError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text((next).message),
            backgroundColor: AppColors.err,
          ),
        );
      }
    });

    final isLoading = detailState is CampaignDetailLoading;
    final alreadyRedeemed = detailState is CampaignDetailSuccess;

    return SafeArea(
      child: Column(
        children: [
          EmTopBar(title: c.name ?? 'Campaign'),
          EmScrollContent(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md, 0, AppSpacing.md, AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Banner placeholder
                  Container(
                    height: 160,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceTint,
                      borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
                    ),
                    alignment: Alignment.center,
                    child: EmTag(
                      kind: _tagKindFor(c.campaignType),
                      label: _typeLabel(c.campaignType),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Name + type
                  Row(
                    children: [
                      Expanded(
                        child: Text(c.name ?? 'Campaign', style: AppTypography.h1),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      EmTag(
                        kind: _tagKindFor(c.campaignType),
                        label: _typeLabel(c.campaignType),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Description + terms
                  if (c.description != null || c.terms != null)
                    EmCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (c.description != null)
                            Text(c.description!, style: AppTypography.bodyR),
                          if (c.description != null && c.terms != null)
                            const SizedBox(height: AppSpacing.sm),
                          if (c.terms != null) ...[
                            Text('TERMS',
                                style: AppTypography.meta.copyWith(
                                    color: AppColors.textTertiary)),
                            const SizedBox(height: AppSpacing.xs),
                            Text(c.terms!, style: AppTypography.bodyR),
                          ],
                        ],
                      ),
                    ),
                  const SizedBox(height: AppSpacing.sm),

                  // Validity + time restrictions
                  EmCard(
                    variant: CardVariant.inset,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (c.validFrom != null)
                          _InfoRow(
                              label: 'Start',
                              value: _dateLabel(c.validFrom!)),
                        if (c.validUntil != null)
                          _InfoRow(
                              label: 'Expires',
                              value: _dateLabel(c.validUntil!)),
                        if (c.applicableSystemTypes != null &&
                            c.applicableSystemTypes!.isNotEmpty) ...[
                          const SizedBox(height: AppSpacing.xs),
                          Wrap(
                            spacing: AppSpacing.xs,
                            children: c.applicableSystemTypes!
                                .map((s) => EmChip(value: s))
                                .toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // Eligibility
                  EmCard(
                    variant: CardVariant.inset,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (c.minTier != null)
                          _InfoRow(
                              label: 'Min tier', value: 'Tier ${c.minTier}'),
                        if (c.maxPerUser != null)
                          _InfoRow(
                              label: 'Per user',
                              value: 'Max ${c.maxPerUser} use(s)'),
                        if (c.maxRedemptions != null) ...[
                          _InfoRow(
                              label: 'Total',
                              value:
                                  '${c.currentRedemptions ?? 0} / ${c.maxRedemptions} redeemed'),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // Benefit summary
                  EmCard(
                    variant: CardVariant.tint,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('BENEFIT',
                            style: AppTypography.meta
                                .copyWith(color: AppColors.textSecondary)),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          _benefitSummary(c),
                          style: AppTypography.h1,
                        ),
                      ],
                    ),
                  ),
                  if (alreadyRedeemed) ...[
                    const SizedBox(height: AppSpacing.sm),
                    const EmTag(kind: EmTagKind.mute, label: 'Redeemed'),
                  ],
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          ),

          // Sticky CTA
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.md),
            child: EmButtonFull(
              label: alreadyRedeemed ? 'Redeemed' : 'Redeem Now',
              loading: isLoading,
              onPressed: (isLoading || alreadyRedeemed) ? null : notifier.redeem,
            ),
          ),
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

  static String _benefitSummary(CampaignModel c) {
    final val = c.value;
    if (val == null) return 'Special offer';
    return switch (c.campaignType) {
      CampaignType.percentageOff => '${val.toStringAsFixed(0)}% off',
      CampaignType.fixedOff => '₹${val.toStringAsFixed(0)} off',
      CampaignType.bonusCredits => '+${val.toStringAsFixed(0)} credits',
      CampaignType.bonusMinutes => '+${val.toStringAsFixed(0)} minutes free',
      CampaignType.happyHour => '${val.toStringAsFixed(0)}% off',
      CampaignType.firstVisit => '₹${val.toStringAsFixed(0)} off first visit',
      null => 'Special offer',
    };
  }

  static String _dateLabel(DateTime dt) {
    const m = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${dt.day} ${m[dt.month - 1]} ${dt.year}';
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        children: [
          Text(label, style: AppTypography.small),
          const SizedBox(width: AppSpacing.sm),
          Text(value,
              style: AppTypography.small.copyWith(
                  color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
