import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/auth/token_storage.dart';
import '../data/repositories/wallet_repository.dart';
import 'wallet_ui_models.dart';

class CreditHistoryNotifier extends AsyncNotifier<CreditHistoryState> {
  static const int _pageSize = 20;

  @override
  Future<CreditHistoryState> build() async {
    ref.watch(activeStoreIdProvider);
    return _loadFirstPage();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_loadFirstPage);
  }

  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null || current.isLoadingMore || !current.hasMore) {
      return;
    }

    state = AsyncData(current.copyWith(isLoadingMore: true));
    try {
      final page = await ref
          .read(walletRepositoryProvider)
          .fetchTransactions(page: current.page + 1, limit: _pageSize);
      state = AsyncData(
        current.copyWith(
          entries: [...current.entries, ...page.transactions],
          page: page.page,
          hasMore: page.hasMore,
          isLoadingMore: false,
        ),
      );
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }

  Future<CreditHistoryState> _loadFirstPage() async {
    final page = await ref
        .read(walletRepositoryProvider)
        .fetchTransactions(limit: _pageSize);
    return CreditHistoryState(
      entries: page.transactions,
      page: page.page,
      hasMore: page.hasMore,
      isLoadingMore: false,
    );
  }
}

final creditHistoryNotifierProvider =
    AsyncNotifierProvider<CreditHistoryNotifier, CreditHistoryState>(
      CreditHistoryNotifier.new,
    );
