import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_constants.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/network/network_checker.dart';
import '../../../../models/api_responses.dart';
import '../../../../models/domain_misc.dart';

class NotificationsResult {
  const NotificationsResult({required this.items, required this.unreadCount});

  final List<NotificationModel> items;
  final int unreadCount;
}

class NotificationsRepository {
  NotificationsRepository(this._api, this._net);

  final ApiClient _api;
  final NetworkChecker _net;

  Future<NotificationsResult> fetchNotifications() async {
    await _net.assertConnection();

    final raw = await _api.get(ApiConstants.playerNotifications);
    final response = NotificationListResponse.fromJson(_asMap(raw));
    final items = response.data ?? const <NotificationModel>[];
    final unreadCount =
        response.unreadCount ??
        items.where((item) => item.readAt == null).length;

    return NotificationsResult(items: items, unreadCount: unreadCount);
  }

  Future<NotificationModel> fetchNotificationById(String id) async {
    await _net.assertConnection();

    final raw = await _api.get(
      _withId(ApiConstants.playerNotificationDetail, id),
    );
    final map = _asMap(raw);
    final response = NotificationResponse.fromJson(map);
    final data = response.data;
    if (data != null) {
      return data;
    }

    final payload = map['data'];
    if (payload is Map<String, dynamic>) {
      return NotificationModel.fromJson(payload);
    }
    if (payload is Map) {
      return NotificationModel.fromJson(
        payload.map((key, value) => MapEntry(key.toString(), value)),
      );
    }

    throw const ApiException(
      statusCode: 500,
      message: 'Notification detail response is missing notification data',
    );
  }

  Future<void> markRead(String id) async {
    await _net.assertConnection();
    await _api.patch(_withId(ApiConstants.playerNotificationRead, id));
  }

  Future<void> markAllRead() async {
    await _net.assertConnection();
    await _api.post(ApiConstants.playerNotificationsReadAll);
  }

  Future<Map<String, bool>> fetchPreferences() async {
    await _net.assertConnection();

    final raw = await _api.get(ApiConstants.playerNotifPrefs);
    return NotificationPreferencesResponse.fromJson(_asMap(raw)).data ??
        const <String, bool>{};
  }

  Future<Map<String, bool>> updatePreferences(
    Map<String, bool> preferences,
  ) async {
    await _net.assertConnection();

    final raw = await _api.patch(
      ApiConstants.playerNotifPrefs,
      body: preferences,
    );
    return NotificationPreferencesResponse.fromJson(_asMap(raw)).data ??
        preferences;
  }

  String _withId(String template, String id) => template.replaceAll('{id}', id);

  Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    if (value is Map) {
      return value.map((key, mapValue) => MapEntry(key.toString(), mapValue));
    }
    throw const ApiException(
      statusCode: 500,
      message: 'Expected object response from notifications API',
    );
  }
}

final notificationsRepositoryProvider = Provider<NotificationsRepository>((
  ref,
) {
  return NotificationsRepository(
    ref.watch(apiClientProvider),
    ref.watch(networkCheckerProvider),
  );
});
