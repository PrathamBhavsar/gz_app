import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/api_client.dart';
import '../../../../models/api_responses.dart';

class NotificationService {
  final ApiClient _apiClient;

  NotificationService(this._apiClient);

  /// GET /notifications — Bearer
  Future<NotificationListResponse> getNotifications({
    int? page,
    int? limit,
  }) async {
    final queryParams = <String, String>{
      if (page != null) 'page': page.toString(),
      if (limit != null) 'limit': limit.toString(),
    };
    final qs = queryParams.isNotEmpty ? '?${_encodeQuery(queryParams)}' : '';
    final data = await _apiClient.get('/notifications$qs');
    return NotificationListResponse.fromJson(data as Map<String, dynamic>);
  }

  /// PATCH /notifications/:id/read — Bearer
  Future<NotificationResponse> markAsRead(String notificationId) async {
    final data = await _apiClient.patch('/notifications/$notificationId/read');
    return NotificationResponse.fromJson(data as Map<String, dynamic>);
  }

  /// POST /notifications/read-all — Bearer
  Future<void> markAllRead() async {
    await _apiClient.post('/notifications/read-all');
  }

  /// GET /notifications/preferences — Bearer
  Future<NotificationPreferencesResponse> getPreferences() async {
    final data = await _apiClient.get('/notifications/preferences');
    return NotificationPreferencesResponse.fromJson(
      data as Map<String, dynamic>,
    );
  }

  /// PATCH /notifications/preferences — Bearer (send only changed keys)
  Future<NotificationPreferencesResponse> updatePreferences(
    Map<String, bool> changes,
  ) async {
    final data = await _apiClient.patch(
      '/notifications/preferences',
      body: changes,
    );
    return NotificationPreferencesResponse.fromJson(
      data as Map<String, dynamic>,
    );
  }

  String _encodeQuery(Map<String, String> params) {
    return params.entries
        .map((e) => '${e.key}=${Uri.encodeQueryComponent(e.value)}')
        .join('&');
  }
}

final notificationServiceProvider = Provider<NotificationService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return NotificationService(apiClient);
});
