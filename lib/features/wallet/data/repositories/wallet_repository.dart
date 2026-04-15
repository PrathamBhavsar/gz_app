import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/network_checker.dart';
import '../services/wallet_service.dart';
import '../../../../models/api_responses.dart';

class WalletRepository {
  final WalletService _walletService;
  final NetworkChecker _networkChecker;

  WalletRepository(this._walletService, this._networkChecker);

  Future<PaginatedTransactionsResponse> fetchTransactions() async {
    await _networkChecker.assertConnection();
    return await _walletService.getTransactions();
  }

  Future<TransactionResponse> performTopUp(double amount) async {
    await _networkChecker.assertConnection();
    return await _walletService.topUpWallet(amount);
  }
}

final walletRepositoryProvider = Provider<WalletRepository>((ref) {
  final service = ref.watch(walletServiceProvider);
  final network = ref.watch(networkCheckerProvider);
  return WalletRepository(service, network);
});
