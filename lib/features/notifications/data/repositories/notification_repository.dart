import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/network_checker.dart';
import '../services/notification_service.dart';
import '../../../../models/api_responses.dart';

class NotificationRepository {
  final NotificationService _notificationService;
  final NetworkChecker _networkChecker;

  NotificationRepository(this._notificationService, this._networkChecker);

  Future<NotificationListResponse> fetchNotifications({
    int? page,
    int? limit,
  }) async {
    await _networkChecker.assertConnection();
    return await _notificationService.getNotifications(
      page: page ?? 1,
      limit: limit ?? 30,
    );
  }

  Future<void> markAsRead(String notificationId) async {
    await _networkChecker.assertConnection();
    await _notificationService.markAsRead(notificationId);
  }

  Future<void> markAllRead() async {
    await _networkChecker.assertConnection();
    await _notificationService.markAllRead();
  }

  Future<NotificationPreferencesResponse> fetchPreferences() async {
    await _networkChecker.assertConnection();
    return await _notificationService.getPreferences();
  }

  Future<NotificationPreferencesResponse> updatePreferences(
    Map<String, bool> changes,
  ) async {
    await _networkChecker.assertConnection();
    return await _notificationService.updatePreferences(changes);
  }
}

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  final service = ref.watch(notificationServiceProvider);
  final network = ref.watch(networkCheckerProvider);
  return NotificationRepository(service, network);
});
