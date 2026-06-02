import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../models/domain_loyalty.dart';
import '../../../../models/enums.dart';
import '../../../../shared/widgets/gz_top_bar.dart';
import '../../../../shared/widgets/gz_card.dart';
import '../../../../shared/widgets/gz_section_head.dart';
import '../../../../shared/widgets/page_error_display.dart';
import '../providers/credit_history_notifier.dart';

class CreditHistoryMobileLayout extends ConsumerStatefulWidget {
  const CreditHistoryMobileLayout({super.key});

  @override
  ConsumerState<CreditHistoryMobileLayout> createState() =>
      _CreditHistoryMobileLayoutState();
}

class _CreditHistoryMobileLayoutState
    extends ConsumerState<CreditHistoryMobileLayout> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(creditHistoryNotifierProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(creditHistoryNotifierProvider);

    return SafeArea(
      child: Column(
        children: [
          const GzTopBar(title: 'Transactions'),
          if (state.error != null && state.items.isEmpty)
            Expanded(
              child: PageErrorDisplay(
                error: AppPageError.from(Exception(state.error)),
                onRetry: () =>
                    ref.read(creditHistoryNotifierProvider.notifier).refresh(),
              ),
            )
          else if (state.isLoading && state.items.isEmpty)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (state.items.isEmpty)
            const Expanded(child: _EmptyState())
          else
            Expanded(
              child: RefreshIndicator(
                onRefresh: () =>
                    ref.read(creditHistoryNotifierProvider.notifier).refresh(),
                child: _GroupedList(
                  items: state.items,
                  hasMore: state.hasMore,
                  isLoadingMore: state.isLoading,
                  scrollController: _scrollController,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _GroupedList extends StatelessWidget {
  const _GroupedList({
    required this.items,
    required this.hasMore,
    required this.isLoadingMore,
    required this.scrollController,
  });

  final List<CreditLedgerModel> items;
  final bool hasMore;
  final bool isLoadingMore;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final grouped = _groupByMonth(items);
    final months = grouped.keys.toList();

    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.md, AppSpacing.xs, AppSpacing.md, AppSpacing.lg),
      itemCount: months.length + (isLoadingMore ? 1 : 0),
      itemBuilder: (_, i) {
        if (i == months.length) {
          return const Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final month = months[i];
        final txList = grouped[month]!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GzSectionHead(month),
            GzCard(
              padding: 0,
              child: Column(
                children: txList.asMap().entries.map((e) {
                  return _TxRow(tx: e.value, first: e.key == 0)
                      .animate(delay: (e.key * 40).ms)
                      .fadeIn(duration: 220.ms);
                }).toList(),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        )
            .animate(delay: (i * 60).ms)
            .fadeIn(duration: 220.ms)
            .slideY(begin: 0.04, end: 0, duration: 220.ms);
      },
    );
  }

  static Map<String, List<CreditLedgerModel>> _groupByMonth(
      List<CreditLedgerModel> items) {
    final map = <String, List<CreditLedgerModel>>{};
    for (final tx in items) {
      final dt = tx.createdAt ?? DateTime.now();
      final key = _monthLabel(dt);
      (map[key] ??= []).add(tx);
    }
    return map;
  }

  static String _monthLabel(DateTime dt) {
    const m = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return '${m[dt.month - 1]} ${dt.year}';
  }
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
    final date = _dateLabel(tx.createdAt);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 12),
      decoration: BoxDecoration(
        border: first ? null : Border(top: BorderSide(color: AppColors.rule)),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
            child: Center(
              child: HugeIcon(icon: _iconFor(tx.transactionType), color: fg, size: 16),
            ),
          ),
          const SizedBox(width: AppSpacing.sm + AppSpacing.xs),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(desc, style: AppTypography.body.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 1),
                Text(date, style: AppTypography.small),
              ],
            ),
          ),
          Text(
            '$sign$amt',
            style: AppTypography.num.copyWith(fontWeight: FontWeight.w700, color: fg),
          ),
        ],
      ),
    );
  }

  static dynamic _iconFor(CreditTransactionType? type) => switch (type) {
        CreditTransactionType.earned => HugeIcons.strokeRoundedStar,
        CreditTransactionType.redeemed => HugeIcons.strokeRoundedArrowUp01,
        CreditTransactionType.bonus => HugeIcons.strokeRoundedGift,
        CreditTransactionType.adminAdjust => HugeIcons.strokeRoundedSettings01,
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

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Center(
        child: GzCard(
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
                    icon: HugeIcons.strokeRoundedCoins01,
                    color: AppColors.textTertiary,
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              const Text('No transactions yet', style: AppTypography.h2),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Earn credits by completing sessions at this store.',
                style: AppTypography.bodyR,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
