import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/domain_misc.dart';
import '../data/repositories/notifications_repository.dart';
import 'notifications_ui_models.dart';

class NotificationsNotifier extends AsyncNotifier<NotificationsData> {
  @override
  Future<NotificationsData> build() => _load();

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_load);
  }

  Future<void> markRead(String id) async {
    final current = state.valueOrNull;
    if (current == null) {
      await ref.read(notificationsRepositoryProvider).markRead(id);
      return;
    }

    final next = current.markRead(id);
    if (next.unreadCount == current.unreadCount) {
      return;
    }

    state = AsyncData(next);
    try {
      await ref.read(notificationsRepositoryProvider).markRead(id);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      state = await AsyncValue.guard(_load);
      rethrow;
    }
  }

  Future<void> markAllRead() async {
    final current = state.valueOrNull;
    if (current == null) {
      await ref.read(notificationsRepositoryProvider).markAllRead();
      await refresh();
      return;
    }

    if (!current.hasUnread) {
      return;
    }

    state = AsyncData(current.markAllRead());
    try {
      await ref.read(notificationsRepositoryProvider).markAllRead();
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      state = await AsyncValue.guard(_load);
      rethrow;
    }
  }

  void prependFromWs(Map<String, dynamic> payload) {
    final current = state.valueOrNull;
    if (current == null) {
      return;
    }

    state = AsyncData(current.prepend(_notificationFromPayload(payload)));
  }

  void mergeDetail(NotificationModel notification) {
    final current = state.valueOrNull;
    if (current == null) {
      return;
    }
    state = AsyncData(current.upsert(notification));
  }

  Future<NotificationsData> _load() async {
    final result = await ref
        .read(notificationsRepositoryProvider)
        .fetchNotifications();
    return NotificationsData(
      items: result.items,
      unreadCount: result.unreadCount,
    );
  }

  NotificationModel _notificationFromPayload(Map<String, dynamic> payload) {
    final now = DateTime.now();
    return NotificationModel(
      id: payload['id']?.toString() ?? payload['notificationId']?.toString(),
      title:
          payload['title']?.toString() ??
          payload['message']?.toString() ??
          'New notification',
      body:
          payload['body']?.toString() ??
          payload['subtitle']?.toString() ??
          'Open notifications for details',
      referenceType:
          payload['referenceType']?.toString() ?? payload['type']?.toString(),
      referenceId:
          payload['referenceId']?.toString() ?? payload['entityId']?.toString(),
      createdAt:
          _parseDate(
            payload['createdAt'] ?? payload['created_at'] ?? payload['sentAt'],
          ) ??
          now,
      sentAt: _parseDate(payload['sentAt'] ?? payload['sent_at']) ?? now,
      deliveredAt: _parseDate(
        payload['deliveredAt'] ?? payload['delivered_at'],
      ),
      readAt: null,
    );
  }

  DateTime? _parseDate(dynamic value) {
    if (value == null) {
      return null;
    }
    return DateTime.tryParse(value.toString());
  }
}

final notificationsNotifierProvider =
    AsyncNotifierProvider<NotificationsNotifier, NotificationsData>(
      NotificationsNotifier.new,
    );

final unreadNotificationCountProvider = Provider<int>((ref) {
  return ref.watch(
    notificationsNotifierProvider.select(
      (state) => state.valueOrNull?.unreadCount ?? 0,
    ),
  );
});
