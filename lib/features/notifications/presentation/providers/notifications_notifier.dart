import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../models/domain_misc.dart';
import '../../data/repositories/notification_repository.dart';

class NotificationsData {
  final List<NotificationModel> items;
  final int unreadCount;

  const NotificationsData({required this.items, required this.unreadCount});

  bool get hasUnread => unreadCount > 0;

  NotificationsData copyWithMarkRead(String id) {
    final wasUnread = items.any((n) => n.id == id && n.readAt == null);
    return NotificationsData(
      items: items
          .map((n) => n.id == id ? _withReadAt(n, DateTime.now()) : n)
          .toList(),
      unreadCount: wasUnread && unreadCount > 0 ? unreadCount - 1 : unreadCount,
    );
  }

  NotificationsData copyWithAllRead() {
    final now = DateTime.now();
    return NotificationsData(
      items: items.map((n) => n.readAt != null ? n : _withReadAt(n, now)).toList(),
      unreadCount: 0,
    );
  }

  NotificationsData copyWithPrepended(NotificationModel n) {
    return NotificationsData(
      items: [n, ...items],
      unreadCount: unreadCount + 1,
    );
  }

  static NotificationModel _withReadAt(NotificationModel n, DateTime when) {
    return NotificationModel(
      id: n.id,
      storeId: n.storeId,
      userId: n.userId,
      channel: n.channel,
      status: n.status,
      title: n.title,
      body: n.body,
      scheduledAt: n.scheduledAt,
      sentAt: n.sentAt,
      deliveredAt: n.deliveredAt,
      readAt: when,
      referenceType: n.referenceType,
      referenceId: n.referenceId,
      gatewayResponse: n.gatewayResponse,
      createdAt: n.createdAt,
    );
  }
}

class NotificationsNotifier extends Notifier<AsyncValue<NotificationsData>> {
  @override
  AsyncValue<NotificationsData> build() {
    _fetch();
    return const AsyncLoading();
  }

  Future<void> _fetch() async {
    state = const AsyncLoading();
    try {
      final res = await ref
          .read(notificationRepositoryProvider)
          .fetchNotifications(limit: 30);
      state = AsyncData(NotificationsData(
        items: res.data ?? [],
        unreadCount: res.unreadCount ?? 0,
      ));
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> refresh() => _fetch();

  Future<void> markRead(String id) async {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData(current.copyWithMarkRead(id));
    try {
      await ref.read(notificationRepositoryProvider).markAsRead(id);
    } catch (_) {
      _fetch();
    }
  }

  Future<void> markAllRead() async {
    final current = state.valueOrNull;
    if (current == null || !current.hasUnread) return;
    state = AsyncData(current.copyWithAllRead());
    try {
      await ref.read(notificationRepositoryProvider).markAllRead();
    } catch (_) {
      _fetch();
    }
  }

  void prependNew(NotificationModel n) {
    final current = state.valueOrNull;
    if (current != null) {
      state = AsyncData(current.copyWithPrepended(n));
    }
  }
}

final notificationsNotifierProvider =
    NotifierProvider<NotificationsNotifier, AsyncValue<NotificationsData>>(
  () => NotificationsNotifier(),
);
