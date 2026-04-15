import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../models/domain_billing.dart';
import '../../data/repositories/wallet_repository.dart';

class WalletState {
  final double balance;
  final List<TransactionModel> transactions;
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
    List<TransactionModel>? transactions,
    bool? isLoading,
    String? error,
  }) {
    return WalletState(
      balance: balance ?? this.balance,
      transactions: transactions ?? this.transactions,
      isLoading: isLoading ?? this.isLoading,
      error: error, // Can clear error by copying
    );
  }
}

class WalletNotifier extends Notifier<WalletState> {
  @override
  WalletState build() {
    _loadData();
    return const WalletState(balance: 45.50); // Mock starting balance
  }

  Future<void> _loadData() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final repo = ref.read(walletRepositoryProvider);
      final response = await repo.fetchTransactions();
      
      state = state.copyWith(
        transactions: List<TransactionModel>.from(response.data ?? []),
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<bool> topUp(double amount) async {
    state = state.copyWith(isLoading: true);
    try {
      final repo = ref.read(walletRepositoryProvider);
      final response = await repo.performTopUp(amount);
      if (response.success == true) {
        // Simulate local balance increase
        state = state.copyWith(
          balance: state.balance + amount,
          isLoading: false,
        );
        _loadData(); // refresh history
        return true;
      }
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<void> refresh() => _loadData();
}

final walletNotifierProvider = NotifierProvider<WalletNotifier, WalletState>(() {
  return WalletNotifier();
});
