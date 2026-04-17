import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/api_client.dart';
import '../../../../models/api_responses.dart';

class WalletService {
  final ApiClient _apiClient;

  WalletService(this._apiClient);

  /// GET /stores/:storeId/credits/balance — Bearer
  Future<CreditBalanceResponse> getBalance(String storeId) async {
    final data = await _apiClient.get('/stores/$storeId/credits/balance');
    return CreditBalanceResponse.fromJson(data as Map<String, dynamic>);
  }

  /// GET /stores/:storeId/credits/transactions — Bearer
  Future<PaginatedCreditLedgerResponse> getTransactions(
    String storeId, {
    int? page,
    int? limit,
  }) async {
    final queryParams = <String, String>{
      if (page != null) 'page': page.toString(),
      if (limit != null) 'limit': limit.toString(),
    };
    final qs = queryParams.isNotEmpty ? '?${_encodeQuery(queryParams)}' : '';
    final data = await _apiClient.get(
      '/stores/$storeId/credits/transactions$qs',
    );
    return PaginatedCreditLedgerResponse.fromJson(data as Map<String, dynamic>);
  }

  /// POST /stores/:storeId/credits/redeem — Bearer
  Future<Map<String, dynamic>> redeemCredits(
    String storeId, {
    required double amount,
  }) async {
    return await _apiClient.post(
          '/stores/$storeId/credits/redeem',
          body: {'amount': amount},
        )
        as Map<String, dynamic>;
  }

  /// POST /stores/:storeId/campaigns/:id/redeem — Bearer
  Future<CampaignRedemptionResponse> redeemCampaign(
    String storeId,
    String campaignId,
  ) async {
    final data = await _apiClient.post(
      '/stores/$storeId/campaigns/$campaignId/redeem',
    );
    return CampaignRedemptionResponse.fromJson(data as Map<String, dynamic>);
  }

  String _encodeQuery(Map<String, String> params) {
    return params.entries
        .map((e) => '${e.key}=${Uri.encodeQueryComponent(e.value)}')
        .join('&');
  }
}

final walletServiceProvider = Provider<WalletService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return WalletService(apiClient);
});
