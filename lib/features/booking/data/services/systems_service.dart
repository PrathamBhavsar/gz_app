import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/api_client.dart';
import '../../../../models/api_responses.dart';

class SystemsService {
  final ApiClient _apiClient;
  SystemsService(this._apiClient);

  Future<SystemsListResponse> getAvailableSystems(String storeId) async {
    final data = await _apiClient.get('/stores/$storeId/systems/available');
    return SystemsListResponse.fromJson(data as Map<String, dynamic>);
  }
}

final systemsServiceProvider = Provider<SystemsService>((ref) {
  return SystemsService(ref.watch(apiClientProvider));
});
