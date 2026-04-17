import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/api_client.dart';
import '../../../../models/api_responses.dart';

class StoreService {
  final ApiClient _apiClient;

  StoreService(this._apiClient);

  /// GET /stores — public, optional query params
  Future<PaginatedStoresResponse> getStores({
    String? search,
    String? platform,
    bool? isOpen,
    int? page,
    int? limit,
  }) async {
    final queryParams = <String, String>{
      if (search != null) 'search': search,
      if (platform != null) 'platform': platform,
      if (isOpen != null) 'isOpen': isOpen.toString(),
      if (page != null) 'page': page.toString(),
      if (limit != null) 'limit': limit.toString(),
    };
    final queryString = queryParams.isNotEmpty
        ? '?${_encodeQuery(queryParams)}'
        : '';
    final data = await _apiClient.get('/stores$queryString');
    return PaginatedStoresResponse.fromJson(data as Map<String, dynamic>);
  }

  /// GET /stores/:slug — public
  Future<StoreResponse> getStore(String slug) async {
    final data = await _apiClient.get('/stores/$slug');
    return StoreResponse.fromJson(data as Map<String, dynamic>);
  }

  /// GET /stores/:storeId/campaigns/active — Bearer
  Future<PaginatedCampaignsResponse> getActiveCampaigns(String storeId) async {
    final data = await _apiClient.get('/stores/$storeId/campaigns/active');
    return PaginatedCampaignsResponse.fromJson(data as Map<String, dynamic>);
  }

  /// GET /stores/:storeId/systems/available — Bearer
  Future<SystemsListResponse> getAvailableSystems(
    String storeId, {
    String? systemTypeId,
    String? startTime,
    String? endTime,
  }) async {
    final queryParams = <String, String>{
      if (systemTypeId != null) 'systemTypeId': systemTypeId,
      if (startTime != null) 'startTime': startTime,
      if (endTime != null) 'endTime': endTime,
    };
    final queryString = queryParams.isNotEmpty
        ? '?${_encodeQuery(queryParams)}'
        : '';
    final data = await _apiClient.get(
      '/stores/$storeId/systems/available$queryString',
    );
    return SystemsListResponse.fromJson(data as Map<String, dynamic>);
  }

  String _encodeQuery(Map<String, String> params) {
    return params.entries
        .map((e) => '${e.key}=${Uri.encodeQueryComponent(e.value)}')
        .join('&');
  }
}

final storeServiceProvider = Provider<StoreService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return StoreService(apiClient);
});
