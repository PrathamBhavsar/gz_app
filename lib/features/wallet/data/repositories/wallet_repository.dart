import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/network_checker.dart';
import '../services/wallet_service.dart';
import '../../../../models/api_responses.dart';

class WalletRepository {
  final WalletService _walletService;
  final NetworkChecker _networkChecker;

  WalletRepository(this._walletService, this._networkChecker);

  Future<CreditBalanceResponse> fetchBalance(String storeId) async {
    await _networkChecker.assertConnection();
    return await _walletService.getBalance(storeId);
  }

  Future<PaginatedCreditLedgerResponse> fetchTransactions(
    String storeId, {
    int? page,
    int? limit,
  }) async {
    await _networkChecker.assertConnection();
    return await _walletService.getTransactions(
      storeId,
      page: page ?? 1,
      limit: limit ?? 20,
    );
  }

  Future<Map<String, dynamic>> redeemCredits(
    String storeId, {
    required double amount,
  }) async {
    await _networkChecker.assertConnection();
    return await _walletService.redeemCredits(storeId, amount: amount);
  }

  Future<CampaignRedemptionResponse> redeemCampaign(
    String storeId,
    String campaignId,
  ) async {
    await _networkChecker.assertConnection();
    return await _walletService.redeemCampaign(storeId, campaignId);
  }
}

final walletRepositoryProvider = Provider<WalletRepository>((ref) {
  final service = ref.watch(walletServiceProvider);
  final network = ref.watch(networkCheckerProvider);
  return WalletRepository(service, network);
});
