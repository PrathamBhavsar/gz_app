import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../core/navigation/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../notifications/presentation/providers/notification_feed_notifier.dart';
import '../../../../shared/widgets/gz_button.dart';
import '../../../../shared/widgets/gz_card.dart';
import '../../../../shared/widgets/gz_icon_btn.dart';
import '../../../../shared/widgets/gz_live_dot.dart';
import '../../../../shared/widgets/gz_tag.dart';
import 'redeem_credits_sheet.dart';

class WalletScreen extends ConsumerWidget {
  const WalletScreen({super.key});

  static const List<_WalletTransaction> _transactions = [
    _WalletTransaction(
      title: 'Booking credit',
      amount: '+200',
      date: 'Jun 02',
      color: AppColors.ok,
    ),
    _WalletTransaction(
      title: 'Session deduct',
      amount: '−150',
      date: 'Jun 01',
      color: AppColors.err,
    ),
    _WalletTransaction(
      title: 'Welcome bonus',
      amount: '+500',
      date: 'May 28',
      color: AppColors.ok,
    ),
  ];

  static const List<_WalletCampaign> _campaigns = [
    _WalletCampaign(
      id: 'welcome-bonus',
      title: 'Welcome Bonus',
      description: 'Earn 2× credits on your first booking',
      statusKind: GzTagKind.ok,
      statusLabel: 'Active',
      expiry: 'Expires Dec 31, 2025',
    ),
    _WalletCampaign(
      id: 'happy-hours',
      title: 'Happy Hours',
      description: '50% off all systems 2 PM – 5 PM Mon–Thu',
      statusKind: GzTagKind.ok,
      statusLabel: 'Active',
      expiry: 'Ongoing',
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unreadCount = ref.watch(unreadNotificationCountProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
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
                      onTap: () => context.push(AppRoutes.notifications),
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
            const GzCard(
              variant: CardVariant.tint,
              child: _WalletBalanceHero(),
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
            GzCard(
              child: Column(
                children: List.generate(_transactions.length * 2 - 1, (index) {
                  if (index.isOdd) {
                    return const Divider(height: 1, color: AppColors.divider);
                  }
                  return _TransactionRow(
                    transaction: _transactions[index ~/ 2],
                  );
                }),
              ),
            ),
            const SizedBox(height: 28),
            _SectionHeader(
              title: 'Active campaigns',
              actionLabel: 'See all →',
              onTap: () => context.push(AppRoutes.campaigns),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 220,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _campaigns.length,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  return _CampaignCard(campaign: _campaigns[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WalletBalanceHero extends StatelessWidget {
  const _WalletBalanceHero();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('CREDIT BALANCE', style: AppTypography.meta),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('850', style: AppTypography.hero),
            const SizedBox(width: 8),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text('credits', style: AppTypography.small),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text('≈ ₹85.00 today', style: AppTypography.bodyR),
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

  final _WalletTransaction transaction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${transaction.title} ${transaction.amount}',
                  style: AppTypography.h3,
                ),
                const SizedBox(height: 4),
                Text(transaction.date, style: AppTypography.small),
              ],
            ),
          ),
          Text(
            transaction.amount,
            style: AppTypography.num.copyWith(
              color: transaction.color,
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

  final _WalletCampaign campaign;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 248,
      child: GestureDetector(
        onTap: () => context.push(AppRoutes.campaignDetailPath(campaign.id)),
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
              const SizedBox(height: 14),
              Text(campaign.title, style: AppTypography.h3),
              const SizedBox(height: 6),
              Text(
                campaign.description,
                style: AppTypography.bodyR,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
              GzTag(kind: campaign.statusKind, label: campaign.statusLabel),
              const Spacer(),
              Text(campaign.expiry, style: AppTypography.small),
            ],
          ),
        ),
      ),
    );
  }
}

class _WalletTransaction {
  const _WalletTransaction({
    required this.title,
    required this.amount,
    required this.date,
    required this.color,
  });

  final String title;
  final String amount;
  final String date;
  final Color color;
}

class _WalletCampaign {
  const _WalletCampaign({
    required this.id,
    required this.title,
    required this.description,
    required this.statusKind,
    required this.statusLabel,
    required this.expiry,
  });

  final String id;
  final String title;
  final String description;
  final GzTagKind statusKind;
  final String statusLabel;
  final String expiry;
}
