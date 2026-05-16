import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_constants.dart';
import '../../../../models/api_responses.dart';

class WalletService {
  final ApiClient _apiClient;
  WalletService(this._apiClient);

  Future<CreditBalanceResponse> getBalance(String storeId) async {
    final endpoint = ApiConstants.playerCreditsBalance.replaceAll('{storeId}', storeId);
    final data = await _apiClient.get(endpoint);
    return CreditBalanceResponse.fromJson(data as Map<String, dynamic>);
  }

  Future<PaginatedCreditLedgerResponse> getTransactions(
    String storeId, {
    int page = 1,
    int limit = 20,
  }) async {
    final base = ApiConstants.playerCreditsTransactions.replaceAll('{storeId}', storeId);
    final data = await _apiClient.get('$base?page=$page&limit=$limit');
    return PaginatedCreditLedgerResponse.fromJson(data as Map<String, dynamic>);
  }

  Future<Map<String, dynamic>> redeemCredits(String storeId, {required double amount}) async {
    final endpoint = ApiConstants.playerCreditsRedeem.replaceAll('{storeId}', storeId);
    return await _apiClient.post(endpoint, body: {'amount': amount}) as Map<String, dynamic>;
  }

  Future<PaginatedCampaignsResponse> getCampaigns(String storeId) async {
    final endpoint = ApiConstants.playerCampaignsActive.replaceAll('{storeId}', storeId);
    final data = await _apiClient.get(endpoint);
    return PaginatedCampaignsResponse.fromJson(data as Map<String, dynamic>);
  }

  Future<CampaignRedemptionResponse> redeemCampaign(String storeId, String campaignId) async {
    final endpoint = ApiConstants.playerCampaignRedeem
        .replaceAll('{storeId}', storeId)
        .replaceAll('{id}', campaignId);
    final data = await _apiClient.post(endpoint);
    return CampaignRedemptionResponse.fromJson(data as Map<String, dynamic>);
  }
}

final walletServiceProvider = Provider<WalletService>((ref) {
  return WalletService(ref.watch(apiClientProvider));
});
