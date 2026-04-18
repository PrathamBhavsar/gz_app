import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/api_client.dart';
import '../../../../models/api_responses.dart';

class DisputeService {
  final ApiClient _apiClient;

  DisputeService(this._apiClient);

  /// GET /stores/:storeId/disputes/my — Bearer
  Future<DisputeListResponse> getMyDisputes(String storeId) async {
    final data = await _apiClient.get('/stores/$storeId/disputes/my');
    return DisputeListResponse.fromJson(data as Map<String, dynamic>);
  }

  /// GET /stores/:storeId/disputes/:id — Bearer
  Future<DisputeResponse> getDispute(String storeId, String disputeId) async {
    final data = await _apiClient.get('/stores/$storeId/disputes/$disputeId');
    return DisputeResponse.fromJson(data as Map<String, dynamic>);
  }

  /// POST /stores/:storeId/disputes — Bearer
  Future<DisputeResponse> createDispute(
    String storeId, {
    required String sessionId,
    required String reason,
    double? disputedAmount,
  }) async {
    final body = <String, dynamic>{
      'sessionId': sessionId,
      'reason': reason,
      if (disputedAmount != null) 'disputedAmount': disputedAmount,
    };
    final data = await _apiClient.post('/stores/$storeId/disputes', body: body);
    return DisputeResponse.fromJson(data as Map<String, dynamic>);
  }

  /// POST /stores/:storeId/disputes/:id/withdraw — Bearer
  Future<DisputeResponse> withdrawDispute(
    String storeId,
    String disputeId,
  ) async {
    final data = await _apiClient.post(
      '/stores/$storeId/disputes/$disputeId/withdraw',
    );
    return DisputeResponse.fromJson(data as Map<String, dynamic>);
  }
}

final disputeServiceProvider = Provider<DisputeService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return DisputeService(apiClient);
});
