import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_constants.dart';
import '../../../../models/api_responses.dart';

class BillingService {
  final ApiClient _apiClient;

  BillingService(this._apiClient);

  /// GET /stores/:storeId/billing/my — Bearer
  Future<PaginatedBillingResponse> getMyBilling(
    String storeId, {
    int? page,
    int? limit,
  }) async {
    final queryParams = <String, String>{
      if (page != null) 'page': page.toString(),
      if (limit != null) 'limit': limit.toString(),
    };
    final qs = queryParams.isNotEmpty ? '?${_encodeQuery(queryParams)}' : '';
    final ep = ApiConstants.billingMy.replaceAll('{storeId}', storeId);
    final data = await _apiClient.get('$ep$qs');
    return PaginatedBillingResponse.fromJson(data as Map<String, dynamic>);
  }

  String _encodeQuery(Map<String, String> params) {
    return params.entries
        .map((e) => '${e.key}=${Uri.encodeQueryComponent(e.value)}')
        .join('&');
  }
}

final billingServiceProvider = Provider<BillingService>((ref) {
  return BillingService(ref.watch(apiClientProvider));
});
