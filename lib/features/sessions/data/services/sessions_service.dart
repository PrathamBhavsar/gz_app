import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/api_client.dart';
import '../../../../models/api_responses.dart';

class SessionsService {
  final ApiClient _apiClient;

  SessionsService(this._apiClient);

  /// GET /stores/:storeId/sessions/my — Bearer
  Future<PaginatedSessionsResponse> getSessions(
    String storeId, {
    String? status,
    int? page,
    int? limit,
  }) async {
    final queryParams = <String, String>{
      if (status != null) 'status': status,
      if (page != null) 'page': page.toString(),
      if (limit != null) 'limit': limit.toString(),
    };
    final qs = queryParams.isNotEmpty ? '?${_encodeQuery(queryParams)}' : '';
    final data = await _apiClient.get('/stores/$storeId/sessions/my$qs');
    return PaginatedSessionsResponse.fromJson(data as Map<String, dynamic>);
  }

  /// GET /stores/:storeId/sessions/:id — Bearer
  Future<SessionResponse> getSession(String storeId, String sessionId) async {
    final data = await _apiClient.get('/stores/$storeId/sessions/$sessionId');
    return SessionResponse.fromJson(data as Map<String, dynamic>);
  }

  String _encodeQuery(Map<String, String> params) {
    return params.entries
        .map((e) => '${e.key}=${Uri.encodeQueryComponent(e.value)}')
        .join('&');
  }
}

final sessionsServiceProvider = Provider<SessionsService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return SessionsService(apiClient);
});
