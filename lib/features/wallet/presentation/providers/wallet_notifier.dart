import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../models/domain_loyalty.dart';
import '../../data/repositories/wallet_repository.dart';

class WalletState {
  final double balance;
  final List<CreditLedgerModel> transactions;
  final bool isLoading;
  final String? error;

  const WalletState({
    this.balance = 0.0,
    this.transactions = const [],
    this.isLoading = true,
    this.error,
  });

  WalletState copyWith({
    double? balance,
    List<CreditLedgerModel>? transactions,
    bool? isLoading,
    String? error,
  }) {
    return WalletState(
      balance: balance ?? this.balance,
      transactions: transactions ?? this.transactions,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class WalletNotifier extends Notifier<WalletState> {
  @override
  WalletState build() {
    return const WalletState();
  }

  /// Load balance + transactions for a given store.
  Future<void> loadData(String storeId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final repo = ref.read(walletRepositoryProvider);
      final balanceResponse = await repo.fetchBalance(storeId);
      final transactionsResponse = await repo.fetchTransactions(
        storeId,
        limit: 20,
      );

      state = state.copyWith(
        balance:
            balanceResponse.data?.availableBalance ??
            balanceResponse.data?.currentBalance ??
            0.0,
        transactions: transactionsResponse.data ?? [],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Redeem credits at a given store.
  Future<bool> redeemCredits(String storeId, double amount) async {
    state = state.copyWith(isLoading: true);
    try {
      final repo = ref.read(walletRepositoryProvider);
      await repo.redeemCredits(storeId, amount: amount);
      await loadData(storeId);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<void> refresh(String storeId) => loadData(storeId);
}

final walletNotifierProvider = NotifierProvider<WalletNotifier, WalletState>(
  () {
    return WalletNotifier();
  },
);
