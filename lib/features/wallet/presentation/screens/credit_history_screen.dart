import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../models/domain_loyalty.dart';
import '../../../../shared/widgets/gz_button.dart';
import '../../../../shared/widgets/gz_chip.dart';
import '../../../../shared/widgets/gz_loading_view.dart';
import '../../../../shared/widgets/page_error_display.dart';
import '../../application/credit_history_notifier.dart';
import '../../application/wallet_ui_models.dart';

class CreditHistoryScreen extends ConsumerStatefulWidget {
  const CreditHistoryScreen({super.key});

  @override
  ConsumerState<CreditHistoryScreen> createState() =>
      _CreditHistoryScreenState();
}

class _CreditHistoryScreenState extends ConsumerState<CreditHistoryScreen> {
  static const List<String> _filters = ['All', 'Earned', 'Spent'];

  int _selectedFilter = 0;

  List<CreditLedgerModel> _visibleEntries(List<CreditLedgerModel> entries) {
    return switch (_selectedFilter) {
      1 => entries.where(isCreditGain).toList(growable: false),
      2 =>
        entries.where((entry) => !isCreditGain(entry)).toList(growable: false),
      _ => entries,
    };
  }

  @override
  Widget build(BuildContext context) {
    final historyState = ref.watch(creditHistoryNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text('Credit history', style: AppTypography.h2),
      ),
      body: SafeArea(
        top: false,
        child: historyState.when(
          loading: () => const GzLoadingView(),
          error: (error, _) => PageErrorDisplay(
            error: AppPageError.from(error),
            onRetry: () =>
                ref.read(creditHistoryNotifierProvider.notifier).refresh(),
          ),
          data: (data) {
            if (data.entries.isEmpty) {
              return const PageErrorDisplay(error: AppPageError.empty);
            }
            final visibleEntries = _visibleEntries(data.entries);
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
                  child: visibleEntries.isEmpty
                      ? _FilteredEmptyState(
                          hasMore: data.hasMore,
                          isLoadingMore: data.isLoadingMore,
                          onLoadMore: () => ref
                              .read(creditHistoryNotifierProvider.notifier)
                              .loadMore(),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                          itemCount: visibleEntries.length + 1,
                          separatorBuilder: (_, index) =>
                              index == visibleEntries.length - 1
                              ? const SizedBox(height: 16)
                              : const Divider(
                                  height: 1,
                                  color: AppColors.divider,
                                ),
                          itemBuilder: (context, index) {
                            if (index == visibleEntries.length) {
                              return _LoadMoreRow(
                                hasMore: data.hasMore,
                                isLoadingMore: data.isLoadingMore,
                                onLoadMore: () => ref
                                    .read(
                                      creditHistoryNotifierProvider.notifier,
                                    )
                                    .loadMore(),
                              );
                            }
                            return _CreditRow(entry: visibleEntries[index]);
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

class _FilteredEmptyState extends StatelessWidget {
  const _FilteredEmptyState({
    required this.hasMore,
    required this.isLoadingMore,
    required this.onLoadMore,
  });

  final bool hasMore;
  final bool isLoadingMore;
  final VoidCallback onLoadMore;

  @override
  Widget build(BuildContext context) {
    if (!hasMore) {
      return const PageErrorDisplay(error: AppPageError.empty);
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('No matching entries yet', style: AppTypography.h3),
            const SizedBox(height: 8),
            Text(
              'Load more history to keep searching this filter.',
              style: AppTypography.bodyR,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            GzButton(
              label: 'Load more',
              variant: GzButtonVariant.ghost,
              loading: isLoadingMore,
              onPressed: isLoadingMore ? null : onLoadMore,
            ),
          ],
        ),
      ),
    );
  }
}

class _CreditRow extends StatelessWidget {
  const _CreditRow({required this.entry});

  final CreditLedgerModel entry;

  @override
  Widget build(BuildContext context) {
    final amount = walletCreditsAmountLabel(entry);
    final creditGain = isCreditGain(entry);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: RichText(
        text: TextSpan(
          style: AppTypography.body.copyWith(color: AppColors.textPrimary),
          children: [
            TextSpan(
              text: amount,
              style: AppTypography.num.copyWith(
                color: creditGain ? AppColors.ok : AppColors.err,
                fontWeight: FontWeight.w700,
              ),
            ),
            const TextSpan(text: ' · '),
            TextSpan(text: creditEntryLabel(entry)),
            const TextSpan(text: ' · '),
            TextSpan(
              text: creditEntryDateLabel(entry),
              style: AppTypography.bodyR,
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadMoreRow extends StatelessWidget {
  const _LoadMoreRow({
    required this.hasMore,
    required this.isLoadingMore,
    required this.onLoadMore,
  });

  final bool hasMore;
  final bool isLoadingMore;
  final VoidCallback onLoadMore;

  @override
  Widget build(BuildContext context) {
    if (!hasMore) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: GzButton(
        label: 'Load more',
        variant: GzButtonVariant.ghost,
        loading: isLoadingMore,
        onPressed: isLoadingMore ? null : onLoadMore,
      ),
    );
  }
}
