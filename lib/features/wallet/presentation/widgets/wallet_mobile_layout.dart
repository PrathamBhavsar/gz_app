import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/auth/token_storage.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/navigation/routes.dart';
import 'package:gz_app/features/notifications/presentation/widgets/notification_center_sheet.dart';
import 'package:gz_app/shared/widgets/connectivity_banner.dart';
import 'package:gz_app/shared/widgets/store_selector_sheet.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../models/domain_loyalty.dart';
import '../../../../models/enums.dart';
import '../../../../shared/widgets/em_card.dart';
import '../../../../shared/widgets/em_icon_btn.dart';
import '../../../../shared/widgets/em_progress_bar.dart';
import '../../../../shared/widgets/em_scroll_content.dart';
import '../../../../shared/widgets/em_section_head.dart';
import '../../../../shared/widgets/em_store_selector_pill.dart';
import '../../../../shared/widgets/em_tag.dart';
import '../../../../shared/widgets/em_chip.dart';
import '../../../../shared/widgets/page_error_display.dart';
import '../providers/wallet_notifier.dart';
import 'redeem_credits_sheet.dart';

class WalletMobileLayout extends ConsumerWidget {
  const WalletMobileLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storeId = ref.watch(activeStoreIdProvider);
    final walletState = ref.watch(walletNotifierProvider);

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.md, AppSpacing.xs, AppSpacing.md, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Wallet', style: AppTypography.title),
                EmIconBtn(
                  tooltip: 'Notifications',
                  onTap: () => showNotificationCenter(context),
                  child: const HugeIcon(
                    icon: HugeIcons.strokeRoundedNotification01,
                    color: AppColors.textPrimary,
                    size: 22,
                  ),
                ),
              ],
            ),
          ),

          // ── Store selector ──
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.md, AppSpacing.sm, AppSpacing.md, 0),
            child: EmStoreSelectorPill(
              storeName: storeId ?? 'Select Store',
              onTap: () => showStoreSelectorSheet(context),
            ),
          ),

          const ConnectivityBanner(),
          if (storeId == null)
            Expanded(
              child: Center(
                child: EmCard(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const HugeIcon(
                        icon: HugeIcons.strokeRoundedStore01,
                        color: AppColors.textTertiary,
                        size: 32,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Select a store to view your wallet',
                        style: AppTypography.bodyR,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            Expanded(
              child: walletState.when(
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (e, _) => PageErrorDisplay(
                  error: AppPageError.from(e),
                  onRetry: () =>
                      ref.read(walletNotifierProvider.notifier).refresh(),
                ),
                data: (data) => _WalletContent(
                  data: data,
                  storeId: storeId,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _WalletContent extends ConsumerWidget {
  const _WalletContent({required this.data, required this.storeId});
  final WalletData data;
  final String storeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balance = data.balance.availableBalance ?? data.balance.currentBalance ?? 0;
    final balanceInt = balance.toInt();
    final rupees = (balance / 10).toStringAsFixed(2);
    final txList = data.recentTransactions.take(3).toList();
    final campaigns = data.campaigns;

    return RefreshIndicator(
      onRefresh: () => ref.read(walletNotifierProvider.notifier).refresh(),
      child: EmScrollContent(
        padded: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Hero credit card ──
              EmCard(
                variant: CardVariant.tint,
                padding: 22,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('YOUR CREDITS',
                        style: AppTypography.meta
                            .copyWith(color: AppColors.textSecondary)),
                    const SizedBox(height: 14),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text('$balanceInt', style: AppTypography.hero),
                        const SizedBox(width: 10),
                        const Text('credits', style: AppTypography.bodyR),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text('= ₹$rupees in-store value',
                        style: AppTypography.bodyR),
                    Container(
                      height: 1,
                      color: AppColors.rule,
                      margin: const EdgeInsets.symmetric(
                          vertical: AppSpacing.md),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Valid at this store only',
                            style: AppTypography.small
                                .copyWith(color: AppColors.textSecondary),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _showEarnInfo(context),
                          child: Text(
                            'How do I earn more?',
                            style: AppTypography.small.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // ── Quick actions ──
              Row(
                children: [
                  Expanded(
                    child: _QuickAction(
                      icon: HugeIcons.strokeRoundedCoins01,
                      label: 'Redeem',
                      onTap: () =>
                          showRedeemCreditsSheet(context, balance),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: _QuickAction(
                      icon: HugeIcons.strokeRoundedListView,
                      label: 'History',
                      onTap: () => context.push(AppRoutes.creditHistory),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: _QuickAction(
                      icon: HugeIcons.strokeRoundedGift,
                      label: 'Campaigns',
                      onTap: () => context.push(AppRoutes.campaigns),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // ── Recent transactions ──
              EmCard(
                padding: 0,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                          AppSpacing.md,
                          AppSpacing.md,
                          AppSpacing.md,
                          AppSpacing.sm),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Recent', style: AppTypography.h2),
                          GestureDetector(
                            onTap: () =>
                                context.push(AppRoutes.creditHistory),
                            child: Text(
                              'See all →',
                              style: AppTypography.small.copyWith(
                                color: AppColors.textTertiary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (txList.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Text('No transactions yet',
                            style: AppTypography.bodyR),
                      )
                    else
                      ...txList.asMap().entries.map(
                            (e) => _TxRow(tx: e.value, first: e.key == 0),
                          ),
                    const SizedBox(height: AppSpacing.sm),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // ── Active campaigns ──
              if (campaigns.isNotEmpty) ...[
                EmSectionHead(
                  'Active Campaigns',
                  subtitle: '${campaigns.length}',
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: campaigns
                        .take(5)
                        .map((c) => Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: _CampCard(
                                campaign: c,
                                onTap: () {
                                  context.push(
                                    AppRoutes.campaignDetailPath(c.id ?? ''),
                                    extra: c,
                                  );
                                },
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  static void _showEarnInfo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 38,
                height: 4,
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  color: AppColors.rule,
                  borderRadius:
                      BorderRadius.circular(AppSpacing.borderRadiusPill),
                ),
              ),
            ),
            const Text('How to earn credits', style: AppTypography.h1),
            const SizedBox(height: 14),
            ...[
              ('40 / hr', 'Completing booked sessions'),
              ('200', 'First-time booking at any store'),
              ('500', 'When a referred friend books'),
              ('2×', 'During Double Credits weekends'),
            ].asMap().entries.map(
                  (e) => Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      border: e.key == 0
                          ? null
                          : Border(
                              top: BorderSide(
                                  color: AppColors.rule)),
                    ),
                    child: Row(
                      children: [
                        EmChip(value: e.value.$1),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(e.value.$2,
                              style: AppTypography.body),
                        ),
                      ],
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    this.onTap,
  });
  final dynamic icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
              vertical: 14, horizontal: AppSpacing.sm),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius:
                BorderRadius.circular(AppSpacing.borderRadiusLg),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              HugeIcon(
                  icon: icon,
                  color: AppColors.textPrimary,
                  size: 20),
              const SizedBox(height: 6),
              Text(
                label,
                style: AppTypography.small.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      );
}

class _TxRow extends StatelessWidget {
  const _TxRow({required this.tx, required this.first});
  final CreditLedgerModel tx;
  final bool first;

  @override
  Widget build(BuildContext context) {
    final isCredit = tx.transactionType == CreditTransactionType.earned ||
        tx.transactionType == CreditTransactionType.bonus ||
        tx.transactionType == CreditTransactionType.refund;
    final bg = isCredit ? AppColors.okBg : AppColors.errBg;
    final fg = isCredit ? AppColors.ok : AppColors.err;
    final sign = isCredit ? '+' : '−';
    final amt = tx.amount?.abs().toStringAsFixed(0) ?? '0';
    final desc = tx.description ?? _labelFor(tx.transactionType);
    final sub = _dateLabel(tx.createdAt);
    final icon = _iconFor(tx.transactionType);

    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: 12),
      decoration: BoxDecoration(
        border: first
            ? null
            : Border(top: BorderSide(color: AppColors.rule)),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration:
                BoxDecoration(color: bg, shape: BoxShape.circle),
            child: Center(
              child: HugeIcon(icon: icon, color: fg, size: 16),
            ),
          ),
          const SizedBox(width: AppSpacing.sm + AppSpacing.xs),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  desc,
                  style: AppTypography.body
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 1),
                Text(sub, style: AppTypography.small),
              ],
            ),
          ),
          Text(
            '$sign$amt',
            style: AppTypography.num.copyWith(
              fontWeight: FontWeight.w700,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }

  static dynamic _iconFor(CreditTransactionType? type) => switch (type) {
        CreditTransactionType.earned => HugeIcons.strokeRoundedStar,
        CreditTransactionType.redeemed => HugeIcons.strokeRoundedArrowUp01,
        CreditTransactionType.bonus => HugeIcons.strokeRoundedGift,
        CreditTransactionType.adminAdjust =>
          HugeIcons.strokeRoundedSettings01,
        CreditTransactionType.expired => HugeIcons.strokeRoundedClock01,
        CreditTransactionType.refund => HugeIcons.strokeRoundedArrowLeft01,
        null => HugeIcons.strokeRoundedCoins01,
      };

  static String _labelFor(CreditTransactionType? type) => switch (type) {
        CreditTransactionType.earned => 'Credits earned',
        CreditTransactionType.redeemed => 'Credits redeemed',
        CreditTransactionType.bonus => 'Bonus credits',
        CreditTransactionType.adminAdjust => 'Admin adjustment',
        CreditTransactionType.expired => 'Credits expired',
        CreditTransactionType.refund => 'Refund',
        null => 'Transaction',
      };

  static String _dateLabel(DateTime? dt) {
    if (dt == null) return '';
    const m = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${dt.day} ${m[dt.month - 1]} ${dt.year}';
  }
}

class _CampCard extends StatelessWidget {
  const _CampCard({required this.campaign, required this.onTap});
  final CampaignModel campaign;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final hasProgress = (campaign.maxRedemptions ?? 0) > 0;
    final progress = hasProgress
        ? ((campaign.currentRedemptions ?? 0) / campaign.maxRedemptions!)
            .clamp(0.0, 1.0)
        : 0.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 220,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(campaign.name ?? 'Campaign',
                      style: AppTypography.h3),
                ),
                EmTag(
                  kind: _tagKindFor(campaign.campaignType),
                  label: _typeLabel(campaign.campaignType),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            if (campaign.description != null)
              Text(campaign.description!, style: AppTypography.small),
            if (hasProgress) ...[
              const SizedBox(height: AppSpacing.sm),
              EmProgressBar(
                  value: progress, height: 4, fillColor: AppColors.warn),
              const SizedBox(height: AppSpacing.xs),
              Text(
                '${campaign.currentRedemptions} / ${campaign.maxRedemptions} redeemed',
                style: AppTypography.small
                    .copyWith(color: AppColors.textTertiary),
              ),
            ],
          ],
        ),
      ),
    );
  }

  static EmTagKind _tagKindFor(CampaignType? type) => switch (type) {
        CampaignType.percentageOff || CampaignType.fixedOff => EmTagKind.ok,
        CampaignType.bonusCredits ||
        CampaignType.bonusMinutes =>
          EmTagKind.purple,
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
}
