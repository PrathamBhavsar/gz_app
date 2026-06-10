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
import '../../../../shared/widgets/gz_button.dart';
import '../../../../shared/widgets/gz_card.dart';
import '../../../../shared/widgets/gz_icon_btn.dart';
import '../../../../shared/widgets/gz_live_dot.dart';
import '../../../../shared/widgets/gz_tag.dart';
import '../../../../shared/widgets/gz_loading_view.dart';
import '../../../../shared/widgets/page_error_display.dart';
import '../../../notifications/application/notifications_notifier.dart';
import '../../../notifications/presentation/screens/notification_center_sheet.dart';
import '../../application/wallet_notifier.dart';
import '../../application/wallet_ui_models.dart';
import 'redeem_credits_sheet.dart';

class WalletScreen extends ConsumerWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unreadCount = ref.watch(unreadNotificationCountProvider);
    final walletState = ref.watch(walletNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: walletState.when(
          loading: () => const GzLoadingView(),
          error: (error, _) => PageErrorDisplay(
            error: AppPageError.from(error),
            onRetry: () => ref.read(walletNotifierProvider.notifier).refresh(),
          ),
          data: (data) => ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            children: [
              Row(
                children: [
                  Expanded(child: Text('Wallet', style: AppTypography.h1)),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      GzIconBtn(
                        tooltip: 'Notifications',
                        onTap: () => showNotificationCenter(context),
                        child: const HugeIcon(
                          icon: HugeIcons.strokeRoundedNotification03,
                          color: AppColors.textPrimary,
                          size: 22,
                        ),
                      ),
                      if (unreadCount > 0)
                        const Positioned(
                          top: 6,
                          right: 6,
                          child: GzLiveDot(size: 6, color: AppColors.err),
                        ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 18),
              GzCard(
                variant: CardVariant.tint,
                child: _WalletBalanceHero(balance: data.balance),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: GzButton(
                      label: 'Add credits',
                      variant: GzButtonVariant.ghost,
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Credits are added automatically from eligible bookings.',
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GzButton(
                      label: 'Redeem',
                      onPressed: () => showRedeemCreditsSheet(context),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              _SectionHeader(
                title: 'Transactions',
                actionLabel: 'See all →',
                onTap: () => context.push(AppRoutes.creditHistory),
              ),
              const SizedBox(height: 12),
              if (data.recentTransactions.isEmpty)
                const _EmptySectionCard(
                  title: 'No credit activity yet',
                  subtitle:
                      'Your wallet history will appear here after your first transaction.',
                )
              else
                GzCard(
                  child: Column(
                    children: List.generate(
                      data.recentTransactions.length * 2 - 1,
                      (index) {
                        if (index.isOdd) {
                          return const Divider(
                            height: 1,
                            color: AppColors.divider,
                          );
                        }
                        return _TransactionRow(
                          transaction: data.recentTransactions[index ~/ 2],
                        );
                      },
                    ),
                  ),
                ),
              const SizedBox(height: 28),
              _SectionHeader(
                title: 'Active campaigns',
                actionLabel: 'See all →',
                onTap: () => context.push(AppRoutes.campaigns),
              ),
              const SizedBox(height: 12),
              if (data.campaigns.isEmpty)
                const _EmptySectionCard(
                  title: 'No active campaigns',
                  subtitle:
                      'New offers for this store will show up here when they go live.',
                )
              else
                SizedBox(
                  height: 220,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: data.campaigns.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      return _CampaignCard(campaign: data.campaigns[index]);
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WalletBalanceHero extends StatelessWidget {
  const _WalletBalanceHero({required this.balance});

  final CreditBalanceModel balance;

  @override
  Widget build(BuildContext context) {
    final credits = balance.availableBalance ?? balance.currentBalance ?? 0;
    final storeName = balance.storeName ?? 'your selected store';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('CREDIT BALANCE', style: AppTypography.meta),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(walletCreditsLabel(credits), style: AppTypography.hero),
            const SizedBox(width: 8),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text('credits', style: AppTypography.small),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '≈ ₹${(credits / 10).toStringAsFixed(2)} at $storeName',
          style: AppTypography.bodyR,
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.actionLabel,
    required this.onTap,
  });

  final String title;
  final String actionLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(title, style: AppTypography.h2)),
        GestureDetector(
          onTap: onTap,
          child: Text(
            actionLabel,
            style: AppTypography.body.copyWith(color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }
}

class _TransactionRow extends StatelessWidget {
  const _TransactionRow({required this.transaction});

  final CreditLedgerModel transaction;

  @override
  Widget build(BuildContext context) {
    final amountLabel = walletCreditsAmountLabel(transaction);
    final creditGain = isCreditGain(transaction);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(creditEntryLabel(transaction), style: AppTypography.h3),
                const SizedBox(height: 4),
                Text(
                  creditEntryDateLabel(transaction),
                  style: AppTypography.small,
                ),
              ],
            ),
          ),
          Text(
            amountLabel,
            style: AppTypography.num.copyWith(
              color: creditGain ? AppColors.ok : AppColors.err,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _CampaignCard extends StatelessWidget {
  const _CampaignCard({required this.campaign});

  final CampaignModel campaign;

  @override
  Widget build(BuildContext context) {
    final campaignId = campaign.id;

    return SizedBox(
      width: 220,
      child: GestureDetector(
        onTap: campaignId == null || campaignId.isEmpty
            ? null
            : () => context.push(AppRoutes.campaignDetailPath(campaignId)),
        child: GzCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.surfaceTint,
                  borderRadius: BorderRadius.circular(
                    AppSpacing.borderRadiusLg,
                  ),
                ),
                child: const HugeIcon(
                  icon: HugeIcons.strokeRoundedGift,
                  color: AppColors.textPrimary,
                  size: 22,
                ),
              ),
              const SizedBox(height: 16),
              Text(campaign.name ?? 'Campaign', style: AppTypography.h3),
              const SizedBox(height: 6),
              Text(
                campaign.description ?? campaignBenefitLabel(campaign),
                style: AppTypography.bodyR,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              GzTag(
                kind: campaignTagKind(campaign),
                label: campaignStatusLabel(campaign),
              ),
              const SizedBox(height: 10),
              Text(campaignValidityLabel(campaign), style: AppTypography.small),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptySectionCard extends StatelessWidget {
  const _EmptySectionCard({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return GzCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.h3),
          const SizedBox(height: 6),
          Text(subtitle, style: AppTypography.bodyR),
        ],
      ),
    );
  }
}
