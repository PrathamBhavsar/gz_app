import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../core/errors/app_exception.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../models/domain_loyalty.dart';
import '../../../../../shared/widgets/gz_admin_top_bar.dart';
import '../../../../../shared/widgets/gz_avatar.dart';
import '../../../../../shared/widgets/gz_button.dart';
import '../../../../../shared/widgets/gz_card.dart';
import '../../../../../shared/widgets/gz_loading_view.dart';
import '../../../../../shared/widgets/gz_scroll_content.dart';
import '../../../../../shared/widgets/page_error_display.dart';
import '../../../application/admin_credits_notifier.dart';
import '../../../application/admin_management_models.dart';
import 'adjust_credits_sheet.dart';

class CreditsManagementScreen extends ConsumerStatefulWidget {
  const CreditsManagementScreen({super.key});

  @override
  ConsumerState<CreditsManagementScreen> createState() =>
      _CreditsManagementScreenState();
}

class _CreditsManagementScreenState
    extends ConsumerState<CreditsManagementScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final credits = ref.watch(adminCreditsNotifierProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const GzAdminTopBar(title: 'Credits'),
      body: credits.when(
        loading: () => const GzLoadingView(message: 'Loading credit ledger'),
        error: (error, _) => SafeArea(
          top: false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: _SearchBar(
                  controller: _searchController,
                  onSubmitted: _loadUser,
                ),
              ),
              Expanded(
                child: PageErrorDisplay(
                  error: AppPageError.from(error),
                  onRetry: () =>
                      ref.read(adminCreditsNotifierProvider.notifier).refresh(),
                ),
              ),
            ],
          ),
        ),
        data: (data) => SafeArea(
          top: false,
          child: GzScrollContent(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SearchBar(
                    controller: _searchController,
                    onSubmitted: _loadUser,
                  ),
                  const SizedBox(height: 10),
                  GzCard(
                    variant: CardVariant.inset,
                    child: Text(
                      'Phase 11 supports direct lookup by player user ID. The current plan does not define an admin credits search endpoint by name, phone, or email.',
                      style: AppTypography.bodyR,
                    ),
                  ),
                  const SizedBox(height: 14),
                  if (!data.hasSelection)
                    const GzCard(
                      child: Text(
                        'Enter a player user ID to load balance and recent transactions.',
                        style: AppTypography.bodyR,
                      ),
                    )
                  else if (data.balance == null)
                    const PageErrorDisplay(error: AppPageError.empty)
                  else
                    _CreditsPlayerCard(data: data),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _loadUser(String value) {
    final userId = value.trim();
    if (userId.isEmpty) {
      return;
    }
    ref.read(adminCreditsNotifierProvider.notifier).loadUser(userId);
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.controller, required this.onSubmitted});

  final TextEditingController controller;
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.pillBg,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
      ),
      child: Row(
        children: [
          const HugeIcon(
            icon: HugeIcons.strokeRoundedSearch01,
            color: AppColors.textTertiary,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              textInputAction: TextInputAction.search,
              onSubmitted: onSubmitted,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter player user ID…',
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              style: AppTypography.bodyR,
            ),
          ),
        ],
      ),
    );
  }
}

class _CreditsPlayerCard extends StatelessWidget {
  const _CreditsPlayerCard({required this.data});

  final AdminCreditsData data;

  @override
  Widget build(BuildContext context) {
    final userName = data.user?.name ?? data.selectedUserId ?? 'Player';
    final subtitle =
        data.user?.phone ?? data.user?.email ?? data.selectedUserId;
    final balance = data.balance?.currentBalance?.round() ?? 0;
    return GzCard(
      padding: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GzAvatar(letter: userName[0], size: GzAvatarSize.lg),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(userName, style: AppTypography.h3),
                    const SizedBox(height: 2),
                    Text(subtitle ?? '', style: AppTypography.small),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          GzCard(
            variant: CardVariant.tint,
            padding: 14,
            child: Column(
              children: [
                const Text('CREDIT BALANCE', style: AppTypography.meta),
                const SizedBox(height: 4),
                Text('$balance', style: AppTypography.heroMd),
                const SizedBox(height: 2),
                const Text('credits', style: AppTypography.small),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Text('Recent transactions', style: AppTypography.h3),
              const Spacer(),
              Text(
                '${data.transactions.length} entries',
                style: AppTypography.small.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (data.transactions.isEmpty)
            Text('No recent transactions', style: AppTypography.small)
          else
            ...data.transactions.map(
              (tx) => _TransactionRow(
                transaction: _CreditTransactionData.fromLedger(tx),
              ),
            ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: GzButton(
                  label: 'Deduct credits',
                  variant: GzButtonVariant.ghost,
                  small: true,
                  onPressed: () => showAdjustCreditsSheet(
                    context,
                    userId: data.selectedUserId ?? '',
                    userName: userName,
                    balance: balance,
                    mode: 'deduct',
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GzButton(
                  label: 'Add credits',
                  small: true,
                  onPressed: () => showAdjustCreditsSheet(
                    context,
                    userId: data.selectedUserId ?? '',
                    userName: userName,
                    balance: balance,
                    mode: 'add',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TransactionRow extends StatelessWidget {
  const _TransactionRow({required this.transaction});

  final _CreditTransactionData transaction;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.rule)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.label,
                  style: AppTypography.body.copyWith(fontSize: 13),
                ),
                const SizedBox(height: 2),
                Text(transaction.date, style: AppTypography.small),
              ],
            ),
          ),
          Text(
            transaction.amount,
            style: AppTypography.num.copyWith(
              fontWeight: FontWeight.w600,
              color: transaction.isPositive ? AppColors.ok : AppColors.err,
            ),
          ),
        ],
      ),
    );
  }
}

class _CreditTransactionData {
  const _CreditTransactionData({
    required this.label,
    required this.amount,
    required this.date,
    required this.isPositive,
  });

  final String label;
  final String amount;
  final String date;
  final bool isPositive;

  factory _CreditTransactionData.fromLedger(CreditLedgerModel tx) {
    final amount = tx.amount ?? 0;
    return _CreditTransactionData(
      label: tx.description ?? 'Credit activity',
      amount:
          '${amount >= 0 ? '+' : ''}${amount.truncateToDouble() == amount ? amount.toStringAsFixed(0) : amount.toStringAsFixed(2)}',
      date: tx.createdAt == null
          ? 'Unknown'
          : '${_month(tx.createdAt!.month)} ${tx.createdAt!.day}',
      isPositive: amount >= 0,
    );
  }
}

String _month(int month) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return months[month - 1];
}
