import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/network_checker.dart';
import '../services/wallet_service.dart';
import '../../../../models/api_responses.dart';
import '../../../../models/domain_loyalty.dart';

class WalletRepository {
  final WalletService _service;
  final NetworkChecker _networkChecker;

  WalletRepository(this._service, this._networkChecker);

  Future<CreditBalanceResponse> fetchBalance(String storeId) async {
    await _networkChecker.assertConnection();
    return _service.getBalance(storeId);
  }

  Future<PaginatedCreditLedgerResponse> fetchTransactions(
    String storeId, {
    int page = 1,
    int limit = 20,
  }) async {
    await _networkChecker.assertConnection();
    return _service.getTransactions(storeId, page: page, limit: limit);
  }

  Future<void> redeemCredits(String storeId, {required double amount}) async {
    await _networkChecker.assertConnection();
    await _service.redeemCredits(storeId, amount: amount);
  }

  Future<List<CampaignModel>> fetchCampaigns(String storeId) async {
    await _networkChecker.assertConnection();
    final res = await _service.getCampaigns(storeId);
    return res.data ?? [];
  }

  Future<CampaignRedemptionResponse> redeemCampaign(
    String storeId,
    String campaignId,
  ) async {
    await _networkChecker.assertConnection();
    return _service.redeemCampaign(storeId, campaignId);
  }
}

final walletRepositoryProvider = Provider<WalletRepository>((ref) {
  return WalletRepository(
    ref.watch(walletServiceProvider),
    ref.watch(networkCheckerProvider),
  );
});
