import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/api_client.dart';
import '../../../../models/api_responses.dart';
import '../../../auth/data/services/auth_service.dart';

class WalletService {
  final ApiClient _apiClient;

  WalletService(this._apiClient);

  Future<PaginatedTransactionsResponse> getTransactions() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return const PaginatedTransactionsResponse(data: []); // Return mock empty or populated
  }

  Future<TransactionResponse> topUpWallet(double amount) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return const TransactionResponse(data: null);
  }
}

final walletServiceProvider = Provider<WalletService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return WalletService(apiClient);
});
