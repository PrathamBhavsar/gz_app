import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/auth/token_storage.dart';
import '../../../../models/domain_loyalty.dart';
import '../../data/repositories/wallet_repository.dart';

class CreditHistoryState {
  final List<CreditLedgerModel> items;
  final bool isLoading;
  final bool hasMore;
  final int currentPage;
  final String? error;

  const CreditHistoryState({
    this.items = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.currentPage = 1,
    this.error,
  });

  CreditHistoryState copyWith({
    List<CreditLedgerModel>? items,
    bool? isLoading,
    bool? hasMore,
    int? currentPage,
    String? error,
  }) => CreditHistoryState(
    items: items ?? this.items,
    isLoading: isLoading ?? this.isLoading,
    hasMore: hasMore ?? this.hasMore,
    currentPage: currentPage ?? this.currentPage,
    error: error,
  );
}

class CreditHistoryNotifier extends Notifier<CreditHistoryState> {
  @override
  CreditHistoryState build() {
    final storeId = ref.watch(activeStoreIdProvider);
    if (storeId != null) {
      Future.microtask(() => _load(storeId, reset: true));
    }
    return const CreditHistoryState(isLoading: true);
  }

  Future<void> _load(String storeId, {bool reset = false}) async {
    if (state.isLoading && !reset) return;
    final page = reset ? 1 : state.currentPage + 1;
    state = state.copyWith(isLoading: true, error: null);
    try {
      final repo = ref.read(walletRepositoryProvider);
      final res = await repo.fetchTransactions(storeId, page: page, limit: 20);
      final newItems = res.data ?? [];
      final meta = res.pagination;
      final hasMore = meta != null ? page < (meta.totalPages ?? 1) : newItems.length == 20;
      state = state.copyWith(
        items: reset ? newItems : [...state.items, ...newItems],
        isLoading: false,
        hasMore: hasMore,
        currentPage: page,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> refresh() async {
    final storeId = ref.read(activeStoreIdProvider);
    if (storeId == null) return;
    await _load(storeId, reset: true);
  }

  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoading) return;
    final storeId = ref.read(activeStoreIdProvider);
    if (storeId == null) return;
    await _load(storeId);
  }
}

final creditHistoryNotifierProvider =
    NotifierProvider<CreditHistoryNotifier, CreditHistoryState>(
  () => CreditHistoryNotifier(),
);
